import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/student/transport_provider.dart';
import '../views/Student_views/payment/widgets/payment_summary_sheet.dart';
import '../views/Student_views/transport/widget/transport_payment_details.dart';

void showPaymentSummaryBottomSheet(
  BuildContext context, {
  required Map<String, bool> selectedFees,
  required String pointId,
  required String from,
  required String toyear,
}) {
  final provider = context.read<TransportProvider>();
  final quarters = provider.transportQuarter ?? [];

  // Collect selected & unpaid quarters
  final selectedQuarters = <dynamic>[]; // use your actual model type
  double totalPayable = 0;
  double totalComp = 0;
  double totalAmount = 0;
  List<String> selectedFeeHeadIds = [];
  List<String> selectedFeeGroupIds = [];

  for (int i = 0; i < quarters.length; i++) {
    final quarter = quarters[i];
    final title = quarter.feeHeadName;
    
    // Check if this quarter is selected AND unpaid
    if (selectedFees[title] == true && quarter.isPaid == 'No') {
      selectedQuarters.add(quarter);
      totalPayable += double.tryParse(quarter.payableAmount) ?? 0.0;
      totalComp += double.tryParse(quarter.concession) ?? 0.0;
      totalAmount += double.tryParse(quarter.amount) ?? 0.0;
      selectedFeeHeadIds.add(quarter.feeheadId);
      selectedFeeGroupIds.add(quarter.feegroupId);
    }
  }

  // Don't show bottom sheet if nothing is selected or all selected items are paid
  if (selectedQuarters.isEmpty) {
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Please select unpaid fees to proceed'),
    //     duration: Duration(seconds: 2),
    //   ),
    // );
    return;
  }

  PaymentSummaryBottomSheet.show(
    context: context,
    totalAmount: totalAmount,
    totalConcession: totalComp,
    totalAmountWithout: totalPayable,
    totalLateFine: 0.0,
    totalCheckBounce: 0.0,
    onPayNow: () => handlePayment(
      context,
      totalAmount,
      selectedFeeHeadIds,
      selectedFeeGroupIds,
      pointId,
      from,
      toyear,

    ),
  ); 
}

void handlePayment(
  BuildContext context,
    double totalAmount, 
    List<String> selectedFeeHeadIds, 
    List<String> selectedFeeGroupIds,
    String pointId,
    String from,
    String toyear,
  ) {
    // setState(() {
    //   _isPaymentProcessing = true;
    // });

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransportPaymentDetailPage(
          selectedFromYear: from,
          selectedToYear: toyear,
          feeStructureProvider: Provider.of<TransportProvider>(context, listen: false),
          selectedInstallmentIds: [],
          totalAmount: totalAmount,
          feegroupId: selectedFeeGroupIds.join(','),
          feeheadId: selectedFeeHeadIds.join(','),
          busdate: DateTime.now(),
          point: pointId,
        ),
      ),
    ).then((_) {
      // setState(() {
      //   _isPaymentProcessing = false;
      // });
    });
  }

