import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

void showLoadingDialog(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
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
}