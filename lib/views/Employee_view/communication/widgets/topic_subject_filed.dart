// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../providers/employee/emp_communication.dart';

class TopicSubjectField extends StatelessWidget {
  late EmpCommunicationProvider controller;
  TopicSubjectField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topic/Subject',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
          ),
          child: TextField(
            controller: controller.topicController,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: '',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 16.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16.w),
            ),
          ),
        ),
      ],
    );
  }
}