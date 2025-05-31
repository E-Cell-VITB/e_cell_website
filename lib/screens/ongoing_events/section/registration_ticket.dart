import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/screens/auth/widgets/gradient_box_auth.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EventTicketSection extends StatelessWidget {
  final dynamic event;
  final bool isMobile;
  final bool isTablet;
  final DateTime Function(DateTime) truncateToSeconds;

  const EventTicketSection({
    required this.event,
    required this.isMobile,
    required this.isTablet,
    required this.truncateToSeconds,
    super.key,
  });

  String remaining_days(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    if (difference.isNegative) {
      return 'Event has ended';
    }
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;
    if (days > 0) {
      return '$days days left';
    } else if (hours > 0) {
      return '$hours hours left';
    } else if (minutes > 0) {
      return '$minutes minutes left';
    } else {
      return '$seconds seconds left';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        if ((event.registrationEnds == null ||
                event.registrationEnds!.isAfter(DateTime.now())) &&
            event.registrationStarts != null &&
            truncateToSeconds(event.registrationStarts!) !=
                truncateToSeconds(event.createdAt.toDate()))
          SizedBox(
            width: isMobile
                ? screenWidth * 0.95
                : isTablet
                    ? screenWidth * 0.5
                    : screenWidth * 0.4,
            height: isMobile
                ? 180
                : isTablet
                    ? 200
                    : 225,
            child: Center(
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/ticket.png",
                    height: isMobile
                        ? 240
                        : isTablet
                            ? 200
                            : 225,
                    width: isMobile
                        ? screenWidth * 0.95
                        : isTablet
                            ? screenWidth * 0.5
                            : screenWidth * 0.4,
                    fit: BoxFit.contain,
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            "assets/images/Ecell.png",
                            height: isMobile
                                ? 80
                                : isTablet
                                    ? 120
                                    : 180,
                            width: isMobile
                                ? 80
                                : isTablet
                                    ? 120
                                    : 180,
                            fit: BoxFit.cover,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LinearGradientText(
                                child: Text(
                                  "Grab your Spot",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMobile
                                        ? 14
                                        : isTablet
                                            ? 20
                                            : 25,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: isMobile
                                      ? 4
                                      : isTablet
                                          ? 10
                                          : 15),
                              Container(
                                height: isMobile
                                    ? 16
                                    : isTablet
                                        ? 24
                                        : 30,
                                width: isMobile
                                    ? 70
                                    : isTablet
                                        ? 100
                                        : 150,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 39, 39, 39),
                                  borderRadius:
                                      BorderRadius.circular(isMobile ? 12 : 20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_time_outlined,
                                      color: Colors.amber,
                                      size: isMobile
                                          ? 12
                                          : isTablet
                                              ? 16
                                              : 18,
                                    ),
                                    SizedBox(width: isMobile ? 3 : 7),
                                    LinearGradientText(
                                      child: Text(
                                        remaining_days(event.registrationEnds ??
                                            event.eventDate),
                                        style: TextStyle(
                                          fontSize: isMobile
                                              ? 6
                                              : isTablet
                                                  ? 11
                                                  : 13,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height: isMobile
                                      ? 4
                                      : isTablet
                                          ? 10
                                          : 15),
                              GestureDetector(
                                onTap: () {
                                  final authProvider =
                                      Provider.of<AuthProvider>(context,
                                          listen: false);
                                  if (authProvider.currentUserModel == null) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      showCustomToast(
                                        title: "Hold Up!",
                                        description:
                                            "You need to log in before registering for an event.",
                                      );
                                    });
                                    showDialog<bool>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (dialogContext) {
                                        return Dialog(
                                          backgroundColor: Colors.white,
                                          child: SizedBox(
                                            height: screenHeight * 0.8,
                                            width: screenWidth * 0.4,
                                            child: GradientBoxAuth(
                                              radius: 16,
                                              height: screenHeight * 0.8,
                                              width: screenWidth * 0.4,
                                              child: Consumer<AuthProvider>(
                                                builder: (context, auth, _) {
                                                  return auth.page.widget;
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((result) {
                                      if (result == true &&
                                          authProvider.currentUserModel !=
                                              null) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          context.go(
                                              '/onGoingEvents/register/${event.id}');
                                        });
                                      } else if (result != true) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          authProvider.setPage(Pages.login);
                                        });
                                      }
                                    });
                                  } else {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      context.go(
                                          '/onGoingEvents/register/${event.id}');
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isMobile
                                        ? 3
                                        : isTablet
                                            ? 8
                                            : 10,
                                    horizontal: isMobile
                                        ? 10
                                        : isTablet
                                            ? 20
                                            : 30,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(isMobile ? 4 : 7),
                                    gradient: const LinearGradient(
                                        colors: linerGradient),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Register Now!",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: isMobile
                                            ? 9
                                            : isTablet
                                                ? 11
                                                : 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
