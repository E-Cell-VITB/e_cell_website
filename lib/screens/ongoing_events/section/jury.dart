import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/schedule_time_card.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class Jury extends StatelessWidget {
  final OngoingEvent event;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;
  const Jury(
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
            '|  Jury',
            style: isMobile
                ? Theme.of(context).textTheme.headlineSmall
                : Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: _jurycard(),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

Widget _jurycard() {
  return Container(
      height: 220,
      width: 180,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 41, 40, 40),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                //white border only on the bottom
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 0),
            ListTile(
              title: Text(
                'Jury Name',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'Designation',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              ),
            ),
          ]));
}
