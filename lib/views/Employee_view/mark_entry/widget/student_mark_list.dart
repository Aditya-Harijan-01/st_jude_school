// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../models/employee/student_mark_entry_model.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/constant.dart';
import '../../../../../providers/common/common_post_method.dart';
import '../../../../widgets/show_loading_dialog.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class StudentMarkListWidget extends StatefulWidget {
  final List<StudentMarkEntryData> students;
  final Function(StudentMarkEntryData, String)? onMarkChanged;
  final Map<String, TextEditingController>? markControllers;
  
  final String className;
  final String section;
  final String stream;
  final String examId;
  final String subgroupId;
  final String subType;
  final String fromYear;
  final String subCode;
  final String toYear;
  final String empLogin;

  const StudentMarkListWidget({
    super.key,
    required this.students,
    this.onMarkChanged,
    this.markControllers,
    required this.className,
    required this.section,
    required this.stream,
    required this.examId,
    required this.subgroupId,
    required this.subType,
    required this.fromYear,
    required this.subCode,
    required this.toYear,
    required this.empLogin,
  });

  @override
  State<StudentMarkListWidget> createState() => _StudentMarkListWidgetState();
}

class _StudentMarkListWidgetState extends State<StudentMarkListWidget> {
  final Map<String, UniqueKey> _studentKeys = {};
  bool _isSubmitting = false;


  String _createCompositeKey(StudentMarkEntryData student) {
    return '${student.sid}_${student.markId}_${student.regno.hashCode}';
  }

  Future<bool> _deleteStudentMark(StudentMarkEntryData student) async {
    try {
      final body = {
        "login_id": widget.empLogin,
        "sid": student.sid,
        "exam_id": widget.examId,
        "mark_id": student.markId.toString(),
        "sub_code": widget.subCode,
        "subject_group_id": widget.subgroupId,
        "fromyear": widget.fromYear,
      };


      final response = await postRequest(
        ApiEndpoints.deleteDuplicateMarkEntry,
        body,
      );

      if (response != null && response['statusCode'] == 'Success') {
        if (response['message'] != "Unable to continue, Please try again.") {
          return true;
        } else {
          final errorMessage = response['message'] ?? 'Failed to delete mark entry';

            _showErrorDialog(errorMessage);

          return false;
        }
      } else {
        final errorMessage = response?['message'] ?? 'Failed to delete mark entry';

          _showErrorDialog(errorMessage);

        return false;
      }
    } catch (e) {
      final errorMessage = 'An error occurred while deleting: $e';

        _showErrorDialog(errorMessage);

      return false;
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 28.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Success',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error_rounded,
                color: Colors.red,
                size: 28.r,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Error',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitMarks() async {

    try {
      setState(() {
        _isSubmitting = true;
      });
      
      showLoadingDialog(context);

      final markDetail = <Map<String, String>>[];
      
      for (final student in widget.students) {
        final compositeKey = _createCompositeKey(student);
        final markController = widget.markControllers?[compositeKey];
        final markValue = markController?.text ?? student.mark;

        if (markValue.isEmpty) {
          if (_isSubmitting) {
            Navigator.of(context).pop();
            setState(() {
              _isSubmitting = false;
            });
          }
          _showValidationError();
          return;
        }
        
        markDetail.add({
          "sid": student.sid,
          "regno": student.regno,
          "mark": markValue,
          "remarks": "",
          "positive_point": "",
          "negative_point": ""
        });
      }

      final body = {
        "empid": widget.empLogin,
        "classname": widget.className,
        "section": widget.section,
        "stream": widget.stream,
        "examId": widget.examId,
        "subgroupid": widget.subgroupId,
        "sub_type": widget.subType,
        "fromyear": widget.fromYear,
        "sub_code": widget.subCode,
        "toyear": widget.toYear,
        "mark_detail": markDetail,
      };

      log('body: $body');
      final response = await postRequest(
        ApiEndpoints.saveMarkEntry,
        body,
      );

      if (response != null && response['statusCode'] == 'Success') {
        Navigator.of(context).pop();
        _showSuccessDialog(response['message'] ?? 'Mark Entry submitted successfully');

      } else {
        final errorMessage = response?['message'] ?? 'Failed to submit marks';
        Navigator.of(context).pop();
          _showErrorDialog(errorMessage);

      }
    } catch (e) {
      // Exception handling
      final errorMessage = 'An error occurred: $e';
      Navigator.of(context).pop();
        _showErrorDialog(errorMessage);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (widget.students.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.not_interested,
              size: 64.r,
              color: Colors.red[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No records found.',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'No student records found for the selected criteria. \nPlease check your selections and try again.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w,
              vertical: 12.h,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(38),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.r),
                topRight: Radius.circular(6.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Reg No',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withAlpha(77),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Text(
                    'Students Name',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: CustomColor.colorBlack.withAlpha(77),
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      'Roll',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: CustomColor.colorBlack.withAlpha(77),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Text(
                      'Mark',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: CustomColor.colorBlack.withAlpha(77),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                    ),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: CustomColor.colorBlack.withAlpha(77),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Students List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: widget.students.length,
              itemBuilder: (context, index) {
                final student = widget.students[index];
                final canDelete =
                    student.allowDelete == "Yes" &&
                    student.markId != 0;
                final compositeKey = _createCompositeKey(student);
                final markController = widget.markControllers?[compositeKey];
                final studentKey =
                    _studentKeys.putIfAbsent(
                      compositeKey,
                      () => UniqueKey(),
                    );

                return Dismissible(
                  key: studentKey,
                  direction:
                      canDelete
                          ? DismissDirection.endToStart
                          : DismissDirection.none,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.w),
                    color: CustomColor.primaryColor,
                    child: Icon(
                      Icons.delete,
                      color: CustomColor.colorWhite,
                      size: 24.r,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:
                              CustomColor.colorWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  12.r,
                                ),
                          ),
                          title: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: CustomColor.primaryColor,
                                size: 28.r,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Confirm Delete',
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                          content: Text(
                            'Are you sure you want to delete ${student.studentName}?',
                            style: TextStyle(fontSize: 14.sp),
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.of(
                                    context,
                                  ).pop(false),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                CustomColor.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                        8.r,
                                      ),
                                ),
                              ),
                              onPressed: _isSubmitting
                                  ? null
                                  : () async {
                                      Navigator.of(context).pop(false);

                                      setState(() {
                                        _isSubmitting = true;
                                      });

                                      final success = await _deleteStudentMark(student);

                                      setState(() {
                                        _isSubmitting = false;
                                      });

                                      if (success) {
                                        widget.students.remove(student);

                                        final compositeKey = _createCompositeKey(student);
                                        _studentKeys[compositeKey] = UniqueKey();

                                        setState(() {});

                                        final successMessage = 'Student mark entry deleted successfully';
                                        _showSuccessDialog(successMessage);
                                      }
                                    },
                              child: _isSubmitting
                                  ? SizedBox(
                                      height: 16.h,
                                      width: 16.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(CustomColor.colorWhite),
                                      ),
                                    )
                                  : Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: CustomColor.colorWhite,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) async {
                    final success = await _deleteStudentMark(student);

                    if (success) {
                      widget.students.remove(student);

                      final compositeKey = _createCompositeKey(student);
                      _studentKeys[compositeKey] = UniqueKey();

                      setState(() {});

                      final successMessage = 'Student mark entry deleted successfully';
                        _showSuccessDialog(successMessage);
                    } else {
                      _studentKeys[compositeKey] = UniqueKey();
                      setState(() {});
                    }
                  },
                  child: _buildStudentRow(
                    context,
                    student,
                    index,
                    markController,
                  ),
                );
              },
            ),
          ),
          Container(
            height: 40.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: CustomColor.primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.r), bottomRight: Radius.circular(10.r)
              ),
            ),
            child: ElevatedButton(
              onPressed: _isSubmitting ? null : () {
                _submitMarks();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                foregroundColor: CustomColor.colorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r)
                  ),
                ),
                elevation: 0,
                disabledBackgroundColor: CustomColor.colorGrey,
              ),
              child: _isSubmitting
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(CustomColor.colorWhite),
                      ),
                    )
                  : Text(
                      'SUBMIT',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.sp,
                      ),
                    ),
            ),


          ),
          SizedBox(height: 4.h)
        ],
      ),
    );
  }

  Widget _buildStudentRow(
    BuildContext context,
    StudentMarkEntryData student,
    int index,
    TextEditingController? markController,
  ) {
    return Container(
      decoration: BoxDecoration(
        color:
            index % 2 == 0
                ? CustomColor.colorWhite
                : CustomColor.colorGrey.withOpacity(
                  0.05,
                ),
        border: Border(
          bottom: BorderSide(
            color: CustomColor.primaryColor.withOpacity(
              0.2,
            ),
            width: 1,
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 12.h,
                ),
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  student.regno,
                  style: TextStyle(
                    color: CustomColor.primaryColor,
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              color: CustomColor.primaryColor.withOpacity(
                0.2,
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 12.h,
                ),
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  student.studentName,
                  style: TextStyle(
                    color: CustomColor.primaryColor,
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ),
            ),
            Container(
              width: 1,
              color: CustomColor.primaryColor.withOpacity(
                0.2,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 12.h,
                ),
                alignment: Alignment.center,
                child: Text(
                  student.rollNo,
                  style: TextStyle(
                    color: CustomColor.primaryColor,
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            Container(
              width: 1,
              color: CustomColor.primaryColor.withOpacity(
                0.2,
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 8.h,
                ),
                alignment: Alignment.center,
                child: TextFormField(
                  controller: markController,
                  textAlign: TextAlign.center,
                  keyboardType:
                      student.isNumberOnly ==
                              "Yes"
                          ? TextInputType
                              .number
                          : TextInputType
                              .text,
                  inputFormatters: [
                    student.isNumberOnly ==
                            "Yes"
                        ? FilteringTextInputFormatter.deny(
                          RegExp(
                            r'[^\d.]|(\..*\.)',
                          ),
                        )
                        : UpperCaseTextFormatter(),
                    LengthLimitingTextInputFormatter(
                      5,
                    ),
                  ],
                  style: TextStyle(
                    color: CustomColor.primaryColor,
                    fontWeight:
                        FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                            4.r,
                          ),
                      borderSide: BorderSide(
                        color: CustomColor.primaryColor,
                      ),
                    ),
                    focusedBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                            4.r,
                          ),
                      borderSide: BorderSide(
                        color:
                        CustomColor.primaryColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                            4.r,
                          ),
                      borderSide: BorderSide(
                        color: CustomColor.primaryColor,
                      ),
                    ),
                    errorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                            4.r,
                          ),
                      borderSide:
                          BorderSide(
                            color:
                              CustomColor.colorRed,
                            width: 2,
                          ),
                    ),
                    focusedErrorBorder:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(
                            4.r,
                          ),
                      borderSide:
                          BorderSide(
                            color:
                              CustomColor.colorRed,
                            width: 2,
                          ),
                    ),
                    filled:
                        student.mark == ""
                            ? true
                            : false,
                    fillColor: Colors
                        .orangeAccent
                        .withOpacity(0.5),
                    contentPadding:
                        EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 4.h,
                        ),
                    isDense: true,
                    enabled:
                        student.isDisabled ==
                                "Yes"
                            ? false
                            : true,
                    hintText: '',
                    hintStyle: TextStyle(
                      color: CustomColor.colorGrey,
                      fontSize: 12.sp,
                    ),
                  ),
                  onChanged: (value) {
                    if (widget.onMarkChanged != null) {
                      widget.onMarkChanged!(student, value);
                    }
                  },
                ),
              ),
            ),
            Container(
              width: 1,
              color: CustomColor.primaryColor.withOpacity(
                0.2,
              ),
            ),
            SizedBox(
              width: 48.w,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    if (markController !=
                        null) {
                      markController.text =
                          "AB";
                      if (widget.onMarkChanged != null) {
                        widget.onMarkChanged!(student, "AB");
                      }
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                    decoration: BoxDecoration(
                      color: CustomColor.primaryColor,
                      borderRadius:
                          BorderRadius.circular(
                            4.r,
                          ),
                    ),
                    child: Text(
                      'AB',
                      style: TextStyle(
                        color: CustomColor.colorWhite,
                        fontSize: 14.sp,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showValidationError() {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: CustomColor.primaryColor,
                size: 28.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Please fill all the marks!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
                ),
              ),
            ],
          ),
          content: Text(
            'Please fill marks for all students before submitting.',
            style: TextStyle(fontSize: 16.sp),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColor.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK', style: TextStyle(color: CustomColor.colorWhite)),
            ),
          ],
        );
      },
    );
  }
}