// ignore_for_file: deprecated_member_use

import '../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../providers/employee/employee_profile.dart';
import '../../../providers/employee/leave_provider.dart';
import '../../../providers/student/get_session.dart';
// import '../widget/togglebutton.dart';
import '../widget/top_card.dart';
import 'widgets/bottom_shimmer.dart';
import 'widgets/buttom_summary_card.dart';
import 'widgets/calendar_loader.dart';
import 'widgets/leave_form.dart';
import 'widgets/leave_history_cards.dart';
import 'widgets/leave_summary_card.dart';
import 'widgets/summary_loader.dart';
import 'widgets/toggle_bar.dart';

class LeaveScreen extends StatefulWidget {
  final String empId;
  final String name;
  final String type;
  final String? image;
  const LeaveScreen(
  {
    super.key,
    required this.empId,
    required this.name,
    required this.type,
    required this.image
  });

  @override
  State<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends State<LeaveScreen>
    with SingleTickerProviderStateMixin {
  bool isSummarySelected = true;
  bool openForm = false;
  bool isSessionLoaded = false;

  /// ------------------------
  /// SESSION SELECTED YEARS
  /// ------------------------
  String selectedFromYear = "";
  String selectedToYear = "";

  @override
  void initState() {
    super.initState();

    widget.type == "EMP" ?
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      selectedFromYear = auth.loginData?.currentyearfrom ?? "";
      selectedToYear = auth.loginData?.currentyearto ?? "";
      sessionLoad(selectedFromYear,selectedToYear);
      _reloadAll();
    }) : WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      selectedFromYear = auth.loginData?.currentyearfrom ?? "";
      selectedToYear = auth.loginData?.currentyearto ?? "";
      _reloadAll();
    });
  }

  /// ------------------------
  /// LOAD ALL DATA
  /// ------------------------
  Future<void> _reloadAll() async {
    final leave = context.read<LeaveProvider>();
    leave.clearLeaveScreenData();

    await Future.wait([
      _loadSummary(),
      _loadCalendar(),
    ]);

    setState(() {});
  }

  /// ------------------------
  /// SESSION BASED RELOAD
  /// ------------------------
  Future<void> _reloadAllSessionedData(String from, String to) async {
    selectedFromYear = from;
    selectedToYear = to;

    final leave = context.read<LeaveProvider>();
    leave.clearLeaveScreenData();

    await Future.wait([
      _loadSummary(),
      _loadCalendar(),
    ]);

    setState(() {});
  }

  /// ------------------------
  /// LOAD SUMMARY BASED ON SESSION
  /// ------------------------
  Future<void> _loadSummary() async {
    final auth = context.read<AuthProvider>();
    final empId = widget.type == "EMP" ? widget.empId : auth.loginData?.empId;
    await context.read<LeaveProvider>().getEmployeeLeaveSummery(
          empId,
          selectedFromYear,
          selectedToYear,
        );
  }

  /// ------------------------
  /// LOAD CALENDAR BASED ON SESSION
  /// ------------------------
  Future<void> _loadCalendar() async {
    final auth = context.read<AuthProvider>();
    final empId = widget.type == "EMP" ? widget.empId : auth.loginData?.empId;

    await context.read<LeaveProvider>().getEmployeeLeaveHistory(
          empId,
          selectedFromYear,
          selectedToYear,
        );
  }


  Future<void> sessionLoad(String fYear, String tYear) async {
    final sessProvider = Provider.of<SessionProvider>(context, listen: false);
    sessProvider.selectedSession2 = null;
    await sessProvider.getSessionSecondary(widget.empId, fYear, tYear, "Emp");
    if (mounted) {
      setState(() {
        isSessionLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>();
    final auth = context.read<AuthProvider>();
    final empProvider = context.watch<EmployeeProfileProvider>();
    final leave = context.watch<LeaveProvider>();

    final empId = widget.type == "EMP"
      ? widget.empId
      : auth.loginData?.empId;


    final leavesList = leave.leaveSummary;
    final deductionList = leave.leaveDeductionSummary;
    final historyData = leave.leaveCalendarData;

    return Scaffold(
      backgroundColor: CustomColor.colorWhite,
      appBar: AppBar(
        title: Text("Leaves",
            style: TextStyle(color: CustomColor.colorWhite, fontSize: 20.sp)),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: CustomColor.colorWhite),
        ),
        backgroundColor: CustomColor.primaryColor,
        centerTitle: true,
      ),

      body: Column(
        children: [
          buildTopCard(
            (from, to) async => 
              await _reloadAllSessionedData(from, to),
            session, 
            empProvider, 
            empId!,
            widget.type,
            widget.image,
            true
          ),
          Expanded(
            child: openForm
            ? _buildApplyForm()
            : _buildMainContent(
                leavesList,
                deductionList,
                historyData,
                leave,
                empId,
              ),
          ),
        ],
      ),
    );
  }

  /// ------------------ MAIN CONTENT ------------------

  Widget _buildMainContent(leavesList, deductionList, historyData,
      LeaveProvider leave, String empId) {
    return Column(
      children: [
        _buildToggleBar(leave),
        SizedBox(height: 10.h),

        Expanded(
          child: isSummarySelected
              ? _buildSummarySection(leavesList, deductionList, leave)
              : _buildCalendarSection(historyData, leave),
        ),

        if (isSummarySelected) _buildApplyButton(empId),
      ],
    );
  }

  /// ---------------- TAB SWITCH HANDLER ----------------

  Widget _buildToggleBar(LeaveProvider leave) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(width: 1.5, color: CustomColor.primaryColor),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            buildToggleButton(
              label: "Leave Summary",
              isSelected: isSummarySelected,
              onTap: () => _switchTab(true, leave),
            ),
            buildToggleButton(
              label: "Leave Calendar",
              isSelected: !isSummarySelected,
              onTap: () => _switchTab(false, leave),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _switchTab(bool summary, LeaveProvider leave) async {
    if (summary == isSummarySelected) return;

    setState(() => isSummarySelected = summary);

    /// Reset + reload using selected session years
    leave.clearLeaveScreenData();

    summary ? await _loadSummary() : await _loadCalendar();
  }

  /// ---------------- SUMMARY TAB ----------------

  Widget _buildSummarySection(
      leavesList, deductionList, LeaveProvider leave) {
    if(leavesList.isEmpty && !leave.isSummaryLoading) {
      return Center(
        child: Text(
          "No Leave Summary Data Available",
          style: TextStyle(fontSize: 18.sp, color: CustomColor.colorGrey),
        ),
      );
    }
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount:
              leave.isSummaryLoading ? 6 : leavesList.length,
          gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.25,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (_, i) =>
              leave.isSummaryLoading
                  ? const LeaveCardShimmer()
                  : LeaveCardWidget(leave: leavesList[i]),
        ),

        leave.isSummaryLoading
            ? BottomShimmerCard()
            : BottomSummaryCard(
                bottomSummary: deductionList,
                leave: leave.leaveSummaryResponse,
              ),

        SizedBox(height: 20.h),
      ],
    );
  }

  /// ---------------- CALENDAR TAB ----------------

  Widget _buildCalendarSection(historyData, LeaveProvider leave) {
    return leave.isCalendarLoading
      ? LeaveCalendarShimmerWidget()
      : LeaveCalendarWidget(
        controller: leave,
        leaveCalendar: historyData,
        accessType: leave.userAccess
      );
  }

  /// ---------------- APPLY LEAVE BUTTON ----------------

  Widget _buildApplyButton(String empId) {
    final leave = context.read<LeaveProvider>();
    final auth = context.read<AuthProvider>();

    return GestureDetector(
      onTap: () {
        leave.getEmployeeLeaveTypeMaster(
          empId,
          auth.loginData!.currentyearfrom,
          auth.loginData!.currentyearto,
        );
        setState(() => openForm = true);
      },
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Container(
          height: 40.h,
          width: 200.w,
          decoration: BoxDecoration(
            color: CustomColor.primaryColor,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Center(
            child: Text("Apply Leave",
                style: TextStyle(
                    color: CustomColor.colorWhite,
                    fontSize: 16.sp)),
          ),
        ),
      ),
    );
  }

  /// ---------------- APPLY FORM ----------------

  Widget _buildApplyForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: LeaveApplyForm(
          onClosePressed: () => setState(() => openForm = false),
        ),
      ),
    );
  }
}
