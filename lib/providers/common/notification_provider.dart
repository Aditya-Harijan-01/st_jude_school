import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/notification_notice.dart';
import '../../models/notificaion_model.dart';
import '../common/common_post_method.dart';

class NotificationProvider extends ChangeNotifier {

  EmployeeNotificationResponse? employeeNotificationResponse;
  List<EmployeeNotificationItem>? employeeNotificationItem;
  bool isLoading = false;

  NoticeResponse? noticeResponse;
  List<NoticeData>? noticeData;

  Future<void> getStudentNotification(String reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "sl": "100",
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": "string",
        "usertype": "string"
        };

      final data = await postRequest(ApiEndpoints.getNotification, body);

      if (data != null) {
        log("Message received from API: ${data.length}");
        log("This data is for the student notification :$data");
        final parsed = NoticeResponse.fromJson(data);
        log("Message received from API: ${parsed.data?.length}");
        noticeResponse = parsed;
        noticeData = parsed.data;
      }
    }catch (e){
      log("This is the error for the student notification: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getEmployeeNotification({
    required String empID,
    required String fromYear,
    required String toYear,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "top": '100',
        "empid": empID,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getEmployeeNotification, body);

      if (data != null) {
        log("Employee Notification card data: $data");
        final parsed = EmployeeNotificationResponse.fromJson(data);
        employeeNotificationResponse = parsed;
        employeeNotificationItem = parsed.data;
        notifyListeners();
      }
    } catch (e) {
      log("Error fetching Employee Notification card data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}