import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/admit_card_model.dart';
import '../common/common_post_method.dart';

class AdmitCardProvider extends ChangeNotifier {
  AdmitCardResponse? admitCardResponse;
  List<AdmitCardData>? admitCardData;
  bool isLoading = false;

  Future<void> getAllAdmitCard({
    required String regno,
    required String fromyear,
    required String toyear,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "sl": "",
        "sid": 0,
        "regno": regno,
        "fromyear": fromyear,
        "toyear": toyear,
        "monthid":"",
      };

      final data = await postRequest(ApiEndpoints.getAllAdmitCard, body);

      if (data != null) {
        log("Admit card data: $data");
        final admitCard = AdmitCardResponse.fromJson(data);
        admitCardResponse = admitCard;
        admitCardData = admitCard.data;
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching admit card data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<AdmitCardData> get availableAdmitCards =>
      admitCardData?.where((card) => card.isAdmitCardIssued).toList() ?? [];



  Future<Map<String, dynamic>?> downloadAdmitCard({
    required String sl,
    required int sid,
    required String regno,
    required String fromyear,
    required String toyear,
    required String examid,
  }) async {
    try {
      final body = {
        "sl": sl,
        "sid": sid,
        "regno": regno,
        "fromyear": fromyear,
        "toyear": toyear,
        "examid": examid,
      };

      final data = await postRequest(ApiEndpoints.downloadAdmitCard, body);
      return data;
    } catch (e) {
      log("Error downloading admit card: $e");
      return null;
    }
  }
  int get totalCards => admitCardData?.length ?? 0;
}