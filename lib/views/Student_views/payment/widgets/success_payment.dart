// ignore_for_file: deprecated_member_use

import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../hostel/hostel_payment_screen.dart';
import '../../transport/transport.dart';
import '../payment.dart';


class ResponsiveConstants {
  static double getWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

  // Responsive multipliers
  static double getResponsiveMultiplier(BuildContext context) {
    double width = getWidth(context);
    if (width < 360) return 0.85;
    if (width < 400) return 0.9;
    if (width < 600) return 1.0;
    if (width < 900) return 1.1;
    return 1.2;
  }

  // Font Sizes
  static double getTitleFontSize(BuildContext context) => 18 * getResponsiveMultiplier(context);
  static double getSubtitleFontSize(BuildContext context) => 13 * getResponsiveMultiplier(context);
  static double getAmountFontSize(BuildContext context) => 18 * getResponsiveMultiplier(context);

  // Spacing
  static double getHorizontalPadding(BuildContext context) => 16 * getResponsiveMultiplier(context);
  static double getVerticalPadding(BuildContext context) => 8 * getResponsiveMultiplier(context);
  static double getCardMargin(BuildContext context) => 12 * getResponsiveMultiplier(context);
  static double getBorderRadius(BuildContext context) => 12 * getResponsiveMultiplier(context);
  static double getIconSize(BuildContext context) => 16 * getResponsiveMultiplier(context);
  static double getCheckboxSize(BuildContext context) => 24 * getResponsiveMultiplier(context);
  static double getCheckboxLargeSize(BuildContext context) => 25 * getResponsiveMultiplier(context);

  // Heights
  static double getShimmerTitleHeight(BuildContext context) => 18 * getResponsiveMultiplier(context);
  static double getShimmerSubtitleHeight(BuildContext context) => 13 * getResponsiveMultiplier(context);
  static double getShimmerAmountHeight(BuildContext context) => 18 * getResponsiveMultiplier(context);

  // Widths
  static double getShimmerSubtitleWidth(BuildContext context) => 40 * getResponsiveMultiplier(context);
  static double getShimmerAmountWidth(BuildContext context) => 80 * getResponsiveMultiplier(context);

  // Spacing constants
  static double getSmallSpacing(BuildContext context) => 4 * getResponsiveMultiplier(context);
  static double getMediumSpacing(BuildContext context) => 12 * getResponsiveMultiplier(context);
  static double getLargeSpacing(BuildContext context) => 20 * getResponsiveMultiplier(context);

  // Additional responsive methods for this screen
  static double getSuccessHeaderFontSize(BuildContext context) => 28 * getResponsiveMultiplier(context);
  static double getPaymentDetailsFontSize(BuildContext context) => 22 * getResponsiveMultiplier(context);
  static double getDetailRowFontSize(BuildContext context) => 14 * getResponsiveMultiplier(context);
  static double getLottieSize(BuildContext context) => 150 * getResponsiveMultiplier(context);
  static double getButtonHeight(BuildContext context) => 48 * getResponsiveMultiplier(context);
}

class PaymentSuccessScreen extends StatefulWidget {
  final Map<String, dynamic> paymentData;
  final String title;

  const PaymentSuccessScreen({
    super.key,
    required this.paymentData,
    required this.title
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();


    // Initialize fade animation
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Initialize slide animation
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    // Start animations with delay
    Future.delayed(Duration(milliseconds: 500), () {
      _fadeController.forward();
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Section with Success Animation
            Expanded(
              flex: 2,
              child: _buildSuccessHeader(),
            ),

            // Payment Details Section
            Expanded(
              flex: 4,
              child: _buildPaymentDetails(),
            ),

            // Bottom Actions
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CustomColor.primaryColor,
            CustomColor.primaryOne,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Success Lottie Animation
          SizedBox(
            width: ResponsiveConstants.getLottieSize(context),
            height: ResponsiveConstants.getLottieSize(context),
            child: Lottie.network(
              'https://assets9.lottiefiles.com/packages/lf20_jbrw3hcz.json', // Success tick animation
              repeat: true,
              animate: true,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: ResponsiveConstants.getLottieSize(context) * 0.5,
                  height: ResponsiveConstants.getLottieSize(context) * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle,
                    size: ResponsiveConstants.getLottieSize(context) * 0.4,
                    color: CustomColor.primaryColor,
                  ),
                );
              },
            ),
          ),

          SizedBox(height: ResponsiveConstants.getMediumSpacing(context)),

          // Success Text
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: ResponsiveConstants.getSuccessHeaderFontSize(context),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentDetails() {
    String rawFeeGroupName = widget.paymentData['fee_group_name'] ?? '';
    List<String> feeGroups = rawFeeGroupName.split('|').map((e) => e.trim()).toList();

    if (feeGroups.isNotEmpty && feeGroups.last.toLowerCase() == 'trn') {
      feeGroups.removeLast();
    }

    String displayFeeGroupName = feeGroups.join(' | ');
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: EdgeInsets.all(ResponsiveConstants.getCardMargin(context)),
          padding: EdgeInsets.all(ResponsiveConstants.getHorizontalPadding(context)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveConstants.getBorderRadius(context)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Details',
                style: TextStyle(
                  fontSize: ResponsiveConstants.getPaymentDetailsFontSize(context),
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3A47),
                ),
              ),
              SizedBox(height: ResponsiveConstants.getLargeSpacing(context)),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDetailRow('Student Name', widget.paymentData['student_name'] ?? ''),
                      _buildDetailRow('Registration No.', widget.paymentData['regno'] ?? ''),
                      _buildDetailRow('Class', widget.paymentData['class_name'] ?? ''),
                      _buildDetailRow('Academic Year', '${widget.paymentData['fromyear'] ?? ''} - ${widget.paymentData['toyear'] ?? ''}'),
                      _buildDetailRow('Fee Group', displayFeeGroupName),
                      // _buildDetailRow('Fee Group', widget.paymentData['fee_group_name'] ?? ''),
                      _buildDetailRow('Amount Paid', '₹${widget.paymentData['amount'] ?? ''}', isAmount: true),
                      _buildDetailRow('Payment Date', widget.paymentData[''] ?? DateTime.now().toString().split(' ')[0]),
                      _buildDetailRow('Receipt No.', widget.paymentData['rcpshowno'] ?? ''),
                      _buildDetailRow('Payment Mode', widget.paymentData['transaction_method'] ?? ''),
                      _buildDetailRow('Transaction No.', widget.paymentData['transaction_no'] ?? ''),
                      if (widget.paymentData['bank_name'] != null && widget.paymentData['bank_name'].isNotEmpty)
                        _buildDetailRow('Bank Name', widget.paymentData['bank_name']),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget _buildDetailRow(String label, String value, {bool isAmount = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveConstants.getMediumSpacing(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: ResponsiveConstants.getWidth(context) * 0.35, // 35% of screen width
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: ResponsiveConstants.getDetailRowFontSize(context),
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveConstants.getDetailRowFontSize(context),
                fontWeight: isAmount ? FontWeight.bold : FontWeight.w600,
                color: isAmount ? CustomColor.primaryColor : Color(0xFF2E3A47),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    // Extract and clean fee group name
    String rawFeeGroupName = widget.paymentData['fee_group_name'] ?? '';
    List<String> feeGroups = rawFeeGroupName.split('|').map((e) => e.trim()).toList();
    bool displayFeeGroupName = false;
    // Check if last element is "TRN" or "trn" and remove it
    if (feeGroups.isNotEmpty && feeGroups.last.toLowerCase() == 'trn') {
      displayFeeGroupName = true;
    }

    return Container(
      padding: EdgeInsets.all(ResponsiveConstants.getHorizontalPadding(context)),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: ResponsiveConstants.getButtonHeight(context),
            child: OutlinedButton(
              onPressed: () {

                  Navigator.pop(context);
                  widget.title == 'payment' ?
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PaymentScreen()),
                  ) :
                  widget.title == 'Hostel' ?
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HostelPaymentScreen()),
                  )
                  : 
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => TransportScreen()),
                  );

              },
              style: OutlinedButton.styleFrom(
                foregroundColor: CustomColor.primaryColor,
                side: BorderSide(color: CustomColor.primaryOne),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ResponsiveConstants.getBorderRadius(context)),
                ),
              ),
              child: Text(
                'Back to Home',
                style: TextStyle(
                  fontSize: ResponsiveConstants.getTitleFontSize(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}