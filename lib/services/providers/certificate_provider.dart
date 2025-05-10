import 'package:e_cell_website/backend/firebase_services/certificate_service.dart';
import 'package:e_cell_website/services/const/toaster.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CertificateProvider extends ChangeNotifier {
  final CertificateService _service = CertificateService();

  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = '';
  String _downloadUrl = '';
  String _name = '';
  String _email = '';
  String _message = '';
  String _identifierType = 'Registration Number';
  bool _isDownloading = false;
  // Getters
  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  bool get isDownloading => _isDownloading;
  String get errorMessage => _errorMessage;
  String get downloadUrl => _downloadUrl;
  String get name => _name;
  String get email => _email;
  String get message => _message;
  String get identifierType => _identifierType;

  void setIdentifierType(String type) {
    _identifierType = type;
    notifyListeners();
  }

  void setErrorMessage(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void resetState() {
    _isSuccess = false;
    _errorMessage = '';
    _downloadUrl = '';
    _name = '';
    _email = '';
    _message = '';
    _isDownloading = false;
    notifyListeners();
  }

  Future<void> fetchCertificate(
      {required String identifier, required String apiUrl}) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _service.fetchCertificate(
        identifier: identifier,
        identifierType: _identifierType,
        apiUrl: apiUrl,
      );

      if (response['success'] == true) {
        _isSuccess = true;
        _name = response['name'] ?? '';
        _email = response['email'] ?? '';
        _downloadUrl = response['downloadUrl'] ?? '';
        _message = response['message'] ?? '';
      } else {
        _errorMessage = response['error'] ?? 'An unknown error occurred';
      }
    } catch (e) {
      _errorMessage = 'Connection error. Please try again later.';
      debugPrint('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> downloadCertificate(BuildContext context) async {
    if (_downloadUrl.isNotEmpty) {
      _isDownloading = true;
      notifyListeners();

      final Uri url = Uri.parse(_downloadUrl);
      try {
        final result =
            await launchUrl(url, mode: LaunchMode.externalApplication);

        await Future.delayed(const Duration(seconds: 1));

        _isDownloading = false;
        notifyListeners();

        if (!result) {
          showCustomToast(
              title: "Try Again", description: "Could not launch download URL");
        } else {
          showCustomToast(
              title: "Congrats",
              description: "Download started in your browser");
        }
        return result;
      } catch (e) {
        _isDownloading = false;
        notifyListeners();

        showCustomToast(
            title: "Try Again", description: "Could not launch download URL");
        return false;
      }
    }
    return false;
  }
}
