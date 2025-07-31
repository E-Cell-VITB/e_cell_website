import 'dart:async';
import 'dart:convert';
import 'package:e_cell_website/const/app_logs.dart';
import 'package:http/http.dart' as http;

class RegistrationEmailService {
  Future<Map<String, dynamic>> sendThankYouEmails({
    required String eventName,
    required String eventDate,
    String? teamName,
    required bool isTeamEvent,
    required List<String> participantEmails,
    required String? thankYouEmailAppScriptUrl,
  }) async {
    final payload = {
      'eventName': eventName,
      'eventDate': eventDate,
      'teamName': teamName,
      'isTeamEvent': isTeamEvent,
      'participantEmails': participantEmails,
    };

    // AppLogger.log("Pariticipants emails: $participantEmails");

    if (thankYouEmailAppScriptUrl?.isEmpty ?? true) {
      AppLogger.log('Thank you email script URL is not set');
      return {
        'success': false,
        'data': null,
        'message': 'Thank you email script URL is not set',
      };
    }

    final appsScriptUrl = thankYouEmailAppScriptUrl ??
        'https://script.google.com/macros/s/AKfycbzYASQZTX6DA4DiX76LvtV0FZ6awa8F7o4LJvCoJwRkrl7OCALonSSjF_GW_Q7MmuTWQQ/exec';

    try {
      final response = await http
          .post(
            Uri.parse(appsScriptUrl),
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 30));

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // AppLogger.log(
      //     'Response status: ${response.statusCode}, success: ${data['success']}');

      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        final errorMessage = data['message'] ?? 'Unknown error';
        // AppLogger.log('Failed to send emails: $errorMessage');
        return {
          'success': false,
          'data': null,
          'message': 'Failed to send thank-you emails: $errorMessage',
        };
      }
    } catch (e) {
      // AppLogger.log('Error sending thank-you emails: $e');
      return {
        'success': false,
        'data': null,
        'message': 'Error sending thank-you emails: $e',
      };
    }
  }
}
