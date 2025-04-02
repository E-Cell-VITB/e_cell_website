import 'package:dio/dio.dart';

class CertificateService {
  final Dio _dio = Dio();

  // URL of your deployed Google Apps Script web app
  final String _apiUrl =
      'https://script.google.com/macros/s/AKfycbzqlOnxhhlZiJYeetOiukTviFxobw4_3kyujrcvSDGDXe5uaAXGBJpBPNJL9jEfLpKZBw/exec';

  Future<Map<String, dynamic>> fetchCertificate({
    required String identifier,
    required String identifierType,
    required String apiUrl,
  }) async {
    try {
      // Prepare query parameters based on identifier type
      Map<String, String> params = {};
      if (identifierType == 'Registration Number') {
        params['regdno'] = identifier.trim();
      } else {
        params['email'] = identifier.trim();
      }

      // Make API call
      final response = await _dio.get(_apiUrl, queryParameters: params);

      return response.data;
    } catch (e) {
      throw Exception('Connection error. Please try again later. Error: $e');
    }
  }
}
