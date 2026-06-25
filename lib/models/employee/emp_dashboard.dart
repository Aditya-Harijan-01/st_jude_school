class DashboardResponse {
  final String? statusCode;
  final bool? success;
  final String? message;
  final List<CalendarData>? dataCalendar;
  final List<NoticeData>? dataNotice;
  final List<AttendanceData>? dataAttendance;

  DashboardResponse({
    this.statusCode,
    this.success,
    this.message,
    this.dataCalendar,
    this.dataNotice,
    this.dataAttendance,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      statusCode: json['statusCode'],
      success: json['success'],
      message: json['message'],
      dataCalendar: (json['dataCalendar'] as List?)
          ?.map((e) => CalendarData.fromJson(e))
          .toList(),
      dataNotice: (json['dataNotice'] as List?)
          ?.map((e) => NoticeData.fromJson(e))
          .toList(),
      dataAttendance: (json['dataAttendance'] as List?)
          ?.map((e) => AttendanceData.fromJson(e))
          .toList(),
    );
  }
}



class CalendarData {
  final String? eDate;
  final List<EventName>? eventName;

  CalendarData({
    this.eDate,
    this.eventName,
  });

  factory CalendarData.fromJson(Map<String, dynamic> json) {
    return CalendarData(
      eDate: json['e_date'],
      eventName: (json['event_name'] as List?)
          ?.map((e) => EventName.fromJson(e))
          .toList(),
    );
  }
}

class EventName {
  final String? eventDetails;
  final String? typeCode;

  EventName({
    this.eventDetails,
    this.typeCode,
  });

  factory EventName.fromJson(Map<String, dynamic> json) {
    return EventName(
      eventDetails: json['event_details'],
      typeCode: json['type_code'],
    );
  }
}


class NoticeData {
  final String? announceIdW;
  final String? announceId;
  final String? announcementType;
  final String? announcementTopic;
  final String? announcementDetails;
  final String? lastUpdated;
  final String? fullname;
  final String? startdate;
  final String? appSerial;
  final String? publishedDate;
  final String? doc;
  final String? profileImage;
  final String? totalno;
  final String? msginfo;
  final List<dynamic>? noticeAttachments;

  NoticeData({
    this.announceIdW,
    this.announceId,
    this.announcementType,
    this.announcementTopic,
    this.announcementDetails,
    this.lastUpdated,
    this.fullname,
    this.startdate,
    this.appSerial,
    this.publishedDate,
    this.doc,
    this.profileImage,
    this.totalno,
    this.msginfo,
    this.noticeAttachments,
  });

  factory NoticeData.fromJson(Map<String, dynamic> json) {
    return NoticeData(
      announceIdW: json['announce_idW'],
      announceId: json['announce_id'],
      announcementType: json['announcement_type'],
      announcementTopic: json['announcement_topic'],
      announcementDetails: json['announcement_details'],
      lastUpdated: json['last_updated'],
      fullname: json['fullname'],
      startdate: json['startdate'],
      appSerial: json['app_serial'],
      publishedDate: json['published_date'],
      doc: json['doc'],
      profileImage: json['profile_image'],
      totalno: json['totalno'],
      msginfo: json['msginfo'],
      noticeAttachments: json['notice_attachments'] as List?,
    );
  }
}

class AttendanceData {
  final String? currentDate;
  final String? totalDay;
  final String? totalPresent;
  final String? totalAbsent;
  final String? presentPer;
  final String? absentPer;

  AttendanceData({
    this.currentDate,
    this.totalDay,
    this.totalPresent,
    this.totalAbsent,
    this.presentPer,
    this.absentPer,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      currentDate: json['currentDate'],
      totalDay: json['totalDay'],
      totalPresent: json['totalPresent'],
      totalAbsent: json['totalAbsent'],
      presentPer: json['presentPer'],
      absentPer: json['absentPer'],
    );
  }
}
