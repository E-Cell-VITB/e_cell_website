import 'package:e_cell_website/const/const_labels.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/home/widgets/slogan_text.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'widgets/particle_bg.dart';

class HomeScreen extends StatefulWidget {
  final String? section;
  const HomeScreen({this.section, super.key});
  static const String homeScreenRoute = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final GlobalKey _clgNameKey = GlobalKey();
  final GlobalKey _aboutSectionKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _adjustAnimationStart();

      // Check if we need to scroll to the about section
      if (widget.section == 'about') {
        _scrollToAboutSection();
      }
    });
  }

  void _adjustAnimationStart() {
    final RenderBox? clgBox =
        _clgNameKey.currentContext?.findRenderObject() as RenderBox?;
    if (clgBox != null) {
      final double clgY = clgBox.localToGlobal(Offset.zero).dy;
      final double screenHeight = MediaQuery.of(context).size.height;
      final double startOffset = (screenHeight - clgY) / screenHeight;

      setState(() {
        _offsetAnimation = Tween<Offset>(
          begin: Offset(0, startOffset),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ));
      });

      _controller.forward();
    }
  }

  void _scrollToAboutSection() {
    if (_aboutSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _aboutSectionKey.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: size.height * 0.85,
            child: ParticleBackground(
              primaryColor: const Color(0xFF404040),
              secondaryColor: const Color(0xFFC79200),
              highlightColor: const Color(0xFFC79200),
              baseColor: backgroundColor,
              particleCount: 72,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SlideTransition(
                      position: _offsetAnimation,
                      child: LinearGradientText(
                        child: Text(
                          'E-CELL',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: size.width * 0.14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      clgName.toUpperCase(),
                      key: _clgNameKey,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: primaryColor,
                        shadows: const [
                          Shadow(
                            color: Color.fromRGBO(32, 32, 32, 0.6),
                            offset: Offset(2, 4),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    SloganText(size: size),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            key: _aboutSectionKey,
            height: size.height,
            width: size.width,
            // color: secondaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                LinearGradientText(
                  child: Text(
                    "About Us".toUpperCase(),
                    style: TextStyle(
                      fontSize: size.width * 0.02,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
