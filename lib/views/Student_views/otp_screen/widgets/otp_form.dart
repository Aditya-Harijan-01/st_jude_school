// ignore_for_file: deprecated_member_use

import '../../../../constants/colors.dart';
import 'package:st_jude_school/providers/auth_provider/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
// import '../../home/home_screen.dart';
import '../../../../providers/common/common_menu.dart';
import '../../../../widgets/remember_mee.dart';
import '../../../../widgets/show_loading_dialog.dart';
import '../../home/home_screen.dart';
import '../../set_password/set_password.dart';

class OtpForm extends StatefulWidget {
  final String welcome;
  final String inputLabel;
  final String passwordLabel;
  final String remember;
  final String forgot;
  final String login;
  final String loginDesc;
  final String fieldTitle;
  const OtpForm({
    super.key,
    required this.welcome,
    required this.inputLabel,
    required this.passwordLabel,
    required this.remember,
    required this.forgot,
    required this.login,
    required this.loginDesc,
    required this.fieldTitle,
  });

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

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
                  "We’ve sent 6 digits verification code to ${widget.loginDesc}",
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
          Row(
            children: [
              Text(widget.fieldTitle, style: TextStyle(fontSize: 16.sp)),
            ],
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: otpController,
            obscureText: true,
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
          SizedBox(height: 10.h),
          RememberMeRow(remember: widget.remember),
          ElevatedButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                    if (widget.forgot == "4") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SetPasswordScreen(),
                        ),
                      );
                    } else if (widget.forgot == "2") {
                      final users = await authProvider.checkOtpPhone(
                        otpController.text,
                      );

                      if (users == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid OTP")),
                        );
                        return;
                      }
                      // ✅ OTP matched
                      if (users.length == 1) {
                        authProvider.assignUser(users.first);
                        navigateToHome(context);
                      } else {
                        showUserSelectionPopup(context, authProvider, users);
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              backgroundColor: CustomColor.primaryColor,
            ),
            child: authProvider.isLoading
                ? CircularProgressIndicator(color: CustomColor.colorWhite)
                : Text(
                    'Confirm',
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

  void showUserSelectionPopup(
    BuildContext context,
    AuthProvider authProvider,
    List<LoginUser?> users,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: CustomColor.colorBlack.withOpacity(0.6),
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1F1C2C), // dark purple
                  Color(0xFF2A2A3C), // soft charcoal
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomColor.colorBlack.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔹 Title
                Text(
                  "Select Account",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: CustomColor.colorWhite,
                    letterSpacing: 0.4,
                  ),
                ),

                SizedBox(height: 14.h),

                /// 🔹 Divider
                Divider(
                  color: CustomColor.colorWhite.withOpacity(0.15),
                  thickness: 1,
                ),

                ...users.map((user) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () {
                      authProvider.assignUser(user);
                      Navigator.pop(context);
                      navigateToHome(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Row(
                        children: [
                          /// Avatar
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: CustomColor.colorWhite.withOpacity(
                              0.12,
                            ),
                            child: Icon(
                              user!.logintype == "Student"
                                  ? Icons.school
                                  : Icons.badge,
                              color: CustomColor.colorWhite,
                              size: 20.sp,
                            ),
                          ),

                          SizedBox(width: 12.w),

                          /// Name & Type
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.tname,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: CustomColor.colorWhite,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  user.logintype,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: CustomColor.colorWhite.withOpacity(
                                      0.65,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Arrow
                          Icon(
                            Icons.chevron_right,
                            color: CustomColor.colorWhite.withOpacity(0.6),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> navigateToHome(BuildContext context) async {
    showLoadingDialog(context);
    final commonMenu = Provider.of<CommonMenuProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    if (auth.loginData!.logintype == 'Student') {
      await commonMenu.getCommonMenu(
        auth.loginData!.regno,
        auth.loginData!.currentyearfrom,
      );
    } else {
      await commonMenu.getCommonEmpMenu();
    }

    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Close loading dialog

    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(menuItems: commonMenu.studentMenu),
      ),
    );
  }
}
