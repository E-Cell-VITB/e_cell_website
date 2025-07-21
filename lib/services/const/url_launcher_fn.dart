import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not launch $url";
  }
}

Future<void> launchEmail(String email, String subject, String body) async {
  final String encodedSubject = Uri.encodeComponent(subject);
  final String encodedBody = Uri.encodeComponent(body);

  final Uri emailUri = Uri.parse(
    'mailto:$email?subject=$encodedSubject&body=$encodedBody',
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch $emailUri';
  }
}

