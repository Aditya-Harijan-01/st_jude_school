class AssignmentResponse {
  final String statusCode;
  final int userAccessValue;
  final List<AssignmentData> data;

  AssignmentResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory AssignmentResponse.fromJson(Map<String, dynamic> json) {
    return AssignmentResponse(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      data: List<AssignmentData>.from(
        json['data'].map((x) => AssignmentData.fromJson(x)),
      ),
    );
  }
}


class AssignmentData {
  final int appSerial;
  final String empId;
  final String teacherName;
  final String onBehalfOf;
  final String assignmentDate;
  final String submissionDate;
  final String assignmentDetails;
  final String className;
  final String stream;
  final String section;
  final String subjectId;
  final String subjectCode;
  final String subjectName;
  final String bookId;
  final String bookName;
  final String chapterId;
  final String chapterName;
  final String fromYear;
  final String toYear;
  final String profileImage;
  final List<AssignmentAttachment> assignmentAttachments;

  AssignmentData({
    required this.appSerial,
    required this.empId,
    required this.teacherName,
    required this.onBehalfOf,
    required this.assignmentDate,
    required this.submissionDate,
    required this.assignmentDetails,
    required this.className,
    required this.stream,
    required this.section,
    required this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.bookId,
    required this.bookName,
    required this.chapterId,
    required this.chapterName,
    required this.fromYear,
    required this.toYear,
    required this.profileImage,
    required this.assignmentAttachments,
  });

  factory AssignmentData.fromJson(Map<String, dynamic> json) {
    return AssignmentData(
      appSerial: json['appserial'] != null && json['appserial'] != false ? json['appserial'] : 0,
      empId: json['empid'],
      teacherName: json['teacher_name'],
      onBehalfOf: json['on_behalf_of'],
      assignmentDate: json['assignment_date'],
      submissionDate: json['submission_date'],
      assignmentDetails: json['asignment_details'],
      className: json['class_name'],
      stream: json['stream'],
      section: json['section'],
      subjectId: json['subject_id'],
      subjectCode: json['subject_code'],
      subjectName: json['subject_name'],
      bookId: json['book_id'],
      bookName: json['book_name'],
      chapterId: json['chapter_id'],
      chapterName: json['chapter_name'],
      fromYear: json['fromyear'],
      profileImage: json['profile_photo'],
      toYear: json['profile_photo'],
      assignmentAttachments: json['assignment_attachments'] != null
          ? List<AssignmentAttachment>.from(
              json['assignment_attachments'].map((x) => AssignmentAttachment.fromJson(x)))
          : [],
    );
  }
}


class AssignmentAttachment {
  final int appSerial;
  final String fileName;
  final String filePath;
  final String fileId;

  AssignmentAttachment({
    required this.appSerial,
    required this.fileName,
    required this.filePath,
    required this.fileId
  });

  factory AssignmentAttachment.fromJson(Map<String, dynamic> json) {
    return AssignmentAttachment(
      appSerial: json['appserial'],
      fileName: json['file_name'],
      filePath: json['file_path'] != null && json['file_path'] != false ? json['file_path'] : '',
      fileId: json['file_id'] != null && json['file_id'] != false ? json['file_id'].toString() : '',
    );
  }
}
