import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/enums/url_type.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget buildSocialLinksSection(OngoingEvent currentEvent) {
  if (currentEvent.socialLink.isEmpty) {
    return const SizedBox.shrink();
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isMobile = screenWidth < 600;
      final isTablet = screenWidth >= 600 && screenWidth < 900;

      return Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        ),
        margin: EdgeInsets.symmetric(
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
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          child: Wrap(
            spacing: isMobile
                ? 12
                : isTablet
                    ? 16
                    : 20,
            runSpacing: isMobile
                ? 12
                : isTablet
                    ? 16
                    : 20,
            alignment: WrapAlignment.center,
            children: currentEvent.socialLink.map((link) {
              final typeString = (link['type'])?.toLowerCase() ?? '';
              final url = link['url'] ?? '';
              if (typeString.isEmpty || url.isEmpty) {
                return const SizedBox.shrink();
              }

              UrlType? type;
              try {
                type = UrlType.fromString(typeString);
              } catch (e) {
                return const SizedBox.shrink();
              }

              return InkWell(
                onTap: () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not launch $url')),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                child: Tooltip(
                  message: type.toString(),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  verticalOffset: isMobile ? 10 : 14,
                  preferBelow: true,
                  child: Container(
                    width: isMobile
                        ? 50
                        : isTablet
                            ? 55
                            : 60,
                    height: isMobile
                        ? 50
                        : isTablet
                            ? 55
                            : 60,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                      border: Border.all(
                        color: secondaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        type.icon,
                        width: isMobile
                            ? 24
                            : isTablet
                                ? 28
                                : 32,
                        height: isMobile
                            ? 24
                            : isTablet
                                ? 28
                                : 32,
                        color: secondaryColor,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.link,
                          size: isMobile ? 24 : 32,
                          color: secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}
