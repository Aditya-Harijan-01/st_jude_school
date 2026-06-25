
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';
import '../../../../models/employee/leave_model.dart';

class BottomSummaryCard extends StatelessWidget {
  final List bottomSummary;
  final LeaveSummaryResponse? leave;

  const BottomSummaryCard({
    super.key,
    required this.bottomSummary,
    required this.leave,
  });

  @override
  Widget build(BuildContext context) {
    final late = bottomSummary.first.lateDetails.first;
    final early = bottomSummary.first.earlyDetails.first;
    final isLeaveDeductionEmpty = leave?.leaveDeductionSummary.isEmpty ?? true;
    final isleaveSummaryEmpty = leave?.leaveSummary.isEmpty ?? true;

    if (isLeaveDeductionEmpty || isleaveSummaryEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      // width: 92.,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorBlack.withOpacity(0.06),
            blurRadius: 10.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // ---------------- HEADER ----------------
          Container(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: CustomColor.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r),
              ),
            ),
            child: _headerRow(),
          ),

          _rowDivider(),

          // ---------------- LATE ----------------
          _dataRow(
            type: "Late",
            count: late.totalLate.toString(),
            leave: late.inLeave.toString(),
            dates: late.lateDates.toString(),
          ),

          _rowDivider(),

          // ---------------- EARLY ----------------
          _dataRow(
            type: "Early",
            count: early.totalEarly.toString(),
            leave: early.inLeave.toString(),
            dates: early.earlyDates.toString(),
          ),

          // ---------------- BALANCE ----------------
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: CustomColor.primaryColor.withOpacity(0.06),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18.r),
                bottomRight: Radius.circular(18.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Balance Leave",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  leave?.totalBalanceLeave.toString() ?? "0",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= HEADER ROW =================
  Widget _headerRow() {
    return Row(
      children: const [
        _HeaderCell("Type", flex: 2),
        _HeaderCell("Count", flex: 2),
        _HeaderCell("In Leave", flex: 3),
        _HeaderCell("Dates", flex: 5),
      ],
    );
  }

  // ================= DATA ROW =================
  Widget _dataRow({
    required String type,
    required String count,
    required String leave,
    required String dates,
  }) {
    final parsedDates = _parseDates(dates);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ValueCell(type, flex: 2, bold: true),
          _ValueCell(count, flex: 2),
          _ValueCell(leave, flex: 2),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: parsedDates.map((date) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 4.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 6,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          date,
                          style: TextStyle(
                            fontSize: 12.sp
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================
  List<String> _parseDates(String dateString) {
    if (dateString.isEmpty || dateString == 'null') {
      return ['No dates'];
    }

    final dates = dateString
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty && e != 'null')
        .toList();

    return dates.isEmpty ? ['No dates'] : dates;
  }

  Widget _rowDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade200,
    );
  }
}

// ================= SMALL COMPONENTS =================
class _HeaderCell extends StatelessWidget {
  final String text;
  final int flex;

  const _HeaderCell(this.text, {required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ValueCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool bold;

  const _ValueCell(
    this.text, {
    required this.flex,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
