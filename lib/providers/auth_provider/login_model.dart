class LoginApiResponse {
  final String? responseString;
  final dynamic responseValue;
  final String? responseSuid;
  final String? responseString2;
  final String? responseString3;
  final dynamic responseResult;
  final dynamic responseResult2;
  final dynamic responseObject;
  final int? responseSubmit;
  final List<LoginUser> responseObject2;

  LoginApiResponse({
    this.responseString,
    this.responseValue,
    this.responseSuid,
    this.responseString2,
    this.responseString3,
    this.responseResult,
    this.responseResult2,
    this.responseObject,
    this.responseSubmit,
    required this.responseObject2,
  });

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) {
    return LoginApiResponse(
      responseString: json['responseString'],
      responseValue: json['responseValue'],
      responseSuid: json['responseSuid'],
      responseString2: json['responseString2'],
      responseString3: json['responseString3'],
      responseResult: json['responseResult'],
      responseResult2: json['responseResult2'],
      responseObject: json['responseObject'],
      responseSubmit: json['responseSubmit'],
      responseObject2: (json['responseObject2'] as List? ?? [])
          .map((e) => LoginUser.fromJson(e))
          .toList(),
    );
  }
}


class LoginUser {
  final String logintype;
  final String userid;
  final String username;
  final String empId;
  final String email;
  final String photo;
  final String createddate;
  final String roleid;
  final String position;
  final String tname;
  final String rolename;
  final String regno;
  final String sid;
  final String currentyearfrom;
  final String currentyearto;
  final String sessionstartdate;
  final String sessionenddate;

  LoginUser({
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

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      logintype: json['logintype'] ?? '',
      userid: json['userid'] ?? '',
      username: json['username'] ?? '',
      empId: json['empId'] ?? '0',
      email: json['email'] ?? '',
      photo: json['photo'] ?? '',
      createddate: json['createddate'] ?? '',
      roleid: json['roleid'] ?? '',
      position: json['position'] ?? '',
      tname: json['tname'] ?? '',
      rolename: json['rolename'] ?? '',
      regno: json['regno'] ?? '',
      sid: json['sid'] ?? '0',
      currentyearfrom: json['currentyearfrom'] ?? '',
      currentyearto: json['currentyearto'] ?? '',
      sessionstartdate: json['sessionstartdate'] ?? '',
      sessionenddate: json['sessionenddate'] ?? '',
    );
  }
}
