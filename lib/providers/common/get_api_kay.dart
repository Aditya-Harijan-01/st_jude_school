import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../constants/constant.dart';
import '../../models/get_api_model.dart';

class ApiKeyDart {
  //   Singleton pattern
  static final ApiKeyDart _instance = ApiKeyDart._internal();
  factory ApiKeyDart() => _instance;
  ApiKeyDart._internal();

  ApiKeyModel? apiKeyModel;
  List<DataPermission>? dataPermission;

  Future<void> getApiKey() async {
    try {
      final clientCode = dotenv.env['CLIENT_CODE'];
      if (clientCode == null || clientCode.isEmpty) {
        log("❌ Missing CLIENT_CODE in .env file");
        return;
      }

      final url = Uri.parse("${ApiConfig.baseUrl}${ApiEndpoints.getApiKey}");
      log("Fetching API key from: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"client_code": clientCode}),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        apiKeyModel = ApiKeyModel.fromJson(jsonResponse);
        dataPermission = apiKeyModel?.dataPermission;

        log("  API Key: ${apiKeyModel?.apiKey}");
        log("  First Module: ${apiKeyModel?.dataPermission?.first.moduleName}");
      } else {
        log("❌ Failed: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (e) {
      log("⚠️ Error getting API key: $e");
    }
  }
}


//6312