import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/constant.dart';
import '../../models/Students/add_concern.dart';
import '../../models/Students/concern_history.dart';
import '../../models/Students/contact_to_school.dart';
import '../common/common_post_method.dart';
import '../common/get_api_kay.dart';

class EmpContactToSchoolProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isMessageLoading = false;
  ContactToSchoolResponse? contactToSchoolResponse;
  List<ContactToSchoolTicket>? contactToSchoolTicket;

  ConcernHistoryResponse? concern;
  List<ConcernTicket>? concernTicket;

  CategoryResponse? categoryResponse;
  List<CategoryType>? categoryType;  

  int empSelectedTab = 0;
  int currentPage = 1;

  String selectedTab = "1";
  

  Future<void> fetchContactDetails(String emp, fromYear, toYear, tab) async {
    // _setLoading(true);

    empSelectedTab = tab == "0" ? 0 : 1;
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "empid": emp,
        "page_no": currentPage.toString(),
        "page_length": "20",
        "status": empSelectedTab.toString(),
        "mode": "NA",
        "fromyear": fromYear,
        "toyear": toYear
      };

      final data = await postRequest(ApiEndpoints.fetchEmpContactTOSchool, body);

      if (data != null) {
        log("This data is for the student fetchEmpContactTOSchool :$data");
        final contact = ContactToSchoolResponse.fromJson(data);
        contactToSchoolResponse = contact;
        contactToSchoolTicket = contact.data;
      }
    }catch (e){
      log("This is the error for the student fetchEmpContactTOSchool: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchQueryHistory(
    String reg,
    String fromYear, 
    String toYear
  ) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "sl": reg,
        "fromyear": fromYear,
        "toyear": toYear,
      };

      final data = await postRequest(ApiEndpoints.fetchEmpConcernHistory, body);

      if (data != null) {
        log("This data is for the student fetchEmpConcernHistory history and chat :$data");
        final contact = ConcernHistoryResponse.fromJson(data);
        concern = contact;
        concernTicket = contact.data;
      }
    }catch (e){
      log("This is the error for the student fetchEmpConcernHistory: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchConcernType() async {
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "sl": "string",
        "sid": 0,
        "regno": "String",
        "fromyear": "String",
        "toyear": "String",
        "monthid": "string",
        "usertype": "string"
      };

      final data = await postRequest(ApiEndpoints.fetchConcernTypeList, body);

      if (data != null) {
        log("This data is for the add concern:$data");
        categoryResponse = CategoryResponse.fromJson(data);
        categoryType = categoryResponse!.data;
      }
    }catch (e){
      log("This is the error for the student fetchConcernTypeList: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitEmpConcern(
     category,
     subCategory,
     subId,
     concernText,
    List<PlatformFile> attachment, // single file, can be expanded to list later
      regno,
      from,
      to,
  ) async {
    final String url = "${ApiConfig.baseUrl}${ApiEndpoints.createEmpConcern}";
    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields.addAll({
        'content_type': category?.toString() ?? '',
        'content_category_id': subCategory?.toString() ?? '',
        'content_catregory_type': category?.toString() ?? '',
        'empid': regno?.toString() ?? '',
        'fromyear': from?.toString() ?? '',
        'content_description': concernText,
      });


      if (apiKey != null) {
        request.headers['ApiKey'] = apiKey;
      }
      // request.headers['Content-Type'] = 'multipart/form-data';

      for (var file in attachment){
        if (file.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
            'attachment',
            file.path!,
          ));
          log("Attachment added: ${attachment.length}");
          log('File path: ${file.path}');
        }
      }

      log("Submitting concern with data: ${request.fields}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final responseData = response.body;
        if (responseData.contains("Success")) {
          log("Concern submitted successfully!");
          return true;
        } else {
          log("Failed to submit concern: $responseData");
          return false;
        }
      } else {
        log("Error ${response.statusCode}: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      log("Error submitting concern: $e");
      return false;
    } finally {
      fetchContactDetails(regno,from,to, selectedTab);
    }
  }


  Future<void> sendEmpMessage(
    regno,
    fromYear,
    toYear,
    complaintRegNo,
    message,
    List<PlatformFile> selectedFiles
  ) async {
    notifyListeners(); 
    
    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

    try {
      isMessageLoading = true;
      var url = "${ApiConfig.baseUrl}${ApiEndpoints.replyEmployeeConcern}";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add fields
      request.fields.addAll({
        'complaint_reg_no': complaintRegNo,
        'content_id': '0',
        'EMPID': regno,
        'content_description': message,
      });

      // Add files
      for (var file in selectedFiles) {
        if (file.path != null) {
          request.files.add(
            await http.MultipartFile.fromPath('attachments', file.path!),
          );
        }
      }

      if (apiKey != null) {
        request.headers['ApiKey'] = apiKey;
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      log(response.body);
      if (response.statusCode == 200) {
        isMessageLoading = false;
        // clearConcerns();
      }
    } catch (e) {
      isMessageLoading = false;
      log("This is the Error Message: $e");
    } finally {
      isMessageLoading = false;
      fetchQueryHistory(
        complaintRegNo,
        fromYear, 
        toYear
      );
      notifyListeners();
    }
  }
  void clearEmpContactToSchoolData() {
    // Loading flags
    isLoading = false;
    isMessageLoading = false;

    // Contact to school data
    contactToSchoolResponse = null;
    contactToSchoolTicket = null;

    // Concern history data
    concern = null;
    concernTicket = null;

    // Category data
    categoryResponse = null;
    categoryType = null;

    // Tabs & pagination
    empSelectedTab = 0;
    currentPage = 1;
    selectedTab = "1";

    notifyListeners();
  }

}