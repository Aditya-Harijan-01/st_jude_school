import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';

class SearchWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchWidget({
    super.key,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      decoration: BoxDecoration(
        color: CustomColor.colorGreyBack1,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TextField(
        onChanged: onChanged, // 🔹 Send search text back
        decoration: InputDecoration(
          hintText: 'Search By Subjects',
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: CustomColor.colorGrey,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: CustomColor.colorGrey,
            size: 22.sp,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
