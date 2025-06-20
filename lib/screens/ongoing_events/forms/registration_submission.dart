import 'package:e_cell_website/backend/firebase_services/registration_email_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:e_cell_website/backend/models/ongoing_events.dart';
import 'package:e_cell_website/const/app_logs.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:e_cell_website/services/providers/ongoing_event_provider.dart';

class RegistrationSubmission {
  static Future<void> handleRegistration(
    BuildContext context,
    OngoingEvent event,
    String eventId,
    List<Map<String, dynamic>> participants,
    String? teamName,
    VoidCallback onCheckComplete,
    VoidCallback onSubmitComplete,
  ) async {
    try {
      final provider =
          Provider.of<OngoingEventProvider>(context, listen: false);

      // AppLogger.log("Paricipants: $participants");

      // Check for duplicate emails across all registrations
      final emailDuplicateCheck =
          await _checkDuplicateEmails(eventId, participants);
      if (emailDuplicateCheck['hasDuplicates']) {
        if (context.mounted) {
          showCustomToast(
            title: "Duplicate Registration",
            description:
                "One or more emails are already registered for this event: ${emailDuplicateCheck['duplicateEmails'].join(', ')}",
            type: ToastificationType.error,
          );
          onCheckComplete();
        }
        return;
      }

      // Check if user is already registered
      final isRegistered = await provider.checkUserRegistration(eventId);
      if (isRegistered) {
        if (context.mounted) {
          showCustomToast(
            title: "Already Registered",
            description: "You are already registered for this event.",
            type: ToastificationType.info,
          );
          onCheckComplete();
        }
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
      if (context.mounted) {
        showCustomToast(
          title: "Error",
          description: "Failed to check registration: $e",
          type: ToastificationType.error,
        );
        onCheckComplete();
      }
      AppLogger.log('Registration check error: $e');
    }
  }

  static Future<Map<String, dynamic>> _checkDuplicateEmails(
    String eventId,
    List<Map<String, dynamic>> participants,
  ) async {
    final firestore = FirebaseFirestore.instance;
    final duplicateEmails = <String>[];
    bool hasDuplicates = false;

    for (var participant in participants) {
      final email = participant['email']?.toString();
      if (email != null && email.isNotEmpty) {
        final query = await firestore
            .collection('ongoing_events')
            .doc(eventId)
            .collection('registered_users')
            .where('participants.email', arrayContains: email)
            .get();

        if (query.docs.isNotEmpty) {
          hasDuplicates = true;
          duplicateEmails.add(email);
        }
      }
    }

    return {
      'hasDuplicates': hasDuplicates,
      'duplicateEmails': duplicateEmails,
    };
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
    try {
      final emailService = RegistrationEmailService();
      await provider.submitRegistration(
        eventId,
        event.isTeamEvent ? teamName : 'individual',
        participants,
      );

      if (context.mounted) {
        showCustomToast(
          title: 'Registration Successful',
          description: 'Thank you for registering for ${event.name}!',
          type: ToastificationType.success,
        );
      }

      final participantEmails = participants
          .where((p) => p['Email'] != null && p['Email'].toString().isNotEmpty)
          .map((p) => p['Email'].toString())
          .toList();

      // if (participantEmails.isEmpty && context.mounted) {
      //   showCustomToast(
      //     title: 'Email Warning',
      //     description:
      //         'Registration successful, but no valid emails provided for thank-you emails.',
      //     type: ToastificationType.warning,
      //   );
      // }

      final eventDate = event.eventDate.toUtc().toIso8601String();
      await emailService.sendThankYouEmails(
        eventName: event.name,
        eventDate: eventDate,
        teamName: event.isTeamEvent ? teamName : null,
        isTeamEvent: event.isTeamEvent,
        participantEmails: participantEmails,
        ctaLink: 'https://ecell-vitb.web.app/#/onGoingEvents',
      );

      if (context.mounted) {
        onSubmitComplete();
        GoRouter.of(context).pushReplacement('/onGoingEvents');
      }
    } catch (e) {
      if (context.mounted) {
        showCustomToast(
          title: 'Error',
          description: 'Registration failed: $e',
          type: ToastificationType.error,
        );
        onSubmitComplete();
      }
      AppLogger.log('Registration error: $e');
    }
  }
}
