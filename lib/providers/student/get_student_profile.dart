import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../constants/constant.dart';
import '../../models/Students/student_profile.dart';
import '../common/common_post_method.dart';

class StudentProfileProvider extends ChangeNotifier {
  bool isLoading = false;
  StudentProfileResponse? profileOne; 
  List<AdmissionDetails>? admissionDetails;
  List<ParentDetails>? parentDetails;
  List<RegistrationDetails>? registrationDetails;
  List<AcademicDetails>? academicDetails;
  List<ReadmissionDetails>? readmissionDetails;

  Future<bool> getStudentProfile(userType, username, fromYear, toYear) async {
    isLoading = true;
    notifyListeners();

    const String url = "${ApiConfig.baseUrl}${ApiEndpoints.getStudentProfile}";
    log(url);

    final Map<String, dynamic> body = {
      "usertype": userType,
      "sl": "string",
      "sid": 0,
      "regno": username,
      "fromyear": fromYear,
      "toyear": toYear,
      "monthid": "string"
    };

    try {

      final data = await postRequest(ApiEndpoints.getStudentProfile, body);

      if (data != null) {
        profileOne = StudentProfileResponse.fromJson(data);
        academicDetails = profileOne?.responseObject?.academicDetails;
        registrationDetails = profileOne?.responseObject?.registrationDetails;
        admissionDetails = profileOne?.responseObject?.admissionDetails;
        parentDetails = profileOne?.responseObject?.parentDetails;
        readmissionDetails = profileOne?.responseObject?.readmissionDetails;

        isLoading = false;
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get student profile data error: $e");
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearStudentProfileData() {
    profileOne = null;
    admissionDetails = null;
    parentDetails = null;
    registrationDetails = null;
    academicDetails = null;
    readmissionDetails = null;
    isLoading = false;

    notifyListeners();
    if (kDebugMode) {
      log("  Student profile data cleared successfully");
    }
  }

}
