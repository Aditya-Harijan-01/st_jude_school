import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';
import '../../../../providers/employee/emp_communication.dart';

class AttachmentField extends StatefulWidget {
  final EmpCommunicationProvider controller;
  const AttachmentField({super.key, required this.controller});

  @override
  State<AttachmentField> createState() => _AttachmentFieldState();
}

class _AttachmentFieldState extends State<AttachmentField> {  

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        setState(() {
          widget.controller.selectedFiles = result.files;
        });
      }
    } catch (e) {
      log('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachment',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
          ),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                child: Text(
                  'Choose files',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: widget.controller.selectedFiles != null && widget.controller.selectedFiles.isNotEmpty
                    ? Text(
                        '${widget.controller.selectedFiles.length} file(s) chosen',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      )
                    : Text(
                        'No file chosen',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
              )
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.controller.isAddToResource = !widget.controller.isAddToResource;
                });
              },
              child: Container(
                width: 20.h,
                height: 20.h,
                decoration: BoxDecoration(
                  color: widget.controller.isAddToResource ? CustomColor.primaryColor : Colors.transparent,
                  border: Border.all(
                    color: CustomColor.primaryColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: widget.controller.isAddToResource
                    ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                )
                    : null,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Add to Resource',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: CustomColor.primaryColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}