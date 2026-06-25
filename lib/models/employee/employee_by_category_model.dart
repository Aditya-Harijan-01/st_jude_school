class EmployeeByCategoryResponse {
  String? statusCode;
  String? message;
  List<EmployeeData>? data;

  EmployeeByCategoryResponse({this.statusCode, this.message, this.data});

  EmployeeByCategoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EmployeeData>[];
      json['data'].forEach((v) {
        data!.add(EmployeeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool get isSuccess => statusCode?.toLowerCase() == 'success';
}

class EmployeeData {
  String? categoryId;
  String? empId;
  String? empName;
  String? profileImage;
  String? designation;
  String? fromYear;
  String? toYear;

  EmployeeData({
    this.categoryId,
    this.empId,
    this.empName,
    this.profileImage,
    this.designation,
    this.fromYear,
    this.toYear,
  });

  EmployeeData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    empId = json['emp_id'];
    empName = json['emp_name'];
    profileImage = json['profile_image'];
    designation = json['designation'];
    fromYear = json['fromyear'];
    toYear = json['toyear'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['emp_id'] = empId;
    data['emp_name'] = empName;
    data['profile_image'] = profileImage;
    data['designation'] = designation;
    data['fromyear'] = fromYear;
    data['toyear'] = toYear;
    return data;
  }
}
