import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';
import '../views/Student_views/confirm_password/widgets/confirm_form.dart';
import '../views/Student_views/forgot_password/widgets/forgot_form.dart';
import '../views/Student_views/forgot_password_otp/widgets/forgot_otp_form.dart';
import '../views/Student_views/login/widgets/login_form.dart';
import '../views/Student_views/otp_screen/widgets/otp_form.dart';
import '../views/Student_views/set_password/widgets/set_password_form.dart';

class CommonScreenBody extends StatelessWidget {
  final int page;
  final String firstDesc;
  final String welcome;
  final String inputLabel;
  final String passwordLabel;
  final String remember;
  final String forgot;
  final String login;
  final String loginDesc;
  final String fieldTitle;
  final bool? isAddingAccount;

  const CommonScreenBody({
    super.key,
    required this.page,
    required this.firstDesc,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryOne,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),
                    Image.asset(
                      "assets/images/ednect_logo.png",
                      height: 120.h,
                      width: 180.w,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "GET STARTED NOW",
                      style: TextStyle(
                        fontFamily: "chalk",
                        fontSize: 24.sp,
                        color: CustomColor.colorWhite,
                      ),
                    ),
                    Text(
                      firstDesc,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: CustomColor.colorWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height - 300.h,
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: CustomColor.colorWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              child: page == 1 ? 
                LoginForm(
                  welcome: welcome,
                  inputLabel: inputLabel,
                  passwordLabel: passwordLabel,
                  remember: remember,
                  forgot: forgot,
                  login: login,
                  loginDesc: loginDesc,
                  fieldTitle: fieldTitle,
                  isAddingAccount: isAddingAccount,
                ) : page == 2 ?
                  OtpForm(
                    welcome: welcome,
                    inputLabel: inputLabel,
                    passwordLabel: passwordLabel,
                    remember: remember,
                    forgot: page.toString(),
                    login: login,
                    loginDesc: loginDesc,
                    fieldTitle: fieldTitle
                  ) : page == 3 ?
                  PasswordForm(
                    welcome: welcome,
                    inputLabel: inputLabel,
                    passwordLabel: passwordLabel,
                    remember: remember,
                    forgot: forgot,
                    login: login,
                    loginDesc: loginDesc,
                    fieldTitle: fieldTitle,
                    isAddingAccount: isAddingAccount,
                  ) : page == 4 ?
                  ForgotForm(
                    welcome: welcome,
                    inputLabel: inputLabel,
                    passwordLabel: passwordLabel,
                    remember: remember,
                    forgot: forgot,
                    login: login,
                    loginDesc: loginDesc,
                    fieldTitle: fieldTitle
                  ) : page == 6 ?
                  ForgotOtpForm(
                    welcome: welcome,
                    inputLabel: inputLabel,
                    passwordLabel: passwordLabel,
                    remember: remember,
                    forgot: forgot,
                    login: login,
                    loginDesc: loginDesc,
                    fieldTitle: fieldTitle
                  ) : SetPasswordScreenForm(
                    welcome: welcome,
                    inputLabel: inputLabel,
                    passwordLabel: passwordLabel,
                    remember: remember,
                    forgot: forgot,
                    login: login,
                    loginDesc: loginDesc,
                    fieldTitle: fieldTitle
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
