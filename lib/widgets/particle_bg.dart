// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Painter for the background layer
class ParticleBackground extends StatefulWidget {
  final Color baseColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color highlightColor;
  final int particleCount;
  final Widget? child;
  final double gridOpacity;

  const ParticleBackground({
    super.key,
    this.baseColor = const Color(0xFF202020),
    this.primaryColor = const Color(0xFF404040),
    this.secondaryColor = const Color(0xFFC79200),
    this.highlightColor = const Color(0xFFC79200),
    this.particleCount = 72,
    this.gridOpacity = 0.2,
    this.child,
  });

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with TickerProviderStateMixin {
  late List<Particle> particles;
  Offset? mousePosition;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _initParticles();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _animationController.addListener(() {
      setState(() {
        // Update particle positions slightly for ambient movement
        for (var particle in particles) {
          particle.position = Offset(
              particle.position.dx +
                  particle.speed * math.cos(particle.angle) * 0.1,
              particle.position.dy +
                  particle.speed * math.sin(particle.angle) * 0.1);

          // Keep particles within bounds
          if (particle.position.dx < 0 || particle.position.dx > 1) {
            particle.angle = math.pi - particle.angle;
          }
          if (particle.position.dy < 0 || particle.position.dy > 1) {
            particle.angle = -particle.angle;
          }
        }
      });
    });
  }

  void _initParticles() {
    final random = math.Random();
    particles = List.generate(widget.particleCount, (index) {
      return Particle(
        position: Offset(random.nextDouble(), random.nextDouble()),
        size: 2.0 + random.nextDouble() * 8,
        speed: 0.005 + random.nextDouble() * 0.01,
        angle: random.nextDouble() * 2 * math.pi,
        color: widget.baseColor,
        originalColor: widget.baseColor,
        highlightColor: widget.highlightColor,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          final size = MediaQuery.of(context).size;
          mousePosition = Offset(
            event.position.dx / size.width,
            event.position.dy / size.height,
          );

          // Update particle colors based on distance to mouse
          for (var particle in particles) {
            if (mousePosition != null) {
              final distance = (particle.position - mousePosition!).distance;
              if (distance < 0.2) {
                final t = 1.0 - (distance / 0.2);
                particle.color = Color.lerp(
                    particle.originalColor, particle.highlightColor, t)!;
              } else {
                particle.color = particle.originalColor;
              }
            }
          }
        });
      },
      onExit: (event) {
        setState(() {
          mousePosition = null;
          for (var particle in particles) {
            particle.color = particle.originalColor;
          }
        });
      },
      child: Stack(
        children: [
          Container(
            color: widget.baseColor,
          ),

          SizedBox.expand(
            child: CustomPaint(
              painter: ParticlePainter(
                particles: particles,
                primaryColor: widget.primaryColor,
                secondaryColor: widget.secondaryColor,
                highlightColor: widget.highlightColor,
                gridOpacity: widget.gridOpacity,
                mousePosition: mousePosition,
                baseColor: widget.baseColor,
              ),
            ),
          ),

          // Child content
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }
}

class Particle {
  Offset position;
  final double size;
  double speed;
  double angle;
  Color color;
  final Color originalColor;
  final Color highlightColor;

  Particle({
    required this.position,
    required this.size,
    required this.speed,
    required this.angle,
    required this.color,
    required this.originalColor,
    required this.highlightColor,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color primaryColor;
  final Color secondaryColor;
  final Color highlightColor;
  final double gridOpacity;
  final Offset? mousePosition;
  final Color baseColor;

  ParticlePainter({
    required this.particles,
    required this.primaryColor,
    required this.secondaryColor,
    required this.highlightColor,
    required this.gridOpacity,
    required this.mousePosition,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final cellWidth = size.width / 16;
    final cellHeight = size.height / 12;

    // Calculate mouse position
    final Offset? mouseAbsolute = mousePosition != null
        ? Offset(
            mousePosition!.dx * size.width, mousePosition!.dy * size.height)
        : null;
    final hLines = size.width > 600 ? 12 : 8;
    final vLines = size.width > 600 ? 16 : 16;
    // Draw horizontal grid lines
    for (int i = 0; i <= hLines; i++) {
      final y = i * cellHeight;

      // Draw vertical grid lines
      for (int j = 0; j <= vLines; j++) {
        final x = j * cellWidth;

        // Get the four points of this grid cell
        final topLeft = Offset(x, y);
        final topRight = Offset(x + cellWidth, y);
        final bottomLeft = Offset(x, y + cellHeight);
        // final bottomRight = Offset(x + cellWidth, y + cellHeight);
        // Check if mouse is near this grid cell
        final gridPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        if (mouseAbsolute != null) {
          // Calculate distance from mouse to center of this grid cell
          final cellCenter = Offset(x + cellWidth / 2, y + cellHeight / 2);
          final distance = (mouseAbsolute - cellCenter).distance;
          final maxDistance = size.width * 0.15; // Interaction radius

          if (distance < maxDistance) {
            // Transition from primary to secondary color based on proximity
            final t = 1.0 - (distance / maxDistance);
            gridPaint.color = Color.lerp(primaryColor.withOpacity(gridOpacity),
                secondaryColor.withOpacity(0.8), t)!;
          } else {
            gridPaint.color = primaryColor.withOpacity(gridOpacity);
          }
        } else {
          gridPaint.color = primaryColor.withOpacity(gridOpacity);
        }

        // Draw the top edge of the cell (horizontal line)
        if (i < 14) {
          canvas.drawLine(topLeft, topRight, gridPaint);
        }

        // Draw the left edge of the cell (vertical line)
        if (j < 16) {
          canvas.drawLine(topLeft, bottomLeft, gridPaint);
        }
      }
    }

    // Draw particles
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      // Draw glow
      final glowPaint = Paint()
        ..color = particle.color.withAlpha(100)
        ..style = PaintingStyle.fill
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

      final center = Offset(
        particle.position.dx * size.width,
        particle.position.dy * size.height,
      );

      // Draw star/particle
      _drawStar(canvas, center, particle.size, paint, glowPaint);
    }
  }

  void _drawStar(
      Canvas canvas, Offset center, double size, Paint paint, Paint glowPaint) {
    // Draw glow effect
    canvas.drawCircle(center, size * 2, glowPaint);

    // Draw star shape
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.5;
    const points = 4; // 4-pointed star

    for (int i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outerRadius : innerRadius;
      final angle = i * math.pi / points;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
