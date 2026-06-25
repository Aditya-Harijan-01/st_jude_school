import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../widgets/common_alert_popup.dart';
import '../../forgot_password_otp/forgot_otp_screen.dart';

class ForgotForm extends StatefulWidget {
  final String welcome;
  final String inputLabel;
  final String passwordLabel;
  final String remember;
  final String forgot;
  final String login;
  final String loginDesc;
  final String fieldTitle;
  const ForgotForm({
    super.key,
    required this.welcome,
    required this.inputLabel,
    required this.passwordLabel,
    required this.remember,
    required this.forgot,
    required this.login,
    required this.loginDesc,
    required this.fieldTitle
  });

  @override
  State<ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        spacing: 0.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/icons/logo.png", height: 200.h),
          SizedBox(height: 10.h),
          SizedBox(
            height: 100.h,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  widget.welcome,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.loginDesc,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CustomColor.colorGrey
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(
                "Admission Number",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CustomColor.colorGrey
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Enter Admission Number",
              labelStyle: TextStyle(
                color: CustomColor.colorGrey,
                fontSize: 16.sp
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r)
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Haven't got the OTP yet?",
                style: TextStyle(
                  fontSize: 12.sp,
                ),
              ),
              GestureDetector(
                child: 
                  Text(
                    "Resent OTP",
                    style: TextStyle(
                      color: CustomColor.colorBlue,
                      fontSize: 12.sp
                    ),
                  )
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                  bool success = 
                    await authProvider.forgotPassword(_passwordController.text);
                    if (success) {
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (_) => const ForgotOtpScreen(flag: "Forgot")),
                      );
                    } else {
    // Show invalid credential message
                      CommonAlertPopup.show(
                        context,
                        title: 'Invalid Registration',
                        message: 'Invalid Registration number. Please try again.',
                      );
                    }
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              backgroundColor: CustomColor.primaryColor,
            ),
            child: authProvider.isLoading
                ? CircularProgressIndicator(color: CustomColor.colorWhite)
                : Text(
                  'Continue',
                  style: TextStyle(
                    color: CustomColor.colorWhite,
                    fontSize: 18.sp
                  ),
                ),
          ),
        ],
      ),
    );
  }
}