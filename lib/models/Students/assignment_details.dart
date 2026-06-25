class StudentAssignmentResponse {
  final String statusCode;
  final String? message;
  final List<StudentAssignment> data;

  StudentAssignmentResponse({
    required this.statusCode,
    this.message,
    required this.data,
  });

  factory StudentAssignmentResponse.fromJson(Map<String, dynamic> json) {
    return StudentAssignmentResponse(
      statusCode: json['statusCode'] ?? '',
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => StudentAssignment.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class StudentAssignment {
  final String className;
  final String stream;
  final String section;
  final String assignmentDate;
  final String assignmentSubmissionDate;
  final String insertDate;
  final String assignmentDetails;
  final String subjectName;
  final String teacherName;
  final String chapterName;
  final String pageFrom;
  final String displayStatus;
  final String appSerial;
  final List<AssignmentDocument> docList;
  final String teacherImage;

  StudentAssignment({
    required this.className,
    required this.stream,
    required this.section,
    required this.assignmentDate,
    required this.assignmentSubmissionDate,
    required this.insertDate,
    required this.assignmentDetails,
    required this.subjectName,
    required this.teacherName,
    required this.chapterName,
    required this.pageFrom,
    required this.displayStatus,
    required this.appSerial,
    required this.docList,
    required this.teacherImage,
  });

  factory StudentAssignment.fromJson(Map<String, dynamic> json) {
    return StudentAssignment(
      className: json['class_name'] ?? '',
      stream: json['stream'] ?? '',
      section: json['section'] ?? '',
      assignmentDate: json['assignment_date'] ?? '',
      assignmentSubmissionDate: json['assignment_submission_date'] ?? '',
      insertDate: json['insert_date'] ?? '',
      assignmentDetails: json['assignment_details'] ?? '',
      subjectName: json['sub_name'] ?? '',
      teacherName: json['teacher_name'] ?? '',
      chapterName: json['chapter_name'] ?? '',
      pageFrom: json['page_from'] ?? '',
      displayStatus: json['display_status'] ?? '',
      appSerial: json['app_serial'] ?? '',
      docList: (json['doc_list'] as List<dynamic>?)
              ?.map((item) => AssignmentDocument.fromJson(item))
              .toList() ??
          [],
      teacherImage: json['teacher_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'class_name': className,
        'stream': stream,
        'section': section,
        'assignment_date': assignmentDate,
        'assignment_submission_date': assignmentSubmissionDate,
        'insert_date': insertDate,
        'assignment_details': assignmentDetails,
        'sub_name': subjectName,
        'teacher_name': teacherName,
        'chapter_name': chapterName,
        'page_from': pageFrom,
        'display_status': displayStatus,
        'app_serial': appSerial,
        'doc_list': docList.map((e) => e.toJson()).toList(),
        'teacher_image': teacherImage,
      };
}

class AssignmentDocument {
  final String appSerial;
  final String docPath;

  AssignmentDocument({
    required this.appSerial,
    required this.docPath,
  });

  factory AssignmentDocument.fromJson(Map<String, dynamic> json) {
    return AssignmentDocument(
      appSerial: json['app_serial'] ?? '',
      docPath: json['doc_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'app_serial': appSerial,
        'doc_path': docPath,
      };
}
