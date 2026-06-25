
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../common/common_post_method.dart';

class DashboardNotificationProvider extends ChangeNotifier {
  bool isLoading = false;

  Future<void> dashboardNotification(String? reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "sl": "", 
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": "string",
        "usertype": "string"
        };

      final data = await postRequest(ApiEndpoints.getDashboardRecentNotifications, body);

      if (data != null) {
        log("This data is for the student notification :$data");
        // final libraryBook = LibraryIssueModel.fromJson(data);
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student notification: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}