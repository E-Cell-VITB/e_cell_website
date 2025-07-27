import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/schedule_time_card.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventUpdates extends StatelessWidget {
  final OngoingEvent event;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;
  const EventUpdates(
      {required this.event,
      required this.isMobile,
      required this.isTablet,
      required this.screenWidth,
      super.key});

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? GradientBox(
            width: screenWidth * 0.8,
            height: 380,
            radius: 22,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/anouncment.png',
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: isTablet ? 180 : 290,
                          color: Colors.grey[800],
                          child:
                              const Center(child: Text('Image not available')),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Builder(
                    builder: (context) {
                      final provider =
                          Provider.of<OngoingEventProvider>(context);
                      final now = DateTime.now();
                      final liveUpdates = provider.updates.where((update) {
                        final startTime = update.updateLiveStartTime.toDate();
                        final endTime = update.updateLiveEndTime.toDate();
                        return now.isAfter(startTime) && now.isBefore(endTime);
                      }).toList();

                      if (liveUpdates.isEmpty) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ScheduleTimeCard(
                                    isMobile: isMobile,
                                    isTablet: isTablet,
                                    screenWidth: screenWidth),
                                const SizedBox(width: 3),
                                Text("-"),
                                const SizedBox(width: 3),
                                LinearGradientText(
                                    child: Text("Jury Evaluation Starts",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                            const SizedBox(height: 18),
                            SelectableText(
                              "No live updates at the moment.",
                              textAlign: TextAlign.center,
                            )
                          ],
                        );
                      }

                      // Show all live updates whose time is in between start and end time
                      return Column(
                        children: liveUpdates.map((update) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ScheduleTimeCard(
                                      isMobile: isMobile,
                                      isTablet: isTablet,
                                      screenWidth: screenWidth),
                                  const SizedBox(width: 3),
                                  Text("-"),
                                  const SizedBox(width: 3),
                                  LinearGradientText(
                                      child: Text(update.title,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold))),
                                ],
                              ),
                              const SizedBox(height: 18),
                              SelectableText(
                                update.message,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        : Container(); // You can handle non-mobile UI as needed
  }
}
