class AdmitCardResponse {
  final String statusCode;
  final String? message;
  final List<AdmitCardData> data;

  AdmitCardResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory AdmitCardResponse.fromJson(Map<String, dynamic> json) {
    return AdmitCardResponse(
      statusCode: json['statusCode'] ?? '',
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AdmitCardData.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class AdmitCardData {
  final String examName;
  final String examId;
  final String pendingFee;
  final String issueStatus;
  final String paymentStatus;

  AdmitCardData({
    required this.examName,
    required this.examId,
    required this.pendingFee,
    required this.issueStatus,
    required this.paymentStatus,
  });

  factory AdmitCardData.fromJson(Map<String, dynamic> json) {
    return AdmitCardData(
      examName: json['exam_name'] ?? '',
      examId: json['exam_id'] ?? '',
      pendingFee: json['pending_fee'] ?? '',
      issueStatus: json['issue_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_name': examName,
      'exam_id': examId,
      'pending_fee': pendingFee,
      'issue_status': issueStatus,
      'payment_status': paymentStatus,
    };
  }

  bool get isAdmitCardIssued =>
      issueStatus.toLowerCase().contains('issued');

  String get displaySubtitle =>
      isAdmitCardIssued ? 'Admit Card issued' : 'Admit Card not yet issued';
}