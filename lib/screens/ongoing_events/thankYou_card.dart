import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/enums/communication_url_type.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class ThankYouScreen extends StatefulWidget {
  final String thankYouMessage;
  final List<Map<String, String>> thankYouCommunicationLink;

  const ThankYouScreen({
    super.key,
    required this.thankYouMessage,
    required this.thankYouCommunicationLink,
  });

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen>
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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
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

  Widget _buildFloatingParticles() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Stack(
          children: List.generate(6, (index) {
            final offset =
                _backgroundAnimation.value * 2 * math.pi + index * math.pi / 3;
            final x =
                math.cos(offset) * 100 + MediaQuery.of(context).size.width / 2;
            final y =
                math.sin(offset) * 100 + MediaQuery.of(context).size.height / 2;

            return Positioned(
              left: x,
              top: y,
              child: Container(
                width: 4 + (index % 3) * 2,
                height: 4 + (index % 3) * 2,
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

  Widget _buildCommunicationLink(Map<String, String> link, int index) {
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
                bottom: 16,
                top: index == 0 ? 24 : 0,
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
                    padding: const EdgeInsets.all(20),
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
                          padding: const EdgeInsets.all(12),
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
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            link['label'] ??
                                CommunicationUrlType.fromString(
                                        link['type'] ?? '')
                                    .toString(),
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: secondaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: secondaryColor,
                            size: 16,
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ParticleBackground(
        child: Stack(
          children: [
            _buildFloatingParticles(),

            // Main content
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: AnimatedBuilder(
                    animation: _cardController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _cardAnimation.value,
                        child: Transform.rotate(
                          angle: _cardRotation.value,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 530),
                            child: Container(
                              padding: const EdgeInsets.all(32),
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
                                  // Animated success icon with pulse effect
                                  AnimatedBuilder(
                                    animation: Listenable.merge(
                                        [_iconController, _pulseController]),
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: _iconAnimation.value *
                                            _pulseAnimation.value,
                                        child: Transform.rotate(
                                          angle: _iconRotation.value,
                                          child: Container(
                                            width: 100,
                                            height: 90,
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
                                              margin: const EdgeInsets.all(15),
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
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: secondaryColor
                                                        .withOpacity(0.4),
                                                    blurRadius: 20,
                                                    offset: const Offset(0, 8),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.check_rounded,
                                                color: backgroundColor,
                                                size: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),

                                  const SizedBox(height: 16),

                                  // Animated title with gradient text
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
                                        child: const Text(
                                          'Thank You for Registering',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                            height: 1.2,
                                            letterSpacing: 0.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Animated message
                                  if (widget.thankYouMessage.isNotEmpty) ...[
                                    const SizedBox(height: 30),
                                    SlideTransition(
                                      position: _slideAnimation,
                                      child: FadeTransition(
                                        opacity: _contentAnimation,
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
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
                                            widget.thankYouMessage,
                                            maxLines: 3,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color:
                                                  primaryColor.withOpacity(0.9),
                                              height: 1.6,
                                              letterSpacing: 0.3,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],

                                  const SizedBox(height: 16),

                                  // Animated communication links
                                  if (widget
                                      .thankYouCommunicationLink.isNotEmpty)
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 150),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: widget
                                              .thankYouCommunicationLink
                                              .asMap()
                                              .entries
                                              .map(
                                                (entry) =>
                                                    _buildCommunicationLink(
                                                        entry.value, entry.key),
                                              )
                                              .toList(),
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 24),

                                  // Animated continue button with gradient
                                  SlideTransition(
                                    position: _slideAnimation,
                                    child: FadeTransition(
                                      opacity: _contentAnimation,
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
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
                                                  offset: const Offset(0, 8),
                                                ),
                                              ],
                                            ),
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: const Text(
                                                'Continue',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
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
                      );
                    },
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
