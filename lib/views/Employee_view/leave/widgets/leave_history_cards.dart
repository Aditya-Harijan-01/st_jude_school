// ignore_for_file: deprecated_member_use

import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/leave_calander.dart';
import '../../../../providers/employee/leave_provider.dart';


class LeaveCalendarWidget extends StatefulWidget {
  const LeaveCalendarWidget({
    super.key,
    required this.controller,
    required this.leaveCalendar,
    required this.accessType,
  });

  final LeaveProvider controller;
  final List<LeaveCalendarData>? leaveCalendar;
  final int accessType;

  @override
  State<LeaveCalendarWidget> createState() => _LeaveCalendarWidgetState();
}

class _LeaveCalendarWidgetState extends State<LeaveCalendarWidget> {
  final Map<String, bool> switchStates = {};
  List<_GroupedLeave> _grouped = [];

  @override
  void initState() {
    super.initState();
    _grouped = _groupLeaves(widget.leaveCalendar ?? []);
    _initializeSwitchStates(_grouped);
  }

  @override
  void didUpdateWidget(covariant LeaveCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leaveCalendar != widget.leaveCalendar) {
      _grouped = _groupLeaves(widget.leaveCalendar ?? []);
      _initializeSwitchStates(_grouped);
    }
  }

  void _initializeSwitchStates(List<_GroupedLeave> groups) {
    switchStates.clear();
    for (final g in groups) {
      for (final d in g.details) {
        final key = _detailKey(g.groupKey, d.leaveDate);
        switchStates[key] = d.stname.toLowerCase() == "cancelled"
            ? false
            : true;
      }
    }
  }

  String _detailKey(String groupKey, String date) => '${groupKey}_$date';

  bool _isSwitchDisabled(dynamic detail, permission, String status) {
    final userAccess = widget.accessType;

    if (userAccess == 1 || status.toLowerCase() == "cancelled") {
      return true;
    } else if (userAccess == 0 && permission == "0") {
      return false;
    }
    return true;
  }

  Color _getSwitchColor(bool isActive, bool isDisabled) {
    if (isDisabled) {
      return isActive ? CustomColor.primaryColor : Colors.grey.shade400;
    }
    return isActive ? CustomColor.primaryColor : Colors.grey.shade400;
  }

  @override
  Widget build(BuildContext context) {
    if (_grouped.isEmpty) {
      return Center(
        child: Text(
          "No Leave History Found",
          style: TextStyle(fontSize: 18.sp, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _grouped.length,
      itemBuilder: (context, index) {
        final group = _grouped[index];

        return  Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- GROUP HEADER ----------
              Padding(
                padding: EdgeInsets.all(14.w),
                child:                     
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.event_note,
                              color: CustomColor.primaryColor, size: 20.sp),
                            SizedBox(width: 10.w),
                            Row(
                              children: [
                                Text(
                                  group.leaveFrom,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  group.leaveTo,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color:
                                CustomColor.primaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            group.reason,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: CustomColor.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),

              Divider(color: Colors.grey.shade200),

              // ---------- DETAILS ----------
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  children: [
                    _tableHeader(),
                    SizedBox(height: 6.h),

                    ...group.details.map((detail) {
                      final key =
                          _detailKey(group.groupKey, detail.leaveDate);
                      final isActive = switchStates[key] ?? true;
                      final isDisabled = _isSwitchDisabled(
                          detail, detail.permission, detail.stname);

                      return _leaveRow(
                        detail: detail,
                        isActive: isActive,
                        isDisabled: isDisabled,
                        onToggle: () {
                          setState(() {
                            switchStates[key] = !isActive;
                          });

                          widget.controller.cancelEmployeeLeave(
                            widget.controller.empID,
                            detail.leaveId,
                            detail.leaveDate,
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),

              SizedBox(height: 12.h),
            ],
          ),
        );
      },
    );
  }


  Widget _tableHeader() {
    return Row(
      children: [
        _headerCell("Date"),
        _headerCell("Type"),
        _headerCell("Status"),
        _headerCell("Active", flex: 1),
      ],
    );
  }


  Widget _leaveRow({
    required LeaveHistoryDetail detail,
    required bool isActive,
    required bool isDisabled,
    required VoidCallback onToggle,
  }) {
    final statusColor = detail.stname.toLowerCase() == "cancelled"
        ? Colors.red
        : detail.stname.toLowerCase() == "approved"
            ? Colors.green
            : Colors.orange;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _dataCell(detail.leaveDate),
          _dataCell(detail.leaveName),
          _dataCell(detail.stname, color: statusColor),

          // SWITCH
          Expanded(
            flex: 1,
            child: Center(
              child: SwitchTheme(
                data: SwitchThemeData(
                  thumbColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.white;
                  }),
                  trackColor: MaterialStateProperty.resolveWith((states) {
                    final isDisabled = states.contains(MaterialState.disabled);
                    return _getSwitchColor(isActive, isDisabled);
                  }),
                ),
                child: Switch(
                  value: isActive,
                  onChanged: isDisabled ? null : (_) => onToggle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _headerCell(String title, {int flex = 2}) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _dataCell(String text, {Color color = Colors.black87}) {
    return Expanded(
      flex: 2,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13.sp, color: color),
      ),
    );
  }
}

class _GroupedLeave {
  _GroupedLeave({
    required this.groupKey,
    required this.leaveFrom,
    required this.leaveTo,
    required this.reason,
    required this.details,
  });

  final String groupKey;
  final String leaveFrom;
  final String leaveTo;
  final String reason;
  final List<LeaveHistoryDetail> details;
}

/// GROUPING LOGIC (unchanged)
List<_GroupedLeave> _groupLeaves(List<LeaveCalendarData> items) {
  final map = LinkedHashMap<String, _GroupedLeave>();
  final seenPerGroup = <String, Set<String>>{};

  for (final leave in items) {
    final key = leave.leaveId?.toString() ??
        '${leave.leaveFrom}_${leave.leaveTo}';

    final group = map.putIfAbsent(
      key,
      () => _GroupedLeave(
        groupKey: key,
        leaveFrom: leave.leaveFrom,
        leaveTo: leave.leaveTo,
        reason: leave.reason,
        details: <LeaveHistoryDetail>[],
      ),
    );

    final seen = seenPerGroup.putIfAbsent(key, () => <String>{});

    for (final d in leave.leaveHistoryDetails) {
      final dk = '${d.leaveDate}|${d.leaveName}|${d.stname}|${d.id}';
      if (seen.add(dk)) {
        group.details.add(d);
      }
    }
  }

  final groups = map.values.toList();

  groups.sort((a, b) {
    try {
      return DateTime.parse(b.leaveFrom)
          .compareTo(DateTime.parse(a.leaveFrom));
    } catch (_) {
      return b.leaveFrom.compareTo(a.leaveFrom);
    }
  });

  for (final group in groups) {
    group.details.sort((a, b) {
      try {
        return DateTime.parse(b.leaveDate)
            .compareTo(DateTime.parse(a.leaveDate));
      } catch (_) {
        return b.leaveDate.compareTo(a.leaveDate);
      }
    });
  }

  return groups;
}
