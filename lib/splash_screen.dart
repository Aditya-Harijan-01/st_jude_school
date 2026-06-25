// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants/colors.dart';
import 'providers/auth_provider/auth_provider.dart';
import 'providers/common/common_menu.dart';
import 'providers/common/get_api_kay.dart';
import 'views/Student_views/home/home_screen.dart';
import 'views/Student_views/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final LocalAuthentication auth = LocalAuthentication();
  final box = GetStorage();
  bool _isAuthenticating = true;
  String _authMessage = "Authenticating...";
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final info = await PackageInfo.fromPlatform();

      final bool needsUpdate = await isUpdateRequired();

      if (needsUpdate) {
        redirectToPlayStore(info.packageName);
        return; // 🚫 stop further execution
      }

      // ✅ App is up-to-date
      _handleStartupLogic();
    });

  }

  Future<bool> isUpdateRequired() async {
    final apiKeyService = ApiKeyDart();
    final info = await PackageInfo.fromPlatform();

    // Ensure API key & version are loaded
    if (apiKeyService.apiKeyModel == null) {
      await apiKeyService.getApiKey();
    }

    int? apiVersion = apiKeyService.apiKeyModel?.version;
    int currectVersion = int.parse(normalizeVersion(info.version));

    log("🌐 API Version: $apiVersion");
    log("📦 App Build: ${info.version}");

    if (apiVersion == null || currectVersion == "") {
      return false; // fail-safe
    }

    return apiVersion > currectVersion;
    // return false;
  }

  String normalizeVersion(String version) {
    final parts = version.split('.');
    // while (parts.length < 3) {
    //   parts.add('0'); // Add missing minor/patch as 0
    // }
    return parts.take(3).join('');
  }


  Future<void> redirectToPlayStore(String packageName) async {
    final url = Uri.parse("https://play.google.com/store/apps/details?id=$packageName");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      log('Could not launch Play Store URL.');
    }
  }

  Future<void> _handleStartupLogic() async {
    // Check and show review prompt BEFORE navigation
    if (_shouldShowReviewPrompt()) {
      try {
        if (await inAppReview.isAvailable()) {
          await inAppReview.requestReview();
        }
      } catch (e) {
        log('Error requesting review: $e');
      }
    } 

    bool check = box.read('fingerprint') ?? false;

    check ? _authenticate() : _navigateToLogin();
  }



  bool _shouldShowReviewPrompt([DateTime? date]) {
    final now = date ?? DateTime.now();
    final isEvenMonth = now.month % 2 == 0;
    final isWithinDateRange = now.day >= 1 && now.day <= 2;
    
    return isEvenMonth && isWithinDateRange;
  }


  Future<void> _navigateToLogin() async {
    bool remember = box.read("remember") ?? false;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    

    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 500));

    if (remember) {
      final commonMenu = Provider.of<CommonMenuProvider>(context, listen: false);
      await authProvider.loadRememberedUser();
      if (authProvider.loginType == 'Student') {
        await commonMenu.getCommonMenu(authProvider.loginData!.regno,
            authProvider.loginData!.currentyearfrom);
      }else{
        await commonMenu.getCommonEmpMenu();
      }
      navigateWithForceUpgrade(
        HomeScreen(
          menuItems: commonMenu.studentMenu
        )
      );
    } else {
      navigateWithForceUpgrade(
        LoginScreen()
      );
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      final bool isSupported = await auth.isDeviceSupported();
      final bool canCheck = await auth.canCheckBiometrics;

      if (!isSupported && !canCheck) {
        setState(() => _isAuthenticating = false);
        await _navigateToLogin();
        return;
      }

      final available = await auth.getAvailableBiometrics();
      if (available.isEmpty) {
        setState(() => _isAuthenticating = false);
        await _navigateToLogin();
        return;
      }

      authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to continue',
        biometricOnly: true,
      );

      setState(() => _isAuthenticating = false);

      if (authenticated) {
        await Future.delayed(const Duration(milliseconds: 600));
        await _navigateToLogin();
      } else {
        setState(() {
          _authMessage = "Authentication failed or cancelled.";
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authMessage = "Error: ${e.message}";
      });
    } catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authMessage = "Unexpected error: $e";
      });
    }
  }

  void navigateWithForceUpgrade(Widget targetScreen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => UpgradeAlert(
          showIgnore: false,
          showLater: false,
          barrierDismissible: false,
          dialogStyle: Platform.isAndroid
            ? UpgradeDialogStyle.material
            : UpgradeDialogStyle.cupertino,
          child: WillPopScope(
            onWillPop: () async {
              final upgrader = Upgrader();
              if (upgrader.blocked()) {
                return false; // 🚫 block back button
              }
              return true;
            },
            child: targetScreen,
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              CustomColor.colorWhite,
              CustomColor.primaryColor,
              CustomColor.primaryOne
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icons/logo.png',
                  width: 250.w,
                  height: 250.h,
                ),
                SizedBox(height: 80.h),
    
                _isAuthenticating
                ? Icon(
                    Icons.fingerprint_sharp,
                    size: 70.h,
                    color: CustomColor.colorWhite,
                  )
                : CircularProgressIndicator(
                    color: CustomColor.colorWhite,
                    strokeWidth: 3.5,
                  ),
    
                SizedBox(height: 20.h),
    
                Text(
                  _authMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
    
                SizedBox(height: 100.h),              
                Column(
                  children: [
                    Image.asset(
                      'assets/images/ednect_logo.png',
                      width: 150.w,
                      height: 80.h,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "© 2026 Ednect App",
                      style: TextStyle(
                        color: Colors.white54, 
                        fontSize: 16.sp
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
