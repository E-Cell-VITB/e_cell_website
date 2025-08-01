import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/enums/communication_url_type.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class ThankYouCard extends StatefulWidget {
  final String eventId;

  const ThankYouCard({
    super.key,
    required this.eventId,
  });

  @override
  State<ThankYouCard> createState() => _ThankYouCardState();
}

class _ThankYouCardState extends State<ThankYouCard>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _iconController;
  late AnimationController _contentController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late AnimationController _pulseController;

  late Animation<double> _cardAnimation;
  late Animation<double> _cardRotation;
  late Animation<double> _iconAnimation;
  late Animation<double> _iconRotation;
  late Animation<double> _contentAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _pulseAnimation;

  String thankYouMessage = "";
  List<Map<String, String>> thankYouCommunicationLink = [];
  String eventName = '';
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    try {
      final ongoingEventsProvider =
          Provider.of<OngoingEventProvider>(context, listen: false);
      await ongoingEventsProvider.fetchEventById(widget.eventId);
      final currentEvent = ongoingEventsProvider.currentEvent;

      if (currentEvent != null) {
        setState(() {
          thankYouMessage = currentEvent.thankYouMessage ?? "";
          eventName = currentEvent.name;
          thankYouCommunicationLink = currentEvent.thankYouCommunicationLinks;
          isDataLoaded = true;
        });
      }
    } catch (e) {
      // Handle error if needed
      debugPrint('Error fetching event data: $e');
      setState(() {
        isDataLoaded = true;
      });
    }
  }

  void _initializeAnimations() {
    // Main card animation
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Icon animation
    _iconController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Content animation
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Background particles
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );

    // Particle animation
    _particleController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Setup animations
    _cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _cardRotation = Tween<double>(begin: 0.1, end: 0.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.easeOutBack),
    );

    _iconAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.bounceOut),
    );

    _iconRotation = Tween<double>(begin: -math.pi, end: 0.0).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.elasticOut),
    );

    _contentAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _contentController, curve: Curves.easeOutCubic));

    _backgroundAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_backgroundController);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  void _startAnimationSequence() async {
    // Start background animation immediately
    _backgroundController.repeat();

    // Start pulse animation
    _pulseController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 300));
    _cardController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _iconController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _contentController.forward();

    await Future.delayed(const Duration(milliseconds: 200));
    _particleController.forward();
  }

  @override
  void dispose() {
    _cardController.dispose();
    _iconController.dispose();
    _contentController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // Helper method to get responsive dimensions
  Map<String, dynamic> _getResponsiveDimensions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define breakpoints
    final bool isMobile = screenWidth < 600;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1200;
    final bool isDesktop = screenWidth >= 1200;

    // Calculate dynamic heights based on content
    double baseCardHeight = isMobile ? 300.0 : (isTablet ? 350.0 : 400.0);

    // Add height for message if exists
    if (thankYouMessage.isNotEmpty) {
      baseCardHeight += isMobile ? 80.0 : (isTablet ? 90.0 : 100.0);
    }

    // Add height for communication links if exist
    if (thankYouCommunicationLink.isNotEmpty) {
      double linkHeight = isMobile ? 60.0 : (isTablet ? 65.0 : 70.0);
      baseCardHeight += (thankYouCommunicationLink.length * linkHeight);
      // Add extra padding for links container
      baseCardHeight += isMobile ? 30.0 : (isTablet ? 40.0 : 50.0);
    }

    // Ensure minimum and maximum bounds
    double minHeight = isMobile ? 280.0 : (isTablet ? 320.0 : 360.0);
    double maxHeight = screenHeight * 0.9;

    baseCardHeight = math.max(minHeight, math.min(baseCardHeight, maxHeight));

    return {
      'isMobile': isMobile,
      'isTablet': isTablet,
      'isDesktop': isDesktop,

      // Card dimensions - dynamic height
      'maxCardWidth': isMobile ? screenWidth * 0.9 : (isTablet ? 500.0 : 600.0),
      'calculatedCardHeight': baseCardHeight,
      'maxCardHeight': maxHeight,
      'minCardHeight': minHeight,
      'cardPadding': isMobile ? 16.0 : (isTablet ? 24.0 : 12.0),
      'contentPaddingHorizontal': isMobile ? 20.0 : (isTablet ? 28.0 : 40.0),
      'contentPaddingVertical': isMobile ? 16.0 : (isTablet ? 14.0 : 24.0),

      // Icon dimensions
      'iconContainerSize': isMobile ? 80.0 : (isTablet ? 100.0 : 100.0),
      'iconSize': isMobile ? 32.0 : (isTablet ? 40.0 : 48.0),
      'iconMargin': isMobile ? 10.0 : (isTablet ? 12.0 : 18.0),

      // Typography
      'titleFontSize': isMobile ? 22.0 : (isTablet ? 26.0 : 34.0),
      'messageFontSize': isMobile ? 13.0 : (isTablet ? 13.0 : 14.0),
      'linkFontSize': isMobile ? 14.0 : (isTablet ? 16.0 : 16.0),

      // Spacing - adjusted for dynamic content
      'titleSpacing': isMobile ? 12.0 : (isTablet ? 13.0 : 16.0),
      'messageSpacing': thankYouMessage.isNotEmpty
          ? (isMobile ? 20.0 : (isTablet ? 22.0 : 28.0))
          : 0.0,
      'linkSpacing': thankYouCommunicationLink.isNotEmpty
          ? (isMobile ? 12.0 : (isTablet ? 12.0 : 16.0))
          : 0.0,
      'buttonSpacing': isMobile ? 20.0 : (isTablet ? 18.0 : 24.0),

      // Communication links
      'linkPadding': isMobile ? 10.0 : (isTablet ? 6.0 : 8.0),
      'linkIconPadding': isMobile ? 8.0 : (isTablet ? 12.0 : 14.0),
      'linkIconSize': isMobile ? 16.0 : (isTablet ? 20.0 : 22.0),
      'maxLinksHeight': thankYouCommunicationLink.isNotEmpty
          ? (isMobile ? 120.0 : (isTablet ? 100.0 : 150.0))
          : 0.0,

      // Button
      'buttonHeight': isMobile ? 48.0 : (isTablet ? 45.0 : 55.0),
      'buttonWidth': isMobile ? double.infinity : (isTablet ? 240.0 : 280.0),
      'buttonFontSize': isMobile ? 16.0 : (isTablet ? 16.0 : 20.0),

      // Additional height controls for containers
      'floatingParticleSize': isMobile ? 3.0 : (isTablet ? 4.0 : 5.0),
      'messageContainerMinHeight': thankYouMessage.isNotEmpty
          ? (isMobile ? 60.0 : (isTablet ? 60.0 : 80.0))
          : 0.0,
      'linkContainerMinHeight': isMobile ? 48.0 : (isTablet ? 48.0 : 50.0),
      'linkMarginBottom': isMobile ? 12.0 : (isTablet ? 8.0 : 10.0),
      'linkMarginTop': thankYouCommunicationLink.isNotEmpty
          ? (isMobile ? 16.0 : (isTablet ? 24.0 : 32.0))
          : 0.0,
      'arrowIconContainerSize': isMobile ? 32.0 : (isTablet ? 36.0 : 40.0),
      'arrowIconContainerHeight': isMobile ? 28.0 : (isTablet ? 32.0 : 36.0),
    };
  }

  Widget _buildFloatingParticles(Map<String, dynamic> dimensions) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        final particleCount =
            dimensions['isMobile'] ? 4 : (dimensions['isTablet'] ? 6 : 8);
        final radius = dimensions['isMobile']
            ? 60.0
            : (dimensions['isTablet'] ? 80.0 : 100.0);

        return Stack(
          children: List.generate(particleCount, (index) {
            final offset =
                _backgroundAnimation.value * 2 * math.pi + index * math.pi / 3;
            final x = math.cos(offset) * radius +
                MediaQuery.of(context).size.width / 2;
            final y = math.sin(offset) * radius +
                MediaQuery.of(context).size.height / 2;

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: dimensions['floatingParticleSize'],
                height: dimensions['floatingParticleSize'],
                decoration: BoxDecoration(
                  color: secondaryColor.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildCommunicationLink(
      Map<String, String> link, int index, Map<String, dynamic> dimensions) {
    return AnimatedBuilder(
      animation: _contentController,
      builder: (context, child) {
        final delay = index * 0.1;
        final animationValue =
            math.max(0.0, (_contentAnimation.value - delay) / (1.0 - delay));

        return Transform.translate(
          offset: Offset(0, (1 - animationValue) * 50),
          child: Opacity(
            opacity: animationValue,
            child: Container(
              margin: EdgeInsets.only(
                bottom: dimensions['linkMarginBottom'],
                top: index == 0 ? dimensions['linkMarginTop'] : 0,
              ),
              constraints: BoxConstraints(
                minHeight: dimensions['linkContainerMinHeight'],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    final url = link['url'];
                    if (url != null && url.isNotEmpty) {
                      launchUrl(Uri.parse(url));
                    }
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(dimensions['linkPadding']),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey[800]!.withOpacity(0.3),
                          Colors.grey[900]!.withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: secondaryColor.withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: secondaryColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.all(dimensions['linkIconPadding']),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                secondaryColor.withOpacity(0.8),
                                secondaryColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: secondaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            CommunicationUrlType.fromString(link['type'] ?? '')
                                .icon,
                            color: backgroundColor,
                            size: dimensions['linkIconSize'],
                          ),
                        ),
                        SizedBox(width: dimensions['isMobile'] ? 12.0 : 16.0),
                        Expanded(
                          child: Text(
                            link['label'] ??
                                CommunicationUrlType.fromString(
                                        link['type'] ?? '')
                                    .toString(),
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: dimensions['linkFontSize'],
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          width: dimensions['arrowIconContainerSize'],
                          height: dimensions['arrowIconContainerHeight'],
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: secondaryColor,
                            size: dimensions['isMobile'] ? 14.0 : 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Don't render until data is loaded to avoid layout shifts
    if (!isDataLoaded) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: ParticleBackground(
          child: Center(
            child: CircularProgressIndicator(
              color: secondaryColor,
            ),
          ),
        ),
      );
    }

    final dimensions = _getResponsiveDimensions(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: ParticleBackground(
        child: Stack(
          children: [
            _buildFloatingParticles(dimensions),

            // Main content with responsive scrolling
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(dimensions['cardPadding']),
                    child: AnimatedBuilder(
                      animation: _cardController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _cardAnimation.value,
                          child: Transform.rotate(
                            angle: _cardRotation.value,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: dimensions['maxCardWidth'],
                                minHeight: dimensions['minCardHeight'],
                                maxHeight: dimensions['maxCardHeight'],
                              ),
                              child: IntrinsicHeight(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        dimensions['contentPaddingHorizontal'],
                                    vertical:
                                        dimensions['contentPaddingVertical'],
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: eventBoxLinearGradient,
                                      stops: [0.0, 0.5, 1.0],
                                    ),
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(
                                      color: secondaryColor.withOpacity(0.3),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: secondaryColor.withOpacity(0.2),
                                        blurRadius: 40,
                                        offset: const Offset(0, 20),
                                      ),
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 30,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Animated success icon with responsive sizing
                                      AnimatedBuilder(
                                        animation: Listenable.merge([
                                          _iconController,
                                          _pulseController
                                        ]),
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _iconAnimation.value *
                                                _pulseAnimation.value,
                                            child: Transform.rotate(
                                              angle: _iconRotation.value,
                                              child: Container(
                                                width: dimensions[
                                                    'iconContainerSize'],
                                                height: dimensions[
                                                    'iconContainerSize'],
                                                decoration: BoxDecoration(
                                                  gradient: RadialGradient(
                                                    colors: [
                                                      secondaryColor
                                                          .withOpacity(0.2),
                                                      secondaryColor
                                                          .withOpacity(0.05),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Container(
                                                  margin: EdgeInsets.all(
                                                      dimensions['iconMargin']),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        secondaryColor,
                                                        secondaryColor
                                                            .withOpacity(0.8),
                                                      ],
                                                    ),
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: secondaryColor
                                                            .withOpacity(0.4),
                                                        blurRadius: 20,
                                                        offset:
                                                            const Offset(0, 8),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Icon(
                                                    Icons.check_rounded,
                                                    color: backgroundColor,
                                                    size:
                                                        dimensions['iconSize'],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),

                                      SizedBox(
                                          height: dimensions['titleSpacing']),

                                      // Responsive title
                                      SlideTransition(
                                        position: _slideAnimation,
                                        child: FadeTransition(
                                          opacity: _contentAnimation,
                                          child: ShaderMask(
                                            shaderCallback: (bounds) =>
                                                LinearGradient(
                                              colors: [
                                                primaryColor,
                                                secondaryColor.withOpacity(0.8)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(bounds),
                                            child: thankYouCommunicationLink
                                                        .isEmpty &&
                                                    thankYouMessage.isEmpty
                                                ? Text(
                                                    "Thank You For Registering in the $eventName Event",
                                                    style: TextStyle(
                                                      fontSize: dimensions[
                                                          'titleFontSize'],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor,
                                                      height: 1.2,
                                                      letterSpacing: 0.5,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                : Text(
                                                    'Thank You for Registering',
                                                    style: TextStyle(
                                                      fontSize: dimensions[
                                                          'titleFontSize'],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: primaryColor,
                                                      height: 1.2,
                                                      letterSpacing: 0.5,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                          ),
                                        ),
                                      ),

                                      // Responsive message - only show if not empty
                                      if (thankYouMessage.isNotEmpty) ...[
                                        SizedBox(
                                            height:
                                                dimensions['messageSpacing']),
                                        SlideTransition(
                                          position: _slideAnimation,
                                          child: FadeTransition(
                                            opacity: _contentAnimation,
                                            child: Container(
                                              constraints: BoxConstraints(
                                                minHeight: dimensions[
                                                    'messageContainerMinHeight'],
                                              ),
                                              padding: EdgeInsets.all(
                                                  dimensions['isMobile']
                                                      ? 16.0
                                                      : 20.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[800]!
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: secondaryColor
                                                      .withOpacity(0.1),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Text(
                                                thankYouMessage,
                                                maxLines: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 3
                                                    : 4,
                                                style: TextStyle(
                                                  fontSize: dimensions[
                                                      'messageFontSize'],
                                                  color: primaryColor
                                                      .withOpacity(0.9),
                                                  height: 1.6,
                                                  letterSpacing: 0.3,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],

                                      // Add spacing only if links exist
                                      if (thankYouCommunicationLink.isNotEmpty)
                                        const SizedBox(height: 5),

                                      // Responsive communication links - only show if not empty
                                      if (thankYouCommunicationLink.isNotEmpty)
                                        Flexible(
                                          child: Container(
                                            constraints: BoxConstraints(
                                              maxHeight:
                                                  dimensions['maxLinksHeight'],
                                            ),
                                            child: SingleChildScrollView(
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              child: Column(
                                                children:
                                                    thankYouCommunicationLink
                                                        .asMap()
                                                        .entries
                                                        .map(
                                                          (entry) =>
                                                              _buildCommunicationLink(
                                                            entry.value,
                                                            entry.key,
                                                            dimensions,
                                                          ),
                                                        )
                                                        .toList(),
                                              ),
                                            ),
                                          ),
                                        ),

                                      SizedBox(
                                          height: dimensions['buttonSpacing']),

                                      // Responsive continue button
                                      SlideTransition(
                                        position: _slideAnimation,
                                        child: FadeTransition(
                                          opacity: _contentAnimation,
                                          child: SizedBox(
                                            width: dimensions['buttonWidth'],
                                            height: dimensions['buttonHeight'],
                                            child: ElevatedButton(
                                              onPressed: () {
                                                GoRouter.of(context)
                                                    .pushReplacement(
                                                        '/onGoingEvents');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                              ),
                                              child: Ink(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      secondaryColor,
                                                      secondaryColor
                                                          .withOpacity(0.8),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: secondaryColor
                                                          .withOpacity(0.3),
                                                      blurRadius: 15,
                                                      offset:
                                                          const Offset(0, 8),
                                                    ),
                                                  ],
                                                ),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Continue',
                                                    style: TextStyle(
                                                      fontSize: dimensions[
                                                          'buttonFontSize'],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: backgroundColor,
                                                      letterSpacing: 1,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
