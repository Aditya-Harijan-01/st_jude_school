import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../constants/constant.dart';
import '../../models/Students/fee_structure.dart';
import '../../models/Students/fine_structure_response.dart';
import '../common/get_api_kay.dart';

class FeeStructureProvider extends ChangeNotifier {
  bool isLoading = false;
  FeeStructureResponse? feeStructure;
  List<FeeMainData> dataMain = [];
  List<FeeInstallmentData> paidInstallments = [];
  List<FeeInstallmentData> unpaidInstallments = [];
  FeeStructureResponse? get feeStructureResponse => feeStructure;

  // Fine related properties
  bool isFineLoading = false;
  FineResponseModel? fineResponse;
  List<FineData> unpaidFines = [];
  List<FinePaidData> paidFines = [];
  FineResponseModel? get fineResponseModel => fineResponse;

  Future<bool> getFeeStructureByStudent({
    required String regNo,
    required String fromYear,
    required String toYear,
  })
  async {
    isLoading = true;
    notifyListeners();

    final String url = "${ApiConfig.baseUrl}${ApiEndpoints.getFeeStructureByStudent}";
    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

    final Map<String, dynamic> body = {
      "sl": "string",
      "sid": 0,
      "regno": regNo,
      "fromyear": fromYear,
      "toyear": toYear,
      "cls": "",
      "stream": ""
    };
    log("url: $url body: $body");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          if (apiKey != null) 'ApiKey': apiKey, 
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        feeStructure = FeeStructureResponse.fromJson(data);

        dataMain = feeStructure?.dataMain?? [];
        paidInstallments = feeStructure?.dataInstallment
            .where((fee) => fee.paymentStatus == 'Paid')
            .toList() ?? [];
        unpaidInstallments = feeStructure?.dataInstallment
            .where((fee) => fee.paymentStatus == 'Pending')
            .toList() ?? [];


        log("Fee structure data fetched successfully");
        log(response.body);

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        log("Error: ${response.statusCode} - ${response.body}");
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get fee structure data error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> getFineDetailByStudent({
    required String regNo,
    required String fromYear,
    required String toYear,
  }) async {
    isFineLoading = true;
    notifyListeners();

    final String url = "${ApiConfig.baseUrl}${ApiEndpoints.getFineDetailByStudent}";
    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;
    log(url);

    final Map<String, dynamic> body = {
      "sl": "string",
      "sid": 0,
      "regno": regNo,
      "fromyear": fromYear,
      "toyear": toYear,
      "cls": "",
      "stream": ""
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          if (apiKey != null) 'ApiKey': apiKey, 
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        fineResponse = FineResponseModel.fromJson(data);

        unpaidFines = fineResponse?.unpaidData ?? [];
        paidFines = fineResponse?.paidData ?? [];

        log("Fine detail data fetched successfully");
        log(response.body);

        isFineLoading = false;
        notifyListeners();
        return true;
      } else {
        log("Error: ${response.statusCode} - ${response.body}");
        isFineLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get fine detail data error: $e");
      isFineLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearData() {
    feeStructure = null;
    dataMain.clear();
    paidInstallments.clear();
    unpaidInstallments.clear();
    fineResponse = null;
    unpaidFines.clear();
    paidFines.clear();
    notifyListeners();
  }

}