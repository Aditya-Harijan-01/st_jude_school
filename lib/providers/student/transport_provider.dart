import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import '../../constants/constant.dart';
import '../../models/Students/transport/transport_receipt_download.dart';
import '../../models/Students/transport/transport_route.dart';
import '../../models/Students/transport_fee.dart';
import '../../models/Students/transpost_status.dart';
import '../common/common_post_method.dart';

class TransportProvider extends ChangeNotifier {
  bool isLoading = false;

  TransportResponseModel? transportResponseModel;
  List<TransportPoint>? transportPoint;

  TransportFeeResponse? transportFeeModel;
  List<TransportQuarterFeeModel>? transportQuarter;


  RouteResponse? routeResponse;
  List<RouteInfo>? routeInfo;
  StopPoint? stopPoint;

  TransportPaymentResponseExist? transportPaymentResponseExist;
  List<TransportPaymentData>? transportPayment;
  


  Future<void> getTransportStatus(String reg, fromYear, toYear) async {
    // Clear stale state before fetching fresh transport status.
    transportResponseModel = null;
    transportPoint = null;
    transportFeeModel = null;
    transportQuarter = null;
    routeResponse = null;
    routeInfo = null;
    transportPaymentResponseExist = null;
    transportPayment = null;

    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getStudentTransportStatus, body);

      if (data != null) {
        log("This data is for the student getStudentTransportStatus :$data");
        final newData = TransportResponseModel.fromJson(data);
        transportResponseModel = newData;
        transportPoint = newData.defaultPointList;

        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getStudentTransportStatus: $e");
    } finally {
      isLoading = false;
      final pointId = transportResponseModel?.pointId;
      if (pointId != null && pointId.isNotEmpty) {
        getTransportFeeStructure(reg, fromYear, pointId);
      }
      getTransportAssignedRouteDetails(reg, fromYear, toYear);
      getTransportReceipt(reg,fromYear,toYear);
      notifyListeners();
    }
  }

  Future<void> getTransportReceipt(String reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getStudentTransportReceipt, body);

      if (data != null) {
        log("This data is for the student getStudentTransportReceipt :$data");
        final newData = TransportPaymentResponseExist.fromJson(data);
        transportPaymentResponseExist = newData;
        transportPayment = newData.data;

        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getStudentTransportReceipt: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<Map<String, dynamic>?> downloadfee({
    required List<TransportPaymentData> receipts
  }) async {
    try {
      final body = {
        "regno": receipts.first.regNo,
        "fromyear": receipts.first.fromYear,
        "toyear": receipts.first.toYear,
        "rcpshowno": receipts.first.rcpShowNo,
        "rcpno": receipts.first.rcpNo,
        "rcptype": receipts.first.rcpType,
        "payment_date": receipts.first.paymentDate,
        "paid_amount": receipts.first.paidAmount,
        "flag": receipts.first.flag,
      };

      final data = await postRequest(ApiEndpoints.printStudentPaymentReceipt, body);
      return data;
    } catch (e) {
      log("Error downloading admit card: $e");
      return null;
    }
  }
  Future<String?> printReceipt(List<TransportPaymentData> receipts) async {
    try {
      isLoading = true;
      notifyListeners();

      final body = {
        "regno": receipts.first.regNo,
        "fromyear": receipts.first.fromYear,
        "toyear": receipts.first.toYear,
        "rcpshowno": receipts.first.rcpShowNo,
        "rcpno": receipts.first.rcpNo,
        "rcptype": receipts.first.rcpType,
        "payment_date": receipts.first.paymentDate,
        "paid_amount": receipts.first.paidAmount,
        "flag": receipts.first.flag,
      };

      final data = await postRequest(ApiEndpoints.printStudentPaymentReceipt, body);

      if (data != null && data['download_url'] != null) {
        log("Receipt print response: $data");
        final fixedUrl = data['download_url'].replaceAll("\\", "/");
        final fullUrl = "https://$fixedUrl";
        return fullUrl;
      }
    } catch (e) {
      log("Error printing transport receipt: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> downloadAndOpenReceipt(String fullUrl) async {
    try {
      final dio = Dio();
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/transport_receipt.pdf";

      await dio.download(fullUrl, filePath);
      await OpenFilex.open(filePath);
    } catch (e) {
      log("Error downloading receipt: $e");
    }
  }


  Future<void> getTransportTracking(String reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getTransportTrackingDetails, body);

      if (data != null) {
        log("This data is for the student getTransportTrackingDetails :$data");
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getTransportTrackingDetails: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTransportFeeStructure( String? reg, fromYear, pointId,) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "regno": reg,
        "fromyear": fromYear,
        "pointid": pointId,
        "busdate": ""
      };

      final data = await postRequest(ApiEndpoints.getStudentTransportFeeStructure, body);

      if (data != null) {
        log("This data is for the student getStudentTransportFeeStructure :$data");
        final model = TransportFeeResponse.fromJson(data);
        transportFeeModel = model;
        transportQuarter = model.data;
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getStudentTransportFeeStructure: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getTransportAssignedRouteDetails(String reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getTransportAssignedRouteDetails, body);

      if (data != null) {
        log("This data is for the student getTransportAssignedRouteDetails :$data");
        final newData = RouteResponse.fromJson(data);
        routeResponse = newData;
        routeInfo = newData.cardData;
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getTransportAssignedRouteDetails: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?>  getInitializeTransportFee(String reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.getTransportAssignedRouteDetails, body);

      if (data != null) {
        return data;
      } else {
        return null;
      }
    }catch (e){
      log("This is the error for the student getTransportAssignedRouteDetails: $e");
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  

  void clearTransportData() {
    transportResponseModel = null;
    transportPoint = null;
    transportFeeModel = null;
    transportQuarter = null;
    routeResponse = null;
    routeInfo = null;
    stopPoint = null;
    isLoading = false;

    notifyListeners();
  }

}
