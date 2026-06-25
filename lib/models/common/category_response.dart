class CategoryResponse {
  final String statusCode;
  final int userAccessValue;
  final List<CategoryData> data;

  CategoryResponse({
    required this.statusCode,
    required this.userAccessValue,
    required this.data,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      statusCode: json['statusCode'],
      userAccessValue: json['user_access_value'],
      data: List<CategoryData>.from(
        json['data'].map((item) => CategoryData.fromJson(item)),
      ),
    );
  }
}

class CategoryData {
  final String typeId;
  final String typeName;

  CategoryData({
    required this.typeId,
    required this.typeName,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      typeId: json['type_id'],
      typeName: json['type_name'],
    );
  }
}
