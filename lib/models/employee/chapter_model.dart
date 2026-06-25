class ChapterResponse {
  final String statusCode;
  final int userAccessValue;
  final List<ChapterData> data;

  ChapterResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory ChapterResponse.fromJson(Map<String, dynamic> json) {
    return ChapterResponse(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      data: List<ChapterData>.from(
        json['data'].map((item) => ChapterData.fromJson(item)),
      ),
    );
  }
}

class ChapterData {
  final String chapterId;
  final String chapterName;
  final String examId;
  final String examName;

  ChapterData({
    required this.chapterId,
    required this.chapterName,
    required this.examId,
    required this.examName,
  });

  factory ChapterData.fromJson(Map<String, dynamic> json) {
    return ChapterData(
      chapterId: json['chapter_id'],
      chapterName: json['chapter_name'],
      examId: json['exam_id'],
      examName: json['exam_name'],
    );
  }
}
