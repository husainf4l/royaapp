import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:royaapp/screens/player_detail_screen.dart';
import '../services/camera_service.dart';
import '../services/analysis_service.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/camera_controls_widget.dart';
import '../widgets/player_analysis_card.dart';
import '../models/player_analysis.dart';
import '../utils/debug_navigator.dart';
import 'analysis_history_screen.dart';

class ARPlayerAnalysisScreen extends StatefulWidget {
  const ARPlayerAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<ARPlayerAnalysisScreen> createState() => _ARPlayerAnalysisScreenState();
}

class _ARPlayerAnalysisScreenState extends State<ARPlayerAnalysisScreen>
    with WidgetsBindingObserver {
  final CameraService _cameraService = CameraService();
  final AnalysisService _analysisService = AnalysisService();

  bool _isLoading = false;
  bool _isFlashing = false;
  PlayerAnalysis? _playerAnalysis;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
    _connectWebSocket();

    // Set to fullscreen immersive mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _initializeCamera() async {
    setState(() => _isLoading = true);
    await _cameraService.initialize();
    setState(() => _isLoading = false);

    // If camera failed to initialize, show error
    if (_cameraService.isMockMode && _cameraService.errorMessage != null) {
      // Delay to ensure the UI is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        _showCameraError(_cameraService.errorMessage!);
      });
    }
  }

  void _showCameraError(String error) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Camera Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('There was a problem initializing the camera:\n$error'),
                const SizedBox(height: 16),
                const Text(
                  'The app will continue in demo mode with mock data.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Try Again'),
                onPressed: () {
                  Navigator.pop(context);
                  _cameraService.tryRecoverCamera().then((recovered) {
                    if (!recovered && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Camera recovery failed, still using mock mode',
                          ),
                        ),
                      );
                    }
                  });
                },
              ),
              TextButton(
                child: const Text('Continue in Demo Mode'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
    );
  }

  Future<void> _connectWebSocket() async {
    await _analysisService.connectWebSocket();
  }

  void _handleFocusTap(Offset position) {
    _cameraService.setFocusPoint(position);
  }

  Future<void> _handleCapture() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    if (_cameraService.isMockMode) {
      // Add haptic feedback for better user experience
      HapticFeedback.mediumImpact();

      // Show a brief flash effect to simulate taking a photo
      setState(() => _isFlashing = true);
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() => _isFlashing = false);

      // Simulate processing delay with variable time
      await Future.delayed(
        Duration(milliseconds: 800 + (DateTime.now().millisecond % 500)),
      );

      // Get mock data - use more varied mock data if available
      final analysis = PlayerAnalysis.mockData();

      if (mounted) {
        setState(() {
          _playerAnalysis = analysis;
          _isLoading = false;
        });

        // Add a notification toast to indicate demo mode
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demo mode: Showing sample player analysis'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final imageFile = await _cameraService.takePicture();
    if (imageFile == null) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture image')),
        );
      }
      return;
    }

    // Send via WebSocket
    final bytes = await imageFile.readAsBytes();
    _analysisService.sendImageViaWebSocket(bytes);

    // Send via HTTP and get analysis
    final analysis = await _analysisService.sendImageViaHttp(
      File(imageFile.path),
    );

    if (mounted) {
      setState(() {
        _playerAnalysis = analysis;
        _isLoading = false; // Fixed parenthesis here
      });
    }
  }

  void _closeAnalysis() {
    setState(() {
      _playerAnalysis = null;
    });
  }

  void _showDebugMenu() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Debug Menu'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Test Navigation'),
                  onTap: () {
                    Navigator.pop(context);
                    DebugNavigator.testPlayerDetailNavigation(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Open Mock Player Detail'),
                  onTap: () {
                    Navigator.pop(context);
                    final mockPlayer = PlayerAnalysis.mockData();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => PlayerDetailScreen(player: mockPlayer),
                      ),
                    );
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _cameraService.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraService.dispose();
    _analysisService.disconnectWebSocket();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview or mock UI
          if (_cameraService.isInitialized)
            CameraPreviewWidget(
              cameraService: _cameraService,
              onFocusTap: _handleFocusTap,
            )
          else if (_cameraService.isMockMode)
            _buildMockCameraView(),

          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),

          // Add flash overlay
          if (_isFlashing)
            Positioned.fill(child: Container(color: Colors.white)),

          // Camera controls at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CameraControlsWidget(
              cameraService: _cameraService,
              onCapture: _handleCapture,
              isProcessing: _isLoading,
            ),
          ),

          // Player analysis card (if available)
          if (_playerAnalysis != null)
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).padding.top + 16,
              child: PlayerAnalysisCard(
                playerAnalysis: _playerAnalysis!,
                onClose: _closeAnalysis,
              ),
            ),

          // Status bar background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).padding.top,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    // Only show bottom nav when not in full camera mode
    if (_playerAnalysis != null) {
      // Changed condition to show when analysis is present
      return BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Analysis'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AnalysisHistoryScreen(),
              ),
            );
          } else if (index == 2) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings not implemented yet')),
            );
          }
        },
      );
    }
    return const SizedBox.shrink(); // Hide when in camera mode
  }

  Widget _buildMockCameraView() {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Mock camera background
          Center(
            child: Icon(
              Icons.camera_alt,
              size: 100,
              color: Colors.white.withOpacity(0.3),
            ),
          ),

          // Demo mode indicator
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'DEMO MODE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),

          // Debug button
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.bug_report, color: Colors.white),
              onPressed: _showDebugMenu,
            ),
          ),

          // Hint text
          Positioned(
            bottom: 120,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: const Text(
                'Camera is unavailable. Tap the capture button to see mock player analysis.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
