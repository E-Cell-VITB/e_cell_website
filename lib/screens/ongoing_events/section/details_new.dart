import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/ongoing_events/widgets/count_down_time.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailsSection extends StatelessWidget {
  final OngoingEvent event;
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;

  const DetailsSection({
    required this.event,
    required this.isMobile,
    required this.isTablet,
    required this.screenWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearGradientText(
          child: Text(
            event.name,
            style: isMobile
                ? Theme.of(context).textTheme.displayMedium
                : Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16, vertical: 4),
          child: SelectableText(
            event.description,
            style: isMobile
                ? Theme.of(context).textTheme.bodySmall
                : Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: isMobile ? 4 : 6,
          ),
        ),
        const SizedBox(height: 16),
        if (event.bannerPhotoUrl.isNotEmpty) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(isMobile ? 9 : 18),
            child: Image.network(
              event.bannerPhotoUrl,
              height: isMobile
                  ? 100
                  : isTablet
                      ? 140
                      : 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: isMobile
                    ? 100
                    : isTablet
                        ? 140
                        : 180,
                color: Colors.grey[800],
                child: const Center(child: Text('Image not available')),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // if (event.registrationEnds!.isAfter(DateTime.now()))
        CountdownTimerWidget(
          registrationStarts: event.registrationStarts,
          registrationEnds: event.registrationEnds,
          eventDate: event.eventDate,
          estimatedEventEndTime: event.estimatedEndTime,
          isMobile: isMobile,
          screenWidth: screenWidth,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: isMobile
              ? 8
              : isTablet
                  ? 12
                  : 16,
          runSpacing: isMobile
              ? 8
              : isTablet
                  ? 12
                  : 16,
          alignment: WrapAlignment.center,
          children: [
            _buildDetailTile(
              context,
              icon: Icons.calendar_month_outlined,
              title: "Event Date ::",
              text: DateFormat('dd-MM-yyyy').format(event.eventDate),
            ),
          ],
        ),
        //
      ],
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required IconData icon,
    required String text,
    String? title,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? 8
            : isTablet
                ? 10
                : 12,
        horizontal: isMobile
            ? 12
            : isTablet
                ? 14
                : 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 9 : 18),
        color: const Color(0xFF303030),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: secondaryColor,
            size: isMobile
                ? 16
                : isTablet
                    ? 20
                    : 24,
          ),
          if (title != null) ...[
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: isMobile
                        ? 12
                        : isTablet
                            ? 14
                            : 16),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: isMobile
                      ? 12
                      : isTablet
                          ? 14
                          : 16),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
