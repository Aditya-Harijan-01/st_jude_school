import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../providers/auth_provider/auth_provider.dart';

class RememberMeRow extends StatefulWidget {
  final String remember;
  const RememberMeRow({super.key, required this.remember});

  @override
  State<RememberMeRow> createState() => _RememberMeRowState();
}

class _RememberMeRowState extends State<RememberMeRow> {

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Row(
          children: [
            Checkbox(
              value: auth.isCheck,
              activeColor: CustomColor.primaryColor,
              onChanged: (value) {
                auth.toggleRememberMe(value ?? false);
              },
            ),
            Text("Remember me", style: TextStyle(fontSize: 14.sp),),
          ],
        );
      },
    );
  }
}
