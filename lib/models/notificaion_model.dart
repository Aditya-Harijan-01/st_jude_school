
class EmployeeNotificationResponse {
  final String statusCode;
  final List<EmployeeNotificationItem> data;

  EmployeeNotificationResponse({
    required this.statusCode,
    required this.data,
  });

  factory EmployeeNotificationResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeNotificationResponse(
      statusCode: json['statusCode'] as String? ?? '',
      data: (json['data'] as List? ?? [])
          .map((item) => EmployeeNotificationItem.fromJson(item))
          .toList(),
    );
  }
}

class EmployeeNotificationItem {
  final String announceIdW;
  final String announceId;
  final String announcementType;
  final String announcementTopic;
  final String announcementDetails;
  final String lastUpdated;
  final String fullname;
  final String startdate;
  final String appSerial;
  final String publishedDate;
  final String doc;
  final String msginfo;
  final String profileImage;
  final String totalno;
  final List<NoticeAttachment> noticeAttachments;

  EmployeeNotificationItem({
    required this.announceIdW,
    required this.announceId,
    required this.announcementType,
    required this.announcementTopic,
    required this.announcementDetails,
    required this.lastUpdated,
    required this.fullname,
    required this.startdate,
    required this.appSerial,
    required this.publishedDate,
    required this.doc,
    required this.msginfo,
    required this.profileImage,
    required this.totalno,
    required this.noticeAttachments,
  });

  factory EmployeeNotificationItem.fromJson(Map<String, dynamic> json) {
    return EmployeeNotificationItem(
      announceIdW: json['announce_idW'] as String? ?? '',
      announceId: json['announce_id'] as String? ?? '',
      announcementType: json['announcement_type'] as String? ?? '',
      announcementTopic: json['announcement_topic'] as String? ?? '',
      announcementDetails: json['announcement_details'] as String? ?? '',
      lastUpdated: json['last_updated'] as String? ?? '',
      fullname: json['fullname'] as String? ?? '',
      startdate: json['startdate'] as String? ?? '',
      appSerial: json['app_serial'] as String? ?? '',
      publishedDate: json['published_date'] as String? ?? '',
      doc: json['doc'] as String? ?? '',
      msginfo: json['msginfo'] as String? ?? '',
      profileImage: json['profile_image'] as String? ?? '',
      totalno: json['totalno'] as String? ?? '',
      noticeAttachments: (json['notice_attachments'] as List? ?? [])
          .map((attachment) => NoticeAttachment.fromJson(attachment))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'announce_idW': announceIdW,
      'announce_id': announceId,
      'announcement_type': announcementType,
      'announcement_topic': announcementTopic,
      'announcement_details': announcementDetails,
      'last_updated': lastUpdated,
      'fullname': fullname,
      'startdate': startdate,
      'app_serial': appSerial,
      'published_date': publishedDate,
      'doc': doc,
      'msginfo': msginfo,
      'profile_image': profileImage,
      'totalno': totalno,
      'notice_attachments': noticeAttachments.map((attachment) => attachment.toJson()).toList(),
    };
  }
}

class NoticeAttachment {
  final String attachmentUrl;
  NoticeAttachment({
    required this.attachmentUrl,
  });
  factory NoticeAttachment.fromJson(Map<String, dynamic> json) {
    return NoticeAttachment(
      attachmentUrl: json['doc_path'] as String? ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'attachment_url': attachmentUrl,
    };
  }
}
