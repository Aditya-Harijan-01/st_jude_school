class LeaveSummary {
  final String sl;
  final String shortcode;
  final String leaveName;
  final String endDate;
  final String startDate;
  final String used;
  final String typeId;
  final double perMonth;
  final String leaveId;
  final double assignLeave;
  final double balanceLeave;
  final String isLimit;

  LeaveSummary({
    required this.sl,
    required this.shortcode,
    required this.leaveName,
    required this.endDate,
    required this.startDate,
    required this.used,
    required this.typeId,
    required this.perMonth,
    required this.leaveId,
    required this.assignLeave,
    required this.balanceLeave,
    required this.isLimit,
  });

  factory LeaveSummary.fromJson(Map<String, dynamic> json) {
    return LeaveSummary(
      sl: json['sl'] ?? '',
      shortcode: json['shortcode'] ?? '',
      leaveName: json['leave_name'] ?? '',
      endDate: json['end_date'] ?? '',
      startDate: json['start_date'] ?? '',
      used: json['used'] ?? '',
      typeId: json['type_id'] ?? '',
      perMonth: double.tryParse(json['per_month'] ?? '0') ?? 0,
      leaveId: json['leave_id'] ?? '',
      assignLeave: double.tryParse(json['assign_leave'] ?? '0') ?? 0,
      balanceLeave: double.tryParse(json['balance_leave'] ?? '0') ?? 0,
      isLimit: json['is_limit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sl': sl,
      'shortcode': shortcode,
      'leave_name': leaveName,
      'end_date': endDate,
      'start_date': startDate,
      'used': used.toString(),
      'type_id': typeId,
      'per_month': perMonth.toStringAsFixed(2),
      'leave_id': leaveId,
      'assign_leave': assignLeave.toStringAsFixed(1),
      'balance_leave': balanceLeave.toStringAsFixed(1),
      'is_limit': isLimit,
    };
  }
}


class LeaveLateDetails {
  final String totalLate;
  final String inLeave;
  final String lateDates;

  LeaveLateDetails({
    required this.totalLate,
    required this.inLeave,
    required this.lateDates,
  });

  factory LeaveLateDetails.fromJson(Map<String, dynamic> json) {
    return LeaveLateDetails(
      totalLate: json['total_late'] ?? '',
      inLeave: json['in_leave'] ?? '',
      lateDates: json['late_dates'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_late': totalLate.toString(),
      'in_leave': inLeave,
      'late_dates': lateDates,
    };
  }
}

class LeaveEarlyDetails {
  final String totalEarly;
  final String inLeave;
  final String earlyDates;

  LeaveEarlyDetails({
    required this.totalEarly,
    required this.inLeave,
    required this.earlyDates,
  });

  factory LeaveEarlyDetails.fromJson(Map<String, dynamic> json) {
    return LeaveEarlyDetails(
      totalEarly: json['total_early'] ?? '',
      inLeave: json['in_leave'] ?? '',
      earlyDates: json['early_dates'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_early': totalEarly.toString(),
      'in_leave': inLeave,
      'early_dates': earlyDates,
    };
  }
}

class LeaveDeductionSummary {
  final String empId;
  final List<LeaveLateDetails> lateDetails;
  final List<LeaveEarlyDetails> earlyDetails;

  LeaveDeductionSummary({
    required this.empId,
    required this.lateDetails,
    required this.earlyDetails,
  });

  factory LeaveDeductionSummary.fromJson(Map<String, dynamic> json) {
    return LeaveDeductionSummary(
      empId: json['empid'] ?? '',
      lateDetails: (json['late_details'] as List<dynamic>?)
              ?.map((e) => LeaveLateDetails.fromJson(e))
              .toList() ??
          [],
      earlyDetails: (json['early_details'] as List<dynamic>?)
              ?.map((e) => LeaveEarlyDetails.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'empid': empId,
      'late_details': lateDetails.map((e) => e.toJson()).toList(),
      'early_details': earlyDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveSummaryResponse {
  final String statusCode;
  final String empId;
  final double totalBalanceLeave;
  final int userAccess;
  final List<LeaveSummary> leaveSummary;
  final List<LeaveDeductionSummary> leaveDeductionSummary;

  LeaveSummaryResponse({
    required this.statusCode,
    required this.empId,
    required this.totalBalanceLeave,
    required this.userAccess,
    required this.leaveSummary,
    required this.leaveDeductionSummary,
  });

  factory LeaveSummaryResponse.fromJson(Map<String, dynamic> json) {
    return LeaveSummaryResponse(
      statusCode: json['statusCode'] ?? '',
      empId: json['empid'] ?? '',
      totalBalanceLeave:
          double.tryParse(json['total_balance_leave'].toString()) ?? 0.0,
      userAccess: json['user_access_value'],
      leaveSummary: (json['leave_summery'] as List<dynamic>?)
              ?.map((e) => LeaveSummary.fromJson(e))
              .toList() ??
          [],
      leaveDeductionSummary:
          (json['leave_deduction_summery'] as List<dynamic>?)
                  ?.map((e) => LeaveDeductionSummary.fromJson(e))
                  .toList() ??
              [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'empid': empId,
      'total_balance_leave': totalBalanceLeave,
      'leave_summery': leaveSummary.map((e) => e.toJson()).toList(),
      'leave_deduction_summery':
          leaveDeductionSummary.map((e) => e.toJson()).toList(),
    };
  }
}
