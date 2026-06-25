class AnnouncementCategoryResponse {
  final String statusCode;
  final List<AnnouncementCategory> data;

  AnnouncementCategoryResponse({
    required this.statusCode,
    required this.data,
  });

  factory AnnouncementCategoryResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementCategoryResponse(
      statusCode: json['statusCode'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => AnnouncementCategory.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class AnnouncementCategory {
  final String categoryId;
  final String categoryName;

  AnnouncementCategory({
    required this.categoryId,
    required this.categoryName,
  });

  factory AnnouncementCategory.fromJson(Map<String, dynamic> json) {
    return AnnouncementCategory(
      categoryId: json['category_id'] ?? '',
      categoryName: json['category_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'category_name': categoryName,
    };
  }
}

