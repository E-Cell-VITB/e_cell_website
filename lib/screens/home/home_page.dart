import 'package:e_cell_website/const/const_labels.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/home/widgets/motobox.dart';
import 'package:e_cell_website/screens/home/widgets/ongoing_events.dart';
import 'package:e_cell_website/screens/home/widgets/partnerbox.dart';
import 'package:e_cell_website/screens/home/widgets/slogan_text.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/footer.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seo/seo.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'widgets/speakers.dart';

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
  final GlobalKey _footerSectionKey = GlobalKey();
  late OngoingEventProvider? _eventProvider;

  // Animation controllers for each section
  Map<String, bool> _sectionVisible = {
    'about': false,
    'motto': false,
    'vision': false,
    'partner': false,
    'speakers': false,
    'ongoing': false,
  };

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _eventProvider = Provider.of<OngoingEventProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _eventProvider != null) {
        _eventProvider!.fetchEvents();
      }
    });

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

      if (widget.section == 'about') {
        _scrollToAboutSection();
      }
      if (widget.section == 'footer') {
        _scrollToFooterSection();
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

  void _scrollToFooterSection() {
    if (_footerSectionKey.currentContext != null) {
      Scrollable.ensureVisible(
        _footerSectionKey.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
    _sectionVisible = {
      'about': true,
      'motto': true,
      'vision': true,
      'partner': true,
      'speakers': true,
      'ongoing': true,
    };
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Animated builder for sections
  Widget _buildAnimatedSection({
    required String sectionKey,
    required Widget child,
    bool fadeIn = true,
    bool slideUp = true,
  }) {
    return VisibilityDetector(
      key: Key(sectionKey),
      onVisibilityChanged: (VisibilityInfo info) {
        // Set visibility when 40% of the widget is visible
        if (info.visibleFraction > 0.4 && !_sectionVisible[sectionKey]!) {
          setState(() {
            _sectionVisible[sectionKey] = true;
          });
        }
      },
      child: AnimatedOpacity(
        opacity: _sectionVisible[sectionKey]!
            ? 1.0
            : fadeIn
                ? 0.0
                : 1.0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: AnimatedSlide(
          offset: _sectionVisible[sectionKey]!
              ? Offset.zero
              : slideUp
                  ? const Offset(0, 0.2)
                  : Offset.zero,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutQuint,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: (size.width > 450) ? size.height * 0.9 : size.height * 0.3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
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
                              fontFamily: 'Lora',
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
                          letterSpacing: 3,
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
          SizedBox(height: size.width * 0.02),
          // Ongoing Events Section with Animation
          _buildAnimatedSection(
            sectionKey: 'ongoing',
            child: OngoingEventsWidget(provider: _eventProvider),
          ),
          SizedBox(height: size.height * 0.07),
          _buildAnimatedSection(
            sectionKey: 'about',
            child: SizedBox(
              key: _aboutSectionKey,
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearGradientText(
                    child: Text(
                      "About Us".toUpperCase(),
                      style: TextStyle(
                        fontSize: (size.width > 450) ? size.width * 0.025 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  SizedBox(
                    width: (size.width > 450)
                        ? size.width * 0.65
                        : size.width * 0.85,
                    child: Seo.text(
                      text: aboutUs,
                      child: SelectableText(
                        textAlign: TextAlign.center,
                        aboutUs,
                        style: TextStyle(
                          fontSize:
                              (size.width > 450) ? size.width * 0.012 : 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.width * 0.04),
          // Our Motto Section with Animation
          _buildAnimatedSection(
            sectionKey: 'motto',
            child: SizedBox(
              width: size.width,
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
                          fontSize:
                              (size.width > 450) ? size.width * 0.025 : 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: (size.width > 450) ? size.width * 0.025 : 20,
                    ),
                    SizedBox(
                      width: size.width * 0.75,
                      child: _buildStaggeredItems(
                        size: size,
                        items: const [
                          Motobox(
                            image: "assets/images/innovate.png",
                            heading: "Innovate",
                            info:
                                "Think beyond boundaries and develop groundbreaking ideas.",
                          ),
                          Motobox(
                            image: "assets/images/create.png",
                            heading: "Create",
                            info:
                                "Transform ideas into real-world solutions with creativity and technology.",
                          ),
                          Motobox(
                            image: "assets/images/lead.png",
                            heading: "Lead",
                            info:
                                "Inspire change, take initiative, and drive the future of entrepreneurship.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: size.width * 0.04),
          // Our Vision Section with Animation
          _buildAnimatedSection(
            sectionKey: 'vision',
            child: SizedBox(
              width: size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearGradientText(
                    child: Text(
                      "Our vision".toUpperCase(),
                      style: TextStyle(
                        fontSize: (size.width > 450) ? size.width * 0.025 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.025),
                  SizedBox(
                    width: (size.width > 450)
                        ? size.width * 0.65
                        : size.width * 0.85,
                    child: SelectableText(
                      textAlign: TextAlign.center,
                      ourVision,
                      style: TextStyle(
                        fontSize: (size.width > 450) ? size.width * 0.012 : 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.width * 0.06),
          // Partner Section with Animation
          _buildAnimatedSection(
            sectionKey: 'partner',
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearGradientText(
                    child: Text(
                      "Why Partner with E-Cell?".toUpperCase(),
                      style: TextStyle(
                        fontSize: (size.width > 450) ? size.width * 0.025 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (size.width > 450)
                        ? size.width * 0.025
                        : size.width * 0.08,
                  ),
                  _buildStaggeredItems(
                    size: size,
                    items: const [
                      Partnerbox(
                        heading: "Access to Young Innovators",
                        info: "Connect with talented students and fresh ideas.",
                        imageUrl: "assets/images/partner/innovate.png",
                      ),
                      Partnerbox(
                        heading: "Industry Partnership",
                        info:
                            "Bridge the gap between education and real-world entrepreneurship.",
                        imageUrl: "assets/images/partner/collaborate.png",
                      ),
                      Partnerbox(
                        heading: "Networking & Branding",
                        info:
                            "Gain visibility among future leaders, startups, and investors.",
                        imageUrl: "assets/images/partner/network.png",
                      ),
                      Partnerbox(
                        heading: "Mutual Growth",
                        info:
                            "Create opportunities for innovation, mentorship, and business expansion.",
                        imageUrl: "assets/images/partner/growth.png",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.width * 0.04),
          SizedBox(
            width: (size.width > 450) ? size.width * 0.8 : size.width * 0.6,
            child: SloganText(
              size: size,
              str:
                  "Partner with us and be a part of the next wave of innovation!",
              textsize: (size.width > 450) ? size.width * 0.012 : 14,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: size.width * 0.04),
          _buildAnimatedSection(
            sectionKey: "speakers",
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearGradientText(
                    child: Text(
                      "Speakers".toUpperCase(),
                      style: TextStyle(
                        fontSize: (size.width > 450) ? size.width * 0.025 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: primaryColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: (size.width > 450)
                        ? size.width * 0.02
                        : size.width * 0.08,
                  ),
                  const SpeakerCards()
                ],
              ),
            ),
          ),
          Footer(key: _footerSectionKey),
        ],
      ),
    );
  }

  // Widget to build staggered items with animations
  Widget _buildStaggeredItems({
    required Size size,
    required List<Widget> items,
  }) {
    return Wrap(
      spacing: size.width > 450 ? 30 : 20,
      runSpacing: size.width > 450 ? 40 : 20,
      alignment: WrapAlignment.center,
      children: items.asMap().entries.map((entry) {
        int index = entry.key;
        Widget item = entry.value;
        bool isVisible = _sectionVisible[index < 3 ? 'motto' : 'partner']!;

        return AnimatedOpacity(
          opacity: isVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 800 + (index * 200)),
          curve: Curves.easeInOut,
          child: AnimatedSlide(
            offset: isVisible ? Offset.zero : const Offset(0, 0.2),
            duration: Duration(milliseconds: 800 + (index * 200)),
            curve: Curves.easeOutQuint,
            child: item,
          ),
        );
      }).toList(),
    );
  }
}
