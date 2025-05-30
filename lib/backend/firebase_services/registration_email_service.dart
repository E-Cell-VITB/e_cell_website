import 'dart:async';
import 'dart:convert';
import 'package:e_cell_website/const/app_logs.dart';
import 'package:http/http.dart' as http;

class RegistrationEmailService {
  final String _appsScriptUrl =
      "https://script.google.com/macros/s/AKfycbx6WNDWD8XHkp82bMgHwW9kZMP5yEc5YmiquadIoYzMGbrVw2GKu4PrUSbhyywsd7RUcQ/exec";

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
        AppLogger.log('Failed to send emails: $errorMessage');
        throw Exception('Failed to send thank-you emails: $errorMessage');
      }
    } catch (e) {
      AppLogger.log('Error sending thank-you emails: $e');
      throw Exception('Error sending thank-you emails: $e');
    }
  }
}
