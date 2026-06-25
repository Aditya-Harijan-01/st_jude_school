class TransportResponseModel {
  final String statusCode;
  final String regNo;
  final String fromYear;
  final String toYear;
  final String isTransportTaken;
  final String routeId;
  final String registrationMode;

  final String pointId;
  final List<TransportPoint> defaultPointList;

  TransportResponseModel({
    required this.statusCode,
    required this.regNo,
    required this.fromYear,
    required this.toYear,
    required this.isTransportTaken,
    required this.routeId,
    required this.pointId,
    required this.registrationMode,
    required this.defaultPointList,
  });

  factory TransportResponseModel.fromJson(Map<String, dynamic> json) {
    return TransportResponseModel(
      statusCode: json['statusCode'] ?? '',
      regNo: json['regno'] ?? '',
      fromYear: json['fromyear'] ?? '',
      toYear: json['toyear'] ?? '',
      isTransportTaken: json['is_transport_taken'] ?? '',
      routeId: json['routeid'] ?? '',
      pointId: json['pointid'] ?? '',
      registrationMode: json['registration_mode'] ?? '',
      // registrationMode: 'off',

      defaultPointList: (json['default_point_list'] as List<dynamic>?)
              ?.map((e) => TransportPoint.fromJson(e))
              .toList() ??
          [],
    );
  }
}


class TransportPoint {
  final String pointId;
  final String pointName;
  final String distanceFromSchool;
  final String fromYear;
  final String toYear;
  final String totalStudent;
  final String totalCapacity;

  TransportPoint({
    required this.pointId,
    required this.pointName,
    required this.distanceFromSchool,
    required this.fromYear,
    required this.toYear,
    required this.totalStudent,
    required this.totalCapacity,
  });

  factory TransportPoint.fromJson(Map<String, dynamic> json) {
    return TransportPoint(
      pointId: json['pointid'] ?? '',
      pointName: json['pointname']?.trim() ?? '',
      distanceFromSchool: json['distance_from_school'] ?? '',
      fromYear: json['fromyear'] ?? '',
      toYear: json['toyear'] ?? '',
      totalStudent: json['total_student'] ?? '',
      totalCapacity: json['total_capacity'] ?? '',
    );
  }
}
