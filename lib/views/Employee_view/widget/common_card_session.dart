// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/colors.dart';
import '../../../providers/common/common_Session.dart';

/// ---------------- SESSION DROPDOWN ----------------

  Widget buildSessionDropdown(
      Future<void> Function(String from, String to) reload,
      bool disable,
    ) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.all(4.0.w),
            child: SessionDropdown(
              onSessionChanged: (from, to) async {
                await reload(from, to);  
              },
              disable: disable
            ),
          ),
          Text(
            "Session",
            style: TextStyle(
              color: CustomColor.colorWhite,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }