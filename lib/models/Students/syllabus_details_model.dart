class SyllabusDetailsResponse {
  final String? statusCode;
  final String? message;
  final List<SyllabusData>? data;

  SyllabusDetailsResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory SyllabusDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SyllabusDetailsResponse(
      statusCode: json['statusCode'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => SyllabusData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'statusCode': statusCode,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}

class SyllabusData {
  final String? subId;
  final String? bookId;
  final String? bookName;
  final List<SyllabusItem>? syllabus;

  SyllabusData({
    this.subId,
    this.bookId,
    this.bookName,
    this.syllabus,
  });

  factory SyllabusData.fromJson(Map<String, dynamic> json) {
    return SyllabusData(
      subId: json['sub_id'] as String?,
      bookId: json['book_id'] as String?,
      bookName: json['book_name'] as String?,
      syllabus: (json['syllabus'] as List<dynamic>?)
          ?.map((e) => SyllabusItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'sub_id': subId,
        'book_id': bookId,
        'book_name': bookName,
        'syllabus': syllabus?.map((e) => e.toJson()).toList(),
      };
}

class SyllabusItem {
  final String? subId;
  final String? bookId;
  final String? bookName;
  final String? publisher;
  final String? chapterNo;
  final String? chapterName;
  final String? pages;
  final String? periods;
  final String? term;
  final String? examName;

  SyllabusItem({
    this.subId,
    this.bookId,
    this.bookName,
    this.publisher,
    this.chapterNo,
    this.chapterName,
    this.pages,
    this.periods,
    this.term,
    this.examName,
  });

  factory SyllabusItem.fromJson(Map<String, dynamic> json) {
    return SyllabusItem(
      subId: json['sub_id'] as String?,
      bookId: json['book_id'] as String?,
      bookName: json['book_name'] as String?,
      publisher: json['publisher'] as String?,
      chapterNo: json['chapter_no'] as String?,
      chapterName: json['chapter_name'] as String?,
      pages: json['pages'] as String?,
      periods: json['periods'] as String?,
      term: json['term'] as String?,
      examName: json['exam_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'sub_id': subId,
        'book_id': bookId,
        'book_name': bookName,
        'publisher': publisher,
        'chapter_no': chapterNo,
        'chapter_name': chapterName,
        'pages': pages,
        'periods': periods,
        'term': term,
        'exam_name': examName,
      };
}
