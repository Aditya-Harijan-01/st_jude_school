class BookResponse {
  final String statusCode;
  final int userAccessValue;
  final List<BookData> data;

  BookResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory BookResponse.fromJson(Map<String, dynamic> json) {
    return BookResponse(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      data: List<BookData>.from(
        json['data'].map((item) => BookData.fromJson(item)),
      ),
    );
  }
}

class BookData {
  final String bookId;
  final String bookName;

  BookData({
    required this.bookId,
    required this.bookName,
  });

  factory BookData.fromJson(Map<String, dynamic> json) {
    return BookData(
      bookId: json['book_id'],
      bookName: json['book_name'],
    );
  }
}
