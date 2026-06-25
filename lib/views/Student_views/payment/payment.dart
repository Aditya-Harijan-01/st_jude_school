// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/common/common_Session.dart';
import '../../../providers/student/fee_structure_provider.dart';
import '../../../providers/student/get_session.dart';
import 'payment_detail_screen.dart';
import 'widgets/payment_expandable_card.dart';
import 'widgets/multi_selectable_fee_item.dart';
import 'widgets/single_selectable_fee_item.dart';
import 'widgets/paid_fee_item_widget.dart';
import 'widgets/payment_summary_sheet.dart';
import 'utils/payment_date_utils.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isPendingFeeExpanded = true;
  bool isPendingFineExpanded = false;
  bool isReceiptExpanded = false;
  bool _isPaymentProcessing = false;
  String? selectedFromYear;
  String? selectedToYear;
  Set<String> selectedFeeItems = {};
  // String selectedSession = '2025-2024';`
  String regNo ="";
  bool isMainDataPaid = false;
  


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPaymentData();
    });
  }
  void _fetchPaymentData()  {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    selectedFromYear = authProvider.loginData!.currentyearfrom;
    selectedToYear = authProvider.loginData!.currentyearto;

    _loadFeeStructure(selectedFromYear!,selectedToYear!);
  }
  Future<void> _loadFeeStructure(String fromYear, String toYear) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final feeStructureProvider = Provider.of<FeeStructureProvider>(context, listen: false);
    regNo =  authProvider.loginData!.regno;
      await feeStructureProvider.getFeeStructureByStudent(
        regNo: regNo,
        fromYear: fromYear,
        toYear: toYear,
      );

      await feeStructureProvider.getFineDetailByStudent(
        regNo: regNo,
        fromYear: fromYear,
        toYear: toYear,
      );

      if (mounted) {
        setState(() {
          if (feeStructureProvider.dataMain.isNotEmpty) {
            isMainDataPaid = feeStructureProvider.dataMain.first.rcpNo != "";
          } else {
            isMainDataPaid = false;
          }
        });
      }
  }

  void _buildDirectPaymentSummary() {
    final feeStructureProvider = Provider.of<FeeStructureProvider>(context, listen: false);
    final pendingInstallments = feeStructureProvider.unpaidInstallments;
    final unpaidFines = feeStructureProvider.unpaidFines;


    final selectedInstallments = pendingInstallments.where((installment) {
      return selectedFeeItems.any((item) {
        if (item.contains('~')) {
          final parts = item.split('~');
          return parts.length >= 2 &&
              parts[0] == installment.feeGroupId &&
              parts[1] == installment.headids;
        }
        return item == installment.feeGroupId || item == installment.headids;
      });
    }).toList();

    log("Selected Installments Data: ${selectedInstallments.map((e) => e.toJson()).toList()}");
    log("selectedItem: $selectedFeeItems");

    final selectedFines = unpaidFines
        .where((fine) => selectedFeeItems.contains(fine.fineId))
        .toList();

    double totalAmountWithout = 0.0;
    double totalAmount = 0.0;
    double totalConcession = 0.0;
    double totalLateFine = 0.0;
    double totalCheckBounce = 0.0;

    final installmentsData = <Map<String, dynamic>>[];

    // Add fee installments
    for (var installment in selectedInstallments) {
      double lateFine = double.parse(installment.latefineAmount);
      double checkBounce = double.tryParse(installment.checkBounceAmount ?? '0') ?? 0.0;
      
      totalAmountWithout += double.parse(installment.amount);
      totalAmount += double.parse(installment.feeApplicable) + lateFine + checkBounce;
      totalConcession += double.parse(installment.concession);
      totalLateFine += lateFine;
      totalCheckBounce += checkBounce;
      
      installmentsData.add({
        'amount': installment.amount,
        'concession': installment.concession,
      });
    }

    // Add fine installments
    for (var fine in selectedFines) {
      totalAmountWithout += double.parse(fine.amount);
      totalAmount += double.parse(fine.amount);
      totalConcession += 0.0; // Fines don't have concession
      installmentsData.add({
        'amount': fine.amount,
        'concession': '0',
      });
    }

    PaymentType paymentType = (selectedFines.isNotEmpty && selectedInstallments.isEmpty)
        ? PaymentType.fine
        : PaymentType.fee;

    PaymentSummaryBottomSheet.show(
      context: context,
      // selectedInstallments: installmentsData,
      totalAmount: totalAmount,
      totalLateFine: totalLateFine,
      totalCheckBounce: totalCheckBounce,
      onPayNow: () => _handlePayment(paymentType, totalAmount),
      isProcessing: _isPaymentProcessing,
      totalConcession: totalConcession,
      totalAmountWithout: totalAmountWithout,
    );
  }


  void _handlePayment(PaymentType paymentType, double totalAmount) {
    setState(() {
      _isPaymentProcessing = true;
    });

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailPage(
          selectedFromYear: selectedFromYear,
          selectedToYear: selectedToYear,
          feeStructureProvider: Provider.of<FeeStructureProvider>(context, listen: false),
          selectedInstallmentIds: selectedFeeItems.toList(),
          totalAmount: totalAmount,
          paymentType: paymentType,
        ),
      ),
    ).then((_) {
      setState(() {
        _isPaymentProcessing = false;
      });
    });
  }

  double _calculateTotalPaid(FeeStructureProvider provider) {
    double total = 0.0;
    for (var item in provider.dataMain) {
      total += double.tryParse(item.receivedAmount) ?? 0.0;
    }
    for (var item in provider.paidInstallments) {
      total += double.tryParse(item.feeApplicable) ?? 0.0;
    }
    return total;
  }

  double _calculateTotalDue(FeeStructureProvider provider) {
    double total = 0.0;
    for (var item in provider.unpaidInstallments) {
      total += double.tryParse(item.feeApplicable) ?? 0.0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: CustomColor.colorWhite, size: 24.sp),
        ),
        title: Text("School Fee Payment", style: TextStyle(color: CustomColor.colorWhite, fontSize: 24.sp)),
        centerTitle: true,
      ),
      body: Consumer2<FeeStructureProvider, SessionProvider>(
        builder: (context, feeStructureProvider, sessionProvider, child) {
          // if (feeStructureProvider.isLoading || feeStructureProvider.isFineLoading) {
          //   return Padding(
          //     padding:  EdgeInsets.all(18.r),
          //     child: _buildPaymentShimmer(),
          //   );
          // }

          return Column(
            children: [
              feeStructureProvider.isLoading || feeStructureProvider.isFineLoading ?_buildPaymentShimmer():
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PaymentExpandableCard(
                        title: "Pending Fee",
                        isExpanded: isPendingFeeExpanded,
                        onToggle: () {
                          setState(() => isPendingFeeExpanded = !isPendingFeeExpanded);
                        },
                        iconColor: CustomColor.colorRed,
                        child: _buildFeeList(feeStructureProvider),
                      ),
                      PaymentExpandableCard(
                        title: "Others",
                        isExpanded: isPendingFineExpanded,
                        onToggle: () {
                          setState(() => isPendingFineExpanded = !isPendingFineExpanded);
                        },
                        iconColor: CustomColor.colorRed,
                        child: _buildFineList(feeStructureProvider),
                      ),

                      SizedBox(height: 200.h), // Space for bottom section
                    ],
                  ),
                ),
              ),
              _buildBottomSummarySection(feeStructureProvider, sessionProvider),
            ],
          );
        },
      ),
      // floatingActionButton: _buildPaymentFAB(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBottomSummarySection(FeeStructureProvider provider, SessionProvider sessionProvider) {
    final studentName = sessionProvider.studentInfo?.name ?? 'Student Name';
    final selectedSession = sessionProvider.sessionData?.firstWhere(
      (session) => session.fromYear == selectedFromYear && session.toYear == selectedToYear,
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
                onSessionChanged: (from, to) async {
                  await _loadFeeStructure(from, to);
                  setState(() {
                    selectedFromYear = from;
                    selectedToYear = to;
                  });
                },
                disable: true,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (!provider.isLoading && !provider.isFineLoading) ...[
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
                        '₹${_calculateTotalPaid(provider).toStringAsFixed(2)}',
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
                        '₹${_calculateTotalDue(provider).toStringAsFixed(2)}',
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
          ]
        ],
      ),
    );
  }

  Widget _buildPaymentFAB() {
    return selectedFeeItems.isNotEmpty
        ? Container(

          color: Colors.white,
          padding: EdgeInsets.only( top: 8.h),
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
          )


    )
        : SizedBox.shrink();
  }

  Widget _buildFeeList(FeeStructureProvider feeStructureProvider) {
    final feeMode = feeStructureProvider.feeStructureResponse?.feeMode.toLowerCase();
    // final feeMode = 'multiple';
    final paidInstallments = feeStructureProvider.paidInstallments;
    final pendingInstallments = feeStructureProvider.unpaidInstallments;
    final mainData = feeStructureProvider.dataMain;

    if (paidInstallments.isEmpty && pendingInstallments.isEmpty && mainData.isEmpty) {
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

    return Column(
      children: [
        if(isMainDataPaid)...[
        ...mainData.map((fee) => PaidFeeItem(
          title: fee.structure,
          amount: '₹${fee.receivedAmount}',
          date: PaymentDateUtils.formatDate(fee.paidOn),
          regNo: regNo,
          fromYear: selectedFromYear,
          toYear: selectedToYear,
          receiptShowNo:  fee.rcpNo,
          receiptType: fee.feesType == 'Re-Admission'|| fee.feesType == 'New Admission' ? 'admission' : fee.feesType,
        )),]else...[
          ...mainData.map((fee)=>
          SingleSelectableFeeItem(title: fee.structure, amount: "₹${fee.feeApplicable}", isChecked: false, isItFirst: false, onChanged: (_) => {})
          )
        ],
        if(isMainDataPaid)...[
            ...paidInstallments.map((fee) => PaidFeeItem(
              title: fee.groupName,
              amount: '₹${fee.feeApplicable}',
              date: PaymentDateUtils.formatDate(fee.paidOn),
              regNo:regNo,
              fromYear: selectedFromYear,
              toYear: selectedToYear,
              receiptShowNo: fee.rcpNo,
              receiptType: fee.feetype,
            )),
            if (feeMode == 'single') ...[
              ...pendingInstallments.map((installment) => SingleSelectableFeeItem(
                isItFirst: pendingInstallments.indexOf(installment) == 0,
                title: installment.groupName,
                amount: "₹${installment.feeApplicable}",
                isChecked: selectedFeeItems.contains("${installment.feeGroupId}~${installment.headids}"),
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      selectedFeeItems.add("${installment.feeGroupId}~${installment.headids}");
                    } else {
                      selectedFeeItems.remove("${installment.feeGroupId}~${installment.headids}");
                    }
                  });
                  if (selectedFeeItems.isNotEmpty) {
                    _buildDirectPaymentSummary();
                  }
                },
              )),
            ] else ...[
              ...pendingInstallments.toList().asMap().entries.map((entry) {
                final int index = entry.key;
                final installment = entry.value;
                final List<dynamic> allInstallments = pendingInstallments.toList();
                
                final String installmentId = "${installment.feeGroupId}~${installment.headids}";
                final bool isChecked = selectedFeeItems.contains(installmentId);
                
                bool isEnabled = index == 0;
                if (index > 0) {
                   final prevInstallment = allInstallments[index - 1];
                   final String prevItemId = "${prevInstallment.feeGroupId}~${prevInstallment.headids}";
                   isEnabled = selectedFeeItems.contains(prevItemId);
                }

                return MultiSelectableFeeItem(
                  title: installment.groupName,
                  amount: "₹${installment.feeApplicable}",
                  isChecked: isChecked,
                  isEnabled: isEnabled,
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        selectedFeeItems.add(installmentId);
                      } else {
                        // Deselect this one and all subsequent ones
                        for (int k = index; k < allInstallments.length; k++) {
                           final item = allInstallments[k];
                           selectedFeeItems.remove("${item.feeGroupId}~${item.headids}");
                        }
                      }
                    });
                    if (selectedFeeItems.isNotEmpty) {
                      _buildPaymentFAB();
                    }
                  },
                );
              }),
            ],
          ]else...[
          ...pendingInstallments.map((installment) => SingleSelectableFeeItem(
            isItFirst: false,
            title: installment.groupName,
            amount: "₹${installment.feeApplicable}",
            isChecked:false,
            onChanged: (_)=> {},

              //   (val) {
              // setState(() {
              //   if (val == true) {
              //     selectedFeeItems.add("${installment.feeGroupId}~${installment.headids}");
              //   } else {
              //     selectedFeeItems.remove("${installment.feeGroupId}~${installment.headids}");
              //   }
              // });
              // if (selectedFeeItems.isNotEmpty) {
              //   _buildDirectPaymentSummary();
              // }
            // },
          )),
        ],
        ],
    );
  }

  Widget _buildFineList(FeeStructureProvider feeStructureProvider) {
    final paidFines = feeStructureProvider.paidFines;
    final unpaidFines = feeStructureProvider.unpaidFines;

    if (paidFines.isEmpty && unpaidFines.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(16.w),
        child: Center(
          child: Text(
            'No fine data available',
            style: TextStyle(
              fontSize: 14.sp,
              color: CustomColor.colorGrey,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        if (paidFines.isNotEmpty) ...[
          ...paidFines.map((fine) => PaidFeeItem(
            title: fine.fineMasterName,
            amount: '₹${fine.receivedAmount}',
            date: PaymentDateUtils.formatDate(fine.paymentDate),
            regNo: regNo,
            fromYear: selectedFromYear,
            toYear: selectedToYear,
            receiptShowNo: fine.rcpnoshow,
            receiptType: fine.typeName,
          )),
        ],
        
        if (unpaidFines.isNotEmpty) ...[
          ...unpaidFines.map((fine) => MultiSelectableFeeItem(
            title: fine.fineMasterName,
            amount: "₹${fine.amount}",
            isChecked: selectedFeeItems.contains(fine.fineId),
            isEnabled: true,
            onChanged: (val) {
              setState(() {
                if (val == true) {
                  selectedFeeItems.add(fine.fineId);
                } else {
                  selectedFeeItems.remove(fine.fineId);
                }
              });
              if (selectedFeeItems.isNotEmpty) {
                _buildPaymentFAB();
              }
            },
          )),
        ],
      ],
    );
  }



  Widget _buildPaymentShimmer() {
    return Expanded(
      child: Padding(
        padding:  EdgeInsets.all(18.r),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPaymentExpandableCardShimmer(),
                _buildPaymentExpandableCardShimmer(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentExpandableCardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),

      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 16.w),
            title: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 20.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: CustomColor.colorWhite,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 24.h,
                    width: 24.w,
                    decoration: BoxDecoration(
                      color: CustomColor.colorWhite,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                _buildPaidFeeItemShimmer(),
                _buildMultiSelectableFeeItemShimmer(),
                _buildMultiSelectableFeeItemShimmer(),
                _buildMultiSelectableFeeItemShimmer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaidFeeItemShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.25,
        ),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 2,
                        ),
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 16.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: CustomColor.colorWhite,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 16.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    color: CustomColor.colorWhite,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 32.w),
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 12.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        color: CustomColor.colorWhite,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 12.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: CustomColor.colorWhite,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelectableFeeItemShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 0.25,
        ),
        color: Colors.grey.shade100,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: 22.w,
                  height: 22.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 2,
                    ),
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 16.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: CustomColor.colorWhite,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 16.h,
              width: 80.w,
              decoration: BoxDecoration(
                color: CustomColor.colorWhite,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

}



