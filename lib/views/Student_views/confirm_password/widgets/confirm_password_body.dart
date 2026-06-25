
import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import 'confirm_form.dart';

class PasswordScreenBody extends StatelessWidget {
  final String firstDesc;
  final String welcome;
  final String inputLabel;
  final String passwordLabel;
  final String remember;
  final String forgot;
  final String login;
  final String loginDesc;
  final String fieldTitle;
  const PasswordScreenBody({
    super.key, 
    required this.firstDesc,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.primaryColor,
      // Ensure the body resizes when the keyboard appears
      resizeToAvoidBottomInset: true,
      body: Container(
        // Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/primary_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final screenWidth = MediaQuery.sizeOf(context).width;
              // final screenHeight = MediaQuery.sizeOf(context).height;
    
              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                // Add bottom padding equal to the keyboard height so content can move above it
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  // Ensure the content is at least as tall as the viewport so Spacer works
                  constraints: BoxConstraints(minHeight: availableHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top header
                        SizedBox(height: availableHeight * 0.05),
                        Image.asset(
                          "assets/images/ednect_logo.png",
                          height: availableHeight * 0.15,
                          width: screenWidth * 0.5,
                        ),
                        SizedBox(height: availableHeight * 0.02),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            "GET STARTED NOW",
                            style: TextStyle(
                              fontFamily: "chalk",
                              fontSize: 40,
                              color: CustomColor.colorWhite,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Text(
                            firstDesc,
                            style: TextStyle(
                              fontSize: 14,
                              color: CustomColor.colorWhite,
                            ),
                          ),
                        ),
    
                        // Push the form panel to the bottom when there is enough space
                        const Spacer(),
    
                        // Bottom panel: remove fixed height, let it grow/shrink
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration:  BoxDecoration(
                            color: CustomColor.colorWhite,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          // Keep a reasonable minimum height relative to the current viewport
                          constraints: BoxConstraints(
                            minHeight: availableHeight * 0.65, // was fixed 0.68 of full screen
                          ),
                          child: PasswordForm(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}