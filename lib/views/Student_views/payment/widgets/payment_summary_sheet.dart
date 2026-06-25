import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';

class PaymentSummaryBottomSheet {
  static void show({
    required BuildContext context,
    // required List<Map<String, dynamic>> selectedInstallments,
    required double totalAmount,
    required double totalConcession,
    required double totalAmountWithout,
    required double totalLateFine,
    required double totalCheckBounce,
    required VoidCallback onPayNow,
    bool isProcessing = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            _buildAmountRow('Total amount:', '₹$totalAmountWithout'),
            SizedBox(height: 12.h),
            _buildAmountRow('Concession:', '₹$totalConcession'),
            SizedBox(height: 12.h),
            _buildAmountRow('Late Fine Amount:', '₹${totalLateFine.toStringAsFixed(2)}'),
            SizedBox(height: 12.h),
            _buildAmountRow('Check Bounce Amount:', '₹${totalCheckBounce.toStringAsFixed(2)}'),
            Divider(height: 24.h, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.colorBlack,
                  ),
                ),
                Text(
                  '₹${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            _buildPayNowButton(context, totalAmount, onPayNow, isProcessing),
          ],
        ),
      ),
    );
  }

  static Widget _buildAmountRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            color: CustomColor.colorBlack,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: CustomColor.colorBlack,
          ),
        ),
      ],
    );
  }

  static Widget _buildPayNowButton(
    BuildContext context,
    double totalAmount,
    VoidCallback onPayNow,
    bool isProcessing,
  ) {
    final fontsize = 18.sp;
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton.icon(
        onPressed: isProcessing ? null : onPayNow,
        style: ElevatedButton.styleFrom(
          backgroundColor: isProcessing ? CustomColor.colorGrey : CustomColor.primaryColor,
          foregroundColor: CustomColor.colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 2,
        ),
        icon: isProcessing
            ? SizedBox(
                child: CircularProgressIndicator(
                  color: CustomColor.colorWhite,
                  strokeWidth: 2,
                ),
              )
            : Icon(Icons.payment, color: CustomColor.colorWhite, size: 18.sp),
        label: Text(
          isProcessing ? 'Processing...' : 'Confirm Payment',
          style: TextStyle(
            fontSize: fontsize,
            fontWeight: FontWeight.bold,
            color: CustomColor.colorWhite,
          ),
        ),
      ),
    );
  }
}