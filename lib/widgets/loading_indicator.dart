import 'dart:math';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatefulWidget {
  const LoadingIndicator({super.key});

  @override
  State<LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _outerController;
  late AnimationController _innerController;

  @override
  void initState() {
    super.initState();

    // Outer ring animation (Fast rotation)
    _outerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Inner ring animation (Slower reverse rotation)
    _innerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _outerController.dispose();
    _innerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Rotating Arc
          AnimatedBuilder(
            animation: _outerController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _outerController.value * 2 * pi,
                child: CustomPaint(
                  size: const Size(164, 164),
                  painter: ArcPainter(
                    startAngle: 0,
                    sweepAngle: pi * 1.2, // 67% of a full circle
                    color: Colors.white,
                    strokeWidth: 4,
                  ),
                ),
              );
            },
          ),

          // Inner Rotating Arc (Reverse direction)
          AnimatedBuilder(
            animation: _innerController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_innerController.value * 2 * pi,
                child: CustomPaint(
                  size: const Size(132, 132),
                  painter: ArcPainter(
                    startAngle: pi / 2,
                    sweepAngle: pi, // 50% of a full circle
                    color: Colors.amber,
                    strokeWidth: 4,
                  ),
                ),
              );
            },
          ),

          // Center Logo
          Center(
            child: Image.asset(
              'assets/icons/Icon-192.png',
              width: 72,
              height: 72,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for the arc effect
class ArcPainter extends CustomPainter {
  final double startAngle;
  final double sweepAngle;
  final Color color;
  final double strokeWidth;

  ArcPainter({
    required this.startAngle,
    required this.sweepAngle,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
