import '../../../../constants/colors.dart';
import '../../../../providers/common/common_menu.dart';
import '../../../../providers/common/multi_user_provider.dart';
import 'package:st_jude_school/views/Student_views/forgot_password/forgot_screen.dart';
import '../../home/home_screen.dart';
import '../../../../providers/student/get_student_profile.dart';
// import 'package:st_jude_school/views/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../widgets/common_alert_popup.dart';
import '../../../../widgets/remember_mee.dart';

class PasswordForm extends StatefulWidget {
  final String welcome;
  final String inputLabel;
  final String passwordLabel;
  final String remember;
  final String forgot;
  final String login;
  final String loginDesc;
  final String fieldTitle;
  final bool? isAddingAccount;
  const PasswordForm({
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
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visible = false;
  bool areYouLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final commonMenu = Provider.of<CommonMenuProvider>(context);

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
          SizedBox(height: 1.h),
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
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: CustomColor.colorGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          // Row(
          //   children: [
          //     Text(
          //       widget.fieldTitle,
          //       style: TextStyle(
          //         fontSize: 16.sp
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 10.h),
          TextField(
            controller: _passwordController,
            obscureText: visible ? true : false,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: visible
                    ? Icon(Icons.visibility_off, size: 20.sp)
                    : Icon(Icons.visibility, size: 20.sp),
                onPressed: () {
                  // Toggle password visibility
                  setState(() {
                    visible = !visible;
                  });
                },
              ),
              labelText: widget.inputLabel,
              labelStyle: TextStyle(fontSize: 16.sp),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
            onPressed: areYouLoading
                ? null
                : () async {
                    setState(() {
                      areYouLoading = true;
                    });
                    bool success = await authProvider.password(
                      _passwordController.text,
                      widget.remember,
                    );

                    if (success) {
                      if (widget.isAddingAccount == true &&
                          authProvider.loginType == 'Student') {
                        final multiUserProvider =
                            Provider.of<MultiUserProvider>(
                              context,
                              listen: false,
                            );

                        try {
                          Provider.of<StudentProfileProvider>(
                            context,
                            listen: false,
                          ).clearStudentProfileData();
                        } catch (_) {}

                        if (authProvider.loginData != null) {
                          await multiUserProvider.addAccount(
                            authProvider.loginData!,
                          );
                          await multiUserProvider.ensureCurrentAccountSaved();
                        }
                      }

                      await authProvider.loadRememberedUser();
                      if (authProvider.loginType == 'Student') {
                        await commonMenu.getCommonMenu(
                          authProvider.loginData!.regno,
                          authProvider.loginData!.currentyearfrom,
                        );
                      } else {
                        await commonMenu.getCommonEmpMenu();
                      }
                      Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HomeScreen(menuItems: commonMenu.studentMenu),
                        ),
                        (route) => false,
                      );
                    } else {
                      // ignore: use_build_context_synchronously
                      CommonAlertPopup.show(
                        context,
                        title: "Invalid credentials.",
                        message:
                            "Please enter valid credentials and try again.",
                      );
                    }
                    setState(() {
                      areYouLoading = false;
                    });
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              backgroundColor: CustomColor.primaryColor,
            ),
            child: areYouLoading
                ? CircularProgressIndicator(color: CustomColor.colorWhite)
                : Text(
                    widget.login,
                    style: TextStyle(
                      color: CustomColor.colorWhite,
                      fontSize: 18.sp,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
