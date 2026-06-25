import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import '../login/login_screen.dart';
import '../home/home_screen.dart';
import '../../../providers/common/multi_user_provider.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/common/common_menu.dart';import '../../../../widgets/common_alert_popup.dart';

import '../../../constants/constant.dart';
import '../../../providers/common/common_post_method.dart';
import '../../../providers/student/get_student_profile.dart';


class AccountSwitcher extends StatefulWidget {
  const AccountSwitcher({super.key});

  @override
  _AccountSwitcherState createState() => _AccountSwitcherState();
}

class _AccountSwitcherState extends State<AccountSwitcher> {
  bool isLoadingImage = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }
  Future<void> _loadAccounts() async {
    try {
      final multiUserProvider = Provider.of<MultiUserProvider>(context, listen: false);
      
      // Ensure current user is in the list
      await multiUserProvider.ensureCurrentAccountSaved();
      
      // Load accounts
      await multiUserProvider.loadAccounts();
    } catch (e) {
      log('Error loading accounts in AccountSwitcher: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _loadProfileImage(String sId) async {
    try {
      final response = await postRequest(ApiEndpoints.getStudentProfileImage, {
        "sid": sId
      });

      if (response != null && response['statusCode'] == 'Success') {
        final resultString = response["resultString"];
        final List<dynamic> resultList = jsonDecode(resultString);
        if (resultList.isNotEmpty) {
          return resultList.first["profile_image"];
        }
      }
    } catch (e) {
      log('Error loading profile image: $e');
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
            size: 20.sp,
          ),
        ),
        title: Text(
            "Switch Account",
            style:TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.sp)
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer2<MultiUserProvider, AuthProvider>(
        builder: (context, multiUserProvider, authProvider, child) {
          return _buildBody(context, multiUserProvider);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, MultiUserProvider multiUserProvider) {
    final savedAccounts = multiUserProvider.savedAccounts;
    final currentAccount = savedAccounts.firstWhere(
      (acc) => multiUserProvider.isCurrentAccount(acc), 
      orElse: () => savedAccounts.isNotEmpty ? savedAccounts.first : savedAccounts.first
    );
    final otherAccounts = savedAccounts.where((acc) => !multiUserProvider.isCurrentAccount(acc)).toList();
    bool hasCurrent = savedAccounts.any((acc) => multiUserProvider.isCurrentAccount(acc));

    return Column(
      children: [
        if (hasCurrent)
          _buildActiveUserBanner(currentAccount),
        if (otherAccounts.isNotEmpty)
          ...[
            _buildSavedAccountsHeader(otherAccounts.length),
            _buildOtherAccountsList(context, multiUserProvider, otherAccounts),
          ]
        else if (savedAccounts.length <= 1)
          _buildNoAccountsPlaceholder(),
        _buildAddAccountButton(context),
      ],
    );
  }
  Widget _buildActiveUserBanner(dynamic currentUser) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(16.r),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColor.primaryColor, CustomColor.secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          FutureBuilder<String?>(
            future: _loadProfileImage(currentUser.sid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(10.r),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              if (snapshot.hasData && snapshot.data != null) {
                return Container(
                  width: 55.w,
                  height: 55.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      color: Colors.white,
                      child: Image.memory(
                        base64Decode(snapshot.data!),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person,
                              color: CustomColor.primaryColor, size: 24.sp),
                        ),
                      ),
                    ),
                  ),
                );
              }
              return CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person,
                    color: CustomColor.primaryColor, size: 24.sp),
              );
            },
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Currently Active Account',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  currentUser.username.isNotEmpty ? currentUser.username : (currentUser.regno.isNotEmpty ? currentUser.regno : 'Unknown User'),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (currentUser.logintype.isNotEmpty)
                Text(
                  currentUser.logintype,
                   style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                  ),
                )
              ],
            ),
          ),
          Icon(Icons.check_circle, color: Colors.white, size: 24.sp),
        ],
      ),
    );
  }
  Widget _buildSavedAccountsHeader(int accountCount) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Text(
            'Other Saved Accounts',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          Text(
            '$accountCount account${accountCount > 1 ? 's' : ''}',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
  Widget _buildOtherAccountsList(BuildContext context, MultiUserProvider multiUserProvider, List<dynamic> otherAccounts) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        itemCount: otherAccounts.length,
        itemBuilder: (context, index) {
          // String profileImageBase64;
          final account = otherAccounts[index];
          final originalIndex = multiUserProvider.savedAccounts.indexOf(account);
          // profileImageBase64 = _loadProfileImage(account.sid);

          return Card(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 8.h),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: FutureBuilder<String?>(
                future: _loadProfileImage(account.sid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                     return SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: const Center(child: CircularProgressIndicator(strokeWidth: 1)),
                    );
                  }
                  if (snapshot.hasData &&
                      snapshot.data != null) {
                    return Container(
                      width: 55.w,
                      height: 55.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: CustomColor.primaryColor,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Container(
                          width: 50.w,
                          height: 50.w,
                          color: Colors.white,
                          child: Image.memory(
                            base64Decode(snapshot.data!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderAvatar(),
                          ),
                        ),
                      ),
                    );
                  }
                  return _buildPlaceholderAvatar();
                },
              ),
              title: Text(
                account.username.isNotEmpty ? account.username : account.regno,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   if (account.logintype.isNotEmpty)
                    Text(account.logintype),
                ],
              ),
              trailing: PopupMenuButton<String>(
                color: Colors.white,
                onSelected: (value) {
                  if (value == 'switch') _switchToAccount(context, multiUserProvider, account);
                  if (value == 'remove') _showRemoveAccountDialog(context, multiUserProvider, originalIndex, account);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'switch',
                    child: ListTile(
                      leading: Icon(Icons.swap_horiz, color: Colors.blue),
                      title: Text('Switch to this account'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'remove',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Remove account'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              onTap: () => _switchToAccount(context, multiUserProvider, account),
            ),
          );
        },
      ),
    );
  }
  Widget _buildPlaceholderAvatar() {
    return Container(
      color: CustomColor.primaryLight,
      child: Icon(
        Icons.person,
        color: CustomColor.primaryColor,
        size: 35.sp,
      ),
    );
  }

  Widget _buildNoAccountsPlaceholder() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle_outlined, size: 80.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              'No other saved accounts',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500, color: Colors.grey),
            ),
            SizedBox(height: 8.h),
            Text(
              'Add a new account to switch between accounts',
              style: TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAddAccountButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:  EdgeInsets.all(16.sp),
      child: ElevatedButton.icon(
        onPressed: () => _handleAddAccount(context),
        icon: Icon(Icons.add, size: 24.sp, color: Colors.white,),
        label:  Text('Add Account',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColor.primaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12.w),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  void _clearAllProviders(BuildContext context) {
    // Only attempt to clear if providers expose such methods
    // If methods don't exist, we skip or assume they will be refreshed on load.

    // AuthProvider data is cleared/overwritten in switchAccount logic,
    // but specific feature providers retain old data until refreshed.

    try {
      Provider.of<StudentProfileProvider>(context, listen: false).clearStudentProfileData();
    } catch (_) {}

    try {
       // Assuming these have clear/reset methods as in user example or similar
       // If methods are missing, we might need to add them or just rely on API refresh
       // Provider.of<AssignmentProvider>(context, listen: false).reset();
       // Provider.of<StudentAssignmentProvider>(context, listen: false).studentAssignmentList = []; // Helper access?
       // Most providers likely just hold data that will be overwritten.
    } catch (_) {}

    // Add more clears if methods exist
    try {
      // Provider.of<SessionProvider>(context, listen: false).clearSessions();
    } catch (_) {}

    try {
       // Provider.of<StudentsReportCardsProvider>(context, listen: false).clearData();
    } catch (_) {}
  }
  Future<void> _handleAddAccount(BuildContext context) async {
    final box = GetStorage();
    final isFingerprintEnabled = box.read('fingerprint') ?? false;
    if (isFingerprintEnabled) {
      bool isAuthenticated = await _authenticateWithBiometrics();

      if (isAuthenticated) {
        if (context.mounted) _navigateToLogin(context);
      } else {
        if (context.mounted) {
          CommonAlertPopup.show(
            context,
            title: 'Authentication Failed',
            message: 'Biometric authentication required to add account',
          );
        }
      }
    } else {
      _navigateToLogin(context);
    }
  }

  Future<bool> _authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    try {
      final bool isSupported = await auth.isDeviceSupported();
      final bool canCheck = await auth.canCheckBiometrics;

      if (!isSupported && !canCheck) return false;

      final available = await auth.getAvailableBiometrics();
      if (available.isEmpty) return false;

      return await auth.authenticate(
        localizedReason: 'Please authenticate to add a new account',
        biometricOnly: true,
        // stickyAuth: true,
      );
    } catch (e) {
      log('Biometric auth error: $e');
      return false;
    }
  }
  void _navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(isAddingAccount: true),
      ),
    ).then((_) {
       setState(() {});
       Provider.of<MultiUserProvider>(context, listen: false).loadAccounts();
    });
  }
  void _switchToAccount(BuildContext context, MultiUserProvider multiUserProvider, dynamic account) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Clear all providers
      _clearAllProviders(context);

      // Switch the account
      await multiUserProvider.switchAccount(context, account);
      
      final commonMenu = Provider.of<CommonMenuProvider>(context, listen: false);
      
      // Load Menu for the new user
      if (account.logintype == 'Student') {
        await commonMenu.getCommonMenu(account.regno, account.currentyearfrom);
      } else {
        await commonMenu.getCommonEmpMenu();
      }

      Navigator.of(context).pop(); // Dismiss loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Switched to ${account.regno}'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(menuItems: commonMenu.studentMenu),
        ),
        (route) => false,
      );
    } catch (e) {
      Navigator.of(context).pop();
      CommonAlertPopup.show(
        context,
        title: 'Switch Account Error',
        message: 'Failed to switch account: $e',
      );
    }
  }
  void _showRemoveAccountDialog(BuildContext context, MultiUserProvider multiUserProvider, int accountIndex, dynamic account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Account'),
        content: Text('Are you sure you want to remove "${account.regno}" from saved accounts?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await multiUserProvider.removeAccount(accountIndex);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account removed!'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
