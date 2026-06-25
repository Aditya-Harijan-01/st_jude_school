
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../constants/constant.dart';
import '../../models/Students/acedemic_calendar.dart';
import '../common/common_post_method.dart';

class AcedemicCalandarProvider extends ChangeNotifier {
  bool isLoading = false;
  AcademicCalendarResponse? academicCalendarResponse;
  List<AcademicDay>? academicDay;
  


  Future<void> fetchAcademicCalendarForMonth(reg, fromyear, toYear, month) async {
    try {

      final slValue = month.toString();

      await getAcedemicCalandar(
        reg,
        fromyear,
        toYear,
        slValue,
      );
    } catch (e, s) {
      log('Error fetching academic calendar for month $month: $e');
      debugPrintStack(stackTrace: s);
    }
  }



  Future<void> getAcedemicCalandar(String reg, fromYear, toYear, month) async {
    // _setLoading(true);
    try {
      isLoading = true;
      reg = reg;
      fromYear =  fromYear;
      toYear = toYear;
      notifyListeners();
      final body = {
        "sl": month, 
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": "string",
        "usertype": "string"
      };
      final empBody = {
        "sl": month,
        "empid": "",
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": ""
      };


      final data = await postRequest(reg != "emp" ? ApiEndpoints.getAcademicCalendar: ApiEndpoints.getEmployeeAcademicCalendar,reg != "emp" ? body : empBody);

      if (data != null) {
        final acedCalandar = AcademicCalendarResponse.fromJson(data);
        academicCalendarResponse = acedCalandar;
        academicDay = acedCalandar.data;
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