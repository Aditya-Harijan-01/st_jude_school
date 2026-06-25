import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../providers/student/syllabuss.dart';
import '../../../../widgets/common_bottom_sheet.dart';

class SyllabusBottomSheet extends StatefulWidget {
  final Future<void> Function(String from, String to)? onSessionChange;
  final Future<void> Function(String examId)? onExamChange;
  final String? selectedExamId;

  const SyllabusBottomSheet({
    super.key,
    this.onSessionChange,
    this.onExamChange,
    this.selectedExamId,
  });

  @override
  State<SyllabusBottomSheet> createState() => _SyllabusBottomSheetState();
}

class _SyllabusBottomSheetState extends State<SyllabusBottomSheet> {
  String? selectedExamId;

  @override
  void initState() {
    super.initState();
    selectedExamId = widget.selectedExamId;
  }

  @override
  void didUpdateWidget(SyllabusBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedExamId != oldWidget.selectedExamId) {
      setState(() {
        selectedExamId = widget.selectedExamId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonBottomSheet(
      onSessionChange: widget.onSessionChange,
      content:
      DropdownButtonFormField<String>(
        value: selectedExamId,
        hint: Text(
          "Select Exam",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
        isExpanded: true,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: CustomColor.primaryColor,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: CustomColor.secondaryColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide(color: CustomColor.secondaryColor),
          ),
          filled: true,
          fillColor: CustomColor.colorWhite,
        ),
        items: Provider.of<SubjectSyllabusProvider>(context).examinationData?.map((exam) {
          return DropdownMenuItem<String>(
            value: exam.examId,
            child: Text(
              exam.examName ?? '',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList() ?? [],
        onChanged: (value) {
          setState(() {
            selectedExamId = value;
          });
          if (widget.onExamChange != null && value != null) {
            widget.onExamChange!(value);
          }
        },
      ),
      // SizedBox(),
    );
  }
}
