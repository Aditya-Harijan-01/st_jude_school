// subject_list_model.dart

class SubjectListModel {
  final String? statusCode;
  final String? message;
  final List<SubjectData>? data;

  SubjectListModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory SubjectListModel.fromJson(Map<String, dynamic> json) {
    return SubjectListModel(
      statusCode: json['statusCode'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => SubjectData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class SubjectData {
  final String? subId;
  final String? subCode;
  final String? subName;

  SubjectData({
    this.subId,
    this.subCode,
    this.subName,
  });

  factory SubjectData.fromJson(Map<String, dynamic> json) {
    return SubjectData(
      subId: json['sub_id'] as String?,
      subCode: json['sub_code'] as String?,
      subName: json['sub_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sub_id': subId,
      'sub_code': subCode,
      'sub_name': subName,
    };
  }
}
