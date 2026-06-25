class CategoryResponse {
  final String statusCode;
  final List<CategoryType> data;

  CategoryResponse({
    required this.statusCode,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      statusCode: json['statusCode'] as String,
      data: (json['data'] as List)
          .map((e) => CategoryType.fromJson(e))
          .toList(),
    );
  }
}

class CategoryType {
  final String categoryType;
  final String categoryTypeName;
  final List<SubType> subTypes;

  CategoryType({
    required this.categoryType,
    required this.categoryTypeName,
    required this.subTypes,
  });

  factory CategoryType.fromJson(Map<String, dynamic> json) {
    return CategoryType(
      categoryType: json['category_type'] as String,
      categoryTypeName: json['category_type_name'] as String,
      subTypes: (json['sub_type'] as List)
          .map((e) => SubType.fromJson(e))
          .toList(),
    );
  }
}

class SubType {
  final String contentCategoryId;
  final String contentCategoryName;

  SubType({
    required this.contentCategoryId,
    required this.contentCategoryName,
  });

  factory SubType.fromJson(Map<String, dynamic> json) {
    return SubType(
      contentCategoryId: json['content_category_id'] as String,
      contentCategoryName: json['content_category_name'] as String,
    );
  }
}