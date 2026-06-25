import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../constants/colors.dart';

class CommonClassDropdownRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<Map<String, String>> items;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  const CommonClassDropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuMaxHeight: 200.h,
                isDense: true,
                dropdownColor: Colors.white,
                isExpanded: true,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                value: value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CustomColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                hint: Text(
                  isLoading
                      ? 'Loading classes...'
                      : (items.isEmpty ? 'Select above dropdown first' : 'Select'),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                items: items.map((cls) {
                  final classId = cls['class_id'] ?? '';
                  final className = cls['class_name'] ?? classId;
                  return DropdownMenuItem<String>(
                    value: classId,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: items.isEmpty ? null : onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommonExaminationDropdownRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<Map<String, String>> items;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  const CommonExaminationDropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuMaxHeight: 200.h,
                isDense: true,
                dropdownColor: Colors.white,
                isExpanded: true,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                value: value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CustomColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                hint: Text(
                  isLoading
                      ? 'Loading examinations...'
                      : (items.isEmpty ? 'Select above dropdown first' : 'Select'),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                items: items.map((exam) {
                  final examId = exam['exam_id'] ?? '';
                  final examName = exam['exam_name'] ?? examId;
                  return DropdownMenuItem<String>(
                    value: examId,
                    child: Text(examName),
                  );
                }).toList(),
                onChanged: items.isEmpty ? null : onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CommonSubjectGroupDropdownRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<Map<String, String>> items;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  const CommonSubjectGroupDropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuMaxHeight: 200.h,
                isDense: true,
                dropdownColor: Colors.white,
                isExpanded: true,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                value: value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CustomColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                hint: Text(
                  isLoading
                      ? 'Loading subject groups...'
                      : (items.isEmpty ? 'Select above dropdown first' : 'Select'),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                items: items.map((group) {
                  final id = group['subgroupid'] ?? '';
                  final name = group['subgroupname'] ?? id;
                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: items.isEmpty ? null : onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class CommonSubjectDropdownRow extends StatelessWidget {
  final String label;
  final String? value;
  final List<Map<String, String>> items;
  final bool isLoading;
  final ValueChanged<String?> onChanged;

  const CommonSubjectDropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 4.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                menuMaxHeight: 200.h,
                isDense: true,
                dropdownColor: Colors.white,
                isExpanded: true,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                value: value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CustomColor.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                hint: Text(
                  isLoading
                      ? 'Loading subjects...'
                      : (items.isEmpty ? 'Select above dropdown first' : 'Select'),
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
                items: items.map((subject) {
                  final id = subject['subid'] ?? '';
                  final name = subject['sub_name'] ?? id;
                  return DropdownMenuItem<String>(
                    value: id,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: items.isEmpty ? null : onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

