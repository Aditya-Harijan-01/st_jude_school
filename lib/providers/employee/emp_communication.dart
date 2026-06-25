// corrected emp_communication.dart

// ignore_for_file: use_build_context_synchronously, deprecated_member_use
import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';
import '../../constants/constant.dart';
import '../../models/common/class_response.dart';
import '../../models/employee/announcement.dart';
import '../../models/employee/announcment_category.dart';
import '../../models/employee/class_data.dart';
import '../../models/employee/class_wise_student.dart';
import '../../models/employee/employee.dart';
import '../../models/employee/group_category.dart';
import '../../models/employee/group_employee.dart';
import '../../models/employee/student_management/student_list.dart';
import '../../widgets/show_loading_dialog.dart';
import '../common/common_post_method.dart';
import '../common/get_api_kay.dart';

class EmpCommunicationProvider extends ChangeNotifier {
  // ------------------------------
  // BASIC STATE
  // ------------------------------
  String? selectedAnnouncementType;
  DateTime? selectedDate;
  String? selectedClass;
  String? selectedCategory;

  bool isAddToResource = false;
  bool isDatePickerOpen = false;
  bool isClassSelectionVisible = false;
  bool isStudentSelectionVisible = false;

  bool showAddCommunication = false;

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMoreData = true;

  bool isLoadingAnnouncment = false;
  bool isLoadingClasses = false;

  int currentPage = 1;
  final int pageLength = 20;

  String? empID = "";
  String? year = "";
  String? toYear = "";

  List<String> selectedEmployeeIds = [];
  List<PlatformFile> selectedFiles = [];

  final topicController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? _selectedDate;

  // ------------------------------
  // API DATA
  // ------------------------------
  List<Announcement> announcement = [];

  List<ClassItem>? announcementTypes;
  List<ClassData>? classData;
  List<AnnouncementCategory>? announcementCategory;
  List<Employee>? employees;
  List<Student>? student;
  List<ClassWiseStudent>? students;
  List<GroupCategory>? groupCategory;
  List<GrpEmployee>? grpEmployees;

  Set<String> selectedMessageTypes = {};

  // ------------------------------------
  // RESET
  // ------------------------------------
  void clearFormData() {
    topicController.clear();
    descriptionController.clear();
    selectedAnnouncementType = null;
    selectedDate = null;
    selectedClass = null;
    selectedCategory = null;
    selectedEmployeeIds = [];
    isAddToResource = false;
    selectedFiles = [];
    notifyListeners();
  }

  void hideAddConcernForm() {
    clearFormData();
    showAddCommunication = false;
    notifyListeners();
  }

  void showAddConcernForm() {
    showAddCommunication = true;
    // NOTE: keep this call if you want announcement types loaded when opening form
    getAnnouncementTypes(empID, year, toYear);
    notifyListeners();
  }

  void toggleMessageType(String type) {
    if (selectedMessageTypes.contains(type)) {
      selectedMessageTypes.remove(type);
    } else {
      selectedMessageTypes.add(type);
    }
    notifyListeners();
  }

  String get formattedDate {
    if (_selectedDate == null) return 'xx/xx/xx';
    return '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year.toString().substring(2)}';
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    selectedDate = date;
    isDatePickerOpen = false; // Close the date picker after selection

    // Show class selection if announcement type is 'Class'
    if (selectedAnnouncementType == 'Class') {
      isClassSelectionVisible = true;
    }

    notifyListeners();
  }


  /// Completely resets the Add Communication page state
  void resetAddCommunicationPage() {
    // Clear form data
    topicController.clear();
    descriptionController.clear();
    selectedAnnouncementType = null;
    selectedCategory = null;
    selectedClass = null;
    selectedDate = null;
    selectedEmployeeIds.clear();
    selectedFiles.clear();
    selectedMessageTypes.clear();

    // Reset UI flags
    isAddToResource = false;
    isDatePickerOpen = false;
    isClassSelectionVisible = false;
    isStudentSelectionVisible = false;
    isLoadingAnnouncment = false;
    isLoadingClasses = false;

    // Hide add form
    showAddCommunication = false;

    notifyListeners();
  }


  // ------------------------------
  // ANNOUNCEMENT TYPES
  // ------------------------------
  Future<void> getAnnouncementTypes(String? empID, String? year, String? toYear) async {
    isLoading = true;
    notifyListeners();

    final url = ApiEndpoints.getAnnouncmentType;

    final body = {
      "empid": empID,
      "fromyear": year,
      "toyear": toYear,
    };

    try {
      final response = await postRequest(url, body);

      log("Announcement Types Response: $response");

      if (response != null) {
        announcementTypes = ClassDataResponse.fromJson(response).data;
      }
    } catch (e) {
      log("Error getAnnouncementTypes: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> loadMoreData(String? empid, String? year, String? toYear) async {
    if (!isLoadingMore && hasMoreData) {
      await getCommunicationList(empid, year, toYear);
    }
  }

  // ------------------------------
  // FETCH COMMUNICATION LIST
  // ------------------------------
  Future<void> getCommunicationList(String? id, String? y, String? tY, {bool refresh = false}) async {
    empID = id;
    year = y;
    toYear = tY;

    if (refresh) {
      currentPage = 1;
      hasMoreData = true;
      announcement.clear();
    }

    if (!hasMoreData) return;

    // set loading flags
    if (currentPage == 1) {
      isLoading = true;
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    final url = ApiEndpoints.getCommunicationList;

    final body = {
      "empid": empID,
      "page_no": currentPage,
      "page_length": pageLength,
      "fromyear": year
    };

    try {
      final response = await postRequest(url, body);

      log("Communication List Response: $response");

      if (response != null) {
        final parsed = AnnouncementResponse.fromJson(response).data;

        announcement.addAll(parsed);

        if (parsed.length < pageLength) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
      }
    } catch (e) {
      log("Error getCommunicationList: $e");
    } finally {
      isLoading = false;
      isLoadingMore = false;
      notifyListeners();
    }
  }

  // ------------------------------
  // SUBMIT NOTICE
  // ------------------------------
  Future<void> submitNotice(BuildContext context) async {
    try {
      final apiKey = ApiKeyDart().apiKeyModel?.apiKey;
      final date = selectedDate != null ? DateFormat("yyyy/MM/dd").format(selectedDate!) : "";
      final url = ApiConfig.baseUrl+ApiEndpoints.createNewNotice;

      log("This is the url :$url");

      var req = http.MultipartRequest('POST', Uri.parse(url));

      req.fields.addAll({
        "empid": empID ?? "",
        "send_to": selectedAnnouncementType ?? "",
        "send_date": date,
        "add_to_resource": isAddToResource ? "1" : "0",
        "messgage_type": selectedMessageTypes.join(","),
        "notice_head": topicController.text,
        "notice_detail": descriptionController.text,
        "selected_ids": selectedEmployeeIds.join(","),
        "fromyear": year ?? "",
        "toyear": toYear ?? ""
      });

      for (var file in selectedFiles) {
        if (file.path != null) {
          req.files.add(await http.MultipartFile.fromPath("attachments", file.path!));
        }
      }

      // safe header add
      req.headers.addAll({"ApiKey": apiKey ?? ""});

      final streamed = await req.send();
      final resp = await http.Response.fromStream(streamed);

      log("SubmitNotice: ${resp.body}");
      if(resp.statusCode == 200){
        await getCommunicationList(empID, year, toYear);
        hideAddConcernForm();
      }
    } catch (e) {
      log("Error submitNotice: $e");
    }
    notifyListeners();
  }

  void updateSelectedCategoryType(BuildContext context, String? value, String? category) {
    isLoadingAnnouncment = true;
    selectedCategory = value;

    if (value != null) {
      if (announcementCategory != null && category == "EMP") {
        final selectedCategoryType = announcementCategory!.firstWhere(
          (announcementCategory) => announcementCategory.categoryId == value,
          orElse: () => AnnouncementCategory(categoryId: '', categoryName: ''),
        );
        // NOTE: Ensure this method exists and signature matches
        getEmployeeListByCategoryForCommunication(context, empID, selectedCategoryType.categoryId);
      } else if (category == "STD") {
        final selectedClassData = classData!.firstWhere(
          (classData) => classData.classId == value,
          orElse: () => ClassData(classId: '', className: ''),
        );
        // Fixed variable names: use year and toYear (lowercase)
        getClasswiseStudentListForCommunication(empID, year, toYear, selectedClassData.classId, context);
      } else if (category == "GRP") {
        final selectedClassData = groupCategory!.firstWhere(
          (groupCategory) => groupCategory.groupId == value,
          orElse: () => GroupCategory(groupId: '', groupName: ''),
        );
        getGroupMemberListForCommunication(context, empID, selectedClassData.groupId);
      }
    }

    isLoadingAnnouncment = false;
    notifyListeners();
  }

  void updateSelectedAnnouncementType(BuildContext context, String? value) {
    clearFormData();
    selectedAnnouncementType = value;

    if (value != null && announcementTypes != null) {
      final selectedClassData = announcementTypes!.firstWhere(
        (classItem) => classItem.classId == value,
        orElse: () => ClassItem(classId: '', className: ''),
      );

      if (selectedClassData.classId == "CLS") {
        // Note: this method expects (context, empID, year, toYear, category)
        getClassListForCommunication(context, empID, year, toYear, selectedClassData.classId);
      } else if (selectedClassData.classId == "STD") {
        getClassListForCommunication(context, empID, year, toYear, selectedClassData.classId);
      } else if (selectedClassData.classId == "EMP") {
        getEmployeeCategoryForCommunication(context);
      } else if (selectedClassData.classId == "GRP") {
        getGroupForCommunication(context);
      }
    }

    notifyListeners();
  }

  Future<void> getClassListForCommunication(
    BuildContext context,
    String? empid,
    String? year,
    String? toYear,
    String? category,
  ) async {
    isLoading = true;
    showLoadingDialog(context);
    notifyListeners();

    // NOTE: verify the correct endpoint for fetching class list
    final url = ApiEndpoints.getClassListForCommunication;

    final body = {
      "empid": empID,
      "fromyear": year,
      "toyear": toYear,
    };

    try {
      final response = await postRequest(url, body);

      log("GetClassListForCommunication Response: $response");

      if (response != null) {
        final parsed = ClassResponse.fromJson(response);
        classData = parsed.data;

        if (isLoading){
          Navigator.pop(context);
          isLoading = false;
        }
        if(category == "CLS"){
          showClassListPopup(context, parsed);
        }
      }
    } catch (e) {
      log("GetClassListForCommunication Error: $e");
    } finally {
      if (isLoading){
        Navigator.pop(context);
        isLoading = false;
      }
      notifyListeners();
    }
  }

  Future<void> getClasswiseStudentListForCommunication(
    String? empid,
    String? year,
    String? toYear,
    String? classId,
    BuildContext context,
  ) async {
    isLoading = true;
    showLoadingDialog(context);
    notifyListeners();

    // NOTE: verify the correct endpoint for student list
    final url = ApiEndpoints.getClasswiseStudentListForCommunication;

    final body = {
      "empid": empID,
      "class_string": classId,
      "fromyear": year,
      "toyear": toYear,
    };

    try {
      final response = await postRequest(url, body);

      log("GetClasswiseStudentListForCommunication Response: $response");

      if (response != null) {
        final parsed = StudentListResponse.fromJson(response);
        student = parsed.data;

        if (isLoading) {
          isLoading = false;
          try {
            Navigator.pop(context);
          } catch (_) {}
        }
        showStudentListPopup(context, parsed);
      }
    } catch (e) {
      log("GetClasswiseStudentListForCommunication Error: $e");
    } finally {
      if (isLoading) {
        isLoading = false;
        try {
          Navigator.pop(context);
        } catch (_) {}
      }
      isLoadingAnnouncment = false;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getEmployeeListByCategoryForCommunication(
    BuildContext context, 
    String? empId, 
    String categoryId
  ) async {
    isLoading = true;
    showLoadingDialog(context);
    notifyListeners();

    final url = ApiEndpoints.getEmployeeListByCategoryForCommunication;

    final body = {
      "empid": empID,
      "category_id": categoryId
    };

    try {
      final response = await postRequest(url, body);

      log("getEmployeeListByCategoryForCommunication Response: $response");

      if (response != null) {
        final parsed = EmployeeList.fromJson(response);
        employees = parsed.data;
        showEmployeeListPopup(context, parsed);
      }
    } catch (e) {
      log("getEmployeeListByCategoryForCommunication Error: $e");
    } finally {
      if (isLoading) {
        isLoading = false;
        try {
          Navigator.pop(context);
        } catch (_) {}
      }
      isLoadingAnnouncment = false;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getGroupMemberListForCommunication(BuildContext context, String? empId, String? groupId) async {
     isLoading = true;
    showLoadingDialog(context);
    notifyListeners();

    final url = ApiEndpoints.getGroupMemberListForCommunication;

    final body = {
      "empid": empID,
      "group_id": groupId
    };

    try {
      final response = await postRequest(url, body);

      log("getGroupMemberListForCommunication Response: $response");

      if (response != null) {
        final parsed = GrpEmployeeListResponse.fromJson(response);
        grpEmployees = parsed.data;

        if (isLoading) {
          isLoading = false;
          try {
            Navigator.pop(context);
          } catch (_) {}
        }

        showGroupEmpListPopup(context, parsed);
      }
    } catch (e) {
      log("getGroupMemberListForCommunication Error: $e");
    } finally {
      if (isLoading) {
        isLoading = false;
        try {
          Navigator.pop(context);
        } catch (_) {}
      }
      isLoadingAnnouncment = false;
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getEmployeeCategoryForCommunication(BuildContext context) async {
    bool loaderShown = true;
    showLoadingDialog(context);
    notifyListeners();

    final url = ApiEndpoints.getEmployeeCategoryForCommunication;

    final body = {
      "empid": empID,
      "fromyear": year,
      "toyear": toYear,
    };

    try {
      final response = await postRequest(url, body);

      log("GetEmployeeCategoryForCommunication Response: $response");

      if (response != null) {
        final parsed = AnnouncementCategoryResponse.fromJson(response);
        announcementCategory = parsed.data;
        if (loaderShown){
          loaderShown = false;
          Navigator.pop(context);
        }
        notifyListeners();
      }
    } catch (e) {
      log("GetEmployeeCategoryForCommunication Error: $e");
    } finally {
      if (loaderShown) {
        loaderShown = false;
        try {
          Navigator.pop(context);
        } catch (_) {}
      }
      notifyListeners();
    }
  }

  Future<void> getGroupForCommunication(
    BuildContext context,
  ) async {
    bool loaderShown = true;
    showLoadingDialog(context);
    notifyListeners();

    final url = ApiEndpoints.getGroupForCommunication;

    final body = {
      "empid": empID,
      "fromyear": year,
      "toyear": toYear,
    };

    try {
      final response = await postRequest(url, body);

      log("GetGroupForCommunication Response: $response");

      if (response != null) {
        final parsed = GroupCategoryResponse.fromJson(response);
        groupCategory = parsed.data;
      }
    } catch (e) {
      log("GetGroupForCommunication Error: $e");
    } finally {
      if (loaderShown) {
        loaderShown = false;
        try {
          Navigator.pop(context);
        } catch (_) {}
      }
      isLoading = false;
      notifyListeners();
    }
  }

  

  

  void showSuccessLoaderDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            children: [
              LoadingAnimationWidget.threeRotatingDots(color: CustomColor.primaryColor, size: 50),
              const SizedBox(height: 16),
              const Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

  void showClassListPopup(BuildContext context, ClassResponse? employ) {
    List<ClassData> localEmployees = List.from(employ?.data ?? []);
    bool selectAll = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              contentPadding: const EdgeInsets.all(8),
              titlePadding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 4),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Class'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: const Text('Select All', style: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 21.0),
                        child: Checkbox(
                          value: selectAll,
                          onChanged: (val) {
                            setState(() {
                              selectAll = val ?? false;
                              selectedEmployeeIds.clear();
                              if (selectAll) {
                                selectedEmployeeIds.addAll(localEmployees.map((e) => e.classId));
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: localEmployees.isEmpty
                ? const Center(child: Text('No employees found'))
                : ListView.builder(
                  itemCount: localEmployees.length,
                  itemBuilder: (context, index) {
                    final emp = localEmployees[index];
                    final isSelected = selectedEmployeeIds.contains(emp.classId);
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val ?? false) {
                            selectedEmployeeIds.add(emp.classId);
                          } else {
                            selectedEmployeeIds.remove(emp.classId);
                          }
                          selectAll = selectedEmployeeIds.length == localEmployees.length;
                        });
                      },
                      title: Text(
                        emp.className,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    processSelectedEmployees(selectedEmployeeIds);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void processSelectedEmployees(List<String> employeeIds) {
    log("Selected Employee IDs: $employeeIds");
    selectedEmployeeIds = employeeIds;
  }

  void showStudentListPopup(BuildContext context, StudentListResponse? employ) {
    List<Student> allStudents = List.from(employ?.data ?? []);
    List<Student> filteredStudents = List.from(allStudents);
    bool selectAll = false;
    List<String> selectedEmployeeIds = [];
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            void filterStudents(String query) {
              setState(() {
                if (query.isEmpty) {
                  filteredStudents = List.from(allStudents);
                } else {
                  filteredStudents = allStudents
                      .where((student) => student.studentName
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                      .toList();
                }
              });
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
              insetPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              contentPadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
              titlePadding: EdgeInsets.zero,
              backgroundColor: Colors.white,
              title: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: CustomColor.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Select Students',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextField(
                      controller: searchController,
                      onChanged: filterStudents,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        hintText: 'Search student...',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14.sp),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 400.h,
                child: Column(
                  children: [
                    // Select All Row
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Select All (${filteredStudents.length})',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.sp,
                            child: Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                 value: selectAll,
                                 activeColor: CustomColor.primaryColor,
                                 onChanged: (val) {
                                   setState(() {
                                     selectAll = val;
                                     if (selectAll) {
                                       for (var student in filteredStudents) {
                                         if (!selectedEmployeeIds.contains(student.sid)) {
                                           selectedEmployeeIds.add(student.sid);
                                         }
                                       }
                                     } else {
                                       for (var student in filteredStudents) {
                                         selectedEmployeeIds.remove(student.sid);
                                       }
                                     }
                                   });
                                 },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: filteredStudents.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off,
                                      size: 48.sp, color: Colors.grey[400]),
                                  SizedBox(height: 16.h),
                                  Text(
                                    'No students found',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredStudents.length,
                              itemBuilder: (context, index) {
                                final emp = filteredStudents[index];
                                final isSelected =
                                    selectedEmployeeIds.contains(emp.sid);
                                return Container(
                                  margin: EdgeInsets.only(bottom: 4.h),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? CustomColor.primaryColor.withOpacity(0.1)
                                        : Colors.grey[50],
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: isSelected
                                          ? CustomColor.primaryColor
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    value: isSelected,
                                    activeColor: CustomColor.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val ?? false) {
                                          selectedEmployeeIds.add(emp.sid);
                                        } else {
                                          selectedEmployeeIds.remove(emp.sid);
                                          selectAll = false;
                                        }

                                        if (filteredStudents.isNotEmpty) {
                                            bool allVisibleSelected = true;
                                            for(var s in filteredStudents) {
                                                if(!selectedEmployeeIds.contains(s.sid)) {
                                                    allVisibleSelected = false;
                                                    break;
                                                }
                                            }
                                            if(allVisibleSelected) selectAll = true;
                                            else selectAll = false;
                                        }
                                      });
                                    },
                                    title: Text(
                                      emp.studentName,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? CustomColor.primaryColor
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actionsPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              actions: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    processSelectedEmployees(selectedEmployeeIds);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColor.primaryColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showGroupEmpListPopup(BuildContext context, GrpEmployeeListResponse? employ) {
    List<GrpEmployee> localEmployees = List.from(employ?.data ?? []);
    bool selectAll = false;
    List<String> selectedEmployeeIds = [];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              contentPadding: const EdgeInsets.all(8),
              titlePadding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 4),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Select Employee', style: TextStyle(fontSize: 18)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: const Text('Select All', style: TextStyle(fontSize: 14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 21.0),
                        child: Checkbox(
                          value: selectAll,
                          onChanged: (val) {
                            setState(() {
                              selectAll = val ?? false;
                              selectedEmployeeIds.clear();
                              if (selectAll) {
                                selectedEmployeeIds.addAll(localEmployees.map((e) => e.employeeId));
                              }
                            });
                          },
                        ),
                      ),
                    ]
                  )
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 250,
                child: localEmployees.isEmpty
                    ? const Center(child: Text('No employees found', style: TextStyle(fontSize: 14)))
                    : ListView.builder(
                        itemCount: localEmployees.length,
                        itemBuilder: (context, index) {
                          final emp = localEmployees[index];
                          final isSelected = selectedEmployeeIds.contains(emp.employeeId);
                          return CheckboxListTile(
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            value: isSelected,
                            onChanged: (val) {
                              setState(() {
                                if (val ?? false) {
                                  selectedEmployeeIds.add(emp.employeeId);
                                } else {
                                  selectedEmployeeIds.remove(emp.employeeId);
                                }
                                selectAll = selectedEmployeeIds.length == localEmployees.length;
                              });
                            },
                            title: Text(emp.employeeName, style: const TextStyle(fontSize: 14)),
                          );
                        },
                      ),
              ),
              actionsPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:  Text('Close', style: TextStyle(fontSize: 14.sp)),
                ),
                ElevatedButton(
                  onPressed: () {
                    processSelectedEmployees(selectedEmployeeIds);
                    Navigator.pop(context);
                  },
                  child:  Text('OK', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEmployeeListPopup(BuildContext context, EmployeeList? employ) {
    List<Employee> localEmployees = List.from(employ?.data ?? []);
    bool selectAll = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              contentPadding: const EdgeInsets.all(8),
              titlePadding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 4),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Employee'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: const Text('Select All', style: TextStyle(fontSize: 14)),
                        ),
                  
                      Padding(
                        padding: const EdgeInsets.only(right: 21.0),
                        child: Checkbox(
                          value: selectAll,
                          onChanged: (val) {
                            setState(() {
                              selectAll = val ?? false;
                              selectedEmployeeIds.clear();
                              if (selectAll) {
                                selectedEmployeeIds.addAll(localEmployees.map((e) => e.empId));
                              }
                            });
                          },
                        ),
                      ),
                    ]
                  )
                
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: localEmployees.isEmpty
                ? const Center(child: Text('No employees found'))
                : ListView.builder(
                  itemCount: localEmployees.length,
                  itemBuilder: (context, index) {
                    final emp = localEmployees[index];
                    final isSelected = selectedEmployeeIds.contains(emp.empId);
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (val) {
                        setState(() {
                          if (val ?? false) {
                            selectedEmployeeIds.add(emp.empId);
                          } else {
                            selectedEmployeeIds.remove(emp.empId);
                          }
                          selectAll = selectedEmployeeIds.length == localEmployees.length;
                        });
                      },
                      title: Text(
                        emp.name,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    processSelectedEmployees(selectedEmployeeIds);
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
