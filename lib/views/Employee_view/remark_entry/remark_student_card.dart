import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../providers/employee/remark_entry_provider.dart';
import '../../../constants/colors.dart';
import '../../../widgets/common_alert_popup.dart';
import '../../../widgets/show_loading_dialog.dart';

class RemarkStudentCard extends StatefulWidget {
  final String studentName;
  final String sid;
  final String termId;
  final String fromYear;
  final String toYear;
  final String studentId;
  final String academicPercentage;
  final String attendancePercentage;
  final String? academicFlag;
  final String? attendanceFlag;
  final String? resultFlag;

  final String? initialAcademicRemark;
  final String? initialAttendanceRemark;
  final String? initialResultRemark;
  
  final List<String>? academicOptions;
  final List<String>? attendanceOptions;
  final List<String>? resultOptions;

  const RemarkStudentCard({
    super.key,
    required this.studentName,
    required this.sid,
    required this.termId,
    required this.fromYear,
    required this.toYear,
    required this.studentId,
    required this.academicPercentage,
    required this.attendancePercentage,
    this.academicFlag,
    this.resultFlag,
    this.attendanceFlag,
    this.initialAcademicRemark,
    this.initialAttendanceRemark,
    this.initialResultRemark,
    this.academicOptions,
    this.attendanceOptions,
    this.resultOptions,
  });

  @override
  State<RemarkStudentCard> createState() => _RemarkStudentCardState();
}

class _RemarkStudentCardState extends State<RemarkStudentCard> {
  String? academicRemark;
  String? attendanceRemark;
  String? resultRemark;
  bool isSubmitting = false;

  List<String> academicRemarkOptions = [];
  List<String> attendanceRemarkOptions = [];
  List<String> resultRemarkOptions = [];

  @override
  void initState() {
    super.initState();
    academicRemark = widget.initialAcademicRemark;
    attendanceRemark = widget.initialAttendanceRemark;
    resultRemark = widget.initialResultRemark;
    
    academicRemarkOptions = widget.academicOptions ?? [];
    attendanceRemarkOptions = widget.attendanceOptions ?? [];
    resultRemarkOptions = widget.resultOptions ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [

          _buildHeader(),
          SizedBox(height: 6.h),
          if(widget.academicFlag == "true")...[
            _buildSection(
              label1: 'Academics',
              value1: widget.academicPercentage,
              label2: 'Academic Remarks',
              selectedValue: academicRemark,
              options: academicRemarkOptions,
              onChanged: (val) {
                setState(() => academicRemark = val);
              },
            ),
            SizedBox(height: 6.h),
          ],
          if(widget.attendanceFlag == "true")...[
            _buildSection(
              label1: 'Attendance',
              value1: widget.attendancePercentage,
              label2: 'Attendance Remarks',
              selectedValue: attendanceRemark,
              options: attendanceRemarkOptions,
              onChanged: (val) {
                setState(() => attendanceRemark = val);
              },
            ),
            SizedBox(height: 6.h),
          ],
          if(widget.resultFlag == "true")...[
            _buildResultSection()
          ],
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () async {
              if (academicRemark == null && widget.academicFlag == "true") {
                CommonAlertPopup.show(
                  context,
                  title: "Selection Required",
                  message: "Please select academic remark",
                );
                return;
              }
              //  if (attendanceRemark == null && widget.attendanceFlag == "true") {
              //    CommonAlertPopup.show(
              //      context,
              //      title: "Selection Required",
              //      message: "Please select attendance remark",
              //    );
              //   return;
              // }
               if (resultRemark == null && widget.resultFlag == "true") {
                 CommonAlertPopup.show(
                   context,
                   title: "Selection Required",
                   message: "Please select result remark",
                 );
                return;
              }
              setState(() {
                isSubmitting = true;
              });
              showLoadingDialog(context);
              final provider = Provider.of<RemarkEntryProvider>(context, listen: false);
              final successMessage = await provider.setRemarkForExamination(
                sid: widget.sid,
                regno: widget.studentId,
                termId: widget.termId,
                academicRemark: academicRemark ?? "",
                attendanceRemark: attendanceRemark ?? "",
                result: resultRemark ?? "",
                fromYear: widget.fromYear,
                toYear: widget.toYear,
              );

              if (successMessage != null) {
                if (context.mounted) {
                  provider.updateStudentRemarkLocal(sid: widget.sid, academicRemark: academicRemark ?? '', attendanceRemark: attendanceRemark ?? '', resultRemark: resultRemark ?? '');
                  Navigator.pop(context);
                  Navigator.pop(context);
                  setState(() {
                    isSubmitting = false;
                  });
                  _showSuccessDialog(successMessage);
                }
              } else {
                 if(context.mounted) {
                   setState(() {
                     isSubmitting = false;
                   });
                   _showErrorDialog("Failed to submit remarks");
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColor.primaryColor,
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 0,
            ),
            child: Consumer<RemarkEntryProvider>(
              builder: (context, provider, child) {
                  return Text(
                  'Submit Remarks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            ),
          ),

              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
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

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.studentName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          'Reg No: ${widget.studentId}',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String label1,
    required String value1,
    required String label2,
    required String? selectedValue,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: label1 == "Academics" ? Colors.green.shade100: Colors.cyan.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label1,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: label1 == "Academics" ? Colors.green.shade800: Colors.cyan.shade800,
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  height: 40.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '$value1%',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 6.w),
          // Remarks Dropdown
          Expanded(
            flex: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label2,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: label1 == "Academics" ? Colors.green.shade800 : Colors.cyan.shade800,
                  ),
                ),
                SizedBox(height: 2.h),
                Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: InkWell(
                    onTap: () {
                      _showSpecificRemarkPopup(label2, options, selectedValue, onChanged);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            selectedValue ?? 'Select Remark',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: selectedValue == null ? Colors.grey : Colors.black87,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showSpecificRemarkPopup(String title, List<String> options, String? selectedValue, ValueChanged<String?> onSelected) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          backgroundColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade300),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 400.h,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: options.map((option) {
                      return Column(
                        children: [
                          Container(
                            color: option == selectedValue
                                ? CustomColor.secondaryColor.withOpacity(0.1)
                                : Colors.transparent,
                            child: RadioListTile<String>(

                              dense: true,
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                              title: Text(
                                option,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.black87,
                                  fontWeight: option == selectedValue ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                              value: option,
                              groupValue: selectedValue,
                              activeColor: CustomColor.primaryColor,
                              onChanged: (val) {
                                onSelected(option);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.colorRed,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }
  Widget _buildResultSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color:Colors.grey.shade200),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: resultRemark,
              isExpanded: true,
              dropdownColor: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              hint: Text(
                'Select Result',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
              ),
              items: resultRemarkOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                setState(() => resultRemark = val);
              },
            ),
          ),
        ),
      ],
    );
  }
}
