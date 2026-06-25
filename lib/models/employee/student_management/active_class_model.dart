
class ClassModel {
  final String classId;
  final String className;
  final String? stream;
  final String? section;
  final String grade;

  ClassModel({
    required this.classId,
    required this.className,
    this.stream,
    this.section,
    required this.grade,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    final classId = json['classid'] as String;
    final className = json['classname'] as String;

    final parsedData = _parseClassId(classId);

    return ClassModel(
      classId: classId,
      className: className,
      stream: parsedData['stream'],
      section: parsedData['section'],
      grade: parsedData['grade'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'classid': classId,
      'classname': className,
      'stream': stream,
      'section': section,
      'grade': grade,
    };
  }

  static Map<String, String?> _parseClassId(String classId) {
    // Split by double underscore first to handle cases like "10__C"
    List<String> parts = classId.split('__');

    if (parts.length == 2) {
      return {
        'grade': parts[0],
        'stream': null,
        'section': parts[1].isEmpty ? null : parts[1],
      };
    }

    parts = classId.split('_');

    if (parts.length == 3) {
      // Format: "grade_stream_section"
      return {
        'grade': parts[0],
        'stream': parts[1].isEmpty ? null : parts[1],
        'section': parts[2].isEmpty ? null : parts[2],
      };
    } else if (parts.length == 2) {
      // Format: "grade_stream_" (stream but no section)
      return {
        'grade': parts[0],
        'stream': parts[1].isEmpty ? null : parts[1],
        'section': null,
      };
    }

    return {
      'grade': classId,
      'stream': null,
      'section': null,
    };
  }

  @override
  String toString() {
    return 'ClassModel(classId: $classId, className: $className, grade: $grade, stream: $stream, section: $section)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassModel && other.classId == classId;
  }

  @override
  int get hashCode => classId.hashCode;
}

class ClassResponseModel {
  final String statusCode;
  final int statusCodeValue;
  final List<ClassModel> data;

  ClassResponseModel( {
    required this.statusCodeValue,
    required this.statusCode,
    required this.data,
  });

  factory ClassResponseModel.fromJson(Map<String, dynamic> json) {
    return ClassResponseModel(
      statusCode: json['statusCode'] as String,
      statusCodeValue: json['user_access_value'] as int,
      data: (json['data'] as List<dynamic>)
          .map((item) => ClassModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
  bool get isSuccess => statusCode.toLowerCase() == 'success';
}

