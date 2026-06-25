class SubjectResponse {
  final String statusCode;
  final int userAccessValue;
  final List<SubjectData> data;

  SubjectResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory SubjectResponse.fromJson(Map<String, dynamic> json) {
    return SubjectResponse(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      data: List<SubjectData>.from(
        json['data'].map((item) => SubjectData.fromJson(item)),
      ),
    );
  }
}

class SubjectData {
  final String subjectCode;
  final String subjectName;

  SubjectData({
    required this.subjectCode,
    required this.subjectName,
  });

  factory SubjectData.fromJson(Map<String, dynamic> json) {
    return SubjectData(
      subjectCode: json['subject_code'],
      subjectName: json['subject_name'],
    );
  }
}
