import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/player_analysis.dart';

class AnalysisService {
  final String _apiUrl = 'https://api.example.com/analyze';
  final String _wsUrl = 'wss://ws.example.com/analyze';
  WebSocketChannel? _wsChannel;
  bool _isConnected = false;
  bool _mockMode = true; // Set true for demo mode without backend

  bool get mockMode => _mockMode;
  set mockMode(bool value) => _mockMode = value;

  // Connect to WebSocket
  Future<void> connectWebSocket() async {
    if (!_mockMode) {
      try {
        _wsChannel = WebSocketChannel.connect(Uri.parse(_wsUrl));
        _isConnected = true;
      } catch (e) {
        print('Error connecting to WebSocket: $e');
        _isConnected = false;
      }
    }
  }

  // Disconnect from WebSocket
  void disconnectWebSocket() {
    if (_wsChannel != null && _isConnected) {
      _wsChannel!.sink.close();
      _isConnected = false;
    }
  }

  // Send image via WebSocket
  void sendImageViaWebSocket(Uint8List imageBytes) {
    if (_mockMode) return;

    if (_isConnected && _wsChannel != null) {
      _wsChannel!.sink.add(imageBytes);
    }
  }

  // Send image via HTTP POST
  Future<PlayerAnalysis> sendImageViaHttp(File imageFile) async {
    if (_mockMode) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      return PlayerAnalysis.mockData();
    }

    try {
      final request = http.MultipartRequest('POST', Uri.parse(_apiUrl));
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseString);
        return PlayerAnalysis.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to analyze image. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error sending image via HTTP: $e');
      // Return mock data on error for better user experience
      return PlayerAnalysis.mockData();
    }
  }
}
