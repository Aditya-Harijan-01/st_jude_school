import 'package:flutter/material.dart';
import '../../../constants/constant_text.dart';
import '../../../widgets/common_login_body.dart';

class PasswordScreen extends StatelessWidget {
  final bool isAddingAccount;
  const PasswordScreen({super.key, this.isAddingAccount = false});

  @override
  Widget build(BuildContext context) {
    return CommonScreenBody(
      page: 3,
      firstDesc: ConstantText.firstDescription,
      welcome: ConstantText.welcomeText,
      inputLabel: ConstantText.passwordLabel,
      passwordLabel: ConstantText.passwordLabel,
      remember: ConstantText.rememberMe,
      forgot: ConstantText.forgotText,
      login: ConstantText.loginText,
      loginDesc: ConstantText.loginDesc,
      fieldTitle: ConstantText.passwordLabel,
      isAddingAccount: isAddingAccount,
    );
  }
}
