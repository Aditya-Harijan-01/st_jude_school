class RemarkProfileClassResponse {
  String? statusCode;
  int? userAccessValue;
  List<RemarkProfileClass>? data;

  RemarkProfileClassResponse({this.statusCode, this.userAccessValue, this.data});

  RemarkProfileClassResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    userAccessValue = json['user_access_value'];
    if (json['data'] != null) {
      data = <RemarkProfileClass>[];
      json['data'].forEach((v) {
        data!.add(RemarkProfileClass.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['user_access_value'] = userAccessValue;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RemarkProfileClass {
  String? classId;
  String? className;

  RemarkProfileClass({this.classId, this.className});

  RemarkProfileClass.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class_id'] = classId;
    data['class_name'] = className;
    return data;
  }
}

class RemarkTermResponse {
  String? statusCode;
  int? userAccessValue;
  List<RemarkTerm>? data;

  RemarkTermResponse({this.statusCode, this.userAccessValue, this.data});

  RemarkTermResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    userAccessValue = json['user_access_value'];
    if (json['data'] != null) {
      data = <RemarkTerm>[];
      json['data'].forEach((v) {
        data!.add(RemarkTerm.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['user_access_value'] = userAccessValue;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RemarkTerm {
  String? examId;
  String? examName;

  RemarkTerm({this.examId, this.examName});

  RemarkTerm.fromJson(Map<String, dynamic> json) {
    examId = json['exam_id'];
    examName = json['exam_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['exam_id'] = examId;
    data['exam_name'] = examName;
    return data;
  }
}

class RemarkStudentEntryListResponse {
  String? statusCode;
  bool? success;
  String? message;
  List<RemarkStudentEntry>? data;

  RemarkStudentEntryListResponse({this.statusCode, this.success, this.message, this.data});

  RemarkStudentEntryListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RemarkStudentEntry>[];
      json['data'].forEach((v) {
        data!.add(RemarkStudentEntry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RemarkStudentEntry {
  String? remarkId;
  String? termId;
  String? sid;
  String? regno;
  String? studentName;
  String? accademicPercent;
  List<RemarkHead>? accademicRemarkHeads;
  bool? accademicSection;
  String? attendancePercent;
  List<RemarkHead>? attendanceRemarkHeads;
  bool? attendanceSection;
  List<RemarkHead>? resultRemarkHeads;
  bool? resultSection;

  RemarkStudentEntry({
    this.remarkId,
    this.termId,
    this.sid,
    this.regno,
    this.studentName,
    this.accademicPercent,
    this.accademicRemarkHeads,
    this.accademicSection,
    this.attendancePercent,
    this.attendanceRemarkHeads,
    this.attendanceSection,
    this.resultRemarkHeads,
    this.resultSection,
  });

  RemarkStudentEntry.fromJson(Map<String, dynamic> json) {
    remarkId = json['remark_id'];
    termId = json['term_id'];
    sid = json['sid'];
    regno = json['regno'];
    studentName = json['student_name'];
    accademicPercent = json['accademic_percent'];
    if (json['accademic_remark_heads'] != null) {
      accademicRemarkHeads = <RemarkHead>[];
      json['accademic_remark_heads'].forEach((v) {
        accademicRemarkHeads!.add(RemarkHead.fromJson(v));
      });
    }
    accademicSection = json['accademic_section'];
    attendancePercent = json['attendance_percent'];
    if (json['attendance_remark_heads'] != null) {
      attendanceRemarkHeads = <RemarkHead>[];
      json['attendance_remark_heads'].forEach((v) {
        attendanceRemarkHeads!.add(RemarkHead.fromJson(v));
      });
    }
    attendanceSection = json['attendance_section'];
    if (json['result_remark_heads'] != null) {
      resultRemarkHeads = <RemarkHead>[];
      json['result_remark_heads'].forEach((v) {
        resultRemarkHeads!.add(RemarkHead.fromJson(v));
      });
    }
    resultSection = json['result_section'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remark_id'] = remarkId;
    data['term_id'] = termId;
    data['sid'] = sid;
    data['regno'] = regno;
    data['student_name'] = studentName;
    data['accademic_percent'] = accademicPercent;
    if (accademicRemarkHeads != null) {
      data['accademic_remark_heads'] =
          accademicRemarkHeads!.map((v) => v.toJson()).toList();
    }
    data['accademic_section'] = accademicSection;
    data['attendance_percent'] = attendancePercent;
    if (attendanceRemarkHeads != null) {
      data['attendance_remark_heads'] =
          attendanceRemarkHeads!.map((v) => v.toJson()).toList();
    }
    data['attendance_section'] = attendanceSection;
    if (resultRemarkHeads != null) {
      data['result_remark_heads'] =
          resultRemarkHeads!.map((v) => v.toJson()).toList();
    }
    data['result_section'] = resultSection;
    return data;
  }
}

class RemarkHead {
  String? remarkHeadId;
  String? remarkHead;
  String? isAccademicRemarkSelected;
  String? isResultRemarkSelected;

  RemarkHead({
    this.remarkHeadId,
    this.remarkHead,
    this.isAccademicRemarkSelected,
    this.isResultRemarkSelected,
  });

  RemarkHead.fromJson(Map<String, dynamic> json) {
    remarkHeadId = json['remark_head_id'];
    remarkHead = json['remark_head'];
    isAccademicRemarkSelected = json['is_accademic_remark_selected'];
    isResultRemarkSelected = json['is_result_remark_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['remark_head_id'] = remarkHeadId;
    data['remark_head'] = remarkHead;
    data['is_accademic_remark_selected'] = isAccademicRemarkSelected;
    data['is_result_remark_selected'] = isResultRemarkSelected;
    return data;
  }
}
