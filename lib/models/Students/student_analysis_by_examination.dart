class StudentsAnalysisByExaminationResponse {
  final String statusCode;
  final String? message;
  final List<AnalysisData> data;
  final List<SubjectAnalysisData> data1;

  StudentsAnalysisByExaminationResponse({
    required this.statusCode,
    this.message,
    required this.data,
    required this.data1,
  });

  factory StudentsAnalysisByExaminationResponse.fromJson(Map<String, dynamic> json) {
    return StudentsAnalysisByExaminationResponse(
      statusCode: json['statusCode'] ?? '',
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => AnalysisData.fromJson(item))
              .toList() ?? [],
      data1: (json['data1'] as List<dynamic>?)
              ?.map((item) => SubjectAnalysisData.fromJson(item))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
        'data1': data1.map((e) => e.toJson()).toList(),
      };
}

class AnalysisData {
  final String markObtain;
  final String examTotal;
  final String subjectCount;
  final String sectionRank;
  final String classRank;
  final String examPercent;
  final String classAverage;
  final String changeValue;
  final String valueDirection;

  AnalysisData({
    required this.markObtain,
    required this.examTotal,
    required this.subjectCount,
    required this.sectionRank,
    required this.classRank,
    required this.examPercent,
    required this.classAverage,
    required this.changeValue,
    required this.valueDirection,
  });

  factory AnalysisData.fromJson(Map<String, dynamic> json) {
    return AnalysisData(
      markObtain: json['mark_obtain'] ?? '',
      examTotal: json['exam_total'] ?? '',
      subjectCount: json['subject_count'] ?? '',
      sectionRank: json['section_rank'] ?? '',
      classRank: json['class_rank'] ?? '',
      examPercent: json['exam_percent'] ?? '',
      classAverage: json['class_average'] ?? '',
      changeValue: json['change_value'] ?? '',
      valueDirection: json['value_direction'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'mark_obtain': markObtain,
        'exam_total': examTotal,
        'subject_count': subjectCount,
        'section_rank': sectionRank,
        'class_rank': classRank,
        'exam_percent': examPercent,
        'class_average': classAverage,
        'change_value': changeValue,
        'value_direction': valueDirection,
      };
}

class SubjectGroupItem {
  final String subId;
  final String sortName;
  final String subName;
  final String subObtainMark;
  final String subFullMark;

  SubjectGroupItem({
    required this.subId,
    required this.sortName,
    required this.subName,
    required this.subObtainMark,
    required this.subFullMark,
  });

  factory SubjectGroupItem.fromJson(Map<String, dynamic> json) {
    return SubjectGroupItem(
      subId: json['sub_id'] ?? '',
      sortName: json['sort_name'] ?? '',
      subName: json['sub_name'] ?? '',
      subObtainMark: json['sub_obtain_mark'] ?? '',
      subFullMark: json['sub_full_mark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'sub_id': subId,
        'sort_name': sortName,
        'sub_name': subName,
        'sub_obtain_mark': subObtainMark,
        'sub_full_mark': subFullMark,
      };
}

class SubjectAnalysisData {
  final String aggrId;
  final String subAggrPer;
  final String subRank;
  final String subName;
  final String subAggrMark;
  final String subAggrFull;
  final List<SubjectGroupItem> subjectGroup;

  SubjectAnalysisData({
    required this.aggrId,
    required this.subAggrPer,
    required this.subRank,
    required this.subName,
    required this.subAggrMark,
    required this.subAggrFull,
    required this.subjectGroup,
  });

  factory SubjectAnalysisData.fromJson(Map<String, dynamic> json) {
    return SubjectAnalysisData(
      aggrId: json['aggr_id'] ?? '',
      subAggrPer: json['sub_aggr_per'] ?? '',
      subRank: json['sub_rank'] ?? '',
      subName: json['sub_name'] ?? '',
      subAggrMark: json['sub_aggr_mark'] ?? '',
      subAggrFull: json['sub_aggr_full'] ?? '',
      subjectGroup: (json['subject_group'] as List<dynamic>?)
              ?.map((item) => SubjectGroupItem.fromJson(item))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'aggr_id': aggrId,
        'sub_aggr_per': subAggrPer,
        'sub_rank': subRank,
        'sub_name': subName,
        'sub_aggr_mark': subAggrMark,
        'sub_aggr_full': subAggrFull,
        'subject_group': subjectGroup.map((e) => e.toJson()).toList(),
      };
}