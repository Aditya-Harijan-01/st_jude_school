import 'package:flutter/material.dart';
import '../../../constants/constant_text.dart';
import '../../../widgets/common_login_body.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScreenBody(
      page: 4,
      firstDesc: ConstantText.firstDescription,
      welcome: ConstantText.forgotTextTitle,
      inputLabel: ConstantText.forgotTextLabel,
      passwordLabel: ConstantText.passwordLabel,
      remember: ConstantText.rememberMe,
      forgot: ConstantText.forgotText,
      login: ConstantText.loginText,
      loginDesc: ConstantText.forgotTextDesc, 
      fieldTitle: ConstantText.forgotTitle,
    );
  }
}
