class ApiKeyModel {
  final String? statusCode;
  final String? apiKey;
  final int? version;
  final List<DataPermission>? dataPermission;

  ApiKeyModel({
    this.statusCode,
    this.apiKey,
    this.version,
    this.dataPermission,
  });

  factory ApiKeyModel.fromJson(Map<String, dynamic> json) {
    return ApiKeyModel(
      statusCode: json['statusCode'] as String?,
      apiKey: json['apiKey'] as String?,
      version: json['version'] is int
          ? json['version']
          : int.tryParse(json['version']?.toString() ?? ''),
      dataPermission: json['dataPermission'] != null
          ? (json['dataPermission'] as List)
              .map((e) => DataPermission.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'apiKey': apiKey,
      'version': version,
      'dataPermission': dataPermission?.map((e) => e.toJson()).toList(),
    };
  }
}

class DataPermission {
  final String? moduleCode;
  final String? moduleName;
  final int? moduleStatus;

  DataPermission({
    this.moduleCode,
    this.moduleName,
    this.moduleStatus,
  });

  factory DataPermission.fromJson(Map<String, dynamic> json) {
    return DataPermission(
      moduleCode: json['module_code'] as String?,
      moduleName: json['module_name'] as String?,
      moduleStatus: json['module_status'] is int
          ? json['module_status']
          : int.tryParse(json['module_status']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module_code': moduleCode,
      'module_name': moduleName,
      'module_status': moduleStatus,
    };
  }
}
