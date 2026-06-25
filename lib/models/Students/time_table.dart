class TeacherTimetableModel {
  final String statusCode;
  final String? message;
  final List<TimetableData> data;

  TeacherTimetableModel({
    required this.statusCode,
    required this.data,
    this.message,
  });

  factory TeacherTimetableModel.fromJson(Map<String, dynamic> json) {
    return TeacherTimetableModel(
      statusCode: json['statusCode'] ?? '',
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TimetableData.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
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
  final String periodTime;
  final String roomNo;
  final String teacherImage;

  TimetableData({
    required this.subject,
    required this.teacher,
    required this.period,
    required this.parallelType,
    required this.parallelNo,
    required this.dayName,
    required this.periodTime,
    required this.roomNo,
    required this.teacherImage,
  });

  factory TimetableData.fromJson(Map<String, dynamic> json) {
    return TimetableData(
      subject: json['subject'] ?? '',
      teacher: json['teacher'] ?? '',
      period: json['period'] ?? '',
      parallelType: json['paralleltype'] ?? '',
      parallelNo: json['parallelno'] ?? '',
      dayName: json['day_name'] ?? '',
      periodTime: json['period_time'] ?? '',
      roomNo: json['room_no'] ?? '',
      teacherImage: json['teacher_image'] ?? '',
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
      'period_time': periodTime,
      'room_no': roomNo,
      'teacher_image': teacherImage,
    };
  }
}
