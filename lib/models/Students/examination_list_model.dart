class ExaminationListResponse {
  final String? statusCode;
  final int? userAccessValue;
  final List<ExaminationData>? data;

  ExaminationListResponse({
    this.statusCode,
    this.userAccessValue,
    this.data,
  });

  factory ExaminationListResponse.fromJson(Map<String, dynamic> json) {
    return ExaminationListResponse(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => ExaminationData.fromJson(i)).toList()
          : null,
    );
  }
}

class ExaminationData {
  final String? examId;
  final String? examName;

  ExaminationData({
    this.examId,
    this.examName,
  });

  factory ExaminationData.fromJson(Map<String, dynamic> json) {
    return ExaminationData(
      examId: json['exam_id'],
      examName: json['exam_name'],
    );
  }
}
