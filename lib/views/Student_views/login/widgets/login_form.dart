import 'dart:developer';

import '../../../../constants/colors.dart';
import 'package:st_jude_school/views/Student_views/forgot_password/forgot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../widgets/remember_mee.dart';
import '../../../../widgets/common_alert_popup.dart';
import '../../confirm_password/confirm_password.dart';
import '../../otp_screen/otp_screen.dart';

class LoginForm extends StatefulWidget {
  final String welcome;
  final String inputLabel;
  final String passwordLabel;
  final String remember;
  final String forgot;
  final String login;
  final String loginDesc;
  final String fieldTitle;
  final bool? isAddingAccount;
  const LoginForm({
    super.key,
    required this.welcome,
    required this.inputLabel,
    required this.passwordLabel,
    required this.remember,
    required this.forgot,
    required this.login,
    required this.loginDesc,
    required this.fieldTitle,
    this.isAddingAccount,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    // final screenHeight = MediaQuery.sizeOf(context).height;
    // final screenWidth = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 16.h),
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
                    fontWeight: FontWeight.w500,
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
                    color: CustomColor.colorGrey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Text(widget.fieldTitle, style: TextStyle(fontSize: 14.sp)),
            ],
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: _usernameController,
            obscureText: false,
            decoration: InputDecoration(
              labelText: widget.inputLabel,
              labelStyle: TextStyle(
                color: CustomColor.colorGrey,
                fontSize: 16.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row(
              //   children: [
              //     Checkbox(value: false, onChanged: (_) {}),
              //     Text(widget.remember),
              //   ],
              // ),
              RememberMeRow(remember: widget.remember),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotScreen()),
                  );
                },
                child: Text(
                  widget.forgot,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CustomColor.colorBlue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    bool _isInteger(String s) {
                      return RegExp(r'^\d+$').hasMatch(s);
                    }
                    // bool _isAlphanumeric(String s) {
                    //   if (s.isEmpty) return false;
                    //   return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(s);
                    // }

                    if (_usernameController.text.length == 10 &&
                        _isInteger(_usernameController.text)) {
                      bool success = await authProvider.generateOtp(
                        _usernameController.text,
                      );
                      if (success) {
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtpScreen(
                              flag: "Login",
                              number: _usernameController.text,
                            ),
                          ),
                        );
                      } else {
                        CommonAlertPopup.show(
                          context,
                          title: "Invalid credentials.",
                          message:
                              "Please enter valid credentials and try again.",
                        );
                      }
                    } else {
                      log('into this');
                      bool success = await authProvider.login(
                        _usernameController.text,
                      );
                      if (success) {
                        if ((widget.isAddingAccount ?? false) &&
                            authProvider.loginType != 'Student') {
                          return CommonAlertPopup.show(
                            context,
                            title: "Access Denied",
                            message:
                                "This feature is exclusive for students only.",
                          );
                        }
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (_) => PasswordScreen(
                              isAddingAccount: widget.isAddingAccount ?? false,
                            ),
                          ),
                        );
                      } else {
                        CommonAlertPopup.show(
                          context,
                          title: "Invalid credentials.",
                          message:
                              "Please enter valid credentials and try again.",
                        );
                      }
                    } //else {
                    //   // ignore: use_build_context_synchronously
                    //   CommonAlertPopup.show(
                    //     context,
                    //     title: "Invalid credentials.",
                    //     message: "Please enter valid credentials and try again.",
                    //   );
                    // }
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              backgroundColor: CustomColor.primaryColor,
            ),
            child: authProvider.isLoading
                ? CircularProgressIndicator(color: CustomColor.colorWhite)
                : Text(
                    widget.login,
                    style: TextStyle(
                      color: CustomColor.colorWhite,
                      fontSize: 16.sp,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
