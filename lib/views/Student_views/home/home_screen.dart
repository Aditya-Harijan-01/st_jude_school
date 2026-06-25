import 'package:st_jude_school/providers/employee/emp_dashboard.dart';
import 'package:st_jude_school/views/Employee_view/employee_management/emp_management_screen.dart';
import 'package:st_jude_school/views/Employee_view/compensation/compensation_screen.dart';
import 'package:st_jude_school/views/Employee_view/leave/leave_screen.dart';
import 'package:st_jude_school/views/Employee_view/mark_entry/mark_entry_screen.dart';
import 'package:st_jude_school/views/Employee_view/student_attadence/student_attandence.dart';
import 'package:st_jude_school/views/Employee_view/syllabus/emp_syllabus.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/common/common_menu.dart';
import 'package:st_jude_school/providers/employee/employee_profile.dart';
import 'package:st_jude_school/providers/student/dashboard_notification.dart';
import 'package:st_jude_school/views/Student_views/albums/albums_main_screen.dart';
import 'package:st_jude_school/views/Student_views/assessments/assessment_screen.dart';
import 'package:st_jude_school/views/Student_views/contact_to_school/contact_to_school.dart';
import 'package:st_jude_school/views/Student_views/home/emp_widget/emp_header.dart';
import 'package:st_jude_school/views/Student_views/home/widgets/main_content_student.dart';
import 'package:st_jude_school/views/Student_views/notification_screen/notification_screen.dart';
import 'package:st_jude_school/views/Student_views/payment/payment.dart';
import 'package:st_jude_school/views/Student_views/setting/setting_screen.dart';
import 'package:st_jude_school/views/Student_views/syllabus/syllabus.dart';
import 'package:st_jude_school/views/Student_views/timetable/timetable.dart';
import 'package:st_jude_school/views/Student_views/admit_card/admit_card.dart';
import 'package:st_jude_school/views/Student_views/library/library.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import '../../Employee_view/albums/albums_main_screen.dart';
import '../../Employee_view/appraisal/appraisal_screen.dart';
import '../../Employee_view/attendance/attendance_record_screen.dart';
import '../../Employee_view/calendar/calendar_emp.dart';
import '../../Employee_view/communication/emp_communication.dart';
import '../../Employee_view/contact_the_school/emp_contact_the_school.dart';
import '../../Employee_view/homework/homework_screen.dart';
import '../../Employee_view/library_emp/library.dart';
import '../../Employee_view/remark_entry/remark_entry_sreen.dart';
import '../../Employee_view/students_management/students_manage_screen.dart';
import '../../Employee_view/task/task_screen.dart';
import '../../../constants/colors.dart';
import '../../../models/common_menu_model.dart';
import '../../../providers/student/get_session.dart';
import '../../../providers/student/get_student_profile.dart';
import '../../Employee_view/time_table/time_table.dart';
import '../Homework/screens/academic_screen.dart';
import '../attendance/attendance_record_screen.dart';
import '../calendar/calendar.dart';
import '../hostel/hostel_payment_screen.dart';
import '../transport/transport.dart';
import 'widgets/home_header.dart';
import 'widgets/menu_grid.dart';

class HomeScreen extends StatefulWidget {
  final List<StudentMenuItem>? menuItems;

  const HomeScreen({super.key, required this.menuItems});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMenuOpen = false;
  int selectedDayIndex = () {
    final now = DateTime.now();
    final year = now.month >= 4 ? now.year : now.year - 1;
    final startOfYear = DateTime(year, 4, 1);
    return now.difference(startOfYear).inDays;
  }();
  final box = GetStorage();
  String? userID;
  String? fromYear;
  String? toYear;
  String? userType;
  String? empID;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStudentProfile();
    });
  }

  Future<void> _fetchStudentProfile() async {
    final sessProvider = Provider.of<SessionProvider>(context, listen: false);
    final dashProvider = Provider.of<DashboardNotificationProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    userID = authProvider.loginData!.regno;
    empID = authProvider.loginData!.empId;
    fromYear = authProvider.loginData!.currentyearfrom;
    toYear = authProvider.loginData!.currentyearto;
    userType = authProvider.loginType;

    if (userType == "Student") {
      final provider = Provider.of<StudentProfileProvider>(
        context,
        listen: false,
      );
      debugPrint(
        "Fetching data for userID: $userID, year: $fromYear-$toYear, type: $userType",
      );
      provider.clearStudentProfileData();
      await sessProvider.getSession(userID, fromYear, toYear, userType);
      await dashProvider.dashboardNotification(userID, fromYear, toYear);
      await provider.getStudentProfile(userType, userID, fromYear, toYear);
    } else {
      final empDash = Provider.of<EmpDashBoardProvider>(context, listen: false);
      final empProvider = Provider.of<EmployeeProfileProvider>(
        context,
        listen: false,
      );
      debugPrint(
        "Fetching data for userID: $empID, year: $fromYear-$toYear, type: $userType",
      );
      empDash.fetchEmpDashBoard(empID!, fromYear!, toYear!);
      empProvider.clearEmployeeProfileData();
      await sessProvider.getSession(empID, fromYear, toYear, userType);
      await empProvider.getEmployeeProfile(empID);
    }
  }

  void toggleMenu() {
    setState(() => isMenuOpen = !isMenuOpen);
  }

  void _navigateToScreen(String screenName) {
    switch (screenName) {
      case "M1":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AcademicScreen()),
        );
        break;

      case "M2":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AttendanceRecordScreen()),
        );
        break;

      case "M3":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AssessmentScreen()),
        );
        break;

      case "M4":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const ContactToSchoolScreen(regNo: ''),
          ),
        );
        break;

      case "M5":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MainCalendarScreen()),
        );
        break;

      case "M6":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PaymentScreen()),
        );
        break;

      case "M7":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransportScreen()),
        );
        break;

      case "M8":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AlbumsMainScreen()),
        );
        break;

      case "M9":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LibraryScreen()),
        );
        break;

      case "M10":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TimetableScreen()),
        );
        break;

      case "M11":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SyllabusScreen()),
        );
        break;

      case "M12":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdmitCardScreen()),
        );
        break;

      case "M13":
        break;

      case "M14":
        // Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
        break;

      case "M15":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        );
        break;

      case "M16":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
        break;

      case "M17":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HostelPaymentScreen()),
        );
        break;

      case "E1":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeHomeworkScreen()),
        );
        break;

      case "E2":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AttendanceRecordScreenEmp()),
        );
        break;

      case "E3":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MarkEntryScreen()),
        );
        break;

      case "E4":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmpContactToSchoolScreen()),
        );
        break;

      case "E5":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmpCalendarScreen()),
        );
        break;

      case "E6":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LeaveScreen(empId: '', name: '', type: '', image: ''),
          ),
        );
        break;

      case "E7":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmpCompensationScreen()),
        );
        break;

      case "E8":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AlbumsMainScreenEmp()),
        );
        break;

      case "E9":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmpStudentAttandenceScreen()),
        );
        break;

      case "E10":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TimetableScreenEmployee()),
        );
        break;

      case "E12":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaskScreen()),
        );
        break;

      case "E13":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const StudentsManageScreen()),
        );
        break;

      case "E14":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeManagementScreen()),
        );
        break;

      case "E15":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmpCommunicationlScreen()),
        );
        break;

      case "E11":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EmployeeSyllabusScreen()),
        );
        break;

      case "E16":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LibraryScreenEmp()),
        );
        break;

      case "E17":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AppraisalScreen()),
        );
        break;

      case "E18":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
        break;

      case "E19":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RemarkEntrySreen()),
        );
        break;
    }
  }

  void _onDaySelected(int index) {
    setState(() => selectedDayIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProfileProvider>(context);
    final empProvider = Provider.of<EmployeeProfileProvider>(context);
    final comModel = Provider.of<CommonMenuProvider>(context);

    final empData = empProvider.employeeBasic;
    final office = empProvider.employeeOffice;
    final empAllData = empProvider.employeeDataResponse;
    final academicData = provider.academicDetails;
    final regData = provider.registrationDetails;
    final allData = provider.profileOne;

    return Scaffold(
      backgroundColor: CustomColor.primaryColor,
      body: Column(
        children: [
          SafeArea(
            child: userType == "Student"
                ? HomeHeader(
                    isMenuOpen: isMenuOpen,
                    onMenuToggle: toggleMenu,
                    profile: academicData,
                    regData: regData,
                    allData: allData,
                  )
                : EmpHomeHeader(
                    isMenuOpen: isMenuOpen,
                    onMenuToggle: toggleMenu,
                    profile: office,
                    empData: empData,
                    allData: empAllData,
                  ),
          ),
          Expanded(
            child: isMenuOpen
                ? MenuGrid(
                    menuItems: comModel.studentMenu,
                    onMenuItemTap: _navigateToScreen,
                  )
                : MainContentStudent(
                    selectedDayIndex: selectedDayIndex,
                    onDaySelected: _onDaySelected,
                    userType: userType,
                  ),
          ),
        ],
      ),
    );
  }
}
