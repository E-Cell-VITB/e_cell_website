import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegistrationEmailService {
  final String _appsScriptUrl =
      "https://script.google.com/macros/s/AKfycbwmtMfDC-gq1Tl7cYKIjVrM2mJWWKqUFeOjfX9Z6jG_n8nVR7ycxMTFoWpDCJgdwd0VPA/exec";

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

    // AppLogger.log("Pariticipants emails: $participantEmails");

    try {
      final response = await http
          .post(
            Uri.parse(_appsScriptUrl),
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
