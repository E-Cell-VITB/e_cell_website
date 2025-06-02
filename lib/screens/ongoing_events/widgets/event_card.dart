import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final String eventname;
  final String description;
  final String eventtype;
  final DateTime eventdate;
  final double reward;
  const EventCard(
      {required this.eventname,
      required this.description,
      required this.eventtype,
      required this.eventdate,
      required this.reward,
      super.key});

  String remainingDays(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Event has ended';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    if (days > 0) {
      return '$days days left';
    } else if (hours > 0) {
      return '$hours hours left';
    } else if (minutes > 0) {
      return '$minutes minutes left';
    } else {
      return '$seconds seconds left';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return GradientBox(
      radius: 18,
      height: isMobile ? 150 : 250,
      width: isMobile
          ? MediaQuery.of(context).size.width * 0.9
          : MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: isMobile
            ? const EdgeInsets.symmetric(vertical: 12, horizontal: 20)
            : const EdgeInsets.symmetric(vertical: 18.0, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LinearGradientText(
                    child: Text(
                  eventname,
                  style: TextStyle(fontSize: isMobile ? 18 : 30),
                )),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    LinearGradientText(child: Text(remainingDays(eventdate))),
                  ],
                ),
              ],
            ),
            SelectableText(
              description,
              style: TextStyle(
                  color: const Color(0xFFC4C4C4), fontSize: isMobile ? 8 : 16),
              maxLines: isMobile ? 3 : 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    detail_tile(isMobile, Icons.groups_3_outlined, eventtype),
                    SizedBox(
                      width: isMobile ? 10 : 16,
                    ),
                    detail_tile(isMobile, Icons.calendar_month_outlined,
                        DateFormat('dd-MM-yyyy').format(eventdate)),
                    SizedBox(
                      width: isMobile ? 10 : 16,
                    ),
                    if (reward != 0)
                      detail_tile(isMobile, Icons.emoji_events_outlined,
                          reward.toString()),
                  ],
                ),
                Row(
                  children: [
                    LinearGradientText(
                        child: Text(
                      "Register Now",
                      style: TextStyle(fontSize: isMobile ? 9 : 16),
                    )),
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(
                      Icons.keyboard_double_arrow_right_outlined,
                      color: Colors.amberAccent,
                      size: isMobile ? 8 : 15,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget detail_tile(bool isMobile, IconData icon, String heading) {
    return Container(
      height: isMobile ? 20 : 40,
      width: isMobile ? 60 : 160,
      padding: isMobile
          ? const EdgeInsets.all(2)
          : const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: const Color.fromARGB(255, 43, 43, 43),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isMobile ? 6 : 20,
            color: Colors.white,
          ),
          Text(
            heading,
            style: TextStyle(fontSize: isMobile ? 6 : 16),
          )
        ],
      ),
    );
  }
}
