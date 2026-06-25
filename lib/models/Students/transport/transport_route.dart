class TransportCardResponse {
  final String statusCode;
  final List<CardData> cardData;

  TransportCardResponse({
    required this.statusCode,
    required this.cardData,
  });

  factory TransportCardResponse.fromJson(Map<String, dynamic> json) {
    return TransportCardResponse(
      statusCode: json['statusCode'],
      cardData: (json['cardData'] as List<dynamic>)
          .map((e) => CardData.fromJson(e))
          .toList(),
    );
  }
}

class CardData {
  final String routeid;
  final String pointid;
  final String busid;
  final String busRegNo;
  final List<StaffDetails> staffDetails;

  CardData({
    required this.routeid,
    required this.pointid,
    required this.busid,
    required this.busRegNo,

    required this.staffDetails,
  });

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      routeid: json['routeid'],
      pointid: json['pointid'],
      busid: json['busid'],
      busRegNo: json['bus_reg_no'],
      staffDetails: (json['staff_details'] as List<dynamic>)
          .map((e) => StaffDetails.fromJson(e))
          .toList(),
    );
  }
}

class StaffDetails {
  final String category;
  final String empName;
  final String phone;
  final String empCode;
  final String profileImage;

  StaffDetails({
    required this.category,
    required this.empName,
    required this.phone,
    required this.empCode,
    required this.profileImage,
  });

  factory StaffDetails.fromJson(Map<String, dynamic> json) {
    return StaffDetails(
      category: json['category'],
      empName: json['emp_name'],
      phone: json['phone'],
      empCode: json['emp_code'],
      profileImage: json['profile_image'],
    );
  }
}

///
/////////////////////////////////////////////
////////////////////////////////////////////
///


class RouteResponse {
  final String statusCode;
  final List<RouteInfo> cardData;

  RouteResponse({
    required this.statusCode,
    required this.cardData,
  });

  factory RouteResponse.fromJson(Map<String, dynamic> json) {
    return RouteResponse(
      statusCode: json['statusCode'],
      cardData: (json['cardData'] as List)
          .map((e) => RouteInfo.fromJson(e))
          .toList(),
    );
  }
}

class RouteInfo {
  final String routeId;
  final String routeCode;
  final String routeName;
  final String totalStopage;
  final List<StopPoint> stopPoints;

  RouteInfo({
    required this.routeId,
    required this.routeCode,
    required this.routeName,
    required this.totalStopage,
    required this.stopPoints,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      routeId: json['routeid'],
      routeCode: json['route_code'],
      routeName: json['route_name'],
      totalStopage: json['total_stopage'],
      stopPoints: (json['point_details'] as List)
          .map((e) => StopPoint.fromJson(e))
          .toList(),
    );
  }
}

class StopPoint {
  final String routeId;
  final String pointId;
  final String pointName;
  final String distanceFromSchool;

  StopPoint({
    required this.routeId,
    required this.pointId,
    required this.pointName,
    required this.distanceFromSchool,
  });

  factory StopPoint.fromJson(Map<String, dynamic> json) {
    return StopPoint(
      routeId: json['routeid'],
      pointId: json['point_id'],
      pointName: json['point_name'].trim(),
      distanceFromSchool: json['distance_from_school'],
    );
  }
}
