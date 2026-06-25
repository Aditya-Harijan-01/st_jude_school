// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import '../../../providers/auth_provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/student/transport_provider.dart';
import '../../../models/Students/transport_fee.dart';
import 'package:shimmer/shimmer.dart';

import '../payment/widgets/payment_summary_sheet.dart';
import 'widget/transport_payment_details.dart';

class GetNewTransportScreen extends StatefulWidget {
  final String? yesNoSelection;
  final DateTime? selectedDate;
  final String? selectedTransportPointId;
  final String? selectedTransportPointName;

  const GetNewTransportScreen({
    super.key,
    required this.yesNoSelection,
    required this.selectedDate,
    required this.selectedTransportPointId,
    required this.selectedTransportPointName,
  });

  @override
  State<GetNewTransportScreen> createState() => _GetNewTransportScreenState();
}

class _GetNewTransportScreenState extends State<GetNewTransportScreen> {
  List<bool> selectedStatus = [];
  Set<String> selectedFeeItems = {};
  bool _isPaymentProcessing = false;
  final String fromYear = '';
  final String toYear = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final provider = context.read<TransportProvider>();

      provider
          .getTransportFeeStructure(
        auth.loginData?.regno,
        auth.loginData?.currentyearfrom,
        widget.selectedTransportPointId,
      )
          .then((_) {
        final quarters = provider.transportQuarter ?? [];
        setState(() {
          selectedStatus =
              List.generate(quarters.length, (i) => quarters[i].isPaid == "1");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: Text(
          "Transport Details",
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: CustomColor.colorWhite, size: 20.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Consumer<TransportProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) return _buildShimmerLoader();

          final quarters = provider.transportQuarter ?? [];

          if (selectedStatus.length != quarters.length) {
            selectedStatus =
                List.generate(quarters.length, (i) => quarters[i].isPaid == "1");
          }

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  _buildSummaryCard(provider),
                  SizedBox(height: 18.h),
                  if (quarters.isEmpty)
                    _buildEmptyState()
                  else
                    SizedBox(
                      height: 560.h,
                      child: ListView.builder(
                        itemCount: quarters.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildQuarterCard(
                              context, quarters[index], index);
                        },
                      ),
                    ),
                  SizedBox(height: 20.h),
                  _buildConfirmButton(), //   Updated button
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(TransportProvider provider) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CustomColor.primaryColor.withOpacity(0.9),
            CustomColor.primaryColor.withOpacity(0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Transport Selection Summary",
              style: TextStyle(
                fontSize: 18.sp,
                color: CustomColor.colorWhite,
                fontWeight: FontWeight.w400,
              )),
          SizedBox(height: 5.h),
          _buildSummaryRow("Option:", widget.yesNoSelection ?? "N/A"),
          _buildSummaryRow(
            "Start Date:",
            widget.selectedDate != null
                ? DateFormat('dd MMM yyyy').format(widget.selectedDate!)
                : "N/A",
          ),
          _buildSummaryRow("Route ID:", widget.selectedTransportPointName ?? ''),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp)),
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildQuarterCard(
      BuildContext context, TransportQuarterFeeModel model, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.feeHeadName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: CustomColor.primaryColor,
                ),
              ),
              Checkbox(
                value: model.isPaid != 'No' ? true : selectedStatus[index],
                onChanged: (value) {
                  setState(() {
                    if (model.isPaid == 'No') {
                      if (value == true) {
                        for (int i = 0; i <= index; i++) {
                          selectedStatus[i] = true;
                        }
                        for (int i = index + 1;
                            i < selectedStatus.length;
                            i++) {
                          selectedStatus[i] = false;
                        }
                      } else {
                        for (int i = index; i < selectedStatus.length; i++) {
                          selectedStatus[i] = false;
                        }
                      }
                    }
                  });
                },
                checkColor: CustomColor.colorWhite,
                activeColor: CustomColor.colorGreen,
                side: BorderSide(
                  color: selectedStatus[index]
                      ? CustomColor.colorGreen
                      : CustomColor.colorRed,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r),
                ),
              ),
            ],
          ),
          _buildFeeRow("Total Amount", "₹${model.amount}"),
          _buildFeeRow("Concession", "₹${model.concession}"),
          Divider(),
          _buildFeeRow("Payable", "₹${model.payableAmount}",
              isHighlight: true),
        ],
      ),
    );
  }

  Widget _buildFeeRow(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: isHighlight ? FontWeight.bold : FontWeight.w600,
              color:
                  isHighlight ? CustomColor.primaryColor : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      child: Column(
        children: [
          Icon(Icons.directions_bus_filled_rounded,
              color: Colors.grey.shade400, size: 80.sp),
          SizedBox(height: 10.h),
          Text("No transport fee data found.",
              style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  Widget _buildShimmerLoader() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: List.generate(
          4,
          (index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                height: 80.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🧾 NEW PAYMENT STYLE BOTTOM SHEET INTEGRATION
  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: () {
        final provider = context.read<TransportProvider>();
        final quarters = provider.transportQuarter ?? [];

        // Collect unpaid + selected quarters
        final selectedQuarters = <TransportQuarterFeeModel>[];
        double totalPayable = 0;
        double totalComp = 0;
        double totalAmount = 0;
        List<String> selectedFeeHeadIds = [];
        List<String> selectedFeeGroupIds = [];

        for (int i = 0; i < quarters.length; i++) {
          if (selectedStatus[i] && quarters[i].isPaid == 'No') {
            selectedQuarters.add(quarters[i]);
            totalPayable +=
                double.tryParse(quarters[i].payableAmount) ?? 0.0;
            totalComp +=
                double.tryParse(quarters[i].concession) ?? 0.0;
            totalAmount +=
                double.tryParse(quarters[i].amount) ?? 0.0;
            selectedFeeHeadIds.add(quarters[i].feeheadId);
            selectedFeeGroupIds.add(quarters[i].feegroupId);
          }
        }

        if (selectedQuarters.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Please select at least one quarter to pay")),
          );
          return;
        }

        // 🪄 Show the payment summary bottom sheet
        PaymentSummaryBottomSheet.show(
          context: context,
          // selectedInstallments: installmentsData,
          totalAmount: totalAmount,
          totalLateFine: 0.0,
          totalCheckBounce: 0.0,
          onPayNow: () => _handlePayment(
            totalAmount,
            selectedFeeHeadIds,
            selectedFeeGroupIds
          ),
          isProcessing: _isPaymentProcessing,
          totalConcession: totalComp,
          totalAmountWithout: totalPayable,
        );
      },
        
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          gradient: LinearGradient(
            colors: [CustomColor.primaryColor, CustomColor.primaryOne],
          ),
          boxShadow: [
            BoxShadow(
              color: CustomColor.primaryColor.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Confirm Request",
            style: TextStyle(
              color: CustomColor.colorWhite,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  void _handlePayment(
    double totalAmount, 
    List<String> selectedFeeHeadIds, 
    List<String> selectedFeeGroupIds
  ) {
    setState(() {
      _isPaymentProcessing = true;
    });

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransportPaymentDetailPage(
          selectedFromYear: fromYear,
          selectedToYear: toYear,
          feeStructureProvider: Provider.of<TransportProvider>(context, listen: false),
          selectedInstallmentIds: selectedFeeItems.toList(),
          totalAmount: totalAmount,
          feegroupId: selectedFeeGroupIds.join(','),
          feeheadId: selectedFeeHeadIds.join(','),
          busdate: widget.selectedDate,
          point: widget.selectedTransportPointId,
        ),
      ),
    ).then((_) {
      setState(() {
        _isPaymentProcessing = false;
      });
    });
  }
}
