import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../../../../constants/constant.dart';
import '../../../../providers/common/get_api_kay.dart';
import '../payment_detail_screen.dart';


class PaymentVerificationService {

  static Future<Map<String, dynamic>?> confirmFeePayment({
    required String regno,
    required String fromyear,
    required String toyear,
    required String rcpshowno,
    required String rcpno,
    required String paymentId,
    required String orderId,
    required String signature,
    PaymentType? paymentType,
  }) async {
    final url = paymentType == PaymentType.fee ? 'ConfirmFeePayment' : 'ConfirmFinePayment';
    try {
      var headers = {
        'Content-Type': 'application/json'
      };

      var request = http.Request(
          'POST',
          Uri.parse('${ApiConfig.baseUrl}/$url')
      );

      request.body = json.encode({
        "regno": regno,
        "fromyear": fromyear,
        "toyear": toyear,
        "rcpshowno": rcpshowno,
        "rcpno": rcpno,
        "payment_id": paymentId,
        "order_id": orderId,
        "signature": signature
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        try {
          Map<String, dynamic> responseData = json.decode(responseBody);
          return responseData;
        } catch (e) {
          log('Error parsing response JSON: $e');
          return {
            'success': true,
            'message': 'Payment verified successfully',
            'raw_response': responseBody
          };
        }
      } else {
        String errorBody = await response.stream.bytesToString();
        return {
          'success': false,
          'message': 'Payment verification failed',
          'status_code': response.statusCode,
          'error': response.reasonPhrase,
          'error_body': errorBody
        };
      }
    } catch (e) {
      log('Payment verification exception: $e');
      return {
        'success': false,
        'message': 'Payment verification failed due to network error',
        'error': e.toString()
      };
    }
  }

  static Future<Map<String, dynamic>?> confirmTransportPayment({
    required String regno,
    required String fromyear,
    required String toyear,
    required String rcpshowno,
    required String rcpno,
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    try {
      final apiKey = ApiKeyDart().apiKeyModel?.apiKey;
      var headers = {
        'Content-Type': 'application/json',
        if (apiKey != null) 'ApiKey': apiKey,
      };

      var request = http.Request(
          'POST',
          Uri.parse('${ApiConfig.baseUrl}/ConfirmTransportPayment')
      );

      request.body = json.encode({
        "regno": regno,
        "fromyear": fromyear,
        "toyear": toyear,
        "rcpshowno": rcpshowno,
        "rcpno": rcpno,
        "payment_id": paymentId,
        "order_id": orderId,
        "signature": signature
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        log('Response Body: $responseBody');

        try {
          Map<String, dynamic> responseData = json.decode(responseBody);
          return responseData;
        } catch (e) {
          log('Error parsing response JSON: $e');
          return {
            'success': true,
            'message': 'Payment verified successfully',
            'raw_response': responseBody
          };
        }
      } else {
        String errorBody = await response.stream.bytesToString();
        return {
          'success': false,
          'message': 'Payment verification failed',
          'status_code': response.statusCode,
          'error': response.reasonPhrase,
          'error_body': errorBody
        };
      }
    } catch (e) {
      log('Payment verification exception: $e');
      return {
        'success': false,
        'message': 'Payment verification failed due to network error',
        'error': e.toString()
      };
    }
  }


  static Future<Map<String, dynamic>?> confirmEventPayment({
    required String regno,
    required String fromyear,
    required String toyear,
    required String rcpshowno,
    required String rcpno,
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    try {
      var headers = {
        'Content-Type': 'application/json'
      };

      var request = http.Request(
          'POST',
          Uri.parse('${ApiConfig.baseUrl}/ConfirmEventPayment')
      );

      request.body = json.encode({
        "regno": regno,
        "fromyear": fromyear,
        "toyear": toyear,
        "rcpshowno": rcpshowno,
        "rcpno": rcpno,
        "payment_id": paymentId,
        "order_id": orderId,
        "signature": signature
      });

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        log('Response Body: $responseBody');

        try {
          Map<String, dynamic> responseData = json.decode(responseBody);
          return responseData;
        } catch (e) {
          log('Error parsing response JSON: $e');
          return {
            'success': true,
            'message': 'Payment verified successfully',
            'raw_response': responseBody
          };
        }
      } else {
        String errorBody = await response.stream.bytesToString();
        return {
          'success': false,
          'message': 'Payment verification failed',
          'status_code': response.statusCode,
          'error': response.reasonPhrase,
          'error_body': errorBody
        };
      }
    } catch (e) {
      log('Payment verification exception: $e');
      return {
        'success': false,
        'message': 'Payment verification failed due to network error',
        'error': e.toString()
      };
    }
  }
  static Future<Map<String, dynamic>?> confirmHostelPayment({
    required String regno,
    required String fromyear,
    required String toyear,
    required String rcpshowno,
    required String rcpno,
    required String paymentId,
    required String orderId,
    required String signature,
  }) async {
    try {
      final apiKey = ApiKeyDart().apiKeyModel?.apiKey;
      var headers = {
        'Content-Type': 'application/json',
        if (apiKey != null) 'ApiKey': apiKey,
      };
      var request = http.Request(
          'POST',
          Uri.parse('${ApiConfig.baseUrl}/ConfirmHostelPayment')
      );

      request.body = json.encode({
        "regno": regno,
        "fromyear": fromyear,
        "toyear": toyear,
        "rcpshowno": rcpshowno,
        "rcpno": rcpno,
        "payment_id": paymentId,
        "order_id": orderId,
        "signature": signature
      });

      final body = {
        "regno": regno,
        "fromyear": fromyear,
        "toyear": toyear,
        "rcpshowno": rcpshowno,
        "rcpno": rcpno,
        "payment_id": paymentId,
        "order_id": orderId,
        "signature": signature,
      };

      log("REQUEST BODY: ${jsonEncode(body)}");



      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        log('Response Body: $responseBody');

        try {
          Map<String, dynamic> responseData = json.decode(responseBody);
          return responseData;
        } catch (e) {
          log('Error parsing response JSON: $e');
          return {
            'success': true,
            'message': 'Payment verified successfully',
            'raw_response': responseBody
          };
        }
      } else {
        String errorBody = await response.stream.bytesToString();
        return {
          'success': false,
          'message': 'Payment verification failed',
          'status_code': response.statusCode,
          'error': response.reasonPhrase,
          'error_body': errorBody
        };
      }
    } catch (e) {
      log('Payment verification exception: $e');
      return {
        'success': false,
        'message': 'Payment verification failed due to network error',
        'error': e.toString()
      };
    }
  }
}





// ConfirmTransportPayment