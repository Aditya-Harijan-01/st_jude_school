import 'dart:developer';
import 'package:flutter/material.dart';
import '../../constants/constant.dart';
import '../../models/employee/assignment.dart';
// import '../../widgets/kdebug_log.dart';
import '../common/common_post_method.dart';

class AssignmentListProvider extends ChangeNotifier {
  // UI States
  bool isLoading = false;
  bool hasMore = true;

  // Assignment Data
  List<AssignmentData> assignmentList = [];

  // Filter State
  int currentStatus = -1; // -1 = Pending, 1 = Submitted

  // Pagination
  int page = 1;
  int pageSize = 20;

  // Scroll Controller
  final ScrollController scrollController = ScrollController();

  String? empId;
  String? year;
  String? toYear; 

  AssignmentListProvider() {
    _initScroll();
  }

  /// ------------------------------------------------------------
  /// LISTEN TO SCROLL FOR PAGINATION
  /// ------------------------------------------------------------
  void _initScroll() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  /// ------------------------------------------------------------
  /// SWITCH TAB (Pending / Submitted)
  /// ------------------------------------------------------------
  Future<void> switchStatus(int status, String empId, String year, String toYear) async {
    if (currentStatus == status) return;

    currentStatus = status;
    page = 1;
    hasMore = true;
    assignmentList.clear();

    await fetchAssignments(empId, year, toYear);
  }

  /// ------------------------------------------------------------
  /// FETCH ASSIGNMENT LIST (PAGINATED)
  /// ------------------------------------------------------------
  Future<void> fetchAssignments(
      String empId, String year, String toYear, {bool isMore = false}) async {
    if (isLoading || !hasMore) return;

    this.empId = empId;
    this.year = year;
    this.toYear = toYear;

    isLoading = true;
    notifyListeners();

    final url = ApiEndpoints.getAssignment;

    final body = {
      "empid": empId,
      "page_no": page,
      "page_length": pageSize,
      "search": "",
      "fromyear": year,
      "toyear": toYear,
      "status": currentStatus,
    };

    try {
      final response = await postRequest(
        url,
        body
      );

      log("Assignment List Response: $response");

      if (response != null) {
        final model = AssignmentResponse.fromJson(response);

        if (model.data.isNotEmpty) {
          assignmentList.addAll(model.data);
          // for (var item in model.data) {
          //   log("AppSerial: ${item.appSerial}");
          // }
        } else {
          hasMore = false;
        }

        hasMore = model.data.length >= pageSize ? true : false; 
      }
    } catch (e) {
      log("fetchAssignments ERROR → $e");
      hasMore = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ------------------------------------------------------------
  /// LOAD MORE DATA
  /// ------------------------------------------------------------
  Future<void> loadMore() async {
    if (!hasMore || isLoading) return;
    if (empId == null || year == null || toYear == null) return;
    page++;
    await fetchAssignments(empId!, year!, toYear!, isMore: hasMore);
  }

  /// ------------------------------------------------------------
  /// REFRESH LIST
  /// ------------------------------------------------------------
  Future<void> refreshAssignments(String empId, String year, String toYear) async {
    page = 1;
    hasMore = true;
    assignmentList.clear();
    await fetchAssignments(empId, year, toYear);
  }

  /// ------------------------------------------------------------
  /// SESSION CHANGE
  /// ------------------------------------------------------------
  Future<void> refreshForNewSession(
      String empId, String year, String toYear) async {
    page = 1;
    hasMore = true;
    assignmentList.clear();
    await fetchAssignments(empId, year, toYear);
  }

  /// ------------------------------------------------------------
  /// CLEAR ALL DATA & RESET PROVIDER
  /// ------------------------------------------------------------
  void clearAssignment(){
    assignmentList.clear();
    notifyListeners();
  }
  void clearAll() {
    isLoading = false;
    hasMore = true;

    assignmentList.clear();

    currentStatus = -1;

    page = 1;
    pageSize = 20;

    scrollController.jumpTo(0);

    notifyListeners();
  }
}
