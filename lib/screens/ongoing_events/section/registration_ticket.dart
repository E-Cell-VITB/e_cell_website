import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/theme.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/auth_provider.dart';
import 'package:e_cell_website/screens/auth/widgets/gradient_box_auth.dart';
import 'package:e_cell_website/widgets/linear_grad_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class EventTicketSection extends StatelessWidget {
  final OngoingEvent event;
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

  String remainingDays(DateTime date) {
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
                  "assets/images/ticket-2.png",
                  height: isMobile
                      ? 240
                      : isTablet
                          ? 200
                          : 225,
                  width: isMobile
                      ? screenWidth * 0.90
                      : isTablet
                          ? screenWidth * 0.5
                          : screenWidth * 0.45,
                  fit: BoxFit.contain,
                ),
                Positioned(
                  top: isMobile
                      ? 56
                      : isTablet
                          ? 20
                          : 36,
                  right: isMobile ? screenWidth * 0.1 : screenWidth * 0.03,
                  child: Column(
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
                                remainingDays(
                                    event.registrationEnds ?? event.eventDate),
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
                      RegisterNowButton(
                          screenHeight: screenHeight,
                          screenWidth: screenWidth,
                          event: event,
                          isMobile: isMobile,
                          isTablet: isTablet),
                    ],
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

class RegisterNowButton extends StatelessWidget {
  const RegisterNowButton({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.event,
    required this.isMobile,
    required this.isTablet,
  });

  final double screenHeight;
  final double screenWidth;
  final OngoingEvent event;
  final bool isMobile;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Defensive Null Handling
    final registrationStart = event.registrationStarts;
    final registrationEnd = event.registrationEnds;
    DateTime? eventEnd = event.estimatedEndTime;
    final eventStart = event.eventDate;

    bool isRegistrationDataMissing =
        registrationStart == null || registrationEnd == null;
    eventEnd ??= eventStart.add(const Duration(days: 1));
    // Evaluation logic
    bool isRegistrationNotStarted =
        isRegistrationDataMissing || now.isBefore(registrationStart);
    bool isRegistrationEnded =
        !isRegistrationDataMissing && now.isAfter(registrationEnd);
    bool isEventEnded = !isRegistrationDataMissing && now.isAfter(eventEnd);
    bool isEventOngoing = !isRegistrationDataMissing &&
        now.isAfter(eventStart) &&
        now.isBefore(eventEnd);
    // bool isRegistrationOpen = !isRegistrationDataMissing &&
    //     now.isAfter(registrationStart) &&
    //     now.isBefore(registrationEnd);

    String buttonText;
    bool isClickable;

    if (isRegistrationNotStarted) {
      buttonText = "Registration Not Started";
      isClickable = false;
    } else if (isRegistrationEnded) {
      buttonText = "Registration Closed";
      isClickable = false;
    } else if (isEventEnded) {
      buttonText = "Event Ended";
      isClickable = false;
    } else if (isEventOngoing) {
      buttonText = "Event in Progress";
      isClickable = false;
    } else {
      buttonText = "Register Now!";
      isClickable = true;
    }

    return InkWell(
      onTap: () {
        if (!isClickable) return;
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        if (authProvider.currentUserModel == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
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
                      builder: (context, auth, _) => auth.page.widget,
                    ),
                  ),
                ),
              );
            },
          ).then((result) {
            if (result == true && authProvider.currentUserModel != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/onGoingEvents/register/${event.id}');
              });
            } else if (result != true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                authProvider.setPage(Pages.login);
              });
            }
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/onGoingEvents/register/${event.id}');
          });
        }
      },
      child: Container(
        width: isMobile
            ? screenWidth * 0.32
            : isTablet
                ? screenWidth * 0.25
                : screenWidth * 0.18,
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
            borderRadius: BorderRadius.circular(isMobile ? 4 : 7),
            gradient: const LinearGradient(colors: linerGradient)),
        child: Center(
          child: Text(
            buttonText,
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
    );
  }
}
