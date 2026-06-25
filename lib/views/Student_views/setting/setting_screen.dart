import '../../../providers/auth_provider/auth_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../providers/employee/emp_assignment.dart';
import '../../../providers/employee/emp_assignment_from.dart';
import '../../../providers/employee/emp_contact_the_school.dart';
import '../../../providers/employee/emp_syllabus.dart';
import '../../../providers/employee/employee_appraisal_provider.dart';
import '../../../providers/employee/employee_by_category_provider.dart';
import '../../../providers/employee/employee_counter_provider.dart';
import '../../../providers/employee/employee_profile.dart';
import '../../../providers/employee/employee_task_provider.dart';
import '../../../providers/employee/pending_task_provider.dart';
import '../../../providers/employee/student_management.dart';
import '../../../providers/employee/teacher_mark_entry_provider.dart';
import '../../../providers/student/get_student_profile.dart';
import '../../../widgets/base64_image.dart';
import '../forgot_password/forgot_screen.dart';
import '../login/login_screen.dart';
import '../notification_screen/notification_screen.dart';
import 'switch_account.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool pushNotifications = true;
  bool fingerprint = true;
  String name = "";
  String img = "";
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    pushNotifications = box.read('pushNotifications') ?? true;
    fingerprint = box.read('fingerprint') ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    String loginType = auth.loginType;

    if(loginType != "Student"){
      final emp = Provider.of<EmployeeProfileProvider>(context, listen: false);
      name = emp.employeeBasic!.first.employeeName;
      img = emp.employeeBasic!.first.profileImage;
    }
    
    final profileData = Provider.of<StudentProfileProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: CustomColor.colorWhite,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CustomColor.colorWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1.w,
                ),
              ),
            ),
            child: loginType != "Student"
            ? Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: buildEmpProfileImage(
                      img
                    )
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              )
              :Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: buildProfileImage(
                    profileData.registrationDetails?.first.imgByte
                  )
                ),
                 SizedBox(width: 16.w),
                Text(
                  profileData.registrationDetails?.first.fname ?? '',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 20.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _buildMenuItem('Edit password', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotScreen()));
          }),
          _buildMenuItem('Notifications', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationScreen()));
          }),
          if (loginType == "Student")...[
          _buildMenuItem('Switch Account', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSwitcher()));
          }),
          ],

          _buildToggleItem(
            'Push notifications',
            pushNotifications,
                (value) {
              setState(() {
                pushNotifications = value;
              });
              box.write('pushNotifications', value);
            },
          ),

          _buildToggleItem(
            'Fingerprint',
            fingerprint,
                (value) {
              setState(() {
                fingerprint = value;
              });
              box.write('fingerprint', value);
            },
          ),
          SizedBox(height: 20.h),
          Divider(height: 1.h, color: Colors.grey[200],),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text(
          //       'More',
          //       style: TextStyle(
          //         fontSize: 16.sp,
          //         color: Colors.grey[400],
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),

          // _buildMenuItem('Us', () {}),
          // _buildMenuItem('Privacy Policy', () {}),

          _buildLogoutItem(auth),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style:  TextStyle(
                fontSize: 16.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 20.h,
            child: Transform.scale(
              scale: 0.7.r,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: CustomColor.colorWhite,
                activeTrackColor: CustomColor.primaryColor,
                inactiveThumbColor: CustomColor.colorWhite,
                inactiveTrackColor: Colors.grey[300],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutItem(AuthProvider auth) {
    return InkWell(
      onTap: () async {
      // Show confirmation dialog before logging out
      final shouldLogout = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Logout"),
            ),
          ],
        ),
      );

      if (shouldLogout != true) return;
      _clearAllProviders(context);
      // Perform logout
      auth.logOut(context);

      if (!mounted) return; 

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    },
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        child: Row(
          children: [
             Text(
              'Logout',
              style: TextStyle(
                fontSize: 16.sp,
                color: CustomColor.colorRed,
                fontWeight: FontWeight.w400,
              ),
            ),
             SizedBox(width: 8.w),
            Icon(
              Icons.logout,
              color: Colors.red[400],
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _clearAllProviders(BuildContext context) {
    Provider.of<TeacherMarkEntryProvider>(context, listen: false).clearAllMarkEntryData();
    Provider.of<EmployeeAppraisalProvider>(context, listen: false).clearAppraisalData();
    Provider.of<EmployeeTaskProvider>(context, listen: false).clearEmployeeList();
    Provider.of<EmployeeSyllabusProvider>(context, listen: false).clear();
    Provider.of<AssignmentListProvider>(context, listen: false).clearAssignment();
    Provider.of<AssignmentFormProvider>(context, listen: false).clearAssignmentProviderData();
    Provider.of<PendingTaskProvider>(context, listen: false).clearPendingTaskList();
    Provider.of<EmpContactToSchoolProvider>(context, listen: false).clearEmpContactToSchoolData();
    Provider.of<StudentManagementProvider>(context, listen: false).clearStudentManagementProvider();
    Provider.of<EmployeeCounterProvider>(context, listen: false).clearEmployeeCounterProvider();
    Provider.of<EmployeeByCategoryProvider>(context, listen: false).clearEmployeeByCategoryProvider();
  }
}
