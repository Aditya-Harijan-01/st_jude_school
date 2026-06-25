import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../models/Students/hostel_fee_structure_model.dart';
import '../../../providers/common/common_Session.dart';
import '../../../providers/student/get_session.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/student/hostel_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/colors.dart';
import '../payment/widgets/payment_expandable_card.dart';
import '../payment/widgets/multi_selectable_fee_item.dart';
import '../payment/widgets/paid_fee_item_widget.dart';
import '../payment/widgets/payment_summary_sheet.dart';
import 'hostel_payment_detail_screen.dart';


class HostelPaymentScreen extends StatefulWidget {
  const HostelPaymentScreen({super.key});

  @override
  State<HostelPaymentScreen> createState() => _HostelPaymentScreenState();
}

class _HostelPaymentScreenState extends State<HostelPaymentScreen> {
  bool isHostelFeeExpanded = true;
  bool isMessFeeExpanded = false;
  bool _isPaymentProcessing = false;
  String? selectedFromYear;
  String? selectedToYear;
  Set<String> selectedFeeItems = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchSessionData();
      _fetchHostelStatus();
    });
  }

  void _fetchSessionData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      selectedFromYear = authProvider.loginData?.currentyearfrom;
      selectedToYear = authProvider.loginData?.currentyearto;
    });
  }

  Future<void> _fetchHostelStatus() async {
    final provider = Provider.of<HostelProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.loginData != null) {
      String regNo = authProvider.loginData!.regno;
      String fromYear = selectedFromYear ?? authProvider.loginData!.currentyearfrom;
      String toYear = selectedToYear ?? authProvider.loginData!.currentyearto;

      provider.hostelFeeStructureResponse = null;
      await provider.getStudentHostelStatus(regNo, fromYear, toYear);

      if (provider.hostelStatusResponse?.isHostelTaken == 1) {
        String roomId = "";
        if (provider.hostelStatusResponse!.roomId.isNotEmpty) {
           roomId = provider.hostelStatusResponse!.roomId.first.roomId.toString();
        }
       
        log('roomId: $roomId');

        if (roomId.isNotEmpty) {
           String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
           await provider.getStudentHostelFeeStructure(regNo, fromYear, roomId, currentDate);
        }
      }
    }
  }

  List<HostelFeeHead> get _allFees {
    final provider = Provider.of<HostelProvider>(context, listen: false);
    return provider.hostelFeeStructureResponse?.data ?? [];
  }

  double get totalPaid {
    double total = 0;
    for (var fee in _allFees) {
      if (fee.isPaid == 'Yes') {
        total += double.tryParse(fee.amount) ?? 0.0;
      }
    }
    return total;
  }

  double get totalDue {
    double total = 0;
    for (var fee in _allFees) {
      if (fee.isPaid != 'Yes') {
         total += double.tryParse(fee.payableAmount) ?? 0.0;
      }
    }
    return total;
  }

  void _buildDirectPaymentSummary() {
    final selectedFees = _allFees.where((fee) {
      return selectedFeeItems.any((item) {
        if (item.contains('~')) {
          final parts = item.split('~');
          return parts.length >= 2 &&
              parts[0] == fee.feeGroupId &&
              parts[1] == fee.feeHeadId;
        }
        return item == fee.feeGroupId || item == fee.feeHeadId;
      });
    }).toList();
    log("all fees: ${jsonEncode(_allFees)}");
    log("selected: ${jsonEncode(selectedFees)}");
    double totalAmount = 0.0;
    double totalAmountWithout = 0.0;
    double totalConcession = 0.0;

    for (var fee in selectedFees) {
      double amt = double.tryParse(fee.payableAmount) ?? 0.0;
      totalAmount += amt;
      totalAmountWithout += double.tryParse(fee.amount) ?? 0.0;
      totalConcession += double.tryParse(fee.concession) ?? 0.0;
    }
    log("total: $totalAmount and concession: $totalConcession");

    PaymentSummaryBottomSheet.show(
      context: context,
      totalAmount: totalAmount,
      totalLateFine: 0.0,
      totalCheckBounce: 0.0,
      onPayNow: () => _handlePayment(totalAmount),
      isProcessing: _isPaymentProcessing,
      totalConcession: totalConcession,
      totalAmountWithout: totalAmountWithout,
    );
  }

  void _handlePayment(double totalAmount) {
    setState(() {
      _isPaymentProcessing = true;
    });

    final provider = Provider.of<HostelProvider>(context, listen: false);
    String roomId = "";
    if (provider.hostelStatusResponse != null && provider.hostelStatusResponse!.roomId.isNotEmpty) {
       roomId = provider.hostelStatusResponse!.roomId.first.roomId.toString();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HostelPaymentDetailPage(
          selectedFromYear: selectedFromYear!,
          selectedToYear: selectedToYear!,
          roomId: roomId,
          selectedFeeItems: selectedFeeItems.toList(),
          totalAmount: totalAmount,
          hostelProvider: provider,
        ),
      ),
    ).then((_) {
      setState(() {
        _isPaymentProcessing = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new,
              color: CustomColor.colorWhite, size: 24.sp),
        ),
        title: Text("Hostel Fee Payment",
            style: TextStyle(color: CustomColor.colorWhite, fontSize: 24.sp)),
        centerTitle: true,
      ),
      body: Consumer<HostelProvider>(
        builder: (context, hostelProvider, child) {
          if (hostelProvider.isLoading) {
            return _buildShimmerLoader();
          }

          if (hostelProvider.hostelStatusResponse == null) {
            return _buildEmptyState();
          }

          if (hostelProvider.hostelStatusResponse!.isHostelTaken == 1) {
            return Consumer<SessionProvider>(
              builder: (context, sessionProvider, child) {
                return _buildHostelPaymentView(sessionProvider, hostelProvider);
              },
            );
          } else {
            return Center(child: buildHostelNotRegistered());
          }
        },
      ),
    );
  }

  Widget _buildHostelPaymentView(SessionProvider sessionProvider, HostelProvider hostelProvider) {

    final fees = hostelProvider.hostelFeeStructureResponse?.data ?? [];
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PaymentExpandableCard(
                  title: "Hostel Fees",
                  isExpanded: isHostelFeeExpanded,
                  onToggle: () {
                    setState(() => isHostelFeeExpanded = !isHostelFeeExpanded);
                  },
                  iconColor: CustomColor.colorRed,
                  child: _buildFeeList(fees),
                ),
                SizedBox(height: 200.h),
              ],
            ),
          ),
        ),
        _buildBottomSummarySection(sessionProvider),
      ],
    );
  }

  Widget _buildBottomSummarySection(SessionProvider sessionProvider) {
    final studentName = sessionProvider.studentInfo?.name ?? 'Student F';
    final selectedSession = sessionProvider.sessionData?.firstWhere(
      (session) => session.fromYear == selectedFromYear && session.toYear == selectedToYear,
      orElse: () => sessionProvider.sessionData!.first,
    );
    log('session: ${selectedSession?.toJson().toString()}');
    final studentClass = selectedSession != null && selectedSession.className.isNotEmpty
        ? 'Class ${selectedSession.className} (${selectedSession.section}) ${selectedSession.stream}'
        : 'Class Information';

    return Container(
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    studentName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    studentClass,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              SessionDropdown(
                initialFromYear: selectedFromYear,
                initialToYear: selectedToYear,
                onSessionChanged: (from, to) async {
                  setState(() {
                    selectedFromYear = from;
                    selectedToYear = to;
                  });
                   await _fetchHostelStatus();
                },
                disable: true,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: CustomColor.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: CustomColor.primaryColor,
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Total Paid',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '₹${totalPaid.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        color: CustomColor.colorRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.receipt_long,
                        color: CustomColor.colorRed,
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Total Due',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Spacer(),
                    Text(
                      '₹${totalDue.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.colorRed,
                      ),
                    ),
                  ],
                ),
                _buildPaymentFAB()
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPaymentFAB() {
    return selectedFeeItems.isNotEmpty
        ? Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 8.h),
            height: 55.h,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    CustomColor.primaryOne,
                    CustomColor.lightPrGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ElevatedButton.icon(
                onPressed: _buildDirectPaymentSummary,
                // onPressed: () => {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                ),
                icon: Icon(Icons.payment, color: CustomColor.colorWhite),
                label: Text(
                  'Proceed to Pay',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: CustomColor.colorWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        : SizedBox.shrink();
  }

  Widget _buildFeeList(List<HostelFeeHead> fees) {
    if (fees.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Text(
            'No fee data available',
            style: TextStyle(
              fontSize: 14.sp,
              color: CustomColor.colorGrey,
            ),
          ),
        ),
      );
    }

    final paidFees = fees.where((f) => f.isPaid == 'Yes').toList();
    final unpaidFees = fees.where((f) => f.isPaid == 'No').toList();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final regNo = authProvider.loginData?.regno ?? "";
    
    return Column(
      children: [
        ...paidFees.map((fee) => PaidFeeItem(
              title: fee.feeHeadName,
              amount: '₹${fee.amount}',
              date: fee.paidDate,
              regNo: regNo,
              fromYear: selectedFromYear ?? "",
              toYear: selectedToYear ?? "",
              receiptShowNo: fee.rcvNo,
              receiptType: 'Hst',
            )),
        ...unpaidFees.asMap().entries.map((entry) {
          final int index = entry.key;
          final fee = entry.value;
          final bool isChecked = selectedFeeItems.contains("${fee.feeGroupId}~${fee.feeHeadId}");

          bool isEnabled = index == 0;
          if (index > 0) {
            final prevFee = unpaidFees[index - 1];
            isEnabled = selectedFeeItems.contains("${prevFee.feeGroupId}~${prevFee.feeHeadId}");
          }

          return MultiSelectableFeeItem(
            title: fee.feeHeadName,
            amount: "₹${fee.payableAmount}",
            isChecked: isChecked,
            isEnabled: isEnabled,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  selectedFeeItems.add("${fee.feeGroupId}~${fee.feeHeadId}");
                }
                else {
                  for (int k = index; k < unpaidFees.length; k++) {
                    final item = unpaidFees[k];
                    selectedFeeItems.remove("${item.feeGroupId}~${item.feeHeadId}");
                  }
                }
              });
            },
          );
        }),
      ],
    );
  }

  Widget buildHostelNotRegistered() {
    return Padding(
      padding: EdgeInsets.all(22.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.domain,
                  size: 80.sp,
                  color: CustomColor.primaryColor,
                ),
                SizedBox(height: 12.h),
                Text(
                  "You are not Registered for Hostel",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Hostel service is not registered for your account.\nPlease contact the school administration.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 45.h,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Go Back",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "No hostel data found.",
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 50.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
