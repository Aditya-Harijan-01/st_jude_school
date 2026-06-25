// ignore_for_file: deprecated_member_use

import '../../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../constants/colors.dart';
import '../../../../providers/employee/leave_provider.dart';
import '../../../../models/employee/leave_type_response.dart';

class LeaveApplyForm extends StatefulWidget {
  final VoidCallback onClosePressed;

  const LeaveApplyForm({
    super.key,
    required this.onClosePressed,
  });

  @override
  State<LeaveApplyForm> createState() => _LeaveApplyFormState();
}

class _LeaveApplyFormState extends State<LeaveApplyForm> {
  DateTime? leaveFrom;
  DateTime? leaveTo;
  LeaveType? selectedLeaveType;

  bool isLeaveTypeLoading = false;
  bool isLeaveToLoading = false;

  final reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    final types = provider.leaveType;
    final empId = provider.leaveSummaryResponse?.empId;
    final fromYear = auth.loginData!.currentyearfrom;
    final toYear = auth.loginData!.currentyearto;
    final totalBalance = provider.leaveSummaryResponse?.totalBalanceLeave;

    final bool canApply =
      leaveTo != null &&
      selectedLeaveType != null &&
      leaveFrom != null &&
      reasonController.text.trim().isNotEmpty;

    return Container(
      height: 600.h,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: CustomColor.primaryColor.withOpacity(0.6),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ---------------- HEADER ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Apply For Leave",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: CustomColor.colorBlack,
                ),
              ),
              InkWell(
                onTap: widget.onClosePressed,
                borderRadius: BorderRadius.circular(20.r),
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(Icons.close_rounded, size: 24.sp),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          /// ---------------- LEAVE FROM ----------------
          _label("Leave From"),
          SizedBox(height: 6.h),
          _dateField(
            leaveFrom,
            onPick: (date) {
              setState(() {
                leaveFrom = date;
                leaveTo = null;
                selectedLeaveType = null;
                provider.applyLeaveCalendarResponse = null;
              });
            },
          ),

          SizedBox(height: 14.h),

          /// ---------------- LEAVE TYPE ----------------
          _label("Leave Type"),
          SizedBox(height: 6.h),
          _leaveTypeDropdown(
            types,
            provider,
            empId,
            fromYear,
            toYear,
            totalBalance,
          ),

          SizedBox(height: 14.h),

          /// ---------------- LEAVE TO ----------------
          _label("Leave To"),
          SizedBox(height: 6.h),
          _leaveToDate(provider, fromYear, toYear),

          SizedBox(height: 14.h),

          /// ---------------- REASON ----------------
          _label("Reason"),
          SizedBox(height: 6.h),
          _reasonField(),

          const Spacer(),

          /// ---------------- BUTTONS ----------------
          Row(
            children: [
              Expanded(
                child: _button(
                  "Clear",
                  CustomColor.colorButton,
                  Icons.clear,
                  () => clearForm(provider),
                ),
              ),
              SizedBox(width: 12.w),

              

              Expanded(
                child: _button(
                  "Apply",
                  canApply
                      ? CustomColor.primaryColor
                      : CustomColor.colorGrey.withOpacity(0.6),
                  Icons.send,
                  () {
                    if (canApply) {
                      submit(provider, empId, fromYear, toYear);
                    } else {
                      showFillFormPopup(context);
                    }
                  },
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  /// ---------------- LABEL ----------------
  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: CustomColor.colorGrey,
      ),
    );
  }

  /// ---------------- DATE FIELD ----------------
  Widget _dateField(DateTime? d, {required Function(DateTime) onPick}) {
    return InkWell(
      onTap: () async {
        final pick = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pick != null) onPick(pick);
      },
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: _box(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              d == null
                  ? "dd / mm / yyyy"
                  : DateFormat("dd/MM/yyyy").format(d),
              style: TextStyle(
                fontSize: 14.sp,
                color: d == null
                    ? CustomColor.colorGrey
                    : CustomColor.colorBlack,
              ),
            ),
            Icon(Icons.calendar_month,
                size: 20.sp, color: CustomColor.colorGrey),
          ],
        ),
      ),
    );
  }

  /// ---------------- LEAVE TYPE DROPDOWN ----------------
  Widget _leaveTypeDropdown(
    List<LeaveType>? types,
    LeaveProvider provider,
    empId,
    fromYear,
    toYear,
    totalBalance,
  ) {
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: _box(),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<LeaveType>(
          isExpanded: true,
          value: selectedLeaveType,
          hint: Text(
            "Select Leave Type",
            style: TextStyle(
              fontSize: 14.sp,
              color: CustomColor.colorGrey,
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          items: types?.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(
                e.leaveName,
                style: TextStyle(fontSize: 14.sp),
              ),
            );
          }).toList(),
          onChanged: (val) async {
            if (leaveFrom == null) {
              _toast("Select Leave From first");
              return;
            }

            setState(() => isLeaveTypeLoading = true);

            await provider.verifyEmployeeLeaveRequest(
              empId,
              fromYear,
              toYear,
              val?.leaveId,
              DateFormat("dd/MM/yyyy").format(leaveFrom!),
              totalBalance,
            );

            setState(() {
              selectedLeaveType = val;
              isLeaveTypeLoading = false;
              leaveTo = null;
              provider.applyLeaveCalendarResponse = null;
            });
          },
        ),
      ),
    );
  }

  /// ---------------- LEAVE TO DATE ----------------
  Widget _leaveToDate(
    LeaveProvider provider,
    String fromyear,
    String toyear,
  ) {
    return InkWell(
      onTap: () async {
        if (leaveFrom == null || selectedLeaveType == null) {
          _toast("Select Leave From & Type");
          return;
        }

        final range = provider.leaveFromTo;
        if (range == null) {
          _toast("Invalid date range");
          return;
        }

        // 🔒 SAFETY CHECK (REQUIRED)
        if (range.endDate.isBefore(range.startDate)) {
          _toast("No valid leave dates available");
          return;
        }

        setState(() => isLeaveToLoading = true);

        final pick = await showDatePicker(
          context: context,
          initialDate: range.startDate,
          firstDate: range.startDate,
          lastDate: range.endDate,
        );

        if (pick != null) {
          leaveTo = pick;

          await provider.getRequestedLeaveDescription(
            provider.leaveSummaryResponse?.empId,
            fromyear,
            toyear,
            selectedLeaveType?.leaveId,
            DateFormat("dd/MM/yyyy").format(leaveFrom!),
            DateFormat("dd/MM/yyyy").format(pick),
          );
        }

        setState(() => isLeaveToLoading = false);
      },
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: _box(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leaveTo == null
                  ? "dd / mm / yyyy"
                  : DateFormat("dd/MM/yyyy").format(leaveTo!),
              style: TextStyle(
                fontSize: 14.sp,
                color: leaveTo == null
                    ? CustomColor.colorGrey
                    : CustomColor.colorBlack,
              ),
            ),
            isLeaveToLoading
                ? SizedBox(
                    height: 18.h,
                    width: 18.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.calendar_month,
                    size: 20.sp, color: CustomColor.colorGrey),
          ],
        ),
      ),
    );
  }

  /// ---------------- REASON ----------------
  Widget _reasonField() {
    return Container(
      height: 120.h,
      padding: EdgeInsets.all(12.w),
      decoration: _box(),
      child: TextField(
        controller: reasonController,
        maxLines: null,
        style: TextStyle(fontSize: 14.sp),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Enter your reason...",
        ),
      ),
    );
  }

  /// ---------------- BUTTON ----------------
  Widget _button(
    String text,
    Color color,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: CustomColor.colorWhite, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              text,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: CustomColor.colorWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------------- BOX ----------------
  BoxDecoration _box() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(
        color: CustomColor.primaryColor.withOpacity(0.6),
      ),
    );
  }

  /// ---------------- TOAST ----------------
  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  /// ---------------- CLEAR ----------------
  void clearForm(LeaveProvider provider) {
    setState(() {
      leaveFrom = null;
      leaveTo = null;
      selectedLeaveType = null;
      reasonController.clear();
      provider.applyLeaveCalendarResponse = null;
    });
  }


  void showFillFormPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: CustomColor.colorRed),
                SizedBox(width: 8.w),
                Text("Incomplete Form"),
              ],
            ),
          ],
        ),
        content: const Text("Please fill all required fields before applying."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// ---------------- SUBMIT ----------------
  Future<void> submit(
    LeaveProvider provider,
    empId,
    fromYear,
    toYear,
  ) async {
    if (leaveFrom == null) return _toast("Select Leave From");
    if (selectedLeaveType == null) return _toast("Select Leave Type");
    if (leaveTo == null) return _toast("Select Leave To");
    if (reasonController.text.trim().isEmpty) {
      return _toast("Enter a reason");
    }

    final desc = provider.applyLeaveCalendarResponse?.leaveDescription;
    if (desc == null || desc.isEmpty) return _toast("Invalid leave selection");

    final success = await provider.employeeLeaveApply(
      empId,
      fromYear,
      toYear,
      DateFormat("d d/MM/yyyy").format(leaveFrom!),
      DateFormat("dd/MM/yyyy").format(leaveTo!),
      reasonController.text.trim(),
      desc,
    );

    if (success) {
      _successDialog();
      leaveFrom = null;
      leaveTo = null;
      selectedLeaveType = null;
      reasonController.clear();
      widget.onClosePressed();
    }
  }

  /// ---------------- SUCCESS ----------------
  void _successDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: const Text("Success"),
        content: const Text("Leave Applied Successfully!"),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
}



