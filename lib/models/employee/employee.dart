class EmployeeList {
  final String statusCode;
  final List<Employee> data;

  EmployeeList({
    required this.statusCode,
    required this.data,
  });

  factory EmployeeList.fromJson(Map<String, dynamic> json) {
    return EmployeeList(
      statusCode: json['statusCode'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => Employee.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class Employee {
  final String sln;
  final String empId;
  final String name;
  final String email;
  final String phone;

  Employee({
    required this.sln,
    required this.empId,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      sln: json['slno'] ?? '',
      empId: json['employee_id'] ?? '',
      name: json['employee_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'employee_id': empId,
      'employee_name': name,
      'email': email,
      'mobile': phone,
      'slno': sln,
    };
  }
}
