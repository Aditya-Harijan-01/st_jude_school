class LibraryIssueModel {
  final String statusCode;
  final String regno;
  final String sid;
  final List<IssueDetail> issueDetails;

  LibraryIssueModel({
    required this.statusCode,
    required this.regno,
    required this.sid,
    required this.issueDetails,
  });

  factory LibraryIssueModel.fromJson(Map<String, dynamic> json) {
    return LibraryIssueModel(
      statusCode: json['statusCode'] ?? '',
      regno: json['regno'] ?? '',
      sid: json['sid'] ?? '',
      issueDetails: (json['issue_details'] as List<dynamic>?)
              ?.map((e) => IssueDetail.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'regno': regno,
      'sid': sid,
      'issue_details': issueDetails.map((e) => e.toJson()).toList(),
    };
  }
}

class IssueDetail {
  final String bookIssueId;
  final String bookId;
  final String bookTitle;
  final String author;
  final String bookPrice;
  final String dewey;
  final String barcode;
  final String issueDate;
  final String returnDate;
  final String isReturn;
  final String actualReturnDate;
  final String note;
  final String imageUrl;

  IssueDetail({
    required this.bookIssueId,
    required this.bookId,
    required this.bookTitle,
    required this.author,
    required this.bookPrice,
    required this.dewey,
    required this.barcode,
    required this.issueDate,
    required this.returnDate,
    required this.isReturn,
    required this.actualReturnDate,
    required this.note,
    required this.imageUrl,
  });

  factory IssueDetail.fromJson(Map<String, dynamic> json) {
    return IssueDetail(
      bookIssueId: json['bookissueid'] ?? '',
      bookId: json['bookid'] ?? '',
      bookTitle: json['book_title'] ?? '',
      author: json['author'] ?? '',
      bookPrice: json['book_price'] ?? '',
      dewey: json['dewey'] ?? '',
      barcode: json['barcode'] ?? '',
      issueDate: json['issue_date'] ?? '',
      returnDate: json['return_date'] ?? '',
      isReturn: json['is_return'] ?? '',
      actualReturnDate: json['actual_return_date'] ?? '',
      note: json['note'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookissueid': bookIssueId,
      'bookid': bookId,
      'book_title': bookTitle,
      'author': author,
      'book_price': bookPrice,
      'dewey': dewey,
      'barcode': barcode,
      'issue_date': issueDate,
      'return_date': returnDate,
      'is_return': isReturn,
      'actual_return_date': actualReturnDate,
      'note': note,
      'image_url': imageUrl
    };
  }
}
