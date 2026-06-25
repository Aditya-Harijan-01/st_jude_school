// student_menu_model.dart
class StudentMenuResponse {
  final String? statusCode;
  final String? message;
  final List<StudentMenuItem>? data;

  StudentMenuResponse({
    this.statusCode,
    this.message,
    this.data,
  });

  factory StudentMenuResponse.fromJson(Map<String, dynamic> json) {
    return StudentMenuResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List?)
          ?.map((e) => StudentMenuItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class StudentMenuItem {
  final String? menuKey;
  final String? menuName;
  final String? menuOrder;
  final String? isVisible;
  final String? iconUrl;

  StudentMenuItem({
    this.menuKey,
    this.menuName,
    this.menuOrder,
    this.isVisible,
    this.iconUrl,
  });

  factory StudentMenuItem.fromJson(Map<String, dynamic> json) {
    return StudentMenuItem(
      menuKey: json['menu_key'],
      menuName: json['menu_name'],
      menuOrder: json['menu_order'],
      isVisible: json['is_visible'],
      iconUrl: json['icon_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menu_key': menuKey,
      'menu_name': menuName,
      'menu_order': menuOrder,
      'is_visible': isVisible,
      'icon_url': iconUrl,
    };
  }
}
