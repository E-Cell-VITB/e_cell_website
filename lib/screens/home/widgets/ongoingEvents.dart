import 'package:e_cell_website/const/app_logs.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OngoingEventsWidget extends StatefulWidget {
  final OngoingEventProvider? provider;
  const OngoingEventsWidget({super.key, required this.provider});

  @override
  State<OngoingEventsWidget> createState() => _OngoingEventsWidgetState();
}

class _OngoingEventsWidgetState extends State<OngoingEventsWidget> {
  Future<List<Map<String, String>>>? _liveEventNamesFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future only once
    if (widget.provider != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _liveEventNamesFuture = _getLiveEventNames(widget.provider!);
          });
        }
      });
    }
  }

  Future<List<Map<String, String>>> _getLiveEventNames(
      OngoingEventProvider provider) async {
    if (provider.events.isEmpty) {
      try {
        await provider.fetchEvents();
      } catch (e) {
        AppLogger.log('Error fetching events: $e');
        return [];
      }
    }

    final now = DateTime.now();
    List<Map<String, String>> liveEventNames = [];

    for (var event in provider.events) {
      try {
        await provider.fetchUpdates(event.id!);
        final updates = provider.updates;

        if (updates.isNotEmpty) {
          bool hasLiveUpdate = updates.any((update) {
            final startTime = update.updateLiveStartTime.toDate();
            final endTime = update.updateLiveEndTime.toDate();
            final isLive = now.isAfter(startTime) && now.isBefore(endTime);
            return isLive;
          });
          if (hasLiveUpdate) {
            liveEventNames.add({'name': event.name, 'id': event.id!});
          }
        }
      } catch (e) {
        AppLogger.log('Error fetching updates for ${event.name}: $e');
      }
    }

    return liveEventNames;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width <= 600;
    final isTablet = size.width > 600 && size.width <= 900;

    // Responsive font sizes
    final titleFontSize = isMobile
        ? 21.0
        : isTablet
            ? 22.0
            : size.width * 0.025;
    final subtitleFontSize = isMobile
        ? 11.0
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
        ? 180.0
        : isTablet
            ? 240.0
            : 280.0;
    final verticalSpacing = isMobile
        ? 10.0
        : isTablet
            ? 12.0
            : 15.0;
    final buttonPadding = isMobile
        ? const EdgeInsets.symmetric(horizontal: 0, vertical: 8)
        : isTablet
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 16)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 18);

    if (widget.provider == null) {
      print('Provider is null, returning SizedBox.shrink');
      return const SizedBox.shrink();
    }

    return Selector<OngoingEventProvider, bool>(
      selector: (_, provider) => provider.isLoadingEvents,
      builder: (context, isLoadingEvents, child) {
        if (isLoadingEvents) {
          return SizedBox(
            height: containerHeight * 0.6,
            width: containerHeight * 0.6,
            child: const CircularProgressIndicator(color: secondaryColor),
          );
        }

        return FutureBuilder<List<Map<String, String>>>(
          future: _liveEventNamesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: containerHeight * 0.6,
                width: containerHeight * 0.6,
                child: const CircularProgressIndicator(color: secondaryColor),
              );
            }

            if (snapshot.hasError) {
              AppLogger.log('Error in FutureBuilder: ${snapshot.error}');
              return const SizedBox.shrink();
            }

            final liveEventNames = snapshot.data ?? [];
            if (liveEventNames.isEmpty) {
              // AppLogger.log('No live events found');
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
                  SizedBox(height: verticalSpacing * 1),
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
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(liveEventNames.length, (index) {
                            final event = liveEventNames[index];
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
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        context.go(
                                            '/onGoingEvents/${event['id']}');
                                      },
                                      child: _HoverText(
                                        text: event['name']!,
                                        fontSize: eventNameFontSize,
                                      ),
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
          },
        );
      },
    );
  }
}

// New widget to handle hover effect
class _HoverText extends StatefulWidget {
  final String text;
  final double fontSize;

  const _HoverText({required this.text, required this.fontSize});

  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<_HoverText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Text(
        widget.text,
        style: TextStyle(
            fontSize: _isHovered ? widget.fontSize * 1.1 : widget.fontSize,
            color: _isHovered ? secondaryColor : primaryColor,
            fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
