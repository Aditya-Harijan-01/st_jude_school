import '../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../providers/employee/emp_assignment.dart';
import '../../../providers/employee/emp_assignment_from.dart';
import '../../../providers/employee/employee_profile.dart';
import '../../../providers/student/get_session.dart';
import '../widget/top_card.dart';
import 'widgets/add_homework_widget.dart';
import 'widgets/emp_homework_details.dart';
import 'widgets/homework_card.dart';
import 'widgets/loader/homework_card_shimmer.dart';
import 'widgets/loader/homework_shimmer.dart';


class EmployeeHomeworkScreen extends StatefulWidget {
  const EmployeeHomeworkScreen({super.key});

  @override
  State<EmployeeHomeworkScreen> createState() =>
      _EmployeeHomeworkScreenState();
}

class _EmployeeHomeworkScreenState extends State<EmployeeHomeworkScreen> {
  late AssignmentListProvider listProvider;
  late AssignmentFormProvider formProvider;

  // late EmployeeProfileProvider empProvider;
  late AuthProvider userProvider;

  String? empId;
  String? year;
  String? toYear;
  String? empName;

  String? selectedFrom;
  String? selectedTo;
  

  bool isSessionChanging = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      listProvider = context.read<AssignmentListProvider>();
      formProvider = context.read<AssignmentFormProvider>();

      final empProvider = context.read<EmployeeProfileProvider>();
      userProvider = context.read<AuthProvider>();

      empId = userProvider.loginData?.empId;
      year = userProvider.loginData?.currentyearfrom;
      toYear = userProvider.loginData?.currentyearto;
      empName = empProvider.employeeBasic!.first.employeeName;

      // Initialize provider data
      formProvider.empId = empId;
      formProvider.fromYear = year;
      formProvider.toYear = toYear;

      selectedFrom = year;
      selectedTo = toYear;

      listProvider.fetchAssignments(empId!, year!, toYear!);
    });
  }

  @override
  void dispose() {
    super.dispose();
    // listProvider = context.read<AssignmentListProvider>();
    // formProvider = context.read<AssignmentFormProvider>();

    formProvider.clearForm();

    formProvider.isAdding = false;
    formProvider.isEditMode = false;
    formProvider.isSubmitting = false;
    formProvider.isLoadingEditData = false;

    formProvider.isLoadingClasses = false;
    formProvider.isLoadingSubjects = false;
    formProvider.isLoadingBooks = false;
    formProvider.isLoadingChapters = false;
  }

  // -----------------------------------------
  // STATUS TOGGLE BUTTON
  // -----------------------------------------
  Widget _statusButton({
    required String title,
    required int status,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: 125.w,
        height: 35.h,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                color: selected ? CustomColor.primaryColor : Colors.grey.shade600,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 20.sp,
              color: selected ? CustomColor.primaryColor : Colors.grey.shade600,
            )
          ],
        ),
      ),
    );
  }

  // -----------------------------------------
  // SHIMMER LIST
  // -----------------------------------------
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80.h),
      itemCount: 5,
      itemBuilder: (_, index) => const HomeworkCardShimmer(),
    );
  }

  // -----------------------------------------
  // HOMEWORK LIST (provider version)
  // -----------------------------------------
  Widget _buildHomeworkList() {
    return Consumer2<AssignmentListProvider,AssignmentFormProvider>(
      builder: (_, provider,formProvider, __) {
        return RefreshIndicator(
          onRefresh: () => provider.refreshAssignments(empId!, year!, toYear!),
          child: ListView.builder(
            controller: provider.scrollController,
            padding: EdgeInsets.only(bottom: 80.h),
            itemCount: provider.assignmentList.length +
                (provider.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.assignmentList.length) {
                return HomeworkCardShimmer();
              }

              final homework = provider.assignmentList[index];

              return EmpHomeworkCard(
                publishDate: homework.assignmentDate,
                dueDate: homework.submissionDate,
                subject: homework.bookName,
                chapter: homework.chapterName,
                onView: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EmpAssignmentDetailsScreen(
                        data: homework, listProvider: provider, formProvider: formProvider,
                      ),
                    ),
                  );
                },
                editAssignment: () {
                  formProvider.openEditForm(
                    empId!,
                    homework.appSerial.toString(),
                    year,
                    toYear
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    userProvider = context.read<AuthProvider>();
    String emp = userProvider.loginData!.empId;
    final session = context.read<SessionProvider>();
    final empProvider = context.read<EmployeeProfileProvider>();
    return Consumer2<AssignmentListProvider, AssignmentFormProvider>(
      builder: (_, list, form, __) {
        return Scaffold(
          backgroundColor: Colors.grey.shade50,

          floatingActionButton: !form.isAdding
            ? FloatingActionButton(
              backgroundColor: CustomColor.primaryColor,
              onPressed: () {
                form.toggleForm();       
              },
              child: Icon(Icons.add_home_work_rounded, color: CustomColor.colorWhite),
            )
          : SizedBox.shrink(),

          appBar: AppBar(
            title: Text("Assignment",
              style: TextStyle(
                color: CustomColor.colorWhite, 
                fontSize: 20.sp
                )
              ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: CustomColor.colorWhite
              ),
            ),
            backgroundColor: CustomColor.primaryColor,
            centerTitle: true,
          ),

          body: Column(
            children: [

               buildTopCard(
                (from, to) async {
                  selectedFrom = from;
                  selectedTo = to;
                  list.refreshForNewSession(empId!, from, to);
                },                  
                session, 
                empProvider, 
                emp,
                "",
                "",
                true
              ),

              SizedBox(height: 5.h),

              // TOGGLE BAR
              if (!form.isAdding)
                Container(
                  padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusButton(
                        title: "Pending",
                        status: -1,
                        selected: list.currentStatus == -1,
                        onTap: () => list.switchStatus(-1, empId!, selectedFrom!, selectedTo!),
                      ),
                      Container(
                        height: 30.h,
                        width: 1.w,
                        color: Colors.grey.shade300,
                      ),
                      _statusButton(
                        title: "Submitted",
                        status: 1,
                        selected: list.currentStatus == 1,
                        onTap: () => list.switchStatus(1, empId!, selectedFrom!, selectedTo!),
                      ),
                    ],
                  ),
                ),

              // MAIN AREA
              Expanded(
                child: form.isAdding
                ? (!form.isLoadingEditData)
                  ? AddHomeworkWidget(
                    // formProvider: form,
                    empId: empId,
                    empName: empName,
                    year: year,
                    toYear: toYear,
                  )
                : AddHomeworkShimmerWidget()
              : list.isLoading && list.assignmentList.isEmpty
                ? _buildShimmerList()
                : list.assignmentList.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_outlined,
                          size: 80.h, 
                          color: Colors.grey.shade400
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          list.currentStatus == -1
                            ? "No pending assignments found"
                            : "No completed assignments found",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildHomeworkList(),
              )
            ],
          ),
        );
      },
    );
  }
}
