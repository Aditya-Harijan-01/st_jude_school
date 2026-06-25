import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TimetableItem {
  final String subjectName;
  final String teacher;
  final String img;
  final String time;
  final String room;

  TimetableItem({
    required this.subjectName,
    required this.teacher,
    required this.img,
    required this.time,
    required this.room,
  });
}

class TimetableCards extends StatelessWidget {
  final String period;
  final List<TimetableItem> items;

  const TimetableCards({
    super.key,
    required this.period,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    bool hasMultipleItems = items.length > 1;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color:  Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          bottomLeft: Radius.circular(12.r),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            bottomLeft: Radius.circular(12.r),
          ),
          border: Border(
            left: BorderSide(
              color: hasMultipleItems ? CustomColor.barYellow : CustomColor.primaryColor,
              width: 6.w,
            ),
            top: BorderSide(
              color: hasMultipleItems ? CustomColor.barYellow : CustomColor.primaryColor,
              width: 1.w,
            ),
            bottom: BorderSide(
              color: hasMultipleItems ? CustomColor.barYellow : CustomColor.primaryColor,
              width: 1.w,
            ),
          ),
        ),
        child: Stack(
          children: [
            _buildCardContent(hasMultipleItems),
            Positioned(
              top: 0,
              right: 5.w,
              child: Container(
                width: 75.w,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: hasMultipleItems ? CustomColor.barYellow : CustomColor.primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.r),
                    bottomRight: Radius.circular(8.r),
                  ),
                ),
                child: Center(
                  child: Text(
                    period,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: CustomColor.colorWhite,
                      fontWeight: FontWeight.bold,
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

  Widget _buildCardContent(bool hasMultipleItems) {
    return Column(
      children: items.asMap().entries.map((entry) {
        int index = entry.key;
        TimetableItem item = entry.value;
        bool isLast = index == items.length - 1;

        return Column(
          children: [
            _buildSingleItem(item, hasMultipleItems),
            if (!isLast)
              Divider(
                color: CustomColor.barYellow,
                thickness: 1,
                height: 1,
              ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSingleItem(TimetableItem item, bool hasMultipleItems) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.subjectName,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18.r,
                        backgroundImage: NetworkImage(item.img),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          item.teacher,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 8.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 24.h),
                if (item.time.isNotEmpty)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 8.h),
                      Container(
                        width: 75.w,
                        decoration: BoxDecoration(
                          color: hasMultipleItems ? CustomColor.barYellow : CustomColor.primaryColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.r),
                            topRight: Radius.circular(8.r),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: CustomColor.colorWhite,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 1.h),
                              color: CustomColor.colorWhite,
                              height: 1.w,
                              width: 45.w,
                            ),
                            Text(
                              item.room,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: CustomColor.colorWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}