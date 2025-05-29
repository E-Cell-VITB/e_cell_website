import 'dart:async';
import 'dart:convert';
import 'package:e_cell_website/const/app_logs.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class EmailService {
  final String _appsScriptUrl =
      'https://script.google.com/macros/s/AKfycbwW3dCjjnL0EcgEAvFbN9-83X4oU8jEjpuyYJnyBM1SveUnV0WUgn1V8IwjI06978cugQ/exec';

  /// Sends thank-you emails for event registrations via Apps Script with retry logic
  Future<Map<String, dynamic>> sendThankYouEmails({
    required String eventName,
    required String eventDate,
    String? teamName,
    required bool isTeamEvent,
    required List<String> participantEmails,
    required String ctaLink,
  }) async {
    final payload = {
      'eventName': eventName,
      'eventDate': eventDate,
      'teamName': teamName,
      'isTeamEvent': isTeamEvent,
      'participantEmails': participantEmails,
      'ctaLink': ctaLink,
    };

    // Initialize RetryClient with 3 retry attempts
    final client = RetryClient(http.Client(),
        retries: 3,
        delay: (retryCount) => Duration(milliseconds: 500 * retryCount));

    try {
      AppLogger.log('Sending thank-you emails to: $_appsScriptUrl');
      AppLogger.log('Payload: ${jsonEncode(payload)}');

      final response = await client
          .post(
        Uri.parse(_appsScriptUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      )
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'Request to Apps Script timed out after 30 seconds');
      });

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        AppLogger.log('Response: ${response.statusCode} - ${response.body}');
        return data; // Return response data for processing
      } else {
        AppLogger.log(
            'Apps Script API error: ${response.statusCode} - ${response.body}');
        throw Exception(
            'Failed to send thank-you emails: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      AppLogger.log('Error sending thank-you emails: $e');
      throw Exception('Error sending thank-you emails: $e');
    } finally {
      client.close(); // Close the RetryClient
    }
  }

  /// Returns the current Apps Script URL
  String getAppsScriptUrl() => _appsScriptUrl;
}
