import '../../../../constants/colors.dart';
import '../../login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../constants/constant_text.dart';
import '../../../../providers/auth_provider/auth_provider.dart';

class SetPasswordScreenForm extends StatefulWidget {
  final String welcome;
  final String inputLabel;
  final String passwordLabel;
  final String remember;
  final String forgot;
  final String login;
  final String loginDesc;
  final String fieldTitle;
  const SetPasswordScreenForm({
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
  State<SetPasswordScreenForm> createState() => _SetPasswordScreenFormState();
}

class _SetPasswordScreenFormState extends State<SetPasswordScreenForm> {
  // final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _setPasswordController = TextEditingController();

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
          SizedBox(height: 6.h),
          SizedBox(
            height: 100.h,
            width: double.infinity,
            child: Column(
              children: [
                Text(
                  ConstantText.setPassword,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  ConstantText.setpasswordDesc,
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
          SizedBox(height: 4.h),
          Row(
            children: [
              Text(
                ConstantText.passwordLabel,
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
              labelText: ConstantText.enterPassword,
              labelStyle: TextStyle(
                color: CustomColor.colorGrey,
                fontSize: 16.sp
              ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r)
              ),
              suffixIcon: Icon(Icons.visibility_off_outlined)
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                ConstantText.confirmPasswordLabel,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: CustomColor.colorGrey
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          TextField(
            controller: _setPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: ConstantText.enterConfirmPassword,
              labelStyle: TextStyle(
                color: CustomColor.colorGrey,
                fontSize: 16.sp
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.r)
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
              suffixIcon: Icon(Icons.visibility_off_outlined)
            ),
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: authProvider.isLoading
                ? null
                : () async {
                  bool success = 
                    await authProvider.checkPassword(
                      _passwordController.text, 
                      _setPasswordController.text
                    );
                  if(success){
                      Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false, 
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
                  widget.login,
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