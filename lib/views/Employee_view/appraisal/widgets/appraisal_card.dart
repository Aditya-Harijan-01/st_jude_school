import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';
import '../../../../models/employee/appraisal_model.dart';

class AppraisalCard extends StatelessWidget {
  final YearlyAppraisal appraisal;

  const AppraisalCard({
    super.key,
    required this.appraisal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 2.r, blurRadius: 2.r)
        ]
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appraisal.fromYear,
                  style:  TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:  EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${appraisal.totalPoints.toStringAsFixed(2)} /100',
                    style: TextStyle(
                      color: CustomColor.primaryColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding:  EdgeInsets.all(18.r),
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
            ),
            child: Column(
              children: [
                ...appraisal.mainCategories.map((detail) {
                  return _buildProgressItem(
                    detail.appraisalHeadName,
                    detail.pointValue,
                    detail.weightageValue,
                  );
                }).toList(),

                if (appraisal.domainCategories.isNotEmpty) ...[
                  Container(
                    padding:  EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: appraisal.domainCategories.map((detail) {
                        return _buildDomainItem(
                          detail.appraisalHeadName,
                          detail.point,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, double points, double maxPoints) {
    final progress = maxPoints > 0 ? points / maxPoints : 0.0;
    final hasPoints = points > 0;

    return Padding(
      padding:  EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                hasPoints
                    ? '${points.toStringAsFixed(2)} /${maxPoints.toStringAsFixed(2)}'
                    : '0 /${maxPoints.toStringAsFixed(2)}',
                style: TextStyle(
                  color: hasPoints ? CustomColor.primaryColor : Colors.grey[400],
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
           SizedBox(height: 4.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                hasPoints ? CustomColor.primaryColor : Colors.grey[300]!,
              ),
              minHeight: 6.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDomainItem(String title, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value == '-' ? '-' : value,
            style: TextStyle(
              color: value == '-' ? Colors.grey[500] : CustomColor.primaryColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}