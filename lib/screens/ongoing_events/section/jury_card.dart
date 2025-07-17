import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/schedule_time_card.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class JuryCard extends StatelessWidget {
  final OngoingEvent event;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;
  const JuryCard(
      {required this.event,
      required this.isMobile,
      required this.isTablet,
      required this.screenWidth,
      super.key});

  @override
  Widget build(BuildContext context) {
    return isMobile
        ? GradientBox(
          width: screenWidth*0.8,
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
                          child: const Center(child: Text('Image not available')),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                    "Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development.",
                    textAlign: TextAlign.center,
                    
                  )
                ],
              ),
            ))
        : GradientBox(
            height: 200,
            width: double.infinity,
            radius: 22,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 200,
                  width: 200,              
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/images/anouncment.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Center(child: Text('Image not available')),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: isTablet
                          ? screenWidth * 0.4
                          : screenWidth * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ScheduleTimeCard(
                              isMobile: isMobile,
                              isTablet: isTablet,
                              screenWidth: screenWidth),
                          const SizedBox(width: 10),
                          Text("-"),
                          const SizedBox(width: 10),
                          LinearGradientText(
                              child: Text(" Jury Evaluation Starts",
                                  style: TextStyle(
                                      fontSize: isTablet
                                              ? 14
                                              : 16,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SelectableText(
                        "Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development.",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      )
                    ],
                  ),
                )
              ],
            ));
  }
}
