import 'package:flutter/material.dart';
import '../../../constants/constant_text.dart';
import '../../../widgets/common_login_body.dart';

class OtpScreen extends StatelessWidget {
  final String flag;
  final String number;
  const OtpScreen({
    super.key, 
    required this.flag, required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return CommonScreenBody(
      page: flag == "Forgot" ? 4 : 2,
      firstDesc: ConstantText.firstDescription,
      welcome: flag == "Forgot" ? ConstantText.checkEmail : ConstantText.otpTitle,
      inputLabel: ConstantText.otpLabel,
      passwordLabel: ConstantText.passwordLabel,
      remember: ConstantText.rememberMe,
      forgot: ConstantText.forgotText,
      login: ConstantText.loginText,
      loginDesc: flag == "Forgot" ? ConstantText.emailDesc : number,
      fieldTitle: ConstantText.otpFieldTitle,
    );
  }
}
