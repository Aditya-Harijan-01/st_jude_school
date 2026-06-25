import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/constant.dart';
import '../../../../providers/common/common_post_method.dart';

class PaidFeeItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final String regNo;
  final String? fromYear;
  final String? toYear;
  final String receiptShowNo;
  final String receiptType;

  const PaidFeeItem({
    super.key,
    required this.title,
    required this.amount,
    required this.date,
    required this.regNo,
    required this.fromYear,
    required this.toYear,
    required this.receiptShowNo,
    required this.receiptType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: CustomColor.colorGreen,
          width: 0.25,
        ),
        color: Colors.green.withValues(alpha: 0.08),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: 26.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CustomColor.primaryColor,
              ),

              child:
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => _downloadReceipt(context),
                icon: Icon(
                  Icons.download,
                  color: CustomColor.colorWhite,
                  size: 14.sp,
                ),
              )
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: CustomColor.colorBlack,
                      ),
                    ),
                    Text(
                      amount,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColor.colorGreen,
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Receipt No: ',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          receiptShowNo,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: CustomColor.colorBlack,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Date: ',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: CustomColor.colorBlack,
                          ),
                        ),
                      ],
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

  Future<void> _downloadReceipt(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>  Center(
        child: SizedBox(
          height: 300.h,
          child: Lottie.asset(
            'assets/animation/Paper_plane.json',
            fit: BoxFit.fitHeight,
            repeat: true,
          ),
        ),
      ),
    );

    try {
      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "regno": regNo,
        "fromyear": fromYear,
        "toyear": toYear,
        "rcpshowno": receiptShowNo,
        "rcpno": "",
        "rcptype": receiptType,
        "flag": "",
        "paid_amount": "",
        "payment_date": "",
      };

      log(requestBody.toString());

      // Call the API
      final response = await postRequest(
        ApiEndpoints.printStudentPaymentReceipt,
        requestBody,
      );



      // Close loading dialog
      Navigator.of(context).pop();

      if (response != null && response['statusCode'] == 'Success') {
        String downloadUrl = response['download_url'];
        String cleanUrl(String url) {
          url = url.replaceAll('\\', '/');
          if (!url.startsWith('http')) {
            url = 'https://$url';
          }
          return url;
        }
        
        final cleanedUrl = cleanUrl(downloadUrl);
        
        // Launch the URL to download the receipt
        if (await canLaunchUrl(Uri.parse(cleanedUrl))) {
          await launchUrl(
            Uri.parse(cleanedUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          // Show error if URL cannot be launched
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch download URL'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to download receipt'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}