import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_cell_website/backend/models/team_member.dart';
import 'package:e_cell_website/services/const/url_launcher_fn.dart';
import 'package:e_cell_website/services/enums/designation.dart';
import 'package:e_cell_website/services/enums/head_table.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final TeamMemberModel teamMember;
  const ProfileCard({super.key, required this.teamMember});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        height: 320,
        width: 232,
        decoration: const BoxDecoration(color: containerBgColor),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 232,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                      width: 2, color: const Color.fromARGB(255, 80, 80, 80)),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 4,
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: teamMember.profileURL,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/icons/logo.png",
                    height: 260,
                    width: 222,
                  ),
                  height: 260,
                  width: 222,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 80,
                    width: 224,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              0.96), // Shadow color (with some transparency)
                          offset: const Offset(0,
                              -15), // Negative y-offset to move shadow to the top
                          blurRadius: 16, // Blur radius to soften the shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14.0, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            textAlign: TextAlign.start,
                            teamMember.name,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LinearGradientText(
                                  child: Text(
                                getDesignationDisplay(
                                  teamMember.designation,
                                ),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                              const SizedBox(
                                width: 20,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      onTap: () {
                                        launchEmail(
                                            teamMember.email,
                                            "Contact Request",
                                            "Hello, I would like to contact you for the following reason: ...");
                                      },
                                      splashColor: primaryColor,
                                      child: SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: ShaderMask(
                                          shaderCallback: (Rect bounds) {
                                            return LinearGradient(
                                              colors: [
                                                Colors.amber,
                                                Colors.amberAccent,
                                                Colors.amber,
                                                Colors.grey.shade50,
                                                Colors.amberAccent,
                                                Colors.amber,
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(bounds);
                                          },
                                          child: const Icon(
                                            Icons.mail,
                                            size: 36,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    shape: const CircleBorder(),
                                    child: InkWell(
                                      onTap: () {
                                        launchURL(
                                            teamMember.linkedInProfileURL);
                                      },
                                      splashColor: primaryColor,
                                      child: SizedBox(
                                        width: 34,
                                        height: 28,
                                        child: Image.asset(
                                          "assets/icons/linkdein_icon.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  String getDesignationDisplay(String designationStr) {
    // First try the Designation enum
    try {
      return Designation.values
          .firstWhere((e) => e.name == designationStr)
          .toString();
    } catch (_) {
      // If not found in Designation, try HeadTable enum
      try {
        return HeadTable.values
            .firstWhere((e) => e.name == designationStr)
            .toString();
      } catch (_) {
        // If not found in either enum, return the original string or a default
        return designationStr.isNotEmpty ? designationStr : "Member";
      }
    }
  }
}
