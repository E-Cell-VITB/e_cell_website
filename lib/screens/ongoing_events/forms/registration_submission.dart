import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/app_logs.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';
import 'package:e_cell_website/backend/firebase_services/event_register_service.dart';

class RegistrationService {
  static Future<void> handleRegistration(
    BuildContext context,
    OngoingEvent event,
    String eventId,
    List<Map<String, dynamic>> participants,
    String? teamName,
    VoidCallback onCheckComplete,
    VoidCallback onSubmitComplete,
  ) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onCheckComplete();
    });

    try {
      final provider =
          Provider.of<OngoingEventProvider>(context, listen: false);
      final isRegistered = await provider.checkUserRegistration(eventId);
      if (isRegistered) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomToast(
            title: "Already Registered",
            description: "You are already registered for this event.",
            type: ToastificationType.info,
          );
          context.go('/ongoingEvents');
        });
        return;
      }

      await _submitRegistration(
        context,
        event,
        eventId,
        participants,
        teamName,
        provider,
        onSubmitComplete,
      );
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomToast(
          title: "Error",
          description: "Failed to check registration: $e",
          type: ToastificationType.error,
        );
      });
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onCheckComplete();
      });
    }
  }

  static Future<void> _submitRegistration(
    BuildContext context,
    OngoingEvent event,
    String eventId,
    List<Map<String, dynamic>> participants,
    String? teamName,
    OngoingEventProvider provider,
    VoidCallback onSubmitComplete,
  ) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onSubmitComplete();
    });

    try {
      final emailService = EmailService();
      await provider.submitRegistration(
        eventId,
        event.isTeamEvent ? teamName : 'individual',
        participants,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomToast(
          title: 'Registration Successful',
          description:
              'Thank you for registering for ${event.name}! Sending confirmation emails...',
          type: ToastificationType.success,
        );
      });

      final participantEmails = participants
          .where((p) => p['email'] != null && p['email'].toString().isNotEmpty)
          .map((p) => p['email'].toString())
          .toList();

      if (participantEmails.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomToast(
            title: 'Email Warning',
            description:
                'Registration successful, but no valid emails provided for thank-you emails.',
            type: ToastificationType.warning,
          );
          if (GoRouter.of(context).canPop()) {
            GoRouter.of(context).pushReplacement('/onGoingEvents');
          } else {
            AppLogger.log('Cannot navigate: Router stack is empty or invalid');
            showCustomToast(
              title: 'Navigation Error',
              description: 'Unable to navigate to events page.',
              type: ToastificationType.warning,
            );
          }
        });
        return;
      }

      final eventDate = event.eventDate.toUtc().toIso8601String();
      final result = await emailService.sendThankYouEmails(
        eventName: event.name,
        eventDate: eventDate,
        teamName: event.isTeamEvent ? teamName : null,
        isTeamEvent: event.isTeamEvent,
        participantEmails: participantEmails,
        ctaLink: 'https://ecell-vitb.web.app/#/onGoingEvents',
      );

      if (result['success'] == true) {
        AppLogger.log(
            'Thank-you emails sent: ${result['successCount']} successes, ${result['failureCount']} failures');
        if (result['failureCount'] > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCustomToast(
              title: 'Email Warning',
              description:
                  '${result['successCount']} thank-you emails sent successfully, but ${result['failureCount']} failed.',
              type: ToastificationType.warning,
            );
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showCustomToast(
              title: 'Emails Sent',
              description: 'All thank-you emails sent successfully!',
              type: ToastificationType.success,
            );
          });
        }
      } else {
        AppLogger.log('Failed to send thank-you emails: ${result['message']}');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomToast(
            title: 'Email Error',
            description:
                'Registration successful, but failed to send thank-you emails: ${result['message']}.',
            type: ToastificationType.error,
          );
        });
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (GoRouter.of(context).canPop()) {
          GoRouter.of(context).pushReplacement('/onGoingEvents');
        } else {
          AppLogger.log('Cannot navigate: Router stack is empty or invalid');
          showCustomToast(
            title: 'Navigation Error',
            description: 'Unable to navigate to events page.',
            type: ToastificationType.warning,
          );
        }
      });
    } catch (e) {
      AppLogger.log('Registration error: $e');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showCustomToast(
          title: 'Registration Error',
          description: 'Failed to register: $e',
          type: ToastificationType.error,
        );
      });
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onSubmitComplete();
      });
    }
  }
}
