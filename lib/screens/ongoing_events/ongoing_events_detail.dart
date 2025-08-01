import 'package:e_cell_website/backend/models/event.dart';
import 'package:e_cell_website/screens/ongoing_events/section/details_new.dart';
import 'package:e_cell_website/screens/ongoing_events/section/eventinfo.dart';
import 'package:e_cell_website/screens/ongoing_events/section/guests_and_judges.dart';
import 'package:e_cell_website/screens/ongoing_events/section/registration_ticket.dart';
import 'package:e_cell_website/screens/ongoing_events/section/schedule_table.dart';
import 'package:e_cell_website/screens/ongoing_events/section/social_links.dart';
import 'package:e_cell_website/screens/ongoing_events/section/updates.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OngoingEventDetails extends StatefulWidget {
  final String eventId;
  const OngoingEventDetails({required this.eventId, super.key});

  @override
  State<OngoingEventDetails> createState() => _OngoingEventDetailsState();
}

class _OngoingEventDetailsState extends State<OngoingEventDetails> {
  OngoingEventProvider? _provider;

  @override
  void dispose() {
    // Stop all streams when the widget is disposed
    _provider?.stopAllStreaming();
    super.dispose();
  }

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
      create: (context) {
        _provider = OngoingEventProvider();
        return _provider!;
      },
      child: Builder(
        builder: (context) {
          // Start comprehensive live streaming when the widget is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context
                .read<OngoingEventProvider>()
                .startEventStreaming(widget.eventId);
          });

          return Scaffold(
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${provider.errorEvents}',
                            style: TextStyle(
                                fontSize: isMobile
                                    ? 14
                                    : isTablet
                                        ? 16
                                        : 18,
                                color: Colors.redAccent),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Restart the streams
                              provider.stopAllStreaming();
                              provider.startEventStreaming(widget.eventId);
                            },
                            child: const Text('Retry'),
                          ),
                        ],
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
                            ? 18.0
                            : isTablet
                                ? 18.0
                                : 24.0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    isMobile ? screenWidth : screenWidth * 0.8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // ElevatedButton(
                                //     onPressed: () => Navigator.of(context).push(
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //                 ThankYouScreen(
                                //                   thankYouMessage:
                                //                       event.thankYouMessage ??
                                //                           '',
                                //                   thankYouCommunicationLink: event
                                //                       .thankYouCommunicationLinks,
                                //                 ))),
                                //     child: Text('click')),
                                DetailsSection(
                                    event: event,
                                    isMobile: isMobile,
                                    isTablet: isTablet,
                                    screenWidth: screenWidth),
                                const SizedBox(height: 26),
                                if (provider.updates.isNotEmpty) ...[
                                  LinearGradientText(
                                    child: Text(
                                      'Event Updates',
                                      style: isMobile
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                          : Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 26,
                                  )
                                ],
                                if (provider.updates.isNotEmpty) ...[
                                  EventUpdates(
                                      provider: provider,
                                      isMobile: isMobile,
                                      isTablet: isTablet,
                                      screenWidth: screenWidth),
                                  const SizedBox(height: 26),
                                ],
                                if (provider.schedules.isNotEmpty) ...[
                                  EventScheduleSection(
                                      provider: provider,
                                      isMobile: isMobile,
                                      isTablet: isTablet),
                                  const SizedBox(height: 26),
                                ],
                                if (event.jury.isNotEmpty) ...[
                                  GuestsAndJudgesSection(
                                      event: event, isMobile: isMobile),
                                  const SizedBox(height: 8),
                                ],
                                Eventinfo(
                                    event: event,
                                    isMobile: isMobile,
                                    isTablet: isTablet,
                                    screenWidth: screenWidth),
                                const SizedBox(height: 55),
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
          );
        },
      ),
    );
  }
}
