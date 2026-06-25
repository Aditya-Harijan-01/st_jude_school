class AcademicCalendarResponse {
  final String? statusCode;
  final String? message;
  final List<AcademicDay>? data;
  final dynamic data1;

  AcademicCalendarResponse({
    this.statusCode,
    this.message,
    this.data,
    this.data1,
  });

  factory AcademicCalendarResponse.fromJson(Map<String, dynamic> json) {
    return AcademicCalendarResponse(
      statusCode: json['statusCode'] as String?,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AcademicDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
      'data1': data1,
    };
  }
}

class AcademicDay {
  final String? eDate;
  final List<EventName>? eventName;

  AcademicDay({
    this.eDate,
    this.eventName,
  });

  factory AcademicDay.fromJson(Map<String, dynamic> json) {
    return AcademicDay(
      eDate: json['e_date'] as String?,
      eventName: (json['event_name'] as List<dynamic>?)
          ?.map((e) => EventName.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'e_date': eDate,
      'event_name': eventName?.map((e) => e.toJson()).toList(),
    };
  }
}

class EventName {
  final String? eventDetails;
  final String? typeCode;

  EventName({
    this.eventDetails,
    this.typeCode,
  });

  factory EventName.fromJson(Map<String, dynamic> json) {
    return EventName(
      eventDetails: json['event_details'] as String?,
      typeCode: json['type_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_details': eventDetails,
      'type_code': typeCode,
    };
  }
}
