// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../../../constants/colors.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/common/RazorPay_Services.dart';
import '../../../../providers/student/transport_provider.dart';
import '../../payment/utils/get_initial_payment.dart';
import '../../payment/utils/payment_date_utils.dart';
import '../../payment/utils/verification.dart';
import '../../payment/widgets/success_payment.dart';




class TransportPaymentDetailPage extends StatefulWidget {
  final String? selectedFromYear;
  final String? selectedToYear;

  final TransportProvider? feeStructureProvider;
  final List<String> selectedInstallmentIds;
  final double totalAmount;
  final String feegroupId;
  final String feeheadId;
  final String? point;
  final DateTime? busdate;

  const TransportPaymentDetailPage({
    super.key,
    this.feeStructureProvider,
    required this.selectedInstallmentIds,
    required this.totalAmount,
    required this.selectedFromYear,
    required this.selectedToYear, 
    required this.feegroupId, 
    required this.feeheadId, 
    required this.busdate, 
    required  this.point,
  });

  @override
  State<TransportPaymentDetailPage> createState() => _TransportPaymentDetailPageState();
}

class _TransportPaymentDetailPageState extends State<TransportPaymentDetailPage> {
  bool _isLoading = false;
  bool _isPaymentProcessing = false;
  bool _isVerifying = false;
  Map<String, dynamic>? _paymentData;
  String? _errorMessage;
  late RazorpayService _razorpayService;

  @override
  void initState() {
    super.initState();
    _razorpayService = RazorpayService();
    _initializeRazorpay();
    _initiatePayment();
  }

  void _initializeRazorpay() {
    _razorpayService.initialize(
      onPaymentSuccess: _handlePaymentSuccess,
      onPaymentError: _handlePaymentError,
      onExternalWallet: _handleExternalWallet,
    );
  }

  void _handlePaymentSuccess(response) {
    setState(() {
      _isPaymentProcessing = false;
      _isVerifying = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Successful! Verifying payment...'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    _handlePaymentVerification(response);
  }

  void _handlePaymentError(response) {
    setState(() {
      _isPaymentProcessing = false;
    });

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message ?? 'Unknown error'}'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      ),
    );    
  }

  void _handleExternalWallet(response) {
    setState(() {
      _isPaymentProcessing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('External Wallet Selected: ${response.walletName}'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Future<void> _handlePaymentVerification(response) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final data = _paymentData!;

      final verificationResult = await PaymentVerificationService.confirmTransportPayment(
        regno: authProvider.loginData!.regno,
        fromyear: authProvider.loginData!.currentyearfrom,
        toyear:  authProvider.loginData!.currentyearto,
        rcpshowno: data['rcpno_show'] ?? '',
        rcpno: data['rcpno'] ?? '',
        paymentId: response.paymentId ?? '',
        orderId: response.orderId ?? '',
        signature: response.signature ?? '',
      );


      setState(() {
        _isVerifying = false;
      });

      if (verificationResult != null) {
        if (verificationResult['success'] == true ||
            verificationResult['statusCode'] == 'Success' ||
            verificationResult['status'] == 'success') {

          _showVerificationSuccessDialog(response, verificationResult);
        } else {
          _showVerificationFailureDialog(response, verificationResult);
        }
      } else {
        // No response from verification API
        _showVerificationFailureDialog(response, {'message': 'No response from verification server'});
      }

    }  catch (e) {
      setState(() {
        _isVerifying = false;
      });

      log('Payment verification error: $e');
      _showVerificationFailureDialog(response, {'message': 'Verification failed: $e'});
    }
  }

  void _showVerificationSuccessDialog(response, Map<String, dynamic> verificationResult) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          paymentData: verificationResult,
          title: "transport"
        ),
      ),
    );
  }

  void _showVerificationFailureDialog(response, Map<String, dynamic> verificationResult) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: screenWidth * 0.08),
              SizedBox(width: screenWidth * 0.03),
              Text('Verification Issue'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your payment was successful but there was an issue with verification.'),
              SizedBox(height: screenHeight * 0.015),
              Text('Payment ID: ${response.paymentId}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Order ID: ${response.orderId}', style: TextStyle(fontWeight: FontWeight.bold)),
              if (verificationResult['message'] != null)
                Text('Error: ${verificationResult['message']}'),
              SizedBox(height: screenHeight * 0.015),
              Text('Please contact support with your payment ID if needed.',
                  style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVerificationLoadingScreen() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation (you'll need to add this asset)
            SizedBox(
              height: screenHeight * 0.25,
              width: screenWidth * 0.6,
              child: Lottie.asset(
                'assets/animation/Searching.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            Text(
              'Verifying Payment...',
              style: TextStyle(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.bold,
                color: CustomColor.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.015),

            // Subtitle
            Text(
              'Please wait while we confirm your payment',
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.03),

            SizedBox(
              width: screenWidth * 0.6,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(CustomColor.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _initiatePayment() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // final trans = Provider.of<TransportProvider>(context, listen: false);

      String? response;

      // if (widget.paymentType == PaymentType.fee) {
        // final formattedHeadIds = trans.combineFeeIds(widget.sele);


        response = await getInitiateTransportFeePayment(
          regNo: authProvider.loginData!.regno,
          fromYear: authProvider.loginData!.currentyearfrom,
          toYear: authProvider.loginData!.currentyearto,
          feehead: widget.feeheadId,
          feegroup: widget.feegroupId,
          point: widget.point,
          busDate: widget.busdate,
        );

      if (response != null) {
        log(response);
        final decodedResponse = jsonDecode(response);
        if (decodedResponse['statusCode'] == 'Success') {
          setState(() {
            _paymentData = decodedResponse;
          });
        } else {
          setState(() {
            _errorMessage = 'Payment initiation failed';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to initiate payment';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _startPayment() async {
    if (_paymentData == null) return;

    setState(() {
      _isPaymentProcessing = true;
    });

    try {
      final data = _paymentData!;
      await _razorpayService.startPaymentWithApiData(
        paymentData: data,
        installmentIds: widget.selectedInstallmentIds,
      );

      // await Future.delayed(Duration(seconds: 2));
      // _handlePaymentSuccess();
      
    } catch (e) {
      setState(() {
        _isPaymentProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error starting payment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // String _getPageTitle() {
  //   switch (widget.paymentType) {
  //     case PaymentType.fee:
  //       return 'Fee Payment Receipt';
  //     case PaymentType.fine:
  //       return 'Fine Payment Receipt';
  //   }
  // }

  @override
  void dispose() {
    // Dispose Razorpay service
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isVerifying ? null : AppBar(
        title: Text("Transport"),
        titleTextStyle: TextStyle(
            fontSize: screenHeight * 0.025
        ),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isVerifying
          ? _buildVerificationLoadingScreen()
          : _isLoading
          ? Center(child: Lottie.asset(
            'assets/animation/Loading_pay.json',
            fit: BoxFit.contain,
            repeat: true,
          ))
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: screenWidth * 0.16, color: Colors.red),
            SizedBox(height: screenHeight * 0.02),
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red, fontSize: screenHeight * 0.02),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: _initiatePayment,
              child: Text('Retry'),
            ),
          ],
        ),
      )
          : _paymentData != null
          ? (_paymentData!['is_duplicate_payment_status'] == 1
              ? _buildDuplicatePaymentDialog()
              : _buildReceiptView())
          : Center(child: Text('No data available')),
    );
  }

  Widget _buildReceiptView() {
    final data = _paymentData!;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Receipt Container
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
            ),
            child: Column(
              children: [
                _buildReceiptHeader(data),
                _buildStudentSection(data),
                _buildFeeDetailsSection(data),
                _buildPaymentSummarySection(data),
                _buildReceiptFooter(data),
              ],
            ),
          ),

          SizedBox(height: screenHeight * 0.03),

          // Proceed to Payment Button
          _buildProceedButton(data),
        ],
      ),
    );
  }

  Widget _buildReceiptHeader(Map<String, dynamic> data) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          // School Logo
          if (data['school_logo'] != null)
            SizedBox(
              height: screenHeight * 0.075,
              width: screenHeight * 0.075,
              child: Image.network(
                PaymentDateUtils.cleanUrl(data['school_logo']),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.school,
                  size: screenWidth * 0.1,
                  color: CustomColor.primaryColor,
                ),
              ),
            ),
          SizedBox(height: screenHeight * 0.01),

          // School Name
          Text(
            data['school_name'] ?? '',
            style: TextStyle(
              fontSize: screenHeight * 0.022,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: screenHeight * 0.015),

          // Receipt Number and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Receipt No: ${data['rcpno_show'] ?? 'N/A'}',
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Date: ${DateTime.now().toString().split(' ')[0]}',
                style: TextStyle(
                  fontSize: screenHeight * 0.015,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudentSection(Map<String, dynamic> data) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STUDENT DETAILS',
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),

          _buildReceiptRow('Student Name', data['student_name']),
          _buildReceiptRow('Reg No.', data['notes']?['regNo']),
          _buildReceiptRow('Class', '${data['class_name']} - ${data['section']}'),
          _buildReceiptRow('Academic Year', '${data['fromyear']} - ${data['toyear']}'),
          _buildReceiptRow('Phone', data['phone_no']),
          _buildReceiptRow('Email', data['email']),
        ],
      ),
    );
  }

  Widget _buildFeeDetailsSection(Map<String, dynamic> data) {
    final feeHeadDescription = data['fee_head_description'] as List<dynamic>? ?? [];
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TRANSPORT FEE BREAKDOWN",
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
              color: CustomColor.primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),

          Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(screenWidth * 0.015),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    '  Description',
                    style: TextStyle(
                      fontSize: screenWidth * 0.028,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: screenWidth * 0.028,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Concession',
                    style: TextStyle(
                      fontSize: screenWidth * 0.028,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Payable',
                    style: TextStyle(
                      fontSize: screenWidth * 0.028,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01),

          // Fee Items
          ...feeHeadDescription.map((fee) => _buildFeeItem(
            fee['fee_head_name'],
            fee['part_amount'],
            fee['concession'],
            fee['payable'],
          )),
        ],
      ),
    );
  }

  Widget _buildFeeItem(String name, String amount, String concession, String payable) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              name,
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹$amount',
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹$concession',
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.w500,
                color: Colors.green[600],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '₹$payable',
              style: TextStyle(
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.bold,
                color: CustomColor.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummarySection(Map<String, dynamic> data) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow('Total Amount', '₹${data['total_amount']}'),
          _buildSummaryRow('Total Concession', '₹${data['total_concession']}', isDiscount: true),
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.01),
            child: Container(
              height: 1,
              color: CustomColor.colorGrey,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: screenHeight * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL PAYABLE',
                  style: TextStyle(
                    fontSize: screenHeight * 0.018,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '₹${data['total_payable']}',
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    fontWeight: FontWeight.bold,
                    color: CustomColor.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptFooter(Map<String, dynamic> data) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          Text(
            'Please wait after successful payment for Transport fee Receipt.',
            style: TextStyle(
              fontSize: screenHeight * 0.015,
              fontWeight: FontWeight.w500,
              color: CustomColor.colorRed,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String? value) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.005),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * 0.3,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: screenHeight * 0.015,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: screenHeight * 0.015,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isDiscount = false}) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
              color: isDiscount ? Colors.green[600] : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton(Map<String, dynamic> data) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      width: double.infinity,
      height: screenHeight * 0.07,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColor.primaryColor, CustomColor.primaryColor.withOpacity(0.8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: CustomColor.primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        // onPressed: ()=>{},
        onPressed: (_isPaymentProcessing || _isVerifying) ? null : _startPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: CustomColor.colorWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
        ),
        child: _isPaymentProcessing
            ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.05,
              height: screenWidth * 0.05,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(CustomColor.colorWhite),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Text(
              'Processing...',
              style: TextStyle(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.payment, size: screenWidth * 0.06),
            SizedBox(width: screenWidth * 0.03),
            Text(
              'Proceed to Payment',
              style: TextStyle(
                fontSize: screenHeight * 0.02,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuplicatePaymentDialog() {
    final screenWidth = MediaQuery.of(context).size.width;
    final message = _paymentData!['is_duplicate_payment_message'] ?? 'Duplicate payment detected. Please contact support.';

    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: CustomColor.colorWhite,
              title: Row(
                children: [
                  Icon(Icons.warning, color: CustomColor.primaryColor, size: screenWidth * 0.08),
                  SizedBox(width: screenWidth * 0.03),
                  Text('Warning'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Go back to previous screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColor.primaryColor,
                    foregroundColor: CustomColor.colorWhite,
                  ),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
      );
    });
    
    // Return an empty container since the dialog will be shown
    return Container();
  }
}

