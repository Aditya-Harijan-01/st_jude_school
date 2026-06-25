// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'constants/firebase_services.dart';
import 'firebase_options.dart';
import 'providers/auth_provider/auth_provider.dart';
import 'providers/common/common_menu.dart';
import 'providers/common/notification_provider.dart';
import 'providers/employee/emp_assignment.dart';
import 'providers/employee/emp_assignment_from.dart';
import 'providers/employee/emp_attendance_monthwise.dart';
import 'providers/employee/emp_attendance_summary_provider.dart';
import 'providers/employee/emp_communication.dart';
import 'providers/employee/emp_compensation.dart';
import 'providers/employee/emp_contact_the_school.dart';
import 'providers/employee/emp_dashboard.dart';
import 'providers/employee/emp_student_attendance.dart';
import 'providers/employee/emp_syllabus.dart';
import 'providers/employee/emp_time_table.dart';
import 'providers/employee/employee_appraisal_provider.dart';
import 'providers/employee/employee_counter_provider.dart';
import 'providers/employee/employee_dashboard_provider.dart';
import 'providers/employee/employee_profile.dart';
import 'providers/employee/leave_provider.dart';
import 'providers/employee/student_management.dart';
import 'providers/student/acedemic_calandar.dart';
import 'providers/student/admit_card_provider.dart';
import 'providers/student/contact_to_school.dart';
import 'providers/student/dashboard_notification.dart';
import 'providers/student/fee_structure_provider.dart';
import 'providers/student/gallery_provider.dart';
import 'providers/student/get_assignment.dart';
import 'providers/student/get_session.dart';
import 'providers/student/get_student_profile.dart';
import 'providers/student/hostel_provider.dart';
import 'providers/student/library_details.dart';
import 'providers/student/syllabuss.dart';
import 'providers/student/student_attendance_summary_provider.dart';
import 'providers/student/student_dashboard_provider.dart';
import 'providers/student/student_monthly_attendance_detail_provider.dart';
import 'providers/student/students_analysis_by_examination_provider.dart';
import 'providers/student/students_report_cards_provider.dart';
import 'providers/student/timetable.dart';
import 'providers/student/transport_provider.dart';
import 'providers/employee/teacher_mark_entry_provider.dart';
import 'providers/employee/employee_task_provider.dart';
import 'providers/employee/pending_task_provider.dart';
import 'providers/employee/employee_by_category_provider.dart';
import 'providers/employee/other_employee_profile_provider.dart';
import 'providers/common/multi_user_provider.dart';
import 'providers/employee/remark_entry_provider.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await GetStorage.init('accounts');
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CommonMenuProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StudentProfileProvider()),
        ChangeNotifierProvider(create: (_) => LibraryDetailsProvider()),
        ChangeNotifierProvider(create: (_) => SubjectSyllabusProvider()),
        ChangeNotifierProvider(create: (_) => DashboardNotificationProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => StudentAssignmentProvider()),
        ChangeNotifierProvider(create: (_) => AcedemicCalandarProvider()),
        ChangeNotifierProvider(create: (_) => TransportProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
        ChangeNotifierProvider(create: (_) => ContactToSchoolProvider()),
        ChangeNotifierProvider(create: (_) => FeeStructureProvider()),
        ChangeNotifierProvider(create: (_) => AdmitCardProvider()),
        ChangeNotifierProvider(create: (_) => AdmitCardProvider()),
        ChangeNotifierProvider(create: (_) => TimetableProvider()),
        ChangeNotifierProvider(create: (_) => StudentAttendanceSummaryProvider()),
        ChangeNotifierProvider(create: (_) => StudentMonthlyAttendanceDetailProvider()),
        ChangeNotifierProvider(create: (_) => StudentsReportCardsProvider()),
        ChangeNotifierProvider(create: (_) => StudentsAnalysisByExaminationProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeAttendanceSummaryProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeMonthlyAttendanceDetailProvider()),
        ChangeNotifierProvider(create: (_) => StudentDashboardProvider()),

        //-----------------Employee-Providers------------------//
        ChangeNotifierProvider(create: (_) => EmployeeProfileProvider()),
        ChangeNotifierProvider(create: (_) => TeacherMarkEntryProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeAppraisalProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeTaskProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeSyllabusProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentListProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentFormProvider()),
        ChangeNotifierProvider(create: (_) => PendingTaskProvider()),
        ChangeNotifierProvider(create: (_) => EmpContactToSchoolProvider()),
        ChangeNotifierProvider(create: (_) => StudentManagementProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeCounterProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeByCategoryProvider()),
        ChangeNotifierProvider(create: (_) => OtherEmployeeProfileProvider()),
        ChangeNotifierProvider(create: (_) => EmpCompensationProvider()),
        ChangeNotifierProvider(create: (_) => EmpStudentAttendenceProvider()),
        ChangeNotifierProvider(create: (_) => EmpCommunicationProvider()),
        ChangeNotifierProvider(create: (_) => MultiUserProvider()),
        ChangeNotifierProvider(create: (_) => EmpTimetableProvider()),
        ChangeNotifierProvider(create: (_) => EmpDashBoardProvider()),
        ChangeNotifierProvider(create: (_) => EmpDashboardProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => RemarkEntryProvider()),
        ChangeNotifierProvider(create: (_) => HostelProvider()),
      ],
      child: const MyApp(),
    ),
  );

  unawaited(_initializeBackgroundServices());
}

Future<void> _initializeBackgroundServices() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseApi().initNotifications();
  } catch (e, st) {
    log('Firebase initialization error: $e', stackTrace: st);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit( 
      designSize: const Size(424, 941),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: "Ednect",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.green),
          home: const SplashScreen(),

          builder: (context, child) {
            return UpgradeAlert(
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
                    return false; // 🚫 block back when force update
                  }
                  return true;
                },
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}



