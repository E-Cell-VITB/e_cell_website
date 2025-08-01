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

  // Helper method to get responsive dimensions
  Map<String, dynamic> _getResponsiveDimensions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final size = MediaQuery.of(context).size;

    // Define breakpoints
    final bool isMobile = screenWidth < 650;
    final bool isTablet = screenWidth >= 650 && screenWidth < 1200;
    final bool isDesktop = screenWidth >= 1200;

    return {
      'isMobile': isMobile,
      'isTablet': isTablet,
      'isDesktop': isDesktop,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'size': size,

      // Container dimensions
      'containerHeight': isMobile
          ? screenHeight * 0.1
          : (isTablet ? screenHeight * 0.17 : screenHeight * 0.2),
      'containerWidth': isMobile
          ? screenWidth
          : (isTablet ? screenWidth * 0.4 : screenWidth * 0.3),
      'containerPadding': isMobile ? 8.0 : (isTablet ? 10.0 : 8.0),
      'borderRadius': isMobile ? 70.0 : (isTablet ? 60.0 : 70.0),

      // Avatar dimensions
      'avatarSize': isMobile
          ? screenWidth * 0.09
          : (isTablet ? screenWidth * 0.06 : screenWidth * 0.04),

      // Spacing
      'horizontalSpacing': isMobile
          ? screenWidth * 0.03
          : (isTablet ? screenWidth * 0.025 : screenWidth * 0.03),
      'verticalSpacing': isMobile ? 1.0 : (isTablet ? 2.0 : 1.0),

      // Text container width
      'textContainerWidth': isMobile
          ? screenWidth * 0.55
          : (isTablet ? screenWidth * 0.28 : screenWidth * 0.2),

      // Font sizes
      'headingFontSize': _getHeadingFontSize(size, isMobile, isTablet),
      'infoFontSize': _getInfoFontSize(size, isMobile, isTablet),

      // Animation and effects
      'hoverScale': isMobile ? 1.02 : (isTablet ? 1.03 : 1.05),
      'animationDuration': isMobile ? 150 : (isTablet ? 175 : 200),
      'blurRadius': isMobile ? 8.0 : (isTablet ? 12.0 : 10.0),
      'shadowOffset': isMobile ? 3.0 : (isTablet ? 4.0 : 5.0),
    };
  }

  // Helper method for heading font size calculation
  double _getHeadingFontSize(Size size, bool isMobile, bool isTablet) {
    if (isMobile) {
      return size.width > 450 ? size.width * 0.014 : size.width * 0.02;
    } else if (isTablet) {
      return size.width > 800 ? size.width * 0.018 : size.width * 0.019;
    } else {
      return size.width > 1400 ? size.width * 0.012 : size.width * 0.014;
    }
  }

  // Helper method for info font size calculation
  double _getInfoFontSize(Size size, bool isMobile, bool isTablet) {
    if (isMobile) {
      return size.width > 450 ? size.width * 0.009 : size.width * 0.025;
    } else if (isTablet) {
      return size.width > 800 ? size.width * 0.012 : size.width * 0.013;
    } else {
      return size.width > 1400 ? size.width * 0.008 : size.width * 0.009;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = _getResponsiveDimensions(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true), // Mouse enters
      onExit: (_) => setState(() => _isHovered = false), // Mouse exits
      cursor: SystemMouseCursors.click, // Optional: Hand cursor on hover
      child: AnimatedContainer(
        padding: EdgeInsets.all(dimensions['containerPadding']),
        duration: Duration(
            milliseconds:
                dimensions['animationDuration']), // Animation duration
        transform: Matrix4.identity()
          ..scale(
              _isHovered ? dimensions['hoverScale'] : 1.0), // Scale up on hover
        transformAlignment: Alignment.center, // Scale from center
        height: dimensions['containerHeight'],
        width: dimensions['containerWidth'],
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: eventBoxLinearGradient),
          borderRadius: BorderRadius.circular(dimensions['borderRadius']),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(dimensions['isMobile']
                        ? 0.25
                        : (dimensions['isTablet'] ? 0.28 : 0.3)),
                    blurRadius: dimensions['blurRadius'],
                    offset: Offset(0, dimensions['shadowOffset']),
                  ),
                ]
              : [], // Add shadow on hover
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: dimensions['avatarSize'],
                width: dimensions['avatarSize'],
                child: CircleAvatar(
                  backgroundColor: secondaryColor,
                  backgroundImage: AssetImage(widget.image),
                ),
              ),
              SizedBox(
                width: dimensions['horizontalSpacing'],
              ),
              SizedBox(
                width: dimensions['textContainerWidth'],
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
                          fontSize: dimensions['headingFontSize'],
                          letterSpacing: dimensions['isTablet'] ? 0.3 : 0.0,
                        ),
                      ),
                    ),
                    SizedBox(height: dimensions['verticalSpacing']),
                    SelectableText(
                      widget.info,
                      style: TextStyle(
                        fontSize: dimensions['infoFontSize'],
                        color: Colors.grey,
                        letterSpacing: dimensions['isTablet'] ? 0.2 : 0.0,
                        height: dimensions['isTablet'] ? 1.3 : 1.2,
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
