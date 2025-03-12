import 'package:e_cell_website/const/const_labels.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/home/widgets/slogan_text.dart';
import 'package:e_cell_website/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

import 'widgets/particle_bg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String homePageRoute = "/home";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final GlobalKey _clgNameKey = GlobalKey();

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height,
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
                        child: ShaderMask(
                          blendMode: BlendMode.srcIn,
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              colors: [
                                Colors.yellow[700]!,
                                Colors.orange[600]!,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ).createShader(bounds);
                          },
                          child: Text(
                            'E-CELL',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: size.width * 0.15,
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
            Container(
              height: size.height,
              color: secondaryColor,
            )
          ],
        ),
      ),
    );
  }
}
