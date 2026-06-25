class ConcernHistoryResponse {
  final String statusCode;
  final List<ConcernTicket> data;

  ConcernHistoryResponse({
    required this.statusCode,
    required this.data,
  });

  factory ConcernHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ConcernHistoryResponse(
      statusCode: json['statusCode'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => ConcernTicket.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ConcernTicket {
  final String complaintRegNo;
  final String contentCategoryName;
  final String regno;
  final String className;
  final String contentId;
  final List<ConcernMessage> messages;

  ConcernTicket({
    required this.complaintRegNo,
    required this.contentCategoryName,
    required this.regno,
    required this.className,
    required this.contentId,
    required this.messages,
  });

  factory ConcernTicket.fromJson(Map<String, dynamic> json) {
    return ConcernTicket(
      complaintRegNo: json['complaint_reg_no'] ?? '',
      contentCategoryName: json['content_category_name'] ?? '',
      regno: json['regno'] ?? '',
      className: json['class_name'] ?? '',
      contentId: json['content_id'] ?? '',
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => ConcernMessage.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ConcernMessage {
  final String contentDescription;
  final String contentDirection;
  final String postedBy;
  final String postedOn;
  final String contentDetailId;
  final String contentStatus;
  final List<dynamic> attachment; // adjust type if attachment structure defined later
  final String profileUrl;

  ConcernMessage({
    required this.contentDescription,
    required this.contentDirection,
    required this.postedBy,
    required this.postedOn,
    required this.contentDetailId,
    required this.contentStatus,
    required this.attachment,
    required this.profileUrl
  });

  factory ConcernMessage.fromJson(Map<String, dynamic> json) {
    return ConcernMessage(
      contentDescription: json['content_description'] ?? '',
      contentDirection: json['content_direction'] ?? '',
      postedBy: json['posted_by'] ?? '',
      postedOn: json['posted_on'] ?? '',
      contentDetailId: json['content_detail_id'] ?? '',
      contentStatus: json['content_status'] ?? '',
      attachment: json['attachment'] ?? [],
      profileUrl: json['profile_image'] ?? '',
    );
  }
}
