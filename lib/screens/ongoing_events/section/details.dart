import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/screens/events/widgets/eventdetails.dart';
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
        isMobile?
        GradientBox(
          
          radius: 20, 
          height: 450,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        event.bannerPhotoUrl,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: isTablet ? 180 : 290,
                          color: Colors.grey[800],
                          child:
                              const Center(child: Text('Image not available')),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                    Text("ECE",
                            style: TextStyle(
                                color: const Color.fromARGB(255, 103, 103, 103),
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 4,
                        ),
                        LinearGradientText(
                          child: Text(
                            event.name,
                            style: Theme.of(context).textTheme.bodySmall,
                               
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          event.description,
                          maxLines: 5,
                          style:TextStyle(fontSize: 8, color: Colors.white),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            _buildDetailTile(
                              context,
                              icon: Icons.calendar_month_outlined,
                              text: DateFormat('dd-MM-yyyy')
                                  .format(event.eventDate),
                            ),
                            SizedBox(width: 28),
                            _buildDetailTile(
                              context,
                              icon: Icons.access_time_outlined,
                              text: event.status,
                            ),
                          ],
                        ),
              ],
            ),
          )
          ):
        GradientBox(
            height: isTablet ? 300 : 335,
            width: screenWidth,
            radius: 20,
            child: Row(
              children: [                
                Container(
                  //padding symmetric responsive
                  padding: EdgeInsets.symmetric(
                    vertical: isTablet ? 20 : 25,
                    horizontal: isTablet ? 20 : 35,
                  ),
                  width: isTablet ? screenWidth * 0.5 : screenWidth * 0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ECE",
                          style: TextStyle(
                              color: const Color.fromARGB(255, 103, 103, 103),
                              fontSize: isTablet ? 16 : 25,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 4,
                      ),
                      LinearGradientText(
                        child: Text(
                          event.name,
                          style: isTablet
                              ? Theme.of(context).textTheme.headlineSmall
                              : Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        event.description,
                        maxLines: 7,
                        style: isTablet
                            ? Theme.of(context).textTheme.bodySmall
                            : Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          _buildDetailTile(
                            context,
                            icon: Icons.calendar_month_outlined,
                            text: DateFormat('dd-MM-yyyy')
                                .format(event.eventDate),
                          ),
                          SizedBox(width: 28),
                          _buildDetailTile(
                            context,
                            icon: Icons.access_time_outlined,
                            text: event.status,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isMobile ? 9 : 18),
                      child: Image.network(
                        event.bannerPhotoUrl,
                        height: isTablet ? 180 : 290,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: isTablet ? 180 : 290,
                          color: Colors.grey[800],
                          child:
                              const Center(child: Text('Image not available')),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        SizedBox(height: 26),
        // if (event.registrationEnds!.isAfter(DateTime.now()))
        CountdownTimerWidget(
          registrationStarts: event.registrationStarts,
          registrationEnds: event.registrationEnds,
          eventDate: event.eventDate,
          estimatedEventEndTime: event.estimatedEndTime,
          isMobile: isMobile,
          screenWidth: screenWidth,
        ),
      ],
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile
            ? 4
            : isTablet
                ? 6
                : 8,
        horizontal: isMobile
            ? 6
            : isTablet
                ? 8
                : 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 9 : 26),
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
                    ? 12
                    : 14,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: isMobile
                      ? 12
                      : isTablet
                          ? 10
                          : 12),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
