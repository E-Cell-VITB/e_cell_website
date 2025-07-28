import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/schedule_time_card.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class Eventschedule extends StatelessWidget {
  final OngoingEvent event;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;
  const Eventschedule(
      {required this.event,
      required this.isMobile,
      required this.isTablet,
      required this.screenWidth,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearGradientText(
          child: Text(
            '|  Event Schedule',
            style: isMobile
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: isMobile ? 300 : 280,
          child: Center(
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: isMobile ? Axis.vertical : Axis.vertical,

              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                childAspectRatio: 6,
              ),
              itemCount: 6, // Example item count
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScheduleTimeCard(
                        isMobile: isMobile,
                        isTablet: isTablet,
                        screenWidth: screenWidth),
                    Text(
                      ' -',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Opening Ceremony ${index + 1}',
                      style: isMobile
                          ? Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.grey)
                          : Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Colors.grey),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
