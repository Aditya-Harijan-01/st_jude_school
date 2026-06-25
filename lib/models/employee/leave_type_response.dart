import 'package:intl/intl.dart';

class LeaveTypeResponse {
  final String statusCode;
  final List<LeaveType> data;

  LeaveTypeResponse({
    required this.statusCode,
    required this.data,
  });

  factory LeaveTypeResponse.fromJson(Map<String, dynamic> json) {
    return LeaveTypeResponse(
      statusCode: json['statusCode'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => LeaveType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class LeaveType {
  final String leaveId;
  final String shortCode;
  final String leaveName;
  final int leaveLimit;
  final int status;

  LeaveType({
    required this.leaveId,
    required this.shortCode,
    required this.leaveName,
    required this.leaveLimit,
    required this.status,
  });

  factory LeaveType.fromJson(Map<String, dynamic> json) {
    return LeaveType(
      leaveId: json['leave_id'] as String,
      shortCode: json['short_code'] as String,
      leaveName: json['leave_name'] as String,
      leaveLimit: json['leave_limit'] is int
          ? json['leave_limit'] as int
          : int.tryParse(json['leave_limit'].toString()) ?? 0,
      status: json['status'] is int
          ? json['status'] as int
          : int.tryParse(json['status'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leave_id': leaveId,
      'short_code': shortCode,
      'leave_name': leaveName,
      'leave_limit': leaveLimit,
      'status': status,
    };
  }
}


//====================================////+++++++++++++++++++++++++++++++//
class LeaveFromTo {
  final String statusCode;
  final String leaveId;
  final DateTime startDate;
  final DateTime endDate;

  const LeaveFromTo({
    required this.statusCode,
    required this.leaveId,
    required this.startDate,
    required this.endDate,
  });

  static final DateFormat _fmt = DateFormat('dd/MM/yyyy');

  factory LeaveFromTo.fromJson(Map<String, dynamic> json) {
    return LeaveFromTo(
      statusCode: (json['statusCode'] ?? '').toString(),
      leaveId: (json['leave_id'] ?? '').toString(),
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'leave_id': leaveId,
        // serialize back to the same dd/MM/yyyy format (change if your API expects something else)
        'start_date': _fmt.format(startDate),
        'end_date': _fmt.format(endDate),
      };

  static DateTime _parseDate(dynamic value) {
    if (value is DateTime) return value;
    if (value is int) {
      // treat as epoch ms; change to ~/1000 if seconds
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      // try dd/MM/yyyy first, then ISO-8601 fallback
      try {
        return _fmt.parseStrict(value);
      } catch (_) {
        return DateTime.parse(value);
      }
    }
    throw ArgumentError('Unsupported date value: $value (${value.runtimeType})');
  }

  LeaveFromTo copyWith({
    String? statusCode,
    String? leaveId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return LeaveFromTo(
      statusCode: statusCode ?? this.statusCode,
      leaveId: leaveId ?? this.leaveId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
