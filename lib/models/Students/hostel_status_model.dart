class HostelStatusResponse {
  final String statusCode;
  final String regno;
  final String fromyear;
  final String toyear;
  final int isHostelTaken;
  final List<DefaultRoom> defaultRoomList;
  final List<ProcessedRoomId> roomId;

  HostelStatusResponse({
    required this.statusCode,
    required this.regno,
    required this.fromyear,
    required this.toyear,
    required this.isHostelTaken,
    required this.defaultRoomList,
    required this.roomId,
  });

  factory HostelStatusResponse.fromJson(Map<String, dynamic> json) {
    return HostelStatusResponse(
      statusCode: json['statusCode'] ?? '',
      regno: json['regno'] ?? '',
      fromyear: json['fromyear'] ?? '',
      toyear: json['toyear'] ?? '',
      isHostelTaken: json['is_hostel_taken'] ?? 0,
      defaultRoomList: (json['default_room_list'] as List<dynamic>?)
              ?.map((e) => DefaultRoom.fromJson(e))
              .toList() ??
          [],
      roomId: (json['roomId'] as List<dynamic>?)
              ?.map((e) => ProcessedRoomId.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DefaultRoom {
  final int roomId;
  final int sid;
  final String roomName;
  final int fromYear;
  final int toYear;
  final int status;
  final int totalStd;
  final int allowedStd;

  DefaultRoom({
    required this.roomId,
    required this.sid,
    required this.roomName,
    required this.fromYear,
    required this.toYear,
    required this.status,
    required this.totalStd,
    required this.allowedStd,
  });

  factory DefaultRoom.fromJson(Map<String, dynamic> json) {
    return DefaultRoom(
      roomId: json['roomId'] ?? 0,
      sid: json['sid'] ?? 0,
      roomName: json['roomName'] ?? '',
      fromYear: json['fromYear'] ?? 0,
      toYear: json['toYear'] ?? 0,
      status: json['status'] ?? 0,
      totalStd: json['totalStd'] ?? 0,
      allowedStd: json['allowedStd'] ?? 0,
    );
  }
}

class ProcessedRoomId {
  final int roomId;

  ProcessedRoomId({required this.roomId});

  factory ProcessedRoomId.fromJson(Map<String, dynamic> json) {
    return ProcessedRoomId(
      roomId: json['roomId'] ?? 0,
    );
  }
}
