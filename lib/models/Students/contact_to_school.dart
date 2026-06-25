class ContactToSchoolResponse {
  final String statusCode;
  // final String message;
  final List<ContactToSchoolTicket> data;

  ContactToSchoolResponse({
    required this.statusCode,
    // required this.message,
    required this.data,
  });

  factory ContactToSchoolResponse.fromJson(Map<String, dynamic> json) {
    return ContactToSchoolResponse(
      statusCode: json['statusCode'] as String,
      // message: json['message'],
      data: (json['data'] as List)
          .map((e) => ContactToSchoolTicket.fromJson(e))
          .toList(),
    );
  }
}

class ContactToSchoolTicket {
  final String contentId;
  final String complaintRegNo;
  final String contentCategoryName;
  final String contentDetail;
  final String postedOn;
  final String postedBy;
  final String lastUpdateOn;
  final String lastUpdateBy;
  final String senderType;
  final String lastSenderType;
  final String forwardTo;
  final String noOfReply;
  final String status;
  final List<dynamic> initialAttachments;

  ContactToSchoolTicket({
    required this.contentId,
    required this.complaintRegNo,
    required this.contentCategoryName,
    required this.contentDetail,
    required this.postedOn,
    required this.postedBy,
    required this.lastUpdateOn,
    required this.lastUpdateBy,
    required this.senderType,
    required this.lastSenderType,
    required this.forwardTo,
    required this.noOfReply,
    required this.status,
    required this.initialAttachments,
  });

  factory ContactToSchoolTicket.fromJson(Map<String, dynamic> json) {
    return ContactToSchoolTicket(
      contentId: json['content_id'] as String,
      complaintRegNo: json['complaint_reg_no'] as String,
      contentCategoryName: json['content_category_name'] as String,
      contentDetail: json['content_detail'] as String,
      postedOn: json['posted_on'] as String,
      postedBy: json['posted_by'] as String,
      lastUpdateOn: json['last_update_on'] as String,
      lastUpdateBy: json['last_update_by'] as String,
      senderType: json['sender_type'] as String,
      lastSenderType: json['last_sender_type'] as String,
      forwardTo: json['forward_to'] as String,
      noOfReply: json['no_of_reply'] as String,
      status: json['status'] as String,
      initialAttachments: json['initial_attachments'] ?? [],
    );
  }
}