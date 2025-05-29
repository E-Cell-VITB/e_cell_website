import 'package:e_cell_website/backend/models/event.dart';
import 'package:e_cell_website/screens/ongoing_events/section/details.dart';
import 'package:e_cell_website/screens/ongoing_events/section/evaluation_criteria.dart';
import 'package:e_cell_website/screens/ongoing_events/section/event_photos.dart';
import 'package:e_cell_website/screens/ongoing_events/section/guests_and_judges.dart';
import 'package:e_cell_website/screens/ongoing_events/section/registration_ticket.dart';
import 'package:e_cell_website/screens/ongoing_events/section/schedule_table.dart';
import 'package:e_cell_website/screens/ongoing_events/section/social_links.dart';
import 'package:e_cell_website/screens/ongoing_events/section/updates.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OngoingEventDetails extends StatelessWidget {
  final String eventId;
  const OngoingEventDetails({required this.eventId, super.key});

  DateTime truncateToSeconds(DateTime dateTime) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return ChangeNotifierProvider(
        create: (context) => OngoingEventProvider()
          ..fetchEventById(eventId)
          ..fetchSchedules(eventId)
          ..fetchUpdates(eventId),
        child: Scaffold(
          body: ParticleBackground(
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
                      style: TextStyle(
                          fontSize: isMobile
                              ? 14
                              : isTablet
                                  ? 16
                                  : 18,
                          color: Colors.redAccent),
                    ),
                  );
                }
                final event = provider.currentEvent;
                if (event == null) {
                  return Center(
                    child: Text(
                      'Event not found',
                      style: TextStyle(
                          fontSize: isMobile
                              ? 16
                              : isTablet
                                  ? 18
                                  : 20),
                    ),
                  );
                }

                return Stack(children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(isMobile
                          ? 12.0
                          : isTablet
                              ? 18.0
                              : 24.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                              maxWidth: isMobile ? screenWidth : 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DetailsSection(
                                  event: event,
                                  isMobile: isMobile,
                                  isTablet: isTablet,
                                  screenWidth: screenWidth),
                              EvaluationCriteriaSection(
                                  event: event,
                                  isMobile: isMobile,
                                  isTablet: isTablet,
                                  screenWidth: screenWidth),
                              EventScheduleSection(
                                  provider: provider,
                                  isMobile: isMobile,
                                  isTablet: isTablet),
                              EventUpdatesSection(
                                  provider: provider,
                                  isMobile: isMobile,
                                  isTablet: isTablet,
                                  screenWidth: screenWidth),
                              GuestsAndJudgesSection(
                                  event: event, isMobile: isMobile),
                              // SocialLinksSection(event: event, isMobile: isMobile),
                              EventPhotosSection(
                                  event: event,
                                  isMobile: isMobile,
                                  isTablet: isTablet),
                              EventTicketSection(
                                  event: event,
                                  isMobile: isMobile,
                                  isTablet: isTablet,
                                  truncateToSeconds: truncateToSeconds),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (event.socialLink.isNotEmpty)
                    Positioned(
                      bottom: 30,
                      right: 40,
                      child: FloatingSocialLinks(
                        socialLinks: event.socialLink
                            .map((link) => SocialLink.fromMap(link))
                            .toList(),
                      ),
                    )
                ]);
              },
            ),
          ),
        ));
  }
}
