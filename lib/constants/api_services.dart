import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class ApiService extends ChangeNotifier {
  static String? get appUrl => dotenv.env['APP_URL'];
  static String get apiUrl => '$appUrl/api';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';


  Future<String> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$apiUrl/$endpoint');
      final response = await http.post(
        url,
        headers: {
          'ApiKey': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      log('url: $url');
      log('request body: ${jsonEncode(data)}');
      log('result: ${response.body}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (error) {
      debugPrint('API Error:');
      rethrow;
    }
  }
  //usages:
  // try {
  //       final response = await _apiService.postData('otp/send', {
  //         'phone': phoneNumber,
  //         'signature_id': 'CAREBUS',
  //       });
  //       return jsonDecode(response);
  //     } catch (error) {
  //       debugPrint('Error sending OTP: $error');
  //       rethrow;
  //     }
}


