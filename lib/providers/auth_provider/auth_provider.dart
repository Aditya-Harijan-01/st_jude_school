import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart' as crypto;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../constants/constant.dart';
import '../../models/login_data.dart';
import '../common/get_api_kay.dart';
import '../student/get_student_profile.dart';
import 'login_model.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isCheck = false;
  String loginType = "";
  String userName = "";
  String userId = "";
  String pass = "";
  String sid = "";
  String value = "";
  String hashOtp = "";  
  String mobileNo = "";
  LoginResponse? loginResponse;
  LoginApiResponse? loginApiResponse;
  List<LoginUser>? loginUsers;
  LoginData? loginData;

  final box = GetStorage();

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void toggleRememberMe(bool value) {
    isCheck = value;
    notifyListeners(); // notifies UI to rebuild
  }


  //This is an generic function for the api POST funt. call for the login & the password screen.
  //This function takes only two input :---
  // 1. The API EndPoint
  // 2. The Body of the API call
  //And Return the Response the response it get from the API call. 

  Future<Map<String, dynamic>?> _postRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final String url = "${ApiConfig.baseUrl}$endpoint";
    final apiKey = ApiKeyDart().apiKeyModel?.apiKey;
    log(apiKey.toString());
    log("POST: $url\nBODY: ${jsonEncode(body)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          if (apiKey != null) 'ApiKey': apiKey, 
        },
        body: jsonEncode(body),
      );

      log("Response (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        log("Error ${response.statusCode}: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      log("HTTP error: $e");
      return null;
    }
  }

  Future<bool> login(String username) async {
    _setLoading(true);
    log("username: $username");
    final body = {
      "userid": 0,
      "empid": 0,
      "login": username,
      "usertype": "",
      "hash": "",
      "mobileno": ""
    };


    final data = await _postRequest(ApiEndpoints.authLogin, body);

    if (data != null && data["data"] != null) {
      final userData = data["data"];
      loginType = userData["logintype"] ?? "";
      userName = userData["username"] ?? "";
      userId = userData["userid"]?.toString() ?? "";
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }

  // The below function is here to call the Endpoint to get the user details for the app
  Future<bool> password(String passwordText, rem) async {
    _setLoading(true);

    // final comMenu = Provider.of<CommonMenuProvider>(context);

    // SHA-256 hash ( Encrypt the password into a hash )
    final passwordHash = crypto.sha256.convert(utf8.encode(passwordText)).toString();

    final body = {
      "userid": 0,
      "empid": 0,
      "login": userName,
      "usertype": loginType,
      "hash": passwordHash,
      "mobileno": ""
    };

    final data = await _postRequest(ApiEndpoints.authPassword, body);

    if (data != null) {
      loginResponse = LoginResponse.fromJson(data);
      loginData = loginResponse?.data;

      box.write("currentyearfrom", loginData!.currentyearfrom );
      box.write("currentyearto", loginData!.currentyearto );
      box.write("userid", loginData!.userid );
      box.write("type", loginData!.logintype);
      box.write("sid", loginData!.sid );
      box.write("tname", loginData!.tname );
      box.write("regno", loginData!.regno );
      box.write("email", loginData!.email );
      box.write("empId", loginData!.empId );
      box.write("roleid", loginData!.roleid );
      box.write("rolename", loginData!.rolename);
      box.write("sessionenddate", loginData!.sessionenddate);
      box.write("position", loginData!.position );
      box.write("sessionstartdate", loginData!.sessionstartdate);
      box.write("createddate", loginData!.createddate);


      if(loginData!.logintype == "Student"){
        addFcmToken(loginData!.sid, loginData!.logintype);
      } else {
        addFcmToken(loginData!.empId, loginData!.logintype);
      }
      
      if(isCheck) {
        box.write("remember", isCheck);
      }
      if (kDebugMode) {
        print(box.read("remember"));
      }
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }


  Future<bool> loadRememberedUser() async {
    bool remember = box.read("remember") ?? false;
    if (!remember) return false;

    loginData = LoginData(
      regno: box.read("regno") ?? '',
      currentyearfrom: box.read("currentyearfrom") ?? '',
      currentyearto: box.read("currentyearto") ?? '',
      userid: box.read("userid") ?? '',
      logintype: box.read("type") ?? '',
      sid: box.read("sid") ?? '',
      tname: box.read("tname") ?? '',
      username: box.read("username") ?? '',
      empId: box.read("empId") ?? '',
      email: box.read("email") ?? '',
      photo: box.read("photo") ?? '',
      createddate: box.read("createddate") ?? '',
      roleid: box.read("roleid") ?? '',
      position: box.read("position") ?? '',
      rolename: box.read("rolename") ?? '',
      sessionstartdate: box.read("sessionstartdate") ?? '',
      sessionenddate: box.read("sessionenddate") ?? '',
    );


    loginType = loginData?.logintype ?? "";
    userId = loginData?.userid ?? "";
    sid = loginData?.sid ?? "";

    return true;
  }


  Future<bool> forgotPassword(String username) async {
    _setLoading(true);

    final body = {
      "login": username,
      "pass": "string",
      "sid": "string",
      "mobile_no": "string",
      "value": "string",
      "hashotp": "string",
      "usertype": "string"
    };

    final data = await _postRequest(ApiEndpoints.forgotPassword, body);

    if (data != null &&
      data["statusCode"] == "Success" &&
      data["data"] != null &&
      (data["data"] as List).isNotEmpty) {
    
      final userData = data["data"][0];

      final login = userData["login"]?.toString() ?? "";
      final sid = userData["sid"]?.toString() ?? "";
      final mobile = userData["mobile_no"]?.toString() ?? "";
      final hashData = userData["hashotp"]?.toString() ?? "";
      final userType = userData["usertype"]?.toString() ?? "";

      loginType = userType;
      userName = login;
      userId = sid;
      hashOtp = hashData;
      mobileNo = mobile;

      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }



  Future<bool> addFcmToken(String ownerId, String type) async {
    // final box = GetStorage();
    _setLoading(true);

    try {
      String tok = box.read("Token") ?? "";
      if (tok == "") {
        return false;
      }

      final saveTokenUrl = ApiEndpoints.addFcmToken;
      String deviceName = "Unknown";

      try {
        final deviceInfo = DeviceInfoPlugin();

        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceName = "${androidInfo.manufacturer} ${androidInfo.model}";
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceName = "${iosInfo.name} ${iosInfo.model}";
        }
      } catch (e) {
        log("Device info error: $e");
      }

      final body = {
        "owner_id": ownerId,
        "fcmtype": type,
        "device_id": deviceName,
        "fcm": tok,
      };

      log("FCM Token Body: $body");

      final response = await _postRequest(saveTokenUrl, body);

      if (response != null &&
          response["statusCode"] == "Success" &&
          response["data"] is List &&
          response["data"].isNotEmpty) {
        
        final userData = response["data"][0];

        userName  = userData["login"]?.toString() ?? "";
        userId    = userData["sid"]?.toString() ?? "";
        mobileNo  = userData["mobile_no"]?.toString() ?? "";
        hashOtp   = userData["hashotp"]?.toString() ?? "";
        loginType = userData["usertype"]?.toString() ?? "";

        return true;
      }

      return false;
    } catch (e, s) {
      log("addFcmToken error: $e");
      log("StackTrace: $s");
      return false;
    } finally {
      _setLoading(false); // ✅ ALWAYS called
    }
  }


  Future<bool> generateOtp(String username) async {
    _setLoading(true);

    final body = {
      "userid": 0,
      "empid": 0,
      "login": "",
      "hash": "",
      'mobileno': username,
    };

    final data = await _postRequest(ApiEndpoints.generateOtp, body);

    if (data != null) {
      loginApiResponse = LoginApiResponse.fromJson(data);
      loginUsers = loginApiResponse?.responseObject2;

      hashOtp = loginApiResponse?.responseString ?? "";


      // if(loginData!.logintype == "Student"){
      //   addFcmToken(loginData!.sid, loginData!.logintype);
      // } else {
      //   addFcmToken(loginData!.empId, loginData!.logintype);
      // }
      
      // if(isCheck) {
      //   box.write("remember", isCheck);
      // }
      // if (kDebugMode) {
      //   print(box.read("remember"));
      // }
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }


  Future<bool> checkOtp(String otpText) async {
    _setLoading(true);

    // SHA-256 hash ( Encrypt the password into a hash )
    final passwordHash = crypto.sha256.convert(utf8.encode(otpText)).toString();

    if (hashOtp == passwordHash){
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }


  Future<List<LoginUser>?> checkOtpPhone(String otpText) async {
    _setLoading(true);

    final passwordHash =
        crypto.sha256.convert(utf8.encode(otpText)).toString();

    if (hashOtp == passwordHash) {
      _setLoading(false);
      return loginUsers; // 👈 return all users
    }

    _setLoading(false);
    return null;
  }


  void assignUser(LoginUser? user) {
    loginData = LoginData(
      regno: user!.regno,
      currentyearfrom: user.currentyearfrom,
      currentyearto: user.currentyearto,
      userid: user.userid,
      logintype: user.logintype,
      sid: user.sid,
      tname: user.tname,
      username: user.username,
      empId: user.empId,
      email: user.email,
      photo: user.photo,
      createddate: user.createddate,
      roleid: user.roleid,
      position: user.position,
      rolename: user.rolename,
      sessionstartdate: user.sessionstartdate,
      sessionenddate: user.sessionenddate,
    );


    loginType = loginData?.logintype ?? "";
    userId = loginData?.userid ?? "";
    sid = loginData?.sid ?? "";

    box.write("currentyearfrom", user.currentyearfrom);
    box.write("currentyearto", user.currentyearto);
    box.write("userid", user.userid);
    box.write("type", user.logintype);
    box.write("sid", user.sid);
    box.write("tname", user.tname);
    box.write("regno", user.regno);
    box.write("email", user.email);
    box.write("empId", user.empId);
    box.write("roleid", user.roleid);
    box.write("rolename", user.rolename);
    box.write("position", user.position);
    box.write("sessionstartdate", user.sessionstartdate);
    box.write("sessionenddate", user.sessionenddate);

    if (user.logintype == "Student") {
      addFcmToken(user.sid, user.logintype);
    } else {
      addFcmToken(user.empId, user.logintype);
    }
  }

  


  Future<bool> checkPassword(String pass, String setPass) async {
    _setLoading(true);

    if (pass == setPass){
      bool success = await changePassword(setPass);
      _setLoading(false);
      return success;
    }

    _setLoading(false);
    return false;
  }

  Future<bool> changePassword(String setPass) async {
    _setLoading(true);
    final passwordHash = crypto.sha256.convert(utf8.encode(setPass)).toString();

    final body = {
      "userid": userId,
      "empid": 0,
      "login": userName,
      "usertype": loginType,
      "hash": passwordHash,
      "mobileno": "string"
    };

    final data = await _postRequest(ApiEndpoints.changePassword, body);

    if (data!["statusCode"] == "Success") {
      _setLoading(false);
      return true;
    }

    _setLoading(false);
    return false;
  }


  Future<void> logOut (BuildContext context) async {
    box.erase();
    final student = Provider.of<StudentProfileProvider>(context, listen: false);
    student.profileOne = null;
    await clearAllData();
  }

  Future<void> clearAllData() async {
    await box.erase();
    isLoading = false;
    isCheck = false;
    loginType = "";
    userName = "";
    userId = "";
    pass = "";
    sid = "";
    value = "";
    hashOtp = "";
    mobileNo = "";
    loginResponse = null;
    loginData = null;
    notifyListeners();

    if (kDebugMode) {
      log("All Auth data cleared successfully");
    }
  }
}