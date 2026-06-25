import 'dart:developer';
import 'package:flutter/foundation.dart';
import '../../constants/constant.dart';
import '../../models/Students/time_table.dart';
import '../../widgets/date_format.dart';
import '../common/common_post_method.dart';

class TimetableProvider extends ChangeNotifier {
  bool isLoading = false;

  TeacherTimetableModel? teacherTimetableModel;
  List<TimetableData>? timetableData;


  Future<void> getTimetableDetails(date, String reg, fromYear, toYear) async {
    
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "sl": formatDate(date),
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": "string",
        "usertype": "string"
      };

      final data = await postRequest(ApiEndpoints.getDaywiseTimetableDetails, body);

      if (data != null) {
        log("This data is for the student getDaywiseTimetableDetails :$data");
        final time = TeacherTimetableModel.fromJson(data);
        teacherTimetableModel = time;
        timetableData = time.data;
        
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getDaywiseTimetableDetails: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}