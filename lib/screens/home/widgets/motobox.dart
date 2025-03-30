import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class Motobox extends StatefulWidget {
  final String heading;
  final String info;
  final String image;
  const Motobox({
    required this.image,
    required this.heading,
    required this.info,
    super.key,
  });

  @override
  State<Motobox> createState() => _MotoboxState();
}

class _MotoboxState extends State<Motobox> {
  bool _isHovered = false; // Track hover state

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), // Mouse enters
      onExit: (_) => setState(() => _isHovered = false), // Mouse exits
      cursor: SystemMouseCursors.click, // Optional: Hand cursor on hover
      child: AnimatedContainer(
        padding: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 200), // Animation duration
        transform: Matrix4.identity()
          ..scale(_isHovered ? 1.05 : 1.0), // Scale up on hover
        transformAlignment: Alignment.center, // Scale from center
        height: (size.width > 450) ? 110 : 86,
        width: (size.width > 450) ? 432 : 332,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: eventBoxLinearGradient),
          borderRadius: BorderRadius.circular(70),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [], // Add shadow on hover
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: (size.width > 450) ? 67 : 50,
                width: (size.width > 450) ? 67 : 50,
                child: CircleAvatar(
                  backgroundColor: secondaryColor,
                  backgroundImage: AssetImage(widget.image),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: (size.width > 500) ? 320 : 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      widget.heading,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: (size.width > 450)
                            ? size.width * 0.014
                            : size.width * 0.03,
                      ),
                    ),
                    const SizedBox(height: 1),
                    SelectableText(
                      widget.info,
                      style: TextStyle(
                        fontSize: (size.width > 450)
                            ? size.width * 0.009
                            : size.width * 0.025,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
