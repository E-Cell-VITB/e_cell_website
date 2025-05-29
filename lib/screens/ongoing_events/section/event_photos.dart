import 'package:e_cell_website/screens/ongoing_events/widgets/gallery.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:flutter/material.dart';

class EventPhotosSection extends StatelessWidget {
  final OngoingEvent event;
  final bool isMobile;
  final bool isTablet;

  const EventPhotosSection({
    required this.event,
    required this.isMobile,
    required this.isTablet,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        if (event.allPhotos.isNotEmpty) ...[
          LinearGradientText(
            child: Text(
              'Event Photos',
              style: isMobile
                  ? Theme.of(context).textTheme.headlineSmall
                  : Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 16),
          PhotoGalleryWidget(
            photoUrls: event.allPhotos,
            isMobile: isMobile,
            size: size,
          ),
          SizedBox(height: size.height * 0.05),
        ],
      ],
    );
  }
}
