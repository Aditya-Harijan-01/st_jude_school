import 'dart:developer';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayService {
  static final RazorpayService _instance = RazorpayService._internal();
  factory RazorpayService() => _instance;
  RazorpayService._internal();

  Razorpay? _razorpay;
  bool _isInitialized = false;

  Function(PaymentSuccessResponse)? _onPaymentSuccess;
  Function(PaymentFailureResponse)? _onPaymentError;
  Function(ExternalWalletResponse)? _onExternalWallet;

  void initialize({
    required Function(PaymentSuccessResponse) onPaymentSuccess,
    required Function(PaymentFailureResponse) onPaymentError,
    required Function(ExternalWalletResponse) onExternalWallet,
  }) {
    if (_isInitialized) {
      _onPaymentSuccess = onPaymentSuccess;
      _onPaymentError = onPaymentError;
      _onExternalWallet = onExternalWallet;
      return;
    }

    _razorpay = Razorpay();
    _onPaymentSuccess = onPaymentSuccess;
    _onPaymentError = onPaymentError;
    _onExternalWallet = onExternalWallet;

    // Set up event listeners
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    _isInitialized = true;
  }

  // Handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onPaymentSuccess?.call(response);
  }

  // Handle payment error
  void _handlePaymentError(PaymentFailureResponse response) {
    _onPaymentError?.call(response);
  }

  // Handle external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    _onExternalWallet?.call(response);
  }

  Future<void> startPaymentWithApiData({
    required Map<String, dynamic> paymentData,
    required List<String> installmentIds,
  }) async {
    if (!_isInitialized) {
      throw Exception('RazorpayService not initialized. Call initialize() first.');
    }

    try {
      final amountInPaise = int.parse(paymentData['amount'].toString());
      final notes = paymentData['notes'] as Map<String, dynamic>;

      var options = {
        'key': paymentData['key_id'] ?? '',
        'amount': amountInPaise,
        'currency': 'INR',
        'name': paymentData['school_name'] ?? '',
        'image': paymentData['school_logo'] ?? '',
        'description': paymentData['description'] ?? '',
        'order_id': paymentData['order_id'] ?? '',
        'prefill': {
          'contact': paymentData['phone_no'] ?? '',
          'email': paymentData['email'] ?? '',
          'name': paymentData['student_name'] ?? '',
        },
        'theme': {
          'color': '#09826F',
        },
        'notes': notes,
        'retry': {'enabled': true, 'max_count': 1},
        'send_sms_hash': true,
        'remember_customer': false,
        'timeout': 180,
        'readonly': {
          'email': false,
          'contact': false,
          'name': false,
        },
        'hidden': {
          'email': false,
          'contact': false,
          'name': false,
        },
        'modal': {
          'confirm_close': true,
        },
      };
      log('option: $options');
      _razorpay!.open(options);
    } catch (e) {
      throw Exception('Error initiating payment: ${e.toString()}');
    }
  }

  void dispose() {
    if (_isInitialized && _razorpay != null) {
      _razorpay!.clear();
      _razorpay = null;
      _isInitialized = false;
      _onPaymentSuccess = null;
      _onPaymentError = null;
      _onExternalWallet = null;
    }
  }

  // Check if service is initialized
  bool get isInitialized => _isInitialized;
}