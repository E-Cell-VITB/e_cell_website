import 'package:e_cell_website/backend/models/event.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
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
                            showCustomToast(
                                title: 'Error',
                                description: 'Cannot launch ${socialLink.url}',
                                type: ToastificationType.error);
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
