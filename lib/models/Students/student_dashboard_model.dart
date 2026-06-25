class StudentDashboardModel {
  String? statusCode;
  bool? success;
  String? message;
  List<DataCalendar>? dataCalendar;
  List<DataNotice>? dataNotice;
  List<DataAssignment>? dataAssignment;
  List<DataFee>? dataFee;
  List<DataAttendance>? dataAttendance;

  StudentDashboardModel({
    this.statusCode,
    this.success,
    this.message,
    this.dataCalendar,
    this.dataNotice,
    this.dataAssignment,
    this.dataFee,
    this.dataAttendance,
  });

  StudentDashboardModel.fromJson(Map<String, dynamic> json) {
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
    if (json['dataAssignment'] != null) {
      dataAssignment = <DataAssignment>[];
      json['dataAssignment'].forEach((v) {
        dataAssignment!.add(DataAssignment.fromJson(v));
      });
    }
    if (json['dataFee'] != null) {
      dataFee = <DataFee>[];
      json['dataFee'].forEach((v) {
        dataFee!.add(DataFee.fromJson(v));
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
    if (dataAssignment != null) {
      data['dataAssignment'] = dataAssignment!.map((v) => v.toJson()).toList();
    }
    if (dataFee != null) {
      data['dataFee'] = dataFee!.map((v) => v.toJson()).toList();
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
  String? noticeId;
  String? publishDate;
  String? noticeTopic;
  String? noticeDetail;
  String? msginfo;
  String? uploaderImage;
  String? postedBy;
  List<NoticeAttachment>? noticeAttachments;

  DataNotice({
    this.noticeId,
    this.publishDate,
    this.noticeTopic,
    this.noticeDetail,
    this.msginfo,
    this.uploaderImage,
    this.postedBy,
    this.noticeAttachments,
  });

  DataNotice.fromJson(Map<String, dynamic> json) {
    noticeId = json['notice_id'];
    publishDate = json['publish_date'];
    noticeTopic = json['notice_topic'];
    noticeDetail = json['notice_detail'];
    msginfo = json['msginfo'];
    uploaderImage = json['uploader_image'];
    postedBy = json['posted_by'];
    if (json['notice_attachments'] != null) {
      noticeAttachments = <NoticeAttachment>[];
      json['notice_attachments'].forEach((v) {
        noticeAttachments!.add(NoticeAttachment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notice_id'] = noticeId;
    data['publish_date'] = publishDate;
    data['notice_topic'] = noticeTopic;
    data['notice_detail'] = noticeDetail;
    data['msginfo'] = msginfo;
    data['uploader_image'] = uploaderImage;
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

class DataAssignment {
  String? className;
  String? stream;
  String? section;
  String? assignmentDate;
  String? assignmentSubmissionDate;
  String? insertDate;
  String? assignmentDetails;
  String? subName;
  String? teacherName;
  String? chapterName;
  String? pageFrom;
  String? displayStatus;
  String? appSerial;
  List<DocList>? docList;
  String? teacherImage;

  DataAssignment({
    this.className,
    this.stream,
    this.section,
    this.assignmentDate,
    this.assignmentSubmissionDate,
    this.insertDate,
    this.assignmentDetails,
    this.subName,
    this.teacherName,
    this.chapterName,
    this.pageFrom,
    this.displayStatus,
    this.appSerial,
    this.docList,
    this.teacherImage,
  });

  DataAssignment.fromJson(Map<String, dynamic> json) {
    className = json['class_name'];
    stream = json['stream'];
    section = json['section'];
    assignmentDate = json['assignment_date'];
    assignmentSubmissionDate = json['assignment_submission_date'];
    insertDate = json['insert_date'];
    assignmentDetails = json['assignment_details'];
    subName = json['sub_name'];
    teacherName = json['teacher_name'];
    chapterName = json['chapter_name'];
    pageFrom = json['page_from'];
    displayStatus = json['display_status'];
    appSerial = json['app_serial'];
    if (json['doc_list'] != null) {
      docList = <DocList>[];
      json['doc_list'].forEach((v) {
        docList!.add(DocList.fromJson(v));
      });
    }
    teacherImage = json['teacher_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class_name'] = className;
    data['stream'] = stream;
    data['section'] = section;
    data['assignment_date'] = assignmentDate;
    data['assignment_submission_date'] = assignmentSubmissionDate;
    data['insert_date'] = insertDate;
    data['assignment_details'] = assignmentDetails;
    data['sub_name'] = subName;
    data['teacher_name'] = teacherName;
    data['chapter_name'] = chapterName;
    data['page_from'] = pageFrom;
    data['display_status'] = displayStatus;
    data['app_serial'] = appSerial;
    if (docList != null) {
      data['doc_list'] = docList!.map((v) => v.toJson()).toList();
    }
    data['teacher_image'] = teacherImage;
    return data;
  }
}

class DocList {
  String? appSerial;
  String? docPath;

  DocList({this.appSerial, this.docPath});

  DocList.fromJson(Map<String, dynamic> json) {
    appSerial = json['app_serial'];
    docPath = json['doc_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_serial'] = appSerial;
    data['doc_path'] = docPath;
    return data;
  }
}

class DataFee {
  String? amount;
  String? status;

  DataFee({this.amount, this.status});

  DataFee.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
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
