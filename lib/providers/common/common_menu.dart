import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

import '../../constants/constant.dart';
import '../../models/common_menu_model.dart';
import 'common_post_method.dart';


class CommonMenuProvider extends ChangeNotifier {

StudentMenuResponse? studentMenuResponse;
List<StudentMenuItem>? studentMenu;
Future<bool> getCommonMenu(username, fromYear) async {


    // const String url = "${ApiConfig.baseUrl}${ApiEndpoints.getStudentProfile}";
    // log(url);

    final Map<String, dynamic> body = {
      "regno": username,
      "fromyear": fromYear
    };

    try {

      final data = await postRequest(ApiEndpoints.loadMenuStructure, body);

      if (data != null) {
        final menu = StudentMenuResponse.fromJson(data);
        studentMenuResponse = menu;
        studentMenu = menu.data?.cast<StudentMenuItem>() ?? [];
        
        studentMenu!.sort((a, b) {
          final orderA = int.tryParse(a.menuOrder ?? '0') ?? 0;
          final orderB = int.tryParse(b.menuOrder ?? '0') ?? 0;
          return orderA.compareTo(orderB);
        });

        // isLoading = false;
        // notifyListeners();
        return true;
      } else {
        // isLoading = false;
        // notifyListeners();
        return false;
      }
    } catch (e) {
      log("Get Common menu data error: $e");
      // isLoading = false;
      // notifyListeners();
      return false;
    }
  }
Future<bool> getCommonEmpMenu() async {


  // const String url = "${ApiConfig.baseUrl}${ApiEndpoints.getStudentProfile}";
  // log(url);

  final Map<String, dynamic> body = {
    "regno": "",
    "fromyear": ""
  };

  try {

    final data = await postRequest(ApiEndpoints.loadEmployeeMenuStructure, body);

    if (data != null) {
      final menu = StudentMenuResponse.fromJson(data);
      studentMenuResponse = menu;
      studentMenu = menu.data?.cast<StudentMenuItem>() ?? [];
      
      studentMenu!.sort((a, b) {
        final orderA = int.tryParse(a.menuOrder ?? '0') ?? 0;
        final orderB = int.tryParse(b.menuOrder ?? '0') ?? 0;
        return orderA.compareTo(orderB);
      });


      return true;
    } else {
      // isLoading = false;
      // notifyListeners();
      return false;
    }
  } catch (e) {
    log("Get Common menu data error: $e");
    // isLoading = false;
    // notifyListeners();
    return false;
  }
}



  Future<Widget> loadSvgWithHeader(String url, String apiKey) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'ApiKey': apiKey},
      );

      // Check if response is valid SVG content
      if (response.statusCode == 200 && response.body.contains('<svg')) {
        return SvgPicture.string(
          response.body,
          fit: BoxFit.contain,
        );
      } else {
        debugPrint("⚠️ Invalid SVG or response error: ${response.statusCode}");
        debugPrint(response.body.substring(0, response.body.length > 100 ? 100 : response.body.length));
        return Image.asset("assets/images/default_icon.png");
      }
    } catch (e) {
      debugPrint("❌ SVG Load Exception: $e");
      return Image.asset("assets/images/default_icon.png");
    }
  }

}