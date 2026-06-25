class EmployeeListForTaskResponse {
  String? statusCode;
  int? userAccessValue;
  List<EmployeeTaskData>? data;

  EmployeeListForTaskResponse(
      {this.statusCode, this.userAccessValue, this.data});

  EmployeeListForTaskResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    userAccessValue = json['user_access_value'];
    if (json['data'] != null) {
      data = <EmployeeTaskData>[];
      json['data'].forEach((v) {
        data!.add(EmployeeTaskData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['user_access_value'] = userAccessValue;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EmployeeTaskData {
  String? empid;
  String? employeeName;

  EmployeeTaskData({this.empid, this.employeeName});

  EmployeeTaskData.fromJson(Map<String, dynamic> json) {
    empid = json['empid'];
    employeeName = json['employee_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['empid'] = empid;
    data['employee_name'] = employeeName;
    return data;
  }
}
