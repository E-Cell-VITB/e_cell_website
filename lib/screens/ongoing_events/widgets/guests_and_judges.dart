import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:flutter/material.dart';

Widget buildGuestsAndJudgesSection(OngoingEvent currentEvent) {
  if (currentEvent.jury.isEmpty) {
    return const SizedBox.shrink();
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isMobile = screenWidth < 600;
      final isTablet = screenWidth >= 600 && screenWidth < 900;

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? 12
              : isTablet
                  ? 16
                  : 24,
          vertical: isMobile
              ? 8
              : isTablet
                  ? 12
                  : 16,
        ),
        child: Wrap(
          spacing: isMobile
              ? 12
              : isTablet
                  ? 16
                  : 24,
          runSpacing: isMobile
              ? 12
              : isTablet
                  ? 16
                  : 24,
          alignment: WrapAlignment.center,
          children: currentEvent.jury.map((person) {
            return _buildPersonCard(
              person: person,
              isMobile: isMobile,
              isTablet: isTablet,
              maxWidth: constraints.maxWidth,
            );
          }).toList(),
        ),
      );
    },
  );
}

Widget _buildPersonCard({
  required JuryMember person,
  required bool isMobile,
  required bool isTablet,
  required double maxWidth,
}) {
  final cardWidth = isMobile
      ? maxWidth * 0.42
      : isTablet
          ? maxWidth * 0.3
          : 180.0;

  return Container(
    width: cardWidth.clamp(150, 200),
    margin: const EdgeInsets.only(bottom: 8),
    child: Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(
                top: isMobile ? 6 : 8,
                right: isMobile ? 6 : 8,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 6 : 8,
                vertical: isMobile ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: person.role == 'Judge'
                    ? Colors.purple.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                border: Border.all(
                  color: person.role == 'Judge' ? Colors.purple : Colors.blue,
                ),
              ),
              child: Text(
                person.role,
                style: TextStyle(
                  color: person.role == 'Judge'
                      ? Colors.purple.shade200
                      : Colors.blue.shade200,
                  fontSize: isMobile ? 8 : 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: isMobile ? 60 : 80,
            height: isMobile ? 60 : 80,
            margin: EdgeInsets.only(top: isMobile ? 6 : 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isMobile ? 30 : 40),
              child: CachedNetworkImage(
                imageUrl: person.photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: primaryColor),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.person,
                  color: primaryColor,
                  size: 40,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
            child: Text(
              person.name,
              style: TextStyle(
                fontSize: isMobile
                    ? 14
                    : isTablet
                        ? 15
                        : 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 12),
            child: Text(
              person.about,
              style: TextStyle(
                fontSize: isMobile
                    ? 10
                    : isTablet
                        ? 11
                        : 12,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: isMobile ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}
