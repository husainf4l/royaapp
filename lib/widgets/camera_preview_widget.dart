import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraService cameraService;
  final Function(Offset) onFocusTap;

  const CameraPreviewWidget({
    Key? key,
    required this.cameraService,
    required this.onFocusTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!cameraService.isInitialized || cameraService.controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTapDown: (details) => onFocusTap(details.localPosition),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          CameraPreview(cameraService.controller!),

          // AR overlay
          Positioned.fill(child: CustomPaint(painter: AROverlayPainter())),
        ],
      ),
    );
  }
}

class AROverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw AR overlay elements
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..color = Colors.white.withOpacity(0.7)
          ..strokeWidth = 1;

    // Center target circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 70, paint);

    // Crosshair lines
    canvas.drawLine(
      Offset(size.width / 2 - 30, size.height / 2),
      Offset(size.width / 2 + 30, size.height / 2),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - 30),
      Offset(size.width / 2, size.height / 2 + 30),
      paint,
    );

    // Add corner brackets for futuristic look
    final cornerSize = size.width * 0.1;

    // Top-left corner
    canvas.drawLine(Offset(10, 10), Offset(10 + cornerSize, 10), paint);
    canvas.drawLine(Offset(10, 10), Offset(10, 10 + cornerSize), paint);

    // Top-right corner
    canvas.drawLine(
      Offset(size.width - 10, 10),
      Offset(size.width - 10 - cornerSize, 10),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 10, 10),
      Offset(size.width - 10, 10 + cornerSize),
      paint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(10, size.height - 10),
      Offset(10 + cornerSize, size.height - 10),
      paint,
    );
    canvas.drawLine(
      Offset(10, size.height - 10),
      Offset(10, size.height - 10 - cornerSize),
      paint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width - 10, size.height - 10),
      Offset(size.width - 10 - cornerSize, size.height - 10),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - 10, size.height - 10),
      Offset(size.width - 10, size.height - 10 - cornerSize),
      paint,
    );

    // Add metrics overlay text
    final textPaint = Paint()..color = Colors.white;
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );

    final textSpan = TextSpan(text: 'ANALYZING PLAYER', style: textStyle);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width / 2 - textPainter.width / 2, size.height / 2 + 90),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
