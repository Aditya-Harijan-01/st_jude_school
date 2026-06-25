class GetSyllabusByBookResponse {
  final String statusCode;
  final int userAccessValue;
  final List<SyllabusChapter> data;

  GetSyllabusByBookResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory GetSyllabusByBookResponse.fromJson(Map<String, dynamic> json) {
    return GetSyllabusByBookResponse(
      statusCode: json['statusCode'] ?? '',
      userAccessValue: json['user_access_value'] is int
          ? json['user_access_value']
          : int.tryParse(json['user_access_value'].toString()) ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SyllabusChapter.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'user_access_value': userAccessValue,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class SyllabusChapter {
  final String slno;
  final String chapterNo;
  final String chapterName;
  final String pageFrom;
  final String period;
  final String examName;
  final String daExam;
  final String terminal;
  final String markFromPt;
  final String markFromTerm;
  final String syllabusId;
  final String subCode;
  final String bookId;

  SyllabusChapter({
    required this.slno,
    required this.chapterNo,
    required this.chapterName,
    required this.pageFrom,
    required this.period,
    required this.examName,
    required this.daExam,
    required this.terminal,
    required this.markFromPt,
    required this.markFromTerm,
    required this.syllabusId,
    required this.subCode,
    required this.bookId,
  });

  factory SyllabusChapter.fromJson(Map<String, dynamic> json) {
    return SyllabusChapter(
      slno: json['slno'] ?? '',
      chapterNo: json['chapter_no'] ?? '',
      chapterName: (json['chapter_name'] ?? '').trim(),
      pageFrom: json['page_from'] ?? '',
      period: json['period'] ?? '',
      examName: json['exam_name'] ?? '',
      daExam: json['da_Exam'] ?? '',
      terminal: json['terminal'] ?? '',
      markFromPt: json['mark_from_pt'] ?? '',
      markFromTerm: json['mark_from_term'] ?? '',
      syllabusId: json['syllabus_id'] ?? '',
      subCode: json['sub_code'] ?? '',
      bookId: json['bookid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slno': slno,
      'chapter_no': chapterNo,
      'chapter_name': chapterName,
      'page_from': pageFrom,
      'period': period,
      'exam_name': examName,
      'da_Exam': daExam,
      'terminal': terminal,
      'mark_from_pt': markFromPt,
      'mark_from_term': markFromTerm,
      'syllabus_id': syllabusId,
      'sub_code': subCode,
      'bookid': bookId,
    };
  }
}
