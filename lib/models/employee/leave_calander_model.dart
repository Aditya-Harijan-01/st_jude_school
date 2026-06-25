class ApplyLeaveCalendarResponse {
  final String statusCode;
  final String empId;
  final String maximumLeaveLimit;
  final String maximumLeaveLimitMessage;
  final List<LeaveDescription> leaveDescription;

  ApplyLeaveCalendarResponse({
    required this.statusCode,
    required this.empId,
    required this.maximumLeaveLimit,
    required this.maximumLeaveLimitMessage,
    required this.leaveDescription,
  });

  factory ApplyLeaveCalendarResponse.fromJson(Map<String, dynamic> json) {
    return ApplyLeaveCalendarResponse(
      statusCode: json['statusCode'] ?? '',
      empId: json['empid'] ?? '',
      maximumLeaveLimit: json['maximum_leave_limit'] ?? '',
      maximumLeaveLimitMessage: json['maximum_leave_limit_message'] ?? '',
      leaveDescription: (json['leave_description'] as List)
          .map((e) => LeaveDescription.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'empid': empId,
      'maximum_leave_limit': maximumLeaveLimit,
      'maximum_leave_limit_message': maximumLeaveLimitMessage,
      'leave_description': leaveDescription.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveDescription {
  final LeaveDescriptionDetails leaveDescriptionDetails;

  LeaveDescription({required this.leaveDescriptionDetails});

  factory LeaveDescription.fromJson(Map<String, dynamic> json) {
    return LeaveDescription(
      leaveDescriptionDetails: LeaveDescriptionDetails.fromJson(json['leave_description_details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_description_details': leaveDescriptionDetails.toJson(),
    };
  }
}

class LeaveDescriptionDetails {
  final String dayType;
  final String leaveCodeSeries;
  final String backgroundColor;
  final String fontColor;
  final String slNo;
  final String leaveDate;
  final String applyFor;
  final String allowFor;
  final String status;
  final String approvalMode;
  final String remark;

  LeaveDescriptionDetails({
    required this.dayType,
    required this.leaveCodeSeries,
    required this.backgroundColor,
    required this.fontColor,
    required this.slNo,
    required this.leaveDate,
    required this.applyFor,
    required this.allowFor,
    required this.status,
    required this.approvalMode,
    required this.remark,
  });

  factory LeaveDescriptionDetails.fromJson(Map<String, dynamic> json) {
    return LeaveDescriptionDetails(
      dayType: json['day_type'] ?? '',
      leaveCodeSeries: json['leave_code_series'] ?? '',
      backgroundColor: json['background_color'] ?? '',
      fontColor: json['font_color'] ?? '',
      slNo: json['sl_no'] ?? '',
      leaveDate: json['leave_date'] ?? '',
      applyFor: json['apply_for'] ?? '',
      allowFor: json['allow_for'] ?? '',
      status: json['status'] ?? '',
      approvalMode: json['approval_mode'] ?? '',
      remark: json['remark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day_type': dayType,
      'leave_code_series': leaveCodeSeries,
      'background_color': backgroundColor,
      'font_color': fontColor,
      'sl_no': slNo,
      'leave_date': leaveDate,
      'apply_for': applyFor,
      'allow_for': allowFor,
      'status': status,
      'approval_mode': approvalMode,
      'remark': remark,
    };
  }
}
