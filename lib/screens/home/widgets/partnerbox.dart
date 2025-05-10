import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

class Partnerbox extends StatefulWidget {
  final String heading;
  final String info;
  final String imageUrl;
  const Partnerbox(
      {required this.heading,
      required this.info,
      required this.imageUrl,
      super.key});

  @override
  State<Partnerbox> createState() => _PartnerboxState();
}

class _PartnerboxState extends State<Partnerbox> {
  bool _isHovered = false; // Track hover state

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
        transformAlignment: Alignment.center,
        height: (size.width > 450) ? size.width * 0.25 : size.width * 0.55,
        width: (size.width > 450) ? size.width * 0.19 : size.width * 0.43,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: eventBoxLinearGradient),
          borderRadius: BorderRadius.circular(12),
          border: _isHovered ? Border.all(color: secondaryColor) : null,
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
        child: Padding(
          padding: EdgeInsets.all((size.width > 450) ? size.width * 0.01 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: (size.width > 450) ? 38 : 24,
              ),
              Align(
                // top: 10,
                alignment: Alignment.center,
                child: Image.asset(
                  widget.imageUrl,
                  height:
                      (size.width > 450) ? size.width * 0.07 : size.width * 0.1,
                  width:
                      (size.width > 450) ? size.width * 0.07 : size.width * 0.1,
                  // fit: BoxFit.cover,
                ),
              ),
              // SizedBox(
              //   height: (size.width > 450) ? 32 : 24,
              // ),
              const Spacer(),
              SelectableText(
                widget.heading,
                style: TextStyle(
                  fontSize: (size.width > 450)
                      ? size.width * 0.015
                      : size.width * 0.035,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              SelectableText(
                widget.info,
                style: TextStyle(
                  fontSize: (size.width > 450)
                      ? size.width * 0.01
                      : size.width * 0.03,
                  color: Colors.grey,
                ),
              ),
              if ((size.width > 450)) const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
