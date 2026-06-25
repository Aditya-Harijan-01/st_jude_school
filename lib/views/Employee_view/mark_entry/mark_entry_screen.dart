// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../../providers/employee/teacher_mark_entry_provider.dart';
import '../../../../../models/employee/student_mark_entry_model.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../widget/common_bottom_sheet_emp.dart';
import '../widget/access_denied_dialog.dart';
import 'widget/common_mark_entry_dropdowns.dart';
import 'widget/student_mark_list.dart';
import 'widget/table_shimmer.dart';
import 'widget/teacher_dropdown.dart';

class MarkEntryScreen extends StatefulWidget {
  const MarkEntryScreen({super.key});

  @override
  State<MarkEntryScreen> createState() => _MarkEntryScreenState();
}

class _MarkEntryScreenState extends State<MarkEntryScreen> {
   late TeacherMarkEntryProvider _provider;
   bool _hasShownAccessDeniedDialog = false; // Add this flag
   String toYear = '';
   String fromYear = '';
   String empLogin = '';

   String? selectedSubjectGroupId;
   String? selectedSubjectGroupName;
   bool _areStudentsLoaded = false;
   bool _isStudentsLoading = false;

   final Map<String, TextEditingController> markControllers = {};

  @override
  void initState() {
    super.initState();
    _provider = context.read<TeacherMarkEntryProvider>();

    final auth = context.read<AuthProvider>();
    toYear = auth.loginData!.currentyearto;
    fromYear = auth.loginData!.currentyearfrom;
    empLogin = auth.loginData!.empId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetProviderToDefault();
    });
  }

  String _createCompositeKey(StudentMarkEntryData student) {
    return '${student.sid}_${student.markId}_${student.regno.hashCode}';
  }

  Map<String, String> _parseClassId(String classId) {
    final parts = classId.split('_');
    return {
      'class_name': parts.isNotEmpty ? parts[0] : '',
      'section': parts.length > 1 ? parts[1] : '',
      'stream': parts.length > 2 ? parts[2] : '',
    };
  }

  void _resetProviderToDefault() {
    _provider.teacherMarkEntryData?.clear();
    _provider.classList.clear();
    _provider.examinationList.clear();
    _provider.subjectGroupList.clear();
    _provider.subjectList.clear();
    _provider.studentMarkEntryData?.clear();

    _provider.setSelectedTeacher(null);
    _provider.setSelectedClass(null);
    _provider.setSelectedExamination(null);
    _provider.setSelectedSubjectGroup(null);
    _provider.setSelectedSubject(null);


  }

  void _initializeMarkControllers(List<StudentMarkEntryData> students) {
    for (final student in students) {
      final compositeKey = _createCompositeKey(student);
      markControllers.putIfAbsent(
        compositeKey,
        () => TextEditingController(text: student.mark),
      );
    }
  }

  void _onMarkChanged(StudentMarkEntryData student, String markValue) {
    final compositeKey = _createCompositeKey(student);
    final controller = markControllers[compositeKey];
    if (controller != null && controller.text != markValue) {
      controller.text = markValue;
    }
  }



  void _onTeacherChanged() {
    setState(() {
      _areStudentsLoaded = false;
      _isStudentsLoading = false;
      markControllers.clear();
    });
  }

  void clearProvider() async {

    _provider.classList.clear();
    _provider.examinationList.clear();
    _provider.subjectGroupList.clear();
    _provider.subjectList.clear();
    _provider.studentMarkEntryData?.clear();

    _provider.setSelectedTeacher(null);
    _provider.setSelectedClass(null);
    _provider.setSelectedExamination(null);
    _provider.setSelectedSubjectGroup(null);
    _provider.setSelectedSubject(null);

    setState(() {
      _areStudentsLoaded = false;
      _isStudentsLoading = false;
      selectedSubjectGroupId = null;
      selectedSubjectGroupName = null;
      markControllers.clear();
    });
  }


  Future<void> _onSessionChange(String from, String to) async {
    setState(() {
      toYear = to;
      fromYear = from;
    });

    clearProvider();

    if (empLogin.isNotEmpty) {
      await _provider.getTeacherForMarkEntry(
        empId: empLogin,
        fromYear: fromYear,
        toYear: toYear,
      );
    }
  }

  @override
  void dispose() {
    markControllers.values.forEach((controller) => controller.dispose());

    _provider.teacherMarkEntryData?.clear();
    _provider.classList.clear();
    _provider.examinationList.clear();
    _provider.subjectGroupList.clear();
    _provider.subjectList.clear();
    _provider.studentMarkEntryData?.clear();

    _provider.selectedTeacher = null;
    _provider.selectedClassId = null;
    _provider.selectedExaminationId = null;
    _provider.selectedSubjectGroupId = null;
    _provider.selectedSubjectId = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar:AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
            size: 20.sp,
          ),
        ),
        title: Text(
            "Mark Entry",
            style:TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.sp)
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      body: Consumer<TeacherMarkEntryProvider>(
        builder: (context, provider, child) {

          if (provider.isTeacherLoading){
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              child: buildShimmerEffect(),
            );
          }
          if (provider.teacherMarkEntryResponse!.userAccessValue == 100 &&
              !_hasShownAccessDeniedDialog) {
            _hasShownAccessDeniedDialog = true;
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAccessDeniedDialog(context, 'You do not have permission to view the Mark Entry data.');
            });
          }

          return Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: CustomColor.colorWhite,
                  boxShadow: [
                    BoxShadow(
                      color: CustomColor.colorGrey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 7),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                  border: Border(
                    bottom: BorderSide(color: CustomColor.primaryColor, width: 3.h),
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<TeacherMarkEntryProvider>(
                      builder: (context, teacherProvider, _) {
                        final classes = teacherProvider.availableClasses;
    
                        if (teacherProvider.selectedClassId != null &&
                            classes.indexWhere(
                                  (c) =>
                                      c['class_id'] ==
                                      teacherProvider.selectedClassId,
                                ) ==
                                -1) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            teacherProvider.setSelectedClass(null);
                          });
                        }
    
                        return CommonClassDropdownRow(
                          label: 'Class',
                          value: teacherProvider.selectedClassId,
                          items: classes,
                          isLoading: teacherProvider.isLoading,
                          onChanged: (value) async {
                            _provider.setSelectedClass(value);
                            _areStudentsLoaded = false;
                            if (value != null && value.isNotEmpty) {
                              final empId = _provider.getSelectedTeacherEmpId();
                              await _provider.getExaminationForMarkEntry(
                                empId: empId,
                                fromYear: fromYear,
                                toYear: toYear,
                                classId: value,
                              );
                            } else {
                              _provider.setSelectedExamination(null);
                            }
                          },
                        );
                      },
                    ),
                    Consumer<TeacherMarkEntryProvider>(
                      builder: (context, teacherProvider, _) {
                        final examinations = teacherProvider.availableExaminations;
    
                        if (teacherProvider.selectedExaminationId != null &&
                            examinations.indexWhere(
                                  (e) =>
                                      e['exam_id'] ==
                                      teacherProvider.selectedExaminationId,
                                ) ==
                                -1) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            teacherProvider.setSelectedExamination(null);
                          });
                        }
    
                        return CommonExaminationDropdownRow(
                          label: 'Examination',
                          value: teacherProvider.selectedExaminationId,
                          items: examinations,
                          isLoading: teacherProvider.isLoading,
                          onChanged: (value) async {
                            _provider.setSelectedExamination(value);
    
                            setState(() {
                              _areStudentsLoaded = false;
                              selectedSubjectGroupId = null;
                              selectedSubjectGroupName = null;
                            });
    
                            if (value != null &&
                                value.isNotEmpty &&
                                _provider.selectedClassId != null &&
                                _provider.selectedClassId!.isNotEmpty) {
                              final empId = _provider.getSelectedTeacherEmpId();
    
                              await _provider.getSubjectGroupForMarkEntry(
                                empId: empId,
                                fromYear: fromYear,
                                toYear: toYear,
                                classId: _provider.selectedClassId!,
                                examId: value,
                              );
                            }
                          },
                        );
                      },
                    ),
                    Consumer<TeacherMarkEntryProvider>(
                      builder: (context, teacherProvider, _) {
                        final subjectGroups =
                            teacherProvider.availableSubjectGroups;
    
                        return CommonSubjectGroupDropdownRow(
                          label: 'Subject Group',
                          value: selectedSubjectGroupId,
                          items: subjectGroups,
                          isLoading: teacherProvider.isLoading,
                          onChanged: (value) async {
                            setState(() {
                              selectedSubjectGroupId = value;
                              selectedSubjectGroupName = null;
                            });
    
                            final selected = subjectGroups.firstWhere(
                              (g) => g['subgroupid'] == value,
                              orElse: () => {},
                            );
                            setState(() {
                              _areStudentsLoaded = false;
                              selectedSubjectGroupName =
                                  selected['subgroupname'] ?? '';
                            });
                            _provider.setSelectedSubjectGroup(value);
    
                            if (value != null &&
                                value.isNotEmpty &&
                                _provider.selectedClassId != null &&
                                _provider.selectedExaminationId != null) {
                              final empId = _provider.getSelectedTeacherEmpId();
    
                              await _provider.getSubjectListForMarkEntry(
                                empId: empId,
                                classId: _provider.selectedClassId!,
                                examId: _provider.selectedExaminationId!,
                                subgroupIdWithMode: value,
                                fromYear: fromYear,
                                toYear: toYear,
                              );
                            }
                          },
                        );
                      },
                    ),
                    Consumer<TeacherMarkEntryProvider>(
                      builder: (context, teacherProvider, _) {
                        final subjects = teacherProvider.availableSubjects;
    
                        return CommonSubjectDropdownRow(
                          label: 'Subject',
                          value: teacherProvider.selectedSubjectId,
                          items: subjects,
                          isLoading: teacherProvider.isLoading,
                          onChanged: (value) {
                            _provider.setSelectedSubject(value);
    
                            setState(() {
                              _areStudentsLoaded = false;
                            });
                          },
                        );
                      },
                    ),
                    Consumer<TeacherMarkEntryProvider>(
                      builder: (context, teacherProvider, _) {
                        final shouldShowContinueButton =
                            teacherProvider.selectedSubjectId != null &&
                            !_areStudentsLoaded;
    
                        return shouldShowContinueButton
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isStudentsLoading = true;
                                    });
    
                                    try {
                                      await _provider.getStudentListForMarkEntry(
                                        empId: empLogin,
                                        classId: _provider.selectedClassId!,
                                        examId: _provider.selectedExaminationId!,
                                        subjectId: _provider.selectedSubjectId!,
                                        subgroupIdWithMode: selectedSubjectGroupId!,
                                        fromYear: fromYear,
                                        toYear: toYear,
                                      );
    
                                      setState(() {
                                        _areStudentsLoaded = true;
                                        _isStudentsLoading = false;
                                      });
                                    } catch (e) {
                                      // print('log e: $e');
                                      setState(() {
                                        _isStudentsLoading = false;
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    backgroundColor: CustomColor.primaryColor,
                                    foregroundColor: CustomColor.colorWhite,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                  child: Text(
                                    _isStudentsLoading ? 'Loading...' : 'Continue',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: (!_areStudentsLoaded && _isStudentsLoading)
                    ? buildShimmerEffect()
                    : (_areStudentsLoaded && !_isStudentsLoading)
                    ? Consumer<TeacherMarkEntryProvider>(
                        builder: (context, teacherProvider, _) {
                          final students = teacherProvider.availableStudents;
    
                          if (students.isNotEmpty) {
                            _initializeMarkControllers(students);
                          }
    
                          final parsedClass = _parseClassId(
                            teacherProvider.selectedClassId ?? '',
                          );
                          final className = parsedClass['class_name'] ?? '';
                          final section = parsedClass['section'] ?? '';
                          final stream = parsedClass['stream'] ?? '';
    
                          final selectedSubject = teacherProvider.availableSubjects
                              .firstWhere(
                                (subject) =>
                                    subject['subid'] ==
                                    teacherProvider.selectedSubjectId,
                                orElse: () => {},
                              );
                          final subCode = selectedSubject['sub_code'] ?? '';
    
                          List<String> splitData = selectedSubjectGroupId!.split(
                            '_',
                          );
    
                          String code = splitData[0]; // "1099"
                          String type = splitData[1];
    
                          return StudentMarkListWidget(
                            students: students,
                            onMarkChanged: _onMarkChanged,
                            markControllers: markControllers,
                            className: className,
                            section: section,
                            stream: stream,
                            examId: teacherProvider.selectedExaminationId ?? '',
                            subgroupId: code ,
                            fromYear: fromYear,
                            subCode: subCode,
                            toYear: toYear,
                            subType: type,
                            empLogin: empLogin,
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64.r,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No students found',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Please select all dropdowns and click Continue',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: CommonBottomSheetEmp(
        content: TeacherDropdown(
          empId: empLogin,
          to: toYear,
          from: fromYear,
          onTeacherChanged: _onTeacherChanged,
        ),
        onSessionChange: _onSessionChange,
      ),
    );
  }
}
