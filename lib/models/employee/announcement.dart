class AnnouncementResponse {
  final String statusCode;
  final int userAccessValue;
  final List<Announcement> data;

  AnnouncementResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponse(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      data: List<Announcement>.from(
        json['data'].map((item) => Announcement.fromJson(item)),
      ),
    );
  }
}

class Announcement {
  final String announceIdW;
  final String announceId;
  final String announcementType;
  final String announcementTopic;
  final String announcementDetails;
  final String fullName;
  final String startDate;
  final String totalNo;
  final String appSerial;
  final List<AttachmentDetail> attachmentDetail;

  Announcement({
    required this.announceIdW,
    required this.announceId,
    required this.announcementType,
    required this.announcementTopic,
    required this.announcementDetails,
    required this.fullName,
    required this.startDate,
    required this.totalNo,
    required this.appSerial,
    required this.attachmentDetail,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      announceIdW: json['announceidw'],
      announceId: json['announceid'],
      announcementType: json['announcementtype'],
      announcementTopic: json['announcementtopic'],
      announcementDetails: json['announcementdetails'],
      fullName: json['fullname'],
      startDate: json['startdate'],
      totalNo: json['totalno'],
      appSerial: json['app_serial'],
      attachmentDetail: List<AttachmentDetail>.from(
        json['attachment_detail'].map((x) => AttachmentDetail.fromJson(x)),
      ),
    );
  }
}

class AttachmentDetail {
  final String fileId;
  final String filePath;

  AttachmentDetail({
    required this.fileId,
    required this.filePath,
  });

  factory AttachmentDetail.fromJson(Map<String, dynamic> json) {
    return AttachmentDetail(
      fileId: json['file_id'],
      filePath: json['file_path'],
    );
  }
}
