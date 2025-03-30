import 'package:e_cell_website/backend/models/event.dart';
import 'package:e_cell_website/const/theme.dart';

import 'package:e_cell_website/screens/events/widgets/event_dialog.dart';
import 'package:e_cell_website/services/providers/events_provider.dart';
import 'package:e_cell_website/widgets/footer.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/widgets/loading_indicator.dart';
import 'package:e_cell_website/widgets/particle_bg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final size = MediaQuery.of(context).size;
    return ParticleBackground(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LinearGradientText(
                child: Text(
                  "Events",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: size.width * 0.8,
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: size.width > 600
                              ? "Fueling Ideas, Igniting Change: E-Cell VITB Events "
                              : "Fueling Ideas, Igniting Change\nE-Cell VITB Events ",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        TextSpan(
                          text: "✨",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 32),
              StreamBuilder<List<Event>>(
                  stream: eventProvider.getEventsStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: LoadingIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No events found'));
                    }

                    List<Event> events = snapshot.data!;

                    final filteredEvents = events
                        .where((event) => event.allPhotos.isNotEmpty)
                        .toList();
                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          vertical: 20, horizontal: size.width * 0.1),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: size.width > 600 ? 3 : 1,
                        crossAxisSpacing: size.width * 0.08,
                        mainAxisSpacing: size.height * 0.08,
                        childAspectRatio: 3,
                      ),
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final Event event = filteredEvents[index];

                        return InkWell(
                            onTap: () => ShowEventBox(context, index, event),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: linerGradient),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.all(1),
                              child: Container(
                                height: size.height * 0.6,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                        colors: eventBoxLinearGradient),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    event.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                              ),
                            ));
                      },
                    );
                  }),
              const SizedBox(height: 24),
              const Footer()
            ],
          ),
        ),
      ),
    );
  }
}
