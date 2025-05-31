import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

// Breakpoints for responsive design
const double _mobileBreakpoint = 600;
const double _tabletBreakpoint = 900;

class GuestsAndJudgesSection extends StatelessWidget {
  final dynamic event;
  final bool isMobile;

  const GuestsAndJudgesSection({
    required this.event,
    required this.isMobile,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (event.jury.isNotEmpty) ...[
          LinearGradientText(
            child: Text(
              'Guests & Judges',
              style: isMobile
                  ? Theme.of(context).textTheme.headlineSmall
                  : Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 8),
          buildGuestsAndJudgesSection(event),
          const SizedBox(height: 24),
        ],
      ],
    );
  }
}

Widget buildGuestsAndJudgesSection(OngoingEvent currentEvent) {
  if (currentEvent.jury.isEmpty) {
    return const SizedBox.shrink();
  }

  return Builder(
    builder: (context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final isMobile = screenWidth < _mobileBreakpoint;
      final isTablet =
          screenWidth >= _mobileBreakpoint && screenWidth < _tabletBreakpoint;

      // Scale padding and spacing based on screen size
      final horizontalPadding = isMobile
          ? 12.0
          : isTablet
              ? 20.0
              : 32.0;
      final verticalPadding = isMobile
          ? 8.0
          : isTablet
              ? 12.0
              : 16.0;
      final wrapSpacing = isMobile
          ? 12.0
          : isTablet
              ? 16.0
              : 24.0;

      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Wrap(
          spacing: wrapSpacing,
          runSpacing: wrapSpacing,
          alignment: WrapAlignment.center,
          children: currentEvent.jury.map((person) {
            return _buildPersonCard(
              person: person,
              isMobile: isMobile,
              isTablet: isTablet,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
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
  required double screenWidth,
  required double screenHeight,
}) {
  // Calculate card width as a percentage of screen width, with min/max clamps
  final cardWidth = screenWidth *
      (isMobile
          ? 0.45
          : isTablet
              ? 0.33
              : 0.25);
  final clampedCardWidth = cardWidth.clamp(140.0, 220.0);

  // Scale font sizes and image sizes based on screen size
  final imageSize = isMobile
      ? 60.0
      : isTablet
          ? 80.0
          : 100.0;
  final nameFontSize = isMobile
      ? 14.0
      : isTablet
          ? 15.0
          : 16.0;
  final aboutFontSize = isMobile
      ? 10.0
      : isTablet
          ? 11.0
          : 12.0;
  final roleFontSize = isMobile ? 8.0 : 10.0;
  final borderRadius = isMobile ? 12.0 : 16.0;

  return Container(
    width: clampedCardWidth,
    margin: const EdgeInsets.only(bottom: 8.0),
    child: Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(
                top: isMobile ? 6.0 : 8.0,
                right: isMobile ? 6.0 : 8.0,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 6.0 : 8.0,
                vertical: isMobile ? 3.0 : 4.0,
              ),
              decoration: BoxDecoration(
                color: person.role == 'Judge'
                    ? Colors.purple.withOpacity(0.2)
                    : Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(isMobile ? 10.0 : 12.0),
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
                  fontSize: roleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: imageSize,
            height: imageSize,
            margin: EdgeInsets.only(top: isMobile ? 6.0 : 8.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(imageSize / 2),
              child: CachedNetworkImage(
                imageUrl: person.photoUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: SizedBox(
                    width: imageSize * 0.5,
                    height: imageSize * 0.5,
                    child: const CircularProgressIndicator(color: primaryColor),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  color: primaryColor,
                  size: imageSize * 0.6,
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 8.0 : 12.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.0 : 12.0),
            child: Text(
              person.name,
              style: TextStyle(
                fontSize: nameFontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: isMobile ? 4.0 : 6.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.0 : 12.0),
            child: Text(
              person.about,
              style: TextStyle(
                fontSize: aboutFontSize,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
              maxLines: isMobile ? 2 : 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: isMobile ? 8.0 : 12.0),
        ],
      ),
    ),
  );
}
