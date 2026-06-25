class EmployeeCounterResponse {
  String? statusCode;
  int? userAccessValue;
  List<EmployeeCategoryData>? data;

  EmployeeCounterResponse({this.statusCode, this.userAccessValue, this.data});

  EmployeeCounterResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    userAccessValue = json['user_access_value'];
    if (json['data'] != null) {
      data = <EmployeeCategoryData>[];
      json['data'].forEach((v) {
        data!.add(EmployeeCategoryData.fromJson(v));
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

  bool get isSuccess => statusCode?.toLowerCase() == 'success';
}

class EmployeeCategoryData {
  String? categoryId;
  String? categoryName;
  String? totalEmployee;

  EmployeeCategoryData({this.categoryId, this.categoryName, this.totalEmployee});

  EmployeeCategoryData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    totalEmployee = json['total_employee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['total_employee'] = totalEmployee;
    return data;
  }
}
