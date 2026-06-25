import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../../constants/constant.dart';
import 'get_api_kay.dart';

Future<Map<String, dynamic>?> postRequest(
  String endpoint,
  Map<String, dynamic> body,
) async {
  final String url = "${ApiConfig.baseUrl}$endpoint";
  final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

  log("POST: $url\nBODY: $body");

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        if (apiKey != null) 'ApiKey': apiKey, //   Safe null check
      },
      body: jsonEncode(body),
    );

    log("Response (${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log("Error ${response.statusCode}: ${response.reasonPhrase}");
      return null;
    }
  } catch (e) {
    log("HTTP error: $e");
    return null;
  }
}


Future<Map<String, dynamic>?> postRequestForBatchAttendance(
  String endpoint,
  List<Map<String, dynamic>> body,
) async {
  final String url = "${ApiConfig.baseUrl}$endpoint";
  final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

  log("POST: $url\nBODY: $body");

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        if (apiKey != null) 'ApiKey': apiKey, //   Safe null check
      },
      body: jsonEncode(body),
    );

    log("Response (${response.statusCode}): ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      log("Error ${response.statusCode}: ${response.reasonPhrase}");
      return null;
    }
  } catch (e) {
    log("HTTP error: $e");
    return null;
  }
}
