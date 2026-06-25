import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../../constants/constant.dart';
import '../../../../providers/common/get_api_kay.dart';


//It is what it is ...
Future<String?> _postRequest({
  required String endpoint,
  required Map<String, dynamic> body,
  // bool useApiKey = false,
}) async {
  final String url = "${ApiConfig.baseUrl}$endpoint";
  final apiKey = ApiKeyDart().apiKeyModel?.apiKey;

  try {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (apiKey != null) 'ApiKey': apiKey,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    log('POST $url');
    log('Body: ${jsonEncode(body)}');
    log('Status: ${response.statusCode} | Response: ${response.body}');

    if (response.statusCode == 200) {
      return response.body;
    } else {
      log("API failed (${response.statusCode}): ${response.reasonPhrase}");
      return null;
    }
  } catch (e, stack) {
    log("Error in POST $endpoint: $e");
    log(stack.toString());
    return null;
  }
}

Future<String?> getInitiateFeePayment({
  required String regNo,
  required String fromYear,
  required String toYear,
  required String headId,
}) async {
  return _postRequest(
    endpoint: ApiEndpoints.getInitiateFeePayment,
    body: {
      "regno": regNo,
      "fromyear": fromYear,
      "toyear": toYear,
      "payname": "",
      "page": "",
      "fee_head_ids": headId,
    },
  );
}

Future<String?> getInitiateFinePayment({
  required String regNo,
  required String fromYear,
  required String toYear,
  required String headId,
}) async {
  return _postRequest(
    endpoint: ApiEndpoints.getInitiateFinePayment,
    body: {
      "regno": regNo,
      "fromyear": fromYear,
      "toyear": toYear,
      "payname": "",
      "page": "",
      "fee_head_ids": headId,
    },
  );
}

Future<String?> getInitiateTransportFeePayment({
  required String regNo,
  required String fromYear,
  required String toYear,
  required String feehead,
  required String feegroup,
  required String? point,
  required DateTime? busDate,
}) async {
  if (busDate == null) {
    log("Bus date is null. Aborting transport payment initiation.");
    return null;
  }

  final formattedDate = DateFormat('dd/MM/yyyy').format(busDate);

  return _postRequest(
    endpoint: ApiEndpoints.initiateTransportPayment,
    // useApiKey: true,
    body: {
      "regno": regNo,
      "fromyear": fromYear,
      "toyear": toYear,
      "pointid": point ?? "",
      "fee_head_ids": combineFeeIds(feehead, feegroup),
      "busdate": formattedDate,
    },
  );
}

Future<String?> getInitiateHostalPayment({
  required String regNo,
  required String fromYear,
  required String toYear,
  required String roomId,
  required String feeHeadIds,
  required String hostelDate,
}) async {
  return _postRequest(
    endpoint: ApiEndpoints.initiateHostelPayment,
    body: {
      "regno": regNo,
      "fromyear": fromYear,
      "toyear": toYear,
      "roomid": roomId,
      "fee_head_ids": feeHeadIds,
      "hosteldate": hostelDate,
    },
  );
}

String combineFeeIds(String feeheadIds, String feegroupIds) {
  final headList = feeheadIds.split(',').map((e) => e.trim()).toList();
  final groupList = feegroupIds.split(',').map((e) => e.trim()).toList();

  if (headList.length != groupList.length) {
    throw ArgumentError('feeheadIds and feegroupIds must have the same length');
  }

  final combined = List.generate(
    headList.length,
    (i) => '${headList[i]}_${groupList[i]}',
  );

  return combined.join(',');
}
