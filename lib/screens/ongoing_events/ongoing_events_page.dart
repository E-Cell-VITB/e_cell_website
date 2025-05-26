import 'package:e_cell_website/screens/ongoing_events/widgets/event_card.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';

class OngoingEventsPage extends StatelessWidget {
  const OngoingEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ParticleBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EventCard(
                    eventname: "TechSprouts",
                    description: "Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development. Its purpose is to permit a page layout to be designed, independently of the copy that will subsequently populate it, or to demonstrate various fonts of a typeface without meaningful text that could be distracting.",
                    eventtype: "Team Event",
                    eventdate: DateTime(2025,5,30,0,0),
                    reward: "20000",
                  ),
                  SizedBox(height: 30,),
                  EventCard(
                    eventname: "Innovit",
                    description: "Lorem ipsum is a dummy or placeholder text commonly used in graphic design, publishing, and web development. Its purpose is to permit a page layout to be designed, independently of the copy that will subsequently populate it, or to demonstrate various fonts of a typeface without meaningful text that could be distracting.",
                    eventtype: "Individual",
                    eventdate: DateTime(2025,5,28,0,0),
                    reward: "20000",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}