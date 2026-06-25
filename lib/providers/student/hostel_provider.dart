import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../common/common_post_method.dart';
import '../../models/Students/hostel_status_model.dart';
import '../../models/Students/hostel_fee_structure_model.dart';

class HostelProvider extends ChangeNotifier {
  bool isLoading = false;
  HostelStatusResponse? hostelStatusResponse;
  HostelFeeStructureResponse? hostelFeeStructureResponse;

  Future<void> getStudentHostelStatus(String regNo, String fromYear, String toYear) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "regno": regNo,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getStudentHostelStatus, body);

      if (data != null) {
        log("Data for getStudentHostelStatus: $data");
        hostelStatusResponse = HostelStatusResponse.fromJson(data);
      }
    } catch (e) {
      log("Error in getStudentHostelStatus: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStudentHostelFeeStructure(String regNo, String fromYear, String roomId, String hostelDate) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "regno": regNo,
        "fromyear": fromYear,
        "roomid": roomId,
        "hosteldate": hostelDate
      };

      final data = await postRequest(ApiEndpoints.getStudentHostelFeeStructure, body);

      if (data != null) {
        log("Data for getStudentHostelFeeStructure: $data");
        hostelFeeStructureResponse = HostelFeeStructureResponse.fromJson(data);
      }
    } catch (e) {
      log("Error in getStudentHostelFeeStructure: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
