class NoticeResponse {
  final String? statusCode;
  final String? message;
  final List<NoticeData>? data;

  NoticeResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory NoticeResponse.fromJson(Map<String, dynamic> json) {
    return NoticeResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => NoticeData.fromJson(e))
          .toList(),
    );
  }
}


class NoticeData {
  final String noticeId;
  final String publishDate;
  final String noticeTopic;
  final String noticeDetail;
  final String msginfo;
  final String uploaderImage;
  final String postedBy;
  final List<NoticeAttachment> noticeAttachments;

  NoticeData({
    required this.noticeId,
    required this.publishDate,
    required this.noticeTopic,
    required this.noticeDetail,
    required this.msginfo,
    required this.uploaderImage,
    required this.postedBy,
    required this.noticeAttachments,
  });

  factory NoticeData.fromJson(Map<String, dynamic> json) {
    return NoticeData(
      noticeId: json['notice_id'] ?? '',
      publishDate: json['publish_date'] ?? '',
      noticeTopic: json['notice_topic'] ?? '',
      noticeDetail: json['notice_detail'] ?? '',
      msginfo: json['msginfo'] ?? '',
      uploaderImage: json['uploader_image'] ?? '',
      postedBy: json['posted_by'] ?? '',
      noticeAttachments: (json['notice_attachments'] as List?)
          ?.map((e) => NoticeAttachment.fromJson(e))
          .toList() ?? [],
    );
  }
}


class NoticeAttachment {
  final String attachmentId;
  final String announceId;
  final String docPath;
  final String status;

  NoticeAttachment({
    required this.attachmentId,
    required this.announceId,
    required this.docPath,
    required this.status,
  });

  factory NoticeAttachment.fromJson(Map<String, dynamic> json) {
    return NoticeAttachment(
      attachmentId: json['attachment_id'] ?? '',
      announceId: json['announce_id'] ?? '',
      docPath: json['doc_path'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
