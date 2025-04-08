import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Ensure this import is present for MediaType
import '../config/app_config.dart';
import '../models/player_analysis.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart'
    as img; // Add this import for fallback compression

class AnalysisService {
  Future<List<int>> compressImage(File imageFile) async {
    const targetSizeBytes = 90000; // Safe 90KB target

    try {
      // Try using flutter_image_compress plugin first
      int quality = 85;
      List<int> result =
          await FlutterImageCompress.compressWithFile(
            imageFile.absolute.path,
            quality: quality,
          ) ??
          [];

      // If still too large, compress further
      while (result.length > targetSizeBytes && quality > 5) {
        quality -= 10;
        result =
            await FlutterImageCompress.compressWithFile(
              imageFile.absolute.path,
              quality: quality,
            ) ??
            [];
      }

      return result;
    } catch (e) {
      print('Plugin compression failed, using fallback method: $e');
      return await compressImageFallback(imageFile, targetSizeBytes);
    }
  }

  Future<List<int>> compressImageFallback(
    File imageFile,
    int targetSizeBytes,
  ) async {
    // Read the file bytes
    final bytes = await imageFile.readAsBytes();
    // Decode the image
    final image = img.decodeImage(bytes);

    if (image == null) {
      return bytes; // Return original if we can't decode
    }

    // Start with reasonable quality
    int quality = 85;
    List<int> result = img.encodeJpg(image, quality: quality);

    // If still too large, compress further by resizing and reducing quality
    while (result.length > targetSizeBytes && quality > 20) {
      quality -= 15;

      // Also resize if quality reduction isn't enough
      if (quality < 50) {
        final scale = 0.8; // Reduce dimensions to 80%
        final resized = img.copyResize(
          image,
          width: (image.width * scale).round(),
          height: (image.height * scale).round(),
        );
        result = img.encodeJpg(resized, quality: quality);
      } else {
        result = img.encodeJpg(image, quality: quality);
      }
    }

    return result;
  }

  Future<bool> sendImageToServer(File imageFile) async {
    try {
      print('Starting image compression...');
      final compressedBytes = await compressImage(imageFile);
      print('Image compressed. Size: ${compressedBytes.length} bytes');

      final url = Uri.parse('${AppConfig.baseUrl}/analytics/upload');
      print('Sending request to: $url');

      // Create a multipart request
      final request = http.MultipartRequest('POST', url);

      // Create a temporary file with the compressed bytes
      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/compressed_image.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      // Add the file to the request
      final fileStream = http.ByteStream(tempFile.openRead());
      final fileLength = await tempFile.length();

      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpeg'), // Add correct MIME type
      );

      request.files.add(multipartFile);

      // Add other fields if needed
      request.fields['timestamp'] = DateTime.now().toIso8601String();

      // Send the request
      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Request timed out'),
      );

      // Get the response
      final response = await http.Response.fromStream(streamedResponse);

      // Clean up temp file
      await tempFile.delete();

      print('Response status: ${response.statusCode}');
      print(
        'Response body: ${response.body.length > 100 ? '${response.body.substring(0, 100)}...' : response.body}',
      );

      if (response.statusCode != 200) {
        print('Error: Server returned status code ${response.statusCode}');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('Error sending image to webhook: $e');
      // Check for specific error types to provide better feedback
      if (e.toString().contains('SocketException')) {
        print(
          'Network error: Check your internet connection and server availability',
        );
      } else if (e.toString().contains('TimeoutException')) {
        print('Request timed out: The server took too long to respond');
      }
      return false;
    }
  }

  Future<PlayerAnalysis> sendImageViaHttp(File imageFile) async {
    try {
      // In a real app, you would send the image to your API and parse the response
      // For now, we'll simulate a network delay and return mock data

      print('Simulating network delay for image analysis...');
      await Future.delayed(const Duration(seconds: 1));

      // Create a mock analysis (in production, this would come from the API)
      return PlayerAnalysis.mockData();
    } catch (e) {
      print('Error during image analysis: $e');
      // Return a basic mock object on error
      return PlayerAnalysis.mockData();
    }
  }

  Future<PlayerAnalysis> processAnalysisResults(
    Map<String, dynamic> data,
  ) async {
    // This would parse actual API data in production
    // For now, we just return mock data
    return PlayerAnalysis.mockData();
  }
}
