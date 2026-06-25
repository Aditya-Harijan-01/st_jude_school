class LoginResponse {
  final String statusCode;
  final LoginData? data;
  final dynamic data1;

  LoginResponse({
    required this.statusCode,
    this.data,
    this.data1,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'] ?? '',
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      data1: json['data1'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data?.toJson(),
      'data1': data1,
    };
  }
}

class LoginData {
  final String logintype;
  final String userid;
  final String username;
  final String empId;
  final String email;
  final String photo;
  final String createddate;
  final dynamic roleid;
  final dynamic position;
  final dynamic tname;
  final dynamic rolename;
  final String regno;
  final String sid;
  final String currentyearfrom;
  final String currentyearto;
  final String sessionstartdate;
  final String sessionenddate;

  LoginData({
    required this.logintype,
    required this.userid,
    required this.username,
    required this.empId,
    required this.email,
    required this.photo,
    required this.createddate,
    required this.roleid,
    required this.position,
    required this.tname,
    required this.rolename,
    required this.regno,
    required this.sid,
    required this.currentyearfrom,
    required this.currentyearto,
    required this.sessionstartdate,
    required this.sessionenddate,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      logintype: json['logintype'] ?? '',
      userid: json['userid'] ?? '',
      username: json['username'] ?? '',
      empId: json['empId'] ?? '',
      email: json['email'] ?? '',
      photo: json['photo'] ?? '',
      createddate: json['createddate'] ?? '',
      roleid: json['roleid'],
      position: json['position'],
      tname: json['tname'],
      rolename: json['rolename'],
      regno: json['regno'] ?? '',
      sid: json['sid'] ?? '',
      currentyearfrom: json['currentyearfrom'] ?? '',
      currentyearto: json['currentyearto'] ?? '',
      sessionstartdate: json['sessionstartdate'] ?? '',
      sessionenddate: json['sessionenddate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logintype': logintype,
      'userid': userid,
      'username': username,
      'empId': empId,
      'email': email,
      'photo': photo,
      'createddate': createddate,
      'roleid': roleid,
      'position': position,
      'tname': tname,
      'rolename': rolename,
      'regno': regno,
      'sid': sid,
      'currentyearfrom': currentyearfrom,
      'currentyearto': currentyearto,
      'sessionstartdate': sessionstartdate,
      'sessionenddate': sessionenddate,
    };
  }
}
