import 'dart:math';

import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/event_card.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:e_cell_website/widgets/subscription_form.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OngoingEventsPage extends StatelessWidget {
  const OngoingEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    final isMobile = screenWidth < 600;

    return ChangeNotifierProvider(
      create: (context) => OngoingEventProvider()..fetchEvents(),
      child: Scaffold(
        body: ParticleBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12.0 : 18.0),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(maxWidth: isMobile ? screenWidth : 800),
                  child: Consumer<OngoingEventProvider>(
                    builder: (context, provider, child) {
                      if (provider.isLoadingEvents) {
                        return SizedBox(
                            height: size.height * 0.6,
                            child: const Center(
                              child: LoadingIndicator(),
                            ));
                      }
                      if (provider.errorEvents != null) {
                        return Center(
                          child: Text(
                            'Error: ${provider.errorEvents}',
                            style: TextStyle(fontSize: isMobile ? 14 : 18),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      // Filter live events
                      final liveEvents = provider.events
                          .where((event) => event.isEventLive)
                          .toList();

                      if (liveEvents.isEmpty) {
                        return SizedBox(
                          height: size.height * 0.6,
                          child: NoEventsWidget(
                            isMobile: isMobile,
                            onRefresh: () {
                              // Refresh events
                              provider.fetchEvents();
                            },
                            onNotifyMe: () {
                              // Handle notification subscription
                              _showNotificationDialog(context);
                            },
                          ),
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: liveEvents.asMap().entries.map((entry) {
                          final event = entry.value;
                          return Column(
                            children: [
                              InkWell(
                                // onTap: () {
                                //   context.go('/onGoingEvents/${event.id}');
                                // },
                                child: EventCard(
                                  eventId: event.id,
                                  eventEnds: event.estimatedEndTime,
                                  registrationStarts: event.registrationStarts,
                                  registrationEnds: event.registrationEnds,
                                  eventdate: event.eventDate,
                                  eventname: event.name,
                                  description: event.description,
                                  eventtype: event.isTeamEvent
                                      ? 'Team Event'
                                      : 'Individual',
                                  reward: event.prizePool!,
                                ),
                              ),
                              if (entry.key < liveEvents.length - 1)
                                SizedBox(height: isMobile ? 20 : 30),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showNotificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: const Color(0xFFC79200).withOpacity(0.3),
            ),
          ),
          title: const Text(
            'Stay Updated!',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Subscribe to get instant event updates — no alerts, no spam, just the action.",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                ),
              ),
              SizedBox(height: 16),
              SubscriptionForm(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Implement notification subscription logic here
            //     Navigator.of(context).pop();
            //     ScaffoldMessenger.of(context).showSnackBar(
            //       const SnackBar(
            //         content: Text(
            //             'Notifications enabled! You\'ll be updated on new events.'),
            //         backgroundColor: Color(0xFFC79200),
            //       ),
            //     );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: const Color(0xFFC79200),
            //     foregroundColor: const Color(0xFF202020),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: const Text('Enable Notifications'),
            // ),
          ],
        );
      },
    );
  }
}

class NoEventsWidget extends StatelessWidget {
  final bool isMobile;
  final VoidCallback? onRefresh;
  final VoidCallback? onNotifyMe;

  const NoEventsWidget({
    super.key,
    required this.isMobile,
    this.onRefresh,
    this.onNotifyMe,
  });

  // Your app colors
  static const backgroundColor = Color(0xFF202020);
  static const primaryColor = Color(0xFFFFFFFF);
  static const secondaryColor = Color(0xFFC79200);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: eventBoxLinearGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: secondaryColor.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: secondaryColor.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon
            TweenAnimationBuilder(
              duration: const Duration(seconds: 2),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Container(
                    width: isMobile ? 80 : 100,
                    height: isMobile ? 80 : 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          secondaryColor.withOpacity(0.2),
                          secondaryColor.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.event_busy_rounded,
                      size: isMobile ? 40 : 50,
                      color: secondaryColor,
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: isMobile ? 20 : 24),

            // Main message
            Text(
              'No Ongoing Events',
              style: TextStyle(
                fontSize: isMobile ? 24 : 28,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isMobile ? 8 : 12),

            // Subtitle
            Text(
              'Stay tuned for exciting events coming your way!',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: primaryColor.withOpacity(0.7),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: isMobile ? 20 : 26),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Refresh button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: secondaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onRefresh,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 20,
                          vertical: isMobile ? 12 : 14,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh_rounded,
                              size: isMobile ? 18 : 20,
                              color: secondaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Refresh',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                color: secondaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Notify me button
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        secondaryColor,
                        secondaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onNotifyMe,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 16 : 20,
                          vertical: isMobile ? 12 : 14,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.notifications_active_rounded,
                              size: isMobile ? 18 : 20,
                              color: backgroundColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Notify Me',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                color: backgroundColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: isMobile ? 10 : 14),

            // Bottom hint with animated dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Check back soon',
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: primaryColor.withOpacity(0.5),
                  ),
                ),
                const SizedBox(width: 4),
                _AnimatedDots(isMobile: isMobile),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedDots extends StatefulWidget {
  final bool isMobile;

  const _AnimatedDots({required this.isMobile});

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          children: List.generate(3, (index) {
            final delay = index * 0.3;
            final opacity =
                ((_controller.value + delay) % 1.0) > 0.5 ? 1.0 : 0.3;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Text(
                '•',
                style: TextStyle(
                  color: NoEventsWidget.secondaryColor.withOpacity(opacity),
                  fontSize: widget.isMobile ? 12 : 14,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
