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

class ContactToSchoolProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isMessageLoading = false;
  ContactToSchoolResponse? contactToSchoolResponse;
  List<ContactToSchoolTicket>? contactToSchoolTicket;

  ConcernHistoryResponse? concern;
  List<ConcernTicket>? concernTicket;

  CategoryResponse? categoryResponse;
  List<CategoryType>? categoryType;  
  

  Future<void> getContactDetails(String reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "sl": "string",
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": "string",
        "usertype": "string"
      };

      final data = await postRequest(ApiEndpoints.getStudentContactToTheSchool, body);

      if (data != null) {
        log("This data is for the student getStudentContactToTheSchool :$data");
        final contact = ContactToSchoolResponse.fromJson(data);
        contactToSchoolResponse = contact;
        contactToSchoolTicket = contact.data;
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getStudentContactToTheSchool: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getQueryHistory(String reg, fromYear, toYear) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "sl": "string",
        "sid": 0,
        "regno": reg,
        "fromyear": fromYear,
        "toyear": toYear,
        "monthid": "string",
        "usertype": "string"
      };

      final data = await postRequest(ApiEndpoints.getStudentQueryHistoryData, body);

      if (data != null) {
        log("This data is for the student getStudentContactToTheSchool history and chat :$data");
        final contact = ConcernHistoryResponse.fromJson(data);
        concern = contact;
        concernTicket = contact.data;
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getStudentContactToTheSchool: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getConcernType() async {
    // _setLoading(true);
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

      final data = await postRequest(ApiEndpoints.getConcernTypeList, body);

      if (data != null) {
        log("This data is for the add concern:$data");
        categoryResponse = CategoryResponse.fromJson(data);
        categoryType = categoryResponse!.data;
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the student getStudentContactToTheSchool: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitConcern(
     category,
     subCategory,
     subId,
     concernText,
    List<PlatformFile> attachment, // single file, can be expanded to list later
      regno,
      from,
      to,
  ) async {
    final String url = "${ApiConfig.baseUrl}${ApiEndpoints.createStudentNewConcern}";
    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields.addAll({
        'content_type': category?.toString() ?? '',
        'content_category_id': subCategory?.toString() ?? '',
        'content_catregory_type': category?.toString() ?? '',
        'regno': regno?.toString() ?? '',
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
      getContactDetails(regno,from,to);
    }
  }


  Future<void> sendMessage(
    regno,
    fromYear,
    toYear,
    complaintRegNo,
    message,
    List<PlatformFile> selectedFiles
  ) async {    
    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;
    
    try {
      isMessageLoading = true;
      var url = "${ApiConfig.baseUrl}${ApiEndpoints.replyStudentConcern}";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add fields
      request.fields.addAll({
        'complaint_reg_no': complaintRegNo,
        'content_id': '0',
        'regno': regno,
        'content_description': message,
      });

      final files = List<PlatformFile>.from(selectedFiles);

      // Add files
      for (var file in files) {
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
      getQueryHistory(
        complaintRegNo,
        fromYear, 
        toYear
      );
      notifyListeners(); // <-- Always notify, even on error
    }
  }
}