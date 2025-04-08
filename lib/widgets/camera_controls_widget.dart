import 'package:flutter/material.dart';
import '../services/camera_service.dart';
import '../screens/player_history_screen.dart';

class CameraControlsWidget extends StatefulWidget {
  final CameraService cameraService;
  final VoidCallback onCapture;
  final bool isProcessing;

  const CameraControlsWidget({
    Key? key,
    required this.cameraService,
    required this.onCapture,
    this.isProcessing = false,
  }) : super(key: key);

  @override
  State<CameraControlsWidget> createState() => _CameraControlsWidgetState();
}

class _CameraControlsWidgetState extends State<CameraControlsWidget> {
  double _currentZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 5.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Zoom slider
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          color: Colors.black26,
          child: Row(
            children: [
              const Icon(Icons.zoom_out, color: Colors.white),
              Expanded(
                child: Slider(
                  value: _currentZoom,
                  min: _minZoom,
                  max: _maxZoom,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white30,
                  onChanged: (value) {
                    setState(() {
                      _currentZoom = value;
                    });
                    widget.cameraService.setZoom(value);
                  },
                ),
              ),
              const Icon(Icons.zoom_in, color: Colors.white),
            ],
          ),
        ),

        // Capture button and other controls
        Container(
          height: 100,
          padding: const EdgeInsets.all(20),
          color: Colors.black45,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // History button
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PlayerHistoryScreen(),
                    ),
                  );
                },
              ),

              // Settings button
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              // Capture button
              GestureDetector(
                onTap: widget.isProcessing ? null : widget.onCapture,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    color:
                        widget.isProcessing ? Colors.grey : Colors.transparent,
                  ),
                  child:
                      widget.isProcessing
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : const Center(),
                ),
              ),

              // AR mode toggle
              IconButton(
                icon: const Icon(
                  Icons.view_in_ar,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('AR Mode Toggled')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
