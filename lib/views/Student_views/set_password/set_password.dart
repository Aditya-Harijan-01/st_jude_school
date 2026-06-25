import 'package:flutter/material.dart';
import '../../../constants/constant_text.dart';
import '../../../widgets/common_login_body.dart';

class SetPasswordScreen extends StatelessWidget {
  const SetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScreenBody(
      page: 5,
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
