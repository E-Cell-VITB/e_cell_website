import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

extension OffsetExtensions on Offset {
  Offset normalize() {
    final length = distance;
    if (length == 0) return Offset.zero;
    return this / length;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static const String homePageRoute = "/home";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleBackground(
        baseColor: const Color(0xFF202020),
        highlightColor: const Color(0xFFC79200),
        particleCount: 72,
        child: Center(
            child: Text(
          "E-Cell",
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: secondaryColor),
        )),
      ),
    );
  }
}

class ParticleBackground extends StatefulWidget {
  final Color baseColor;
  final Color highlightColor;
  final int particleCount;
  final Widget? child;

  const ParticleBackground({
    super.key,
    this.baseColor = const Color(0xFF202020),
    this.highlightColor = const Color(0xFFC79200),
    this.particleCount = 72,
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

  // Grid cells with simple properties
  List<GridCell> gridCells = [];
  final int gridSize = 20; // 20x20 grid

  @override
  void initState() {
    super.initState();
    _initParticles();
    _initGridCells();

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

        // Smoothly return cells to their original positions when not affected
        for (var cell in gridCells) {
          // If the cell isn't being actively highlighted, move back toward original position
          if (cell.highlightAmount < 0.01) {
            cell.offset = Offset(
              cell.offset.dx * 0.8, // Gradually reduce offset
              cell.offset.dy * 0.8,
            );
            cell.highlightAmount = 0;
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

  void _initGridCells() {
    // Create a grid of cells
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        gridCells.add(
          GridCell(
            position: Offset(x / gridSize, y / gridSize),
            width: 1.0 / gridSize,
            height: 1.0 / gridSize,
            highlightAmount: 0,
            offset: Offset.zero,
          ),
        );
      }
    }
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

          // Update grid cells
          if (mousePosition != null) {
            for (var cell in gridCells) {
              // Calculate distance from mouse to cell center
              final cellCenter = Offset(
                cell.position.dx + (cell.width / 2),
                cell.position.dy + (cell.height / 2),
              );

              final distance = (cellCenter - mousePosition!).distance;
              const effectRadius = 0.15; // Control how far cells are affected

              if (distance < effectRadius) {
                // Simple highlighting based on proximity
                final strength = 1.0 - (distance / effectRadius);
                cell.highlightAmount = strength;

                // Simple movement effect - cells move slightly away from cursor
                final direction = (cellCenter - mousePosition!).normalize();
                const maxOffset =
                    0.01; // Small maximum offset for subtle effect
                cell.offset = direction * maxOffset * strength;
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
          // Base background color
          Container(
            color: widget.baseColor,
          ),

          // Particle and grid layer
          SizedBox.expand(
            child: CustomPaint(
              painter: ParticlePainter(
                particles: particles,
                baseColor: widget.baseColor,
                highlightColor: widget.highlightColor,
                gridCells: gridCells,
                secondaryColor: secondaryColor,
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

// Simplified grid cell class
class GridCell {
  final Offset position; // Cell position (normalized 0-1)
  final double width; // Cell width (normalized)
  final double height; // Cell height (normalized)
  double highlightAmount; // 0-1 highlight intensity
  Offset offset; // Simple displacement offset

  GridCell({
    required this.position,
    required this.width,
    required this.height,
    this.highlightAmount = 0,
    this.offset = Offset.zero,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color baseColor;
  final Color highlightColor;
  final Color secondaryColor;
  final List<GridCell> gridCells;

  ParticlePainter({
    required this.particles,
    required this.baseColor,
    required this.highlightColor,
    required this.gridCells,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    // Draw normal grid
    final normalGridColor = Color.lerp(baseColor, secondaryColor, 0.1)!;
    final normalGridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3
      ..color = normalGridColor.withOpacity(0.4);

    // Draw the base grid
    for (int i = 0; i <= 20; i++) {
      // Horizontal lines
      final y = i / 20 * size.height;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        normalGridPaint,
      );

      // Vertical lines
      final x = i / 20 * size.width;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        normalGridPaint,
      );
    }

    // Draw highlighted cells
    for (var cell in gridCells) {
      if (cell.highlightAmount > 0.01 || cell.offset.distance > 0.001) {
        // Calculate cell rect with offset
        final cellRect = Rect.fromLTWH(
          (cell.position.dx + cell.offset.dx) * size.width,
          (cell.position.dy + cell.offset.dy) * size.height,
          cell.width * size.width,
          cell.height * size.height,
        );

        // Draw cell highlight with secondary color
        if (cell.highlightAmount > 0.05) {
          final cellHighlightPaint = Paint()
            ..style = PaintingStyle.fill
            ..color = secondaryColor.withOpacity(cell.highlightAmount * 0.2);

          canvas.drawRect(cellRect, cellHighlightPaint);
        }

        // Draw cell border with secondary color
        final cellBorderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5 + cell.highlightAmount * 0.5
          ..color = secondaryColor.withOpacity(cell.highlightAmount * 0.8);

        canvas.drawRect(cellRect, cellBorderPaint);
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
    final innerRadius = size * 0.4;
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
