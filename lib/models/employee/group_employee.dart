class GrpEmployeeListResponse {
  final int statusCode;
  final int userAccessValue;
  final List<GrpEmployee> data;

  GrpEmployeeListResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory GrpEmployeeListResponse.fromJson(Map<String, dynamic> json) {
    return GrpEmployeeListResponse(
      statusCode: json['statusCode'] is int ? json['statusCode'] : int.tryParse(json['statusCode'].toString()) ?? 0,
      userAccessValue: json['user_access_value'] is int ? json['user_access_value'] : int.tryParse(json['user_access_value'].toString()) ?? 0,
      data: (json['data'] as List<dynamic>?)?.map((e) => GrpEmployee.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'user_access_value': userAccessValue,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class GrpEmployee {
  final String slno;
  final String employeeId;
  final String employeeName;
  final String email;
  final String mobile;

  GrpEmployee({
    required this.slno,
    required this.employeeId,
    required this.employeeName,
    required this.email,
    required this.mobile,
  });

  factory GrpEmployee.fromJson(Map<String, dynamic> json) {
    return GrpEmployee(
      slno: json['slno']?.toString() ?? '',
      employeeId: json['employee_id']?.toString() ?? '',
      employeeName: json['employee_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'slno': slno,
        'employee_id': employeeId,
        'employee_name': employeeName,
        'email': email,
        'mobile': mobile,
      };
}
