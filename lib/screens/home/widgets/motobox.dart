import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';
import 'package:seo/seo.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isMobile = screenWidth < 650;
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
        height: isMobile ? screenHeight * 0.1 : screenHeight * 0.2,
        width: isMobile ? screenWidth : screenWidth * 0.3,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: isMobile ? screenWidth * 0.09 : screenWidth * 0.04,
                width: isMobile ? screenWidth * 0.09 : screenWidth * 0.04,
                child: CircleAvatar(
                  backgroundColor: secondaryColor,
                  backgroundImage: AssetImage(widget.image),
                ),
              ),
              SizedBox(
                width: screenWidth * 0.03,
              ),
              SizedBox(
                width: isMobile ? screenWidth * 0.55 : screenWidth * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Seo.text(
                      text: widget.heading,
                      child: SelectableText(
                        widget.heading,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: (size.width > 450)
                              ? size.width * 0.014
                              : size.width * 0.02,
                        ),
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
