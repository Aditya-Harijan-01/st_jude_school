import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/Students/library_model.dart';
import '../common/common_post_method.dart';

class LibraryDetailsProvider extends ChangeNotifier {

  LibraryIssueModel? libraryIssueModel;
  List<IssueDetail>? issueDetail;
  // LibraryIssueModel? libraryData;
  bool isLoading = false;

  Future<void> getLibraryData(String reg) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final body = {
        "regno": reg,
      };

      final data = await postRequest(ApiEndpoints.getLibrary, body);

      if (data != null) {
        log("This data is for the library :$data");
        final libraryBook = LibraryIssueModel.fromJson(data);
        libraryIssueModel = libraryBook;
        issueDetail = libraryBook.issueDetails;
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the library: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLibraryDataEmp(String empid) async {
    // _setLoading(true);
    try {
      isLoading = true;
      notifyListeners();
      final Emp = {
        "empid": empid,
      };

      final data = await postRequest(ApiEndpoints.getEmployeeLibraryRecords, Emp);

      if (data != null) {
        log("This data is for the library :$data");
        final libraryBook = LibraryIssueModel.fromJson(data);
        libraryIssueModel = libraryBook;
        issueDetail = libraryBook.issueDetails;
        notifyListeners();
        // return true;
      }
    }catch (e){
      log("This is the error for the library: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

   List<IssueDetail> get issuedBooks =>
      libraryIssueModel?.issueDetails
          .where((b) => b.isReturn == "0")
          .toList() ??
      [];

  List<IssueDetail> get returnedBooks =>
      libraryIssueModel?.issueDetails
          .where((b) => b.isReturn == "1")
          .toList() ??
      [];
}