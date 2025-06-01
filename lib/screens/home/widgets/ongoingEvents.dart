import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OngoingEventsWidget extends StatelessWidget {
  const OngoingEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OngoingEventProvider>(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 600;
    final isTablet = size.width > 600 && size.width <= 900;

    // Responsive font sizes
    final titleFontSize = isMobile
        ? 20.0
        : isTablet
            ? 22.0
            : size.width * 0.025;
    final subtitleFontSize = isMobile
        ? 12.0
        : isTablet
            ? 14.0
            : 16.0;
    final eventNameFontSize = isMobile
        ? 13.0
        : isTablet
            ? 18.0
            : 20.0;
    final buttonFontSize = isMobile
        ? 10.0
        : isTablet
            ? 14.0
            : 16.0;

    // Responsive padding and sizes
    final containerHeight = isMobile
        ? 40.0
        : isTablet
            ? 55.0
            : 60.0;
    final buttonWidth = isMobile
        ? 200.0
        : isTablet
            ? 320.0
            : 340.0;
    final verticalSpacing = isMobile
        ? 10.0
        : isTablet
            ? 12.0
            : 15.0;
    final buttonPadding = isMobile
        ? const EdgeInsets.symmetric(horizontal: 1, vertical: 8)
        : isTablet
            ? const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
            : const EdgeInsets.symmetric(horizontal: 18, vertical: 18);

    bool hasUpdates = false;
    List<String> displayEventNames = [];
    final now = DateTime.now();

    print('Provider events count: ${provider.events.length}');
    print('Provider updates count: ${provider.updates.length}');

    for (var event in provider.events) {
      // Filter updates for this specific event
      final updates =
          provider.updates.where((update) => update.id == event.id).toList();

      // Debug: Log updates for each event
      print('Event: ${event.name}, Updates count: ${updates.length}');

      if (updates.isNotEmpty) {
        hasUpdates = true;
        bool hasLiveUpdate = updates.any((update) {
          final startTime = update.updateLiveStartTime.toDate();
          final endTime = update.updateLiveEndTime.toDate();
          final isLive = now.isAfter(startTime) && now.isBefore(endTime);
          // Debug: Log update details
          print(
              'Update for ${event.name}: Start: $startTime, End: $endTime, IsLive: $isLive');
          return isLive;
        });
        if (hasLiveUpdate) {
          displayEventNames.add(event.name);
          print('Added event to display: ${event.name}');
        }
      }
    }

    // Debug: Log final state
    print('Has updates: $hasUpdates, Display event names: $displayEventNames');

    // Return SizedBox.shrink() if no events have updates or no updates are live
    if (!hasUpdates || displayEventNames.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: size.width,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile
            ? 16.0
            : isTablet
                ? 24.0
                : 32.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LinearGradientText(
            child: Text(
              "Ongoing Events-Don't Miss Out!",
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: verticalSpacing),
          SelectableText(
            "Don’t wait—exciting events are happening right now. Find your spot and register!",
            style: TextStyle(
              color: const Color(0xFFA9A9A9),
              fontSize: subtitleFontSize,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: verticalSpacing * 3),
          Container(
            height: containerHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0D0D0D),
                  Color(0xFF1F1E1E),
                  Color(0xFF000000),
                ],
              ),
              border: Border.all(
                color: const Color(0xFF3C3C3C),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
            ),
            child: provider.isLoadingEvents
                ? SizedBox(
                    height: containerHeight * 0.6,
                    width: containerHeight * 0.6,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            List.generate(displayEventNames.length, (index) {
                          final eventName = displayEventNames[index];
                          return Row(
                            children: [
                              if (index != 0)
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 6 : 8),
                                  child: Text(
                                    "•",
                                    style: TextStyle(
                                      fontSize: eventNameFontSize,
                                      color: secondaryColor,
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: isMobile ? 6 : 8),
                                child: Text(
                                  eventName,
                                  style: TextStyle(
                                    fontSize: eventNameFontSize,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
          ),
          SizedBox(height: verticalSpacing * 2),
          InkWell(
            onTap: () {
              context.go('/onGoingEvents');
            },
            child: Container(
              width: buttonWidth,
              padding: buttonPadding,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                color: const Color(0xFF101010),
                border: Border.all(
                  color: secondaryColor,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Text(
                  "See What’s Happening Now!",
                  style: TextStyle(fontSize: buttonFontSize),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
