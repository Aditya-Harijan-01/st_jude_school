class LeaveCalendarResponse {
  final String statusCode;
  final List<LeaveCalendarData> data;

  LeaveCalendarResponse({
    required this.statusCode,
    required this.data,
  });

  factory LeaveCalendarResponse.fromJson(Map<String, dynamic> json) {
    return LeaveCalendarResponse(
      statusCode: json['statusCode'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => LeaveCalendarData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveCalendarData {
  final String leaveId;
  final String leaveType;
  final String leaveName;
  final String leaveMainId;
  final String id;
  final String leaveFrom;
  final String leaveTo;
  final String reason;
  final String pendingLeave;
  final String activeLeave;
  final String cancelledLeave;
  final String extra;
  final String startDate;
  final String endDate;
  final List<LeaveHistoryDetail> leaveHistoryDetails;

  LeaveCalendarData({
    required this.leaveId,
    required this.leaveType,
    required this.leaveName,
    required this.leaveMainId,
    required this.id,
    required this.leaveFrom,
    required this.leaveTo,
    required this.reason,
    required this.pendingLeave,
    required this.activeLeave,
    required this.cancelledLeave,
    required this.extra,
    required this.startDate,
    required this.endDate,
    required this.leaveHistoryDetails,
  });

  factory LeaveCalendarData.fromJson(Map<String, dynamic> json) {
    return LeaveCalendarData(
      leaveId: json['leave_id'] ?? '',
      leaveType: json['leave_type'] ?? '',
      leaveName: json['leave_name'] ?? '',
      leaveMainId: json['leave_main_id'] ?? '',
      id: json['id'] ?? '',
      leaveFrom: json['leave_from'] ?? '',
      leaveTo: json['leave_to'] ?? '',
      reason: json['reason'] ?? '',
      pendingLeave: json['pending_leave'] ?? '',
      activeLeave: json['active_leave'] ?? '',
      cancelledLeave: json['cancelled_leave'] ?? '',
      extra: json['extra'] ?? '',
      startDate: json['startdate'] ?? '',
      endDate: json['enddate'] ?? '',
      leaveHistoryDetails: (json['leave_history_details'] as List<dynamic>?)
              ?.map((e) => LeaveHistoryDetail.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_id': leaveId,
      'leave_type': leaveType,
      'leave_name': leaveName,
      'leave_main_id': leaveMainId,
      'id': id,
      'leave_from': leaveFrom,
      'leave_to': leaveTo,
      'reason': reason,
      'pending_leave': pendingLeave,
      'active_leave': activeLeave,
      'cancelled_leave': cancelledLeave,
      'extra': extra,
      'startdate': startDate,
      'enddate': endDate,
      'leave_history_details':
          leaveHistoryDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveHistoryDetail {
  final String leaveId;
  final String leaveDate;
  final String applicantId;
  final String applyLeaveType;
  final String grantLeaveType;
  final String stname;
  final String status;
  final String leaveName;
  final String permission;
  final String id;
  final String leaveType;

  LeaveHistoryDetail({
    required this.leaveId,
    required this.leaveDate,
    required this.applicantId,
    required this.applyLeaveType,
    required this.grantLeaveType,
    required this.stname,
    required this.status,
    required this.leaveName,
    required this.permission,
    required this.id,
    required this.leaveType,
  });

  factory LeaveHistoryDetail.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryDetail(
      leaveId: json['leave_id'] ?? '',
      leaveDate: json['leave_date'] ?? '',
      applicantId: json['applicant_id'] ?? '',
      applyLeaveType: json['apply_leave_type'] ?? '',
      grantLeaveType: json['grant_leave_type'] ?? '',
      stname: json['stname'] ?? '',
      status: json['status'] ?? '',
      leaveName: json['leavename'] ?? '',
      permission: json['permission'] ?? '',
      id: json['id'] ?? '',
      leaveType: json['leave_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_id': leaveId,
      'leave_date': leaveDate,
      'applicant_id': applicantId,
      'apply_leave_type': applyLeaveType,
      'grant_leave_type': grantLeaveType,
      'stname': stname,
      'status': status,
      'leavename': leaveName,
      'permission': permission,
      'id': id,
      'leave_type': leaveType,
    };
  }
}

