// import 'package:e_cell_website/backend/models/ongoing_events.dart';
// import 'package:e_cell_website/const/theme.dart';
// import 'package:e_cell_website/services/enums/url_type.dart';
// import 'package:e_cell_website/widgets/linear_grad_text.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class SocialLinksSection extends StatelessWidget {
//   final dynamic event;
//   final bool isMobile;

//   const SocialLinksSection({
//     required this.event,
//     required this.isMobile,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (event.socialLink.isNotEmpty) ...[
//           LinearGradientText(
//             child: Text(
//               'Connect With Us',
//               style: isMobile
//                   ? Theme.of(context).textTheme.headlineSmall
//                   : Theme.of(context).textTheme.headlineMedium,
//             ),
//           ),
//           const SizedBox(height: 8),
//           buildSocialLinksSection(event),
//           const SizedBox(height: 24),
//         ],
//       ],
//     );
//   }
// }

// Widget buildSocialLinksSection(OngoingEvent currentEvent) {
//   if (currentEvent.socialLink.isEmpty) {
//     return const SizedBox.shrink();
//   }

//   return LayoutBuilder(
//     builder: (context, constraints) {
//       final screenWidth = MediaQuery.of(context).size.width;
//       final isMobile = screenWidth < 600;
//       final isTablet = screenWidth >= 600 && screenWidth < 900;

//       return Card(
//         elevation: 4,
//         shadowColor: Colors.black26,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
//         ),
//         margin: EdgeInsets.symmetric(
//           horizontal: isMobile
//               ? 12
//               : isTablet
//                   ? 16
//                   : 24,
//           vertical: isMobile
//               ? 8
//               : isTablet
//                   ? 12
//                   : 16,
//         ),
//         child: Padding(
//           padding: EdgeInsets.all(isMobile ? 12 : 16),
//           child: Wrap(
//             spacing: isMobile
//                 ? 12
//                 : isTablet
//                     ? 16
//                     : 20,
//             runSpacing: isMobile
//                 ? 12
//                 : isTablet
//                     ? 16
//                     : 20,
//             alignment: WrapAlignment.center,
//             children: currentEvent.socialLink.map((link) {
//               final typeString = (link['type'])?.toLowerCase() ?? '';
//               final url = link['url'] ?? '';
//               if (typeString.isEmpty || url.isEmpty) {
//                 return const SizedBox.shrink();
//               }

//               UrlType? type;
//               try {
//                 type = UrlType.fromString(typeString);
//               } catch (e) {
//                 return const SizedBox.shrink();
//               }

//               return InkWell(
//                 onTap: () async {
//                   final uri = Uri.parse(url);
//                   if (await canLaunchUrl(uri)) {
//                     await launchUrl(uri, mode: LaunchMode.externalApplication);
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Could not launch $url')),
//                     );
//                   }
//                 },
//                 borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
//                 child: Tooltip(
//                   message: type.toString(),
//                   decoration: BoxDecoration(
//                     color: Colors.black87,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   textStyle: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                   verticalOffset: isMobile ? 10 : 14,
//                   preferBelow: true,
//                   child: Container(
//                     width: isMobile
//                         ? 50
//                         : isTablet
//                             ? 55
//                             : 60,
//                     height: isMobile
//                         ? 50
//                         : isTablet
//                             ? 55
//                             : 60,
//                     decoration: BoxDecoration(
//                       color: primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
//                       border: Border.all(
//                         color: secondaryColor.withOpacity(0.3),
//                         width: 1,
//                       ),
//                     ),
//                     child: Center(
//                       child: Image.asset(
//                         type.icon,
//                         width: isMobile
//                             ? 24
//                             : isTablet
//                                 ? 28
//                                 : 32,
//                         height: isMobile
//                             ? 24
//                             : isTablet
//                                 ? 28
//                                 : 32,
//                         color: secondaryColor,
//                         errorBuilder: (context, error, stackTrace) => Icon(
//                           Icons.link,
//                           size: isMobile ? 24 : 32,
//                           color: secondaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       );
//     },
//   );
// }

import 'package:e_cell_website/backend/models/event.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FloatingSocialLinks extends StatefulWidget {
  final List<SocialLink> socialLinks;

  const FloatingSocialLinks({
    super.key,
    required this.socialLinks,
  });

  @override
  FloatingSocialLinksState createState() => FloatingSocialLinksState();
}

class FloatingSocialLinksState extends State<FloatingSocialLinks> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _isMenuOpen ? null : 0,
          child: Visibility(
            visible: _isMenuOpen,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  widget.socialLinks.length,
                  (index) {
                    final socialLink = widget.socialLinks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        onTap: () async {
                          final uri = Uri.parse(socialLink.url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, webOnlyWindowName: '_self');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Cannot launch ${socialLink.url}')),
                            );
                          }
                        },
                        child: Tooltip(
                          message: socialLink.urlType.toString(),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          textStyle: const TextStyle(color: Colors.white),
                          verticalOffset: 12,
                          child: Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                socialLink.urlType.icon,
                                fit: BoxFit.contain,
                                height: 26,
                                width: 26,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              _isMenuOpen = !_isMenuOpen;
            });
          },
          child: Tooltip(
            message: "Social Links",
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(color: Colors.white),
            verticalOffset: 12,
            child: Image.asset(
              _isMenuOpen ? "assets/icons/close.png" : "assets/icons/link.png",
              height: 48,
              width: 48,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
