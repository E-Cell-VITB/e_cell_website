import 'package:e_cell_website/screens/ongoing_events/widgets/event_card.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
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
                      if (provider.events.isEmpty) {
                        return Center(
                          child: Text(
                            'No ongoing events found',
                            style: TextStyle(fontSize: isMobile ? 16 : 20),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: provider.events.asMap().entries.map((entry) {
                          final event = entry.value;
                          bool isEventLive = event.isEventLive;
                          if (!isEventLive) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  context.go('/onGoingEvents/${event.id}');
                                },
                                child: EventCard(
                                  eventname: event.name,
                                  description: event.description,
                                  eventtype: event.isTeamEvent
                                      ? 'Team Event'
                                      : 'Individual',
                                  eventdate: event.eventDate,
                                  reward: event.prizePool!,
                                ),
                              ),
                              if (entry.key < provider.events.length - 1)
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
}
