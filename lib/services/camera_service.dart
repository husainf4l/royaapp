import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isMockMode = false;
  String? _errorMessage;

  bool get isInitialized => _isInitialized;
  bool get isMockMode => _isMockMode;
  String? get errorMessage => _errorMessage;
  CameraController? get controller => _controller;

  // Initialize the camera with fallback to mock mode
  Future<void> initialize() async {
    try {
      // Reset state
      _isInitialized = false;
      _isMockMode = false;
      _errorMessage = null;

      // Check if we're running on a simulator/emulator
      bool isRealDevice = !Platform.isIOS || !(await _isIosSimulator());
      if (!isRealDevice) {
        _setMockMode('Camera not available on simulator. Using mock mode.');
        return;
      }

      print('Starting camera initialization...');

      // First try to get available cameras
      try {
        _cameras = await availableCameras().timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            throw TimeoutException('Camera initialization timed out');
          },
        );
        print('Found ${_cameras.length} cameras');
      } catch (e) {
        // Handle specific channel error which is common in Flutter
        if (e is CameraException && e.code == 'channel-error') {
          String additionalInfo = '';
          if (Platform.isIOS) {
            additionalInfo =
                'Make sure your Info.plist has NSCameraUsageDescription.';
          } else if (Platform.isAndroid) {
            additionalInfo =
                'Make sure your AndroidManifest.xml has camera permissions.';
          }

          _setMockMode(
            'Camera plugin communication error: ${e.description}. $additionalInfo',
          );
          return;
        }
        rethrow;
      }

      if (_cameras.isEmpty) {
        _setMockMode('No cameras available on this device');
        return;
      }

      print('Initializing camera controller...');

      // Initialize camera controller
      _controller = CameraController(
        _cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup:
            Platform.isAndroid
                ? ImageFormatGroup.yuv420
                : ImageFormatGroup.bgra8888,
      );

      // Initialize the controller
      try {
        await _controller!.initialize().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw TimeoutException(
              'Camera controller initialization timed out',
            );
          },
        );
      } catch (e) {
        print('Camera controller initialization failed: $e');
        if (e is CameraException && e.code == 'channel-error') {
          _setMockMode('Camera plugin communication error: ${e.description}');
          return;
        }
        rethrow;
      }

      _isInitialized = true;
      print('Camera initialized successfully');
    } catch (e) {
      print('Error initializing camera: $e');
      _setMockMode('Camera initialization failed: ${e.toString()}');
    }
  }

  // Helper method to check if running on iOS simulator
  Future<bool> _isIosSimulator() async {
    if (!Platform.isIOS) return false;

    // On iOS, we can check if we're on a simulator by checking
    // the device model which contains "Simulator" on simulators
    try {
      final String simulatorCheck = await compute<void, String>(
        (_) => Platform.isIOS ? Platform.operatingSystemVersion : '',
        null,
      );

      return simulatorCheck.toLowerCase().contains('simulator');
    } catch (e) {
      print('Error checking if device is simulator: $e');
      // If we can't determine, assume it's a real device
      return false;
    }
  }

  // Set mock mode with error message
  void _setMockMode(String error) {
    _isInitialized = false;
    _isMockMode = true;
    _errorMessage = error;

    // Add more detailed logging
    print('Camera in mock mode: $error');
    print('App will use mock camera data instead');

    // Clean up any existing controller
    if (_controller != null) {
      try {
        _controller!.dispose();
      } catch (e) {
        print('Error disposing camera controller: $e');
      }
      _controller = null;
    }
  }

  // Try to recover camera if possible
  Future<bool> tryRecoverCamera() async {
    try {
      await initialize();
      return _isInitialized;
    } catch (e) {
      print('Failed to recover camera: $e');
      return false;
    }
  }

  Future<void> setZoom(double zoom) async {
    if (!_isInitialized || _controller == null) return;
    try {
      await _controller!.setZoomLevel(zoom);
    } catch (e) {
      print('Error setting zoom: $e');
    }
  }

  Future<void> setFocusPoint(Offset point) async {
    if (!_isInitialized || _controller == null) return;
    try {
      await _controller!.setFocusPoint(point);
      await _controller!.setExposurePoint(point);
    } catch (e) {
      print('Error setting focus: $e');
    }
  }

  Future<XFile?> takePicture() async {
    if (!_isInitialized || _controller == null) {
      if (_isMockMode) {
        // In a real app, you could use a predefined test image
        print('Taking mock picture for webhook testing');
        return null;
      }
      return null;
    }

    try {
      final XFile image = await _controller!.takePicture();
      print('Picture taken: ${image.path}');

      // Get file size for logging
      final File file = File(image.path);
      final int fileSize = await file.length();
      print('Image size: ${(fileSize / 1024).toStringAsFixed(2)} KB');

      return image;
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  void dispose() {
    if (_controller != null) {
      try {
        _controller!.dispose();
      } catch (e) {
        print('Error disposing camera controller: $e');
      }
      _isInitialized = false;
    }
  }
}
