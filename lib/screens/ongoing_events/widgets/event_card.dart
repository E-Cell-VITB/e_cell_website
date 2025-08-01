import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final String eventname;
  final String description;
  final String eventtype;
  final DateTime eventdate;
  final DateTime? registrationStarts;
  final DateTime? registrationEnds;
  final double reward;
  final DateTime? eventEnds;
  final String? eventId;
  const EventCard(
      {required this.eventname,
      required this.description,
      required this.eventtype,
      required this.eventdate,
      required this.reward,
      this.registrationStarts,
      this.registrationEnds,
      this.eventEnds,
      this.eventId,
      super.key});

  String getEventStatus() {
    final now = DateTime.now();

    if (registrationStarts != null && now.isBefore(registrationStarts!)) {
      final days = registrationStarts!.difference(now).inDays;
      return 'Registration starts in $days days';
    }

    if (registrationEnds != null && now.isBefore(registrationEnds!)) {
      final days = registrationEnds!.difference(now).inDays;
      return 'Registration ends in $days days';
    }

    if (eventEnds != null && eventEnds!.isBefore(now)) {
      return 'Event has ended';
    }

    if (eventdate.isBefore(now) &&
        (eventEnds == null || eventEnds!.isAfter(now))) {
      return 'Event is ongoing';
    }

    if (eventdate.isAfter(now) && eventEnds != null) {
      final days = eventEnds!.difference(now).inDays;
      return 'Event ends in $days days';
    }

    final eventDays = eventdate.difference(now).inDays;
    return 'Event starts in $eventDays days';
  }

  String getRegisterCTA() {
    final now = DateTime.now();
    if (registrationStarts == null && registrationEnds == null) {
      return 'Registration Not Started';
    }
    if (eventEnds != null && now.isAfter(eventEnds!)) {
      return 'Event Ended';
    }
    if (registrationEnds != null && now.isAfter(registrationEnds!)) {
      return 'Registration Closed';
    }

    if (registrationStarts != null && now.isBefore(registrationStarts!)) {
      return 'Registration Not Started';
    }

    return 'Register Now';
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 700;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/onGoingEvents/$eventId'),
        child: GradientBox(
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
                      style: TextStyle(fontSize: isMobile ? 17 : 30),
                    )),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          color: Colors.amber,
                          size: isMobile ? 14 : 18,
                        ),
                        SizedBox(width: isMobile ? 4 : 8),
                        LinearGradientText(
                            child: Text(
                          getEventStatus(),
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: isMobile ? 9 : 16),
                        )),
                      ],
                    ),
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      color: const Color(0xFFC4C4C4),
                      fontSize: isMobile ? 8 : 16),
                  maxLines: isMobile ? 3 : 4,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        detailTile(
                            isMobile, Icons.groups_3_outlined, eventtype),
                        SizedBox(
                          width: isMobile ? 10 : 16,
                        ),
                        detailTile(isMobile, Icons.calendar_month_outlined,
                            DateFormat('dd-MM-yyyy').format(eventdate)),
                        SizedBox(
                          width: isMobile ? 10 : 16,
                        ),
                        // if (reward != 0)
                        //   detailTile(isMobile, Icons.emoji_events_outlined,
                        //       reward.toString()),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        // if (getRegisterCTA() == 'Register Now') {
                        context.go('/onGoingEvents/$eventId');
                        // }
                      },
                      child: Row(
                        children: [
                          LinearGradientText(
                              child: Text(
                            getRegisterCTA(),
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
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget detailTile(bool isMobile, IconData icon, String heading) {
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
