// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:provider/provider.dart';
import '../../../constants/constant_text.dart';
// import '../../providers/auth_provider/auth_provider.dart';
import '../../../widgets/common_login_body.dart';
// import '../home/home_screen.dart';

class LoginScreen extends StatelessWidget {
  final bool isAddingAccount;
  const LoginScreen({super.key, this.isAddingAccount = false});

  @override
  Widget build(BuildContext context) {
    // final box = GetStorage();
    // bool rem = box.read("remember") ?? false;
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // // Redirect if "remember" is true
    // Future.microtask(() async {
      
    //   if (rem == true) {
    //     final remembered = await authProvider.loadRememberedUser();
    //     if (kDebugMode) {
    //       print(remembered);
    //     }
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (_) => const HomeScreen()),
    //     );
    //   }
    // });

    return CommonScreenBody(
      page: 1,
      firstDesc: ConstantText.firstDescription,
      welcome: ConstantText.welcomeText,
      inputLabel: ConstantText.inputLabel,
      passwordLabel: ConstantText.passwordLabel,
      remember: ConstantText.rememberMe,
      forgot: ConstantText.forgotText,
      login: ConstantText.loginText,
      loginDesc: ConstantText.loginDesc,
      fieldTitle: ConstantText.loginfieldTitle,
      isAddingAccount: isAddingAccount,
    );
  }
}
