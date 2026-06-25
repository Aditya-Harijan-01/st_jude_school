import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constants/colors.dart';

Widget buildSyllabusTile({
  required String title,
  List<Widget>? details,
  required BuildContext context,
  bool isInitiallyExpanded = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: CustomColor.colorShadow.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, 
        ),
        child: ExpansionTile(
          initiallyExpanded: isInitiallyExpanded,
          tilePadding: EdgeInsets.symmetric(horizontal: 12.w),
          childrenPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide.none, 
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide.none, 
          ),
          backgroundColor: CustomColor.colorWhite,
          collapsedBackgroundColor: CustomColor.colorWhite,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: CustomColor.primaryColor,
                ),
                padding: EdgeInsets.all(6.w),
                child: SvgPicture.asset(
                  "assets/icons/svg/Vector.svg",
                  height: 20.h,
                  width: 20.w,
                  // ignore: deprecated_member_use
                  color: CustomColor.colorWhite,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.colorBlack,
                  ),
                ),
              ),
            ],
          ),
          children: details ?? [],
        ),
      ),
    );
  }
