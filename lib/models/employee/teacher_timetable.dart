class TeacherTimetableModel {
  final String statusCode;
  final List<TimetableData> data;

  TeacherTimetableModel({
    required this.statusCode,
    required this.data,
  });

  factory TeacherTimetableModel.fromJson(Map<String, dynamic> json) {
    return TeacherTimetableModel(
      statusCode: json['statusCode'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TimetableData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}


class TimetableData {
  final String subject;
  final String teacher;
  final String period;
  final String parallelType;
  final String parallelNo;
  final String dayName;
  final String teacherImage;
  final String className;
  final String streamName;
  final String section;

  TimetableData({
    required this.subject,
    required this.teacher,
    required this.period,
    required this.parallelType,
    required this.parallelNo,
    required this.dayName,
    required this.teacherImage,
    required this.className,
    required this.streamName,
    required this.section,
  });

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
      subject: json['subject'] ?? '',
      teacher: json['teacher'] ?? '',
      period: json['period'] ?? '',
      parallelType: json['paralleltype'] ?? '',
      parallelNo: json['parallelno'] ?? '',
      dayName: json['day_name'] ?? '',
      teacherImage: json['teacher_image'] ?? '',
      className: json['class_name'] ?? '',
      streamName: json['stream_name'] ?? '',
      section: json['section'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'teacher': teacher,
      'period': period,
      'paralleltype': parallelType,
      'parallelno': parallelNo,
      'day_name': dayName,
      'teacher_image': teacherImage,
      'class_name': className,
      'stream_name': streamName,
      'section': section,
    };
  }
}