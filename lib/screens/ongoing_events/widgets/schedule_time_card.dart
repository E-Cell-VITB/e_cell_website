import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:flutter/material.dart';

class ScheduleTimeCard extends StatelessWidget {
  final bool isMobile;
  final bool isTablet;
  final double screenWidth;
  const ScheduleTimeCard({
    required this.isMobile,
    required this.isTablet,
    required this.screenWidth,
    super.key});

  @override
  Widget build(BuildContext context) {
    double cardHeight = isMobile ? 24 : isTablet ? 28 : 32;
    double cardWidth = isMobile ? 78 : isTablet ? 90 : 110;
    double fontSize = isMobile ? 10 : isTablet ? 12 : 13;
    double iconSize = isMobile ? 12 : isTablet ? 14 : 16;
    EdgeInsets padding = isMobile
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 2)
        : isTablet
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 4);

    return Container(
      height: cardHeight,
      width: cardWidth,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color.fromARGB(201, 49, 48, 48),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_outlined,
            color: Theme.of(context).colorScheme.primary,
            size: iconSize,
          ),
          SizedBox(width: isMobile ? 3 : isTablet ? 5 : 6),
          Text(
            '10:00 AM',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}