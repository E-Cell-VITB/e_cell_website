import 'package:e_cell_website/const/const_labels.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/home/widgets/motobox.dart';
import 'package:e_cell_website/screens/home/widgets/partnerbox.dart';
import 'package:e_cell_website/screens/home/widgets/slogan_text.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
            height: (size.width > 450) ? size.height * 0.85 : size.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
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
                      SloganText(
                        size: size,
                        str: slogan,
                        textsize: size.width * 0.02,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            key: _aboutSectionKey,
            height: (size.width > 450) ? size.height * 0.45 : size.width * 0.3,
            width: size.width,
            // color: secondaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearGradientText(
                  child: Text(
                    "About Us".toUpperCase(),
                    style: TextStyle(
                      fontSize: size.width * 0.025,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                SizedBox(
                    width: size.width * 0.65,
                    child: SelectableText(
                        textAlign: TextAlign.center,
                        aboutUs,
                        style: TextStyle(fontSize:(size.width>450)? size.width * 0.012:6))),
              ],
            ),
          ),
          SizedBox(
            // key: _aboutSectionKey,
            height: (size.width > 450) ? size.height * 0.6 : size.height*0.4 ,
            width: size.width,
            // color: secondaryColor,
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LinearGradientText(
                    child: Text(
                      "Our Motto".toUpperCase(),
                      style: TextStyle(
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height:(size.width>450)? size.width * 0.025:20,
                  ),
                  SizedBox(
                    width: size.width*0.75,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 106,
                      runSpacing: size.width*0.035,
                      children: [
                        Motobox(
                            image: "assets/icons/innovate.png",
                            heading: "Innovate",
                            info:
                                "Think beyond boundaries and develop groundbreaking ideas."),
                        Motobox(
                            image: "assets/icons/create.png",
                            heading: "Create",
                            info:
                                "Transform ideas into real-world solutions with creativity and technology."),
                        Motobox(
                        image: "assets/icons/lead.png",
                        heading: "Lead",
                        info:
                            "Inspire change, take initiative, and drive the future of entrepreneurship."),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Center(
                  //   child: Motobox(
                  //       icon: Icon(Icons.home),
                  //       heading: "Lead",
                  //       info:
                  //           "Inspire change, take initiative, and drive the future of entrepreneurship."),
                  // )
                ],
              ),
            ),
          ),
          SizedBox(
            // key: _aboutSectionKey,
            height: (size.width > 450) ? size.height * 0.5 : size.height * 0.2,
            width: size.width,
            // color: secondaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LinearGradientText(
                  child: Text(
                    "Our vision".toUpperCase(),
                    style: TextStyle(
                      fontSize: size.width * 0.025,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                SizedBox(
                    width: size.width * 0.65,
                    child: SelectableText(
                        textAlign: TextAlign.center,
                        OurVision,
                        style: TextStyle(fontSize:(size.width>450)? size.width * 0.012:6))),
              ],
            ),
          ),
          SizedBox(
            height: (size.height < 950) ? size.height * 0.8 : size.height * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                LinearGradientText(
                  child: Text(
                    "Why Partner with E-Cell?".toUpperCase(),
                    style: TextStyle(
                      fontSize: size.width * 0.025,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height:(size.width>450)? size.width*0.025:size.width*0.1,
                ),
                Wrap(
                  spacing: 30,
                  runSpacing: 40,
                  children: [
                    Partnerbox(
                        heading: "Access to Young Innovators",
                        info:
                            "Connect with talented students and fresh ideas."),
                    Partnerbox(
                        heading: "Industry-Academia Collaboration",
                        info:
                            "Bridge the gap between education and real-world entrepreneurship."),
                    Partnerbox(
                        heading: "Networking & Branding",
                        info:
                            "Gain visibility among future leaders, startups, and investors."),
                    Partnerbox(
                        heading: "Mutual Growth",
                        info:
                            "Create opportunities for innovation, mentorship, and business expansion."),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: (size.width>450)?size.width*0.8:size.width*0.6,
              child: SloganText(
            size: size,
            str:
                "Partner with us and be a part of the next wave of innovation!",
            textsize:
                (size.width > 450) ? size.width * 0.012 : size.width * 0.025,
            textAlign: TextAlign.center,
          )),
          SizedBox(
            height: size.height * 0.5,
            child: Center(
              child: Text("Footer section"),
            ),
          )
        ],
      ),
    );
  }
}
