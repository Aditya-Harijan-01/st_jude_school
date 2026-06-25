class StudentsReportCardsResponse {
  final String statusCode;
  final String? message;
  final List<ReportCard> data;
  final List<ReportCardSummary> data1;

  StudentsReportCardsResponse({
    required this.statusCode,
    this.message,
    required this.data,
    required this.data1,
  });

  factory StudentsReportCardsResponse.fromJson(Map<String, dynamic> json) {
    return StudentsReportCardsResponse(
      statusCode: json['statusCode'] ?? '',
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => ReportCard.fromJson(item))
              .toList() ??
          [],
      data1: (json['data1'] as List<dynamic>?)
              ?.map((item) => ReportCardSummary.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
        'data1': data1.map((e) => e.toJson()).toList(),
      };
}

class ReportCardSummary {
  final String examPercent;
  final String percentHead;

  ReportCardSummary({
    required this.examPercent,
    required this.percentHead,
  });

  factory ReportCardSummary.fromJson(Map<String, dynamic> json) {
    return ReportCardSummary(
      examPercent: json['exam_percent'] ?? '',
      percentHead: json['percent_head'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'exam_percent': examPercent,
        'percent_head': percentHead,
      };
}

class ReportCard {
  final String reportId;
  final String sid;
  final String regno;
  final String hostExamId;
  final String examTotal;
  final String examObtain;
  final String examPercent; //ReportCard.examPercent
  final String examClassAvg; //ReportCard.examClassAvg
  final String examRank;
  final String examName; //ReportCard.examName
  final String feeGroupId;
  final String groupName;
  final bool isDownload;

  ReportCard( {
    required this.reportId,
    required this.sid,
    required this.regno,
    required this.hostExamId,
    required this.examTotal,
    required this.examObtain,
    required this.examPercent,
    required this.examClassAvg,
    required this.examRank,
    required this.examName,
    required this.feeGroupId,
    required this.groupName,
    required this.isDownload
  });

  factory ReportCard.fromJson(Map<String, dynamic> json) {
    return ReportCard(
      reportId: json['report_id'] ?? '',
      sid: json['sid'] ?? '',
      regno: json['regno'] ?? '',
      hostExamId: json['host_exam_id'] ?? '',
      examTotal: json['exam_total'] ?? '',
      examObtain: json['exam_obtain'] ?? '',
      examPercent: json['exam_percent'] ?? '',
      examRank: json['exam_rank'] ?? '',
      examName: json['exam_name'] ?? '',
      feeGroupId: json['fee_group_id'] ?? '',
      groupName: json['group_name'] ?? '',
      examClassAvg: json['examClassAvg'] ?? '',
      isDownload: json['isDownload'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'report_id': reportId,
        'sid': sid,
        'regno': regno,
        'host_exam_id': hostExamId,
        'exam_total': examTotal,
        'exam_obtain': examObtain,
        'exam_percent': examPercent,
        'exam_rank': examRank,
        'exam_name': examName,
        'fee_group_id': feeGroupId,
        'group_name': groupName,
        'examClassAvg': examClassAvg,
        'isDownload': isDownload,
      };
}