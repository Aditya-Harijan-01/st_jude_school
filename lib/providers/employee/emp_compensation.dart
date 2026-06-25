// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
// import '../../constants/colors.dart';
import '../../constants/constant.dart';
import '../../models/employee/compensession_model.dart';
import '../../widgets/show_loading_dialog.dart';
import '../common/common_post_method.dart';
import '../common/get_api_kay.dart';

class EmpCompensationProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  String empId = "";
  String fromYear = "";
  String toYear = "";

  int currentPage = 1;
  bool isDownloading = false;

  List<CompensationModel> salaryHistory = [];

  Future<void> fetchCompensationHistory(
      String emp, String fromYr, String toYr) async {
    empId = emp;
    fromYear = fromYr;
    toYear = toYr;

    isLoading = true;
    notifyListeners();

    try {
      final body = {
        "empid": empId,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(
        ApiEndpoints.fetchCompensationHistory,
        body,
      );

      if (data != null) {
        log("Compensation History Response: $data");

        if (data["statusCode"] == "Success") {
          final list = data["data"] as List;
          salaryHistory =
            list.map((e) => CompensationModel.fromJson(e)).toList();
        } else {
          errorMessage = data["message"];
          salaryHistory = [];
        }
      } else {
        salaryHistory = [];
      }
    } catch (e) {
      log("fetchCompensationHistory Error: $e");
      errorMessage = e.toString();
      salaryHistory = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // -----------------------------
  // Download PDF Using Same Style
  // -----------------------------
  Future<Object?> downloadPaySlip(
    BuildContext context,
    String emp,
    String fromYr,
    String toYr,
    String monthId,
  ) async {

    showLoadingDialog(context);

    try {
      isDownloading = true;
      notifyListeners();

      final body = {
        "EMPID": emp,
        "fromyear": fromYr,
        "toyear": toYr,
        "monthid": monthId,
      };

      final response = await postRequest(ApiEndpoints.downloadPaySlip, body);

      // CASE 1: Direct PDF
      if (response is Uint8List) {
        hideLoadingDialog(context);
        await showSuccessDialog(context, "", () {});
        return response;
      }

      // CASE 2: JSON contains URL
      if (response != null &&
          response.containsKey("download_url") &&
          response["download_url"] != null) {
        
        String rawUrl = response["download_url"];
        String cleanUrl = rawUrl.replaceAll("\\", "/");

        if (!cleanUrl.startsWith("http")) {
          cleanUrl = "https://$cleanUrl";
        }

        final pdfBytes = await _downloadPdfFromUrl(cleanUrl);

        hideLoadingDialog(context);

        if (pdfBytes != null) {
          // Show success popup and launch
          await showSuccessDialog(
            context,
            cleanUrl,
            () async {
              final uri = Uri.parse(cleanUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
          );
        } else {
          showErrorDialog(context, "Unable to download the file. Please try again.");
        }

        return pdfBytes;
      }

      hideLoadingDialog(context);
      showErrorDialog(context, "Unexpected response from server.");
      return null;

    } catch (e) {
      hideLoadingDialog(context);
      showErrorDialog(context, "Error: $e");
      return null;

    } finally {
      isDownloading = false;
      notifyListeners();
    }
  }


  // ---------------------------
  // Helper: Download PDF By URL
  // ---------------------------
  Future<Uint8List?> _downloadPdfFromUrl(String url) async {
    try {
      final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

      final uri = Uri.parse(url);
      log("this is the url: $uri");
      
      final res = await http.get(uri, headers: {
        "ApiKey": apiKey ?? "",
        "Accept": "application/pdf",
      });

      if (res.statusCode == 200) {
        return res.bodyBytes;
      }
      log("URL PDF failed: ${res.statusCode}");
      return null;
    } catch (e) {
      log("PDF URL download error: $e");
      return null;
    }
  }

  // void showLoadingDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => Dialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Padding(
  //         padding: EdgeInsets.all(20),
  //         child: Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(width: 20),
  //             Text(
  //               "Please wait...",
  //               style: TextStyle(
  //                 fontSize: 16.sp,
  //                 color: CustomColor.colorBlack,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }


  void hideLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  Future<void> showSuccessDialog(
      BuildContext context, String url, VoidCallback onOpen) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Download Complete"),
        content: Text("Salary slip downloaded successfully.\nDo you want to open it?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Open"),
            onPressed: () {
              Navigator.pop(context);
              onOpen();
            },
          ),
        ],
      ),
    );
  }

  Future<void> showErrorDialog(BuildContext context, String message) async {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Failed"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

}