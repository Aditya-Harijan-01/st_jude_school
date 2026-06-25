class EmpDashboardModel {
  String? statusCode;
  bool? success;
  String? message;
  List<DataCalendar>? dataCalendar;
  List<DataNotice>? dataNotice;
  List<DataAttendance>? dataAttendance;

  EmpDashboardModel({
    this.statusCode,
    this.success,
    this.message,
    this.dataCalendar,
    this.dataNotice,
    this.dataAttendance,
  });

  EmpDashboardModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['dataCalendar'] != null) {
      dataCalendar = <DataCalendar>[];
      json['dataCalendar'].forEach((d) {
        dataCalendar!.add(DataCalendar.fromJson(d));
      });
    }
    if (json['dataNotice'] != null) {
      dataNotice = <DataNotice>[];
      json['dataNotice'].forEach((v) {
        dataNotice!.add(DataNotice.fromJson(v));
      });
    }
    if (json['dataAttendance'] != null) {
      dataAttendance = <DataAttendance>[];
      json['dataAttendance'].forEach((v) {
        dataAttendance!.add(DataAttendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (dataCalendar != null) {
      data['dataCalendar'] = dataCalendar!.map((v) => v.toJson()).toList();
    }
    if (dataNotice != null) {
      data['dataNotice'] = dataNotice!.map((v) => v.toJson()).toList();
    }
    if (dataAttendance != null) {
      data['dataAttendance'] = dataAttendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataCalendar {
  String? eDate;
  List<EventName>? eventName;

  DataCalendar({this.eDate, this.eventName});

  DataCalendar.fromJson(Map<String, dynamic> json) {
    eDate = json['e_date'];
    if (json['event_name'] != null) {
      eventName = <EventName>[];
      json['event_name'].forEach((v) {
        eventName!.add(EventName.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['e_date'] = eDate;
    if (eventName != null) {
      data['event_name'] = eventName!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventName {
  String? eventDetails;
  String? typeCode;

  EventName({this.eventDetails, this.typeCode});

  EventName.fromJson(Map<String, dynamic> json) {
    eventDetails = json['event_details'];
    typeCode = json['type_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event_details'] = eventDetails;
    data['type_code'] = typeCode;
    return data;
  }
}

class DataNotice {
  String? announceIdW;
  String? announceId;
  String? announcementType;
  String? announcementTopic;
  String? announcementDetails;
  String? lastUpdated;
  String? fullname;
  String? startdate;
  String? appSerial;
  String? publishedDate;
  String? doc;
  String? profileImage;
  String? totalno;
  String? msginfo;
  List<NoticeAttachment>? noticeAttachments;

  DataNotice({
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

  DataNotice.fromJson(Map<String, dynamic> json) {
    announceIdW = json['announce_idW'];
    announceId = json['announce_id'];
    announcementType = json['announcement_type'];
    announcementTopic = json['announcement_topic'];
    announcementDetails = json['announcement_details'];
    lastUpdated = json['last_updated'];
    fullname = json['fullname'];
    startdate = json['startdate'];
    appSerial = json['app_serial'];
    publishedDate = json['published_date'];
    doc = json['doc'];
    profileImage = json['profile_image'];
    totalno = json['totalno'];
    msginfo = json['msginfo'];
    if (json['notice_attachments'] != null) {
      noticeAttachments = <NoticeAttachment>[];
      json['notice_attachments'].forEach((v) {
        noticeAttachments!.add(NoticeAttachment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['announce_idW'] = announceIdW;
    data['announce_id'] = announceId;
    data['announcement_type'] = announcementType;
    data['announcement_topic'] = announcementTopic;
    data['announcement_details'] = announcementDetails;
    data['last_updated'] = lastUpdated;
    data['fullname'] = fullname;
    data['startdate'] = startdate;
    data['app_serial'] = appSerial;
    data['published_date'] = publishedDate;
    data['doc'] = doc;
    data['profile_image'] = profileImage;
    data['totalno'] = totalno;
    data['msginfo'] = msginfo;
    if (noticeAttachments != null) {
      data['notice_attachments'] =
          noticeAttachments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NoticeAttachment {
  String? attachmentId;
  String? announceId;
  String? docPath;
  String? status;

  NoticeAttachment(
      {this.attachmentId, this.announceId, this.docPath, this.status});

  NoticeAttachment.fromJson(Map<String, dynamic> json) {
    attachmentId = json['attachment_id'];
    announceId = json['announce_id'];
    docPath = json['doc_path'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['attachment_id'] = attachmentId;
    data['announce_id'] = announceId;
    data['doc_path'] = docPath;
    data['status'] = status;
    return data;
  }
}

class DataAttendance {
  String? currentDate;
  String? totalDay;
  String? totalPresent;
  String? totalAbsent;
  String? presentPer;
  String? absentPer;

  DataAttendance({
    this.currentDate,
    this.totalDay,
    this.totalPresent,
    this.totalAbsent,
    this.presentPer,
    this.absentPer,
  });

  DataAttendance.fromJson(Map<String, dynamic> json) {
    currentDate = json['currentDate'];
    totalDay = json['totalDay'];
    totalPresent = json['totalPresent'];
    totalAbsent = json['totalAbsent'];
    presentPer = json['presentPer'];
    absentPer = json['absentPer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['currentDate'] = currentDate;
    data['totalDay'] = totalDay;
    data['totalPresent'] = totalPresent;
    data['totalAbsent'] = totalAbsent;
    data['presentPer'] = presentPer;
    data['absentPer'] = absentPer;
    return data;
  }
}
