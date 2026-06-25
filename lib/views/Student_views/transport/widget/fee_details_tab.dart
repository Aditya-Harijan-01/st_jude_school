import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/student/transport_provider.dart';
import '../../../../widgets/bottom_sheet.dart';
import 'downloadfee.dart';

class FeeDetailsTab extends StatefulWidget {
  // final String selectedDate;
  // final String selectedTransportPointId;
  // final String fromYear;
  // final String toYear;

  const FeeDetailsTab({
    super.key,
    // required this.selectedDate,
    // required this.selectedTransportPointId,
    // required this.fromYear,
    // required this.toYear,
  });

  @override
  State<FeeDetailsTab> createState() => _FeeDetailsTabState();
}

class _FeeDetailsTabState extends State<FeeDetailsTab> {
  final Map<String, bool> _selectedFees = {};
  // bool _isPaymentProcessing = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransportProvider>(context);
    final fees = provider.transportQuarter;
    final status = provider.transportResponseModel;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (fees == null || fees.isEmpty) {
      return const Center(child: Text("No transport fee data available"));
    }

    return Container(
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorShadow,
            blurRadius: 10.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding:  EdgeInsets.all(15.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Transportation Fees",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 10.h),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fees.length,
            itemBuilder: (context, index) {
              final fee = fees[index];
              final title = fee.feeHeadName;
              final paid = (fee.isPaid == "Yes" || fee.paymentStatus == "No");

              _selectedFees.putIfAbsent(title, () => false);

              return FeeCard(
                title: title,
                amount: "₹${fee.amount}",
                receipt: fee.rcvno,
                date: fee.checkInitial,
                paid: paid,
                isSelected: _selectedFees[title] ?? false,
                onSelect: (selected) {
                  setState(() {
                    int targetIndex = index;
                    final currentTitle = fees[index].feeHeadName;
                    final isCurrentlySelected = _selectedFees[currentTitle] ?? false;

                    if (isCurrentlySelected) {
                      // Check if the next item is selected to see if we are in the middle of a range
                      bool isNextSelected = false;
                      if (index + 1 < fees.length) {
                        final nextTitle = fees[index + 1].feeHeadName;
                        isNextSelected = _selectedFees[nextTitle] ?? false;
                      }

                      if (isNextSelected) {
                        // User clicked in the middle of a selection: Shrink selection to this item
                        targetIndex = index;
                      } else {
                        // User clicked the last item of selection: Deselect this item
                        targetIndex = index - 1;
                      }
                    } else {
                      // User clicked an unselected item: Extend selection to this item
                      targetIndex = index;
                    }

                    // Apply selection logic
                    for (int i = 0; i < fees.length; i++) {
                      final title = fees[i].feeHeadName;
                      _selectedFees[title] = i <= targetIndex;
                    }
                  });

                  // Show payment bottom sheet with selected fees
                  if (status != null) {
                    showPaymentSummaryBottomSheet(
                      context,
                      selectedFees: _selectedFees,
                      pointId: status.pointId,
                      from: status.fromYear,
                      toyear: status.toYear,
                    );
                  }
                },
                onDownload: () {
                  final fee = fees[index];
                  final provider = Provider.of<TransportProvider>(context, listen: false);

                  // Find all matching receipts
                  final matchedReceipts = provider.transportPayment
                          ?.where((r) => r.rcpShowNo == fee.rcvno)
                          .toList() ?? [];

                  if (matchedReceipts.isEmpty) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   const SnackBar(content: Text("No matching receipt found")),
                    // );
                    return;
                  }

                  // Show confirmation popup
                  final parentContext = context; // save this first
                  downloadFee(matchedReceipts, context);
                },

              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> _handleReceiptDownload(BuildContext context, dynamic fee) async {
    final provider = Provider.of<TransportProvider>(context, listen: false);

    // Find matching receipts
    final matchedReceipts = provider.transportPayment
            ?.where((r) => r.rcpShowNo == fee.rcvno)
            .toList() ??
        [];

    if (matchedReceipts.isEmpty) {
      _showErrorDialog(context, "No receipt found for this fee.");
      return;
    }

    // Show confirmation dialog
    final confirmed = await _showConfirmationDialog(context);
    if (!confirmed) return;

    // Show loading dialog
    _showLoadingDialog(context, "Preparing receipt...");

    try {
      // Generate receipt URL
      final url = await provider.printReceipt(matchedReceipts);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      if (url == null) {
        _showErrorDialog(context, "Failed to generate receipt. Please try again.");
        return;
      }

      // Show downloading dialog
      _showLoadingDialog(context, "Downloading receipt...");

      // Download and open receipt
      await provider.downloadAndOpenReceipt(url);

      if (!context.mounted) return;
      Navigator.of(context).pop(); // Close downloading dialog

      // Show success dialog
      _showSuccessDialog(context, "Receipt downloaded and opened successfully!");
    } catch (e) {
      if (!context.mounted) return;
      Navigator.of(context).pop(); // Close any open dialog
      _showErrorDialog(context, "An error occurred: ${e.toString()}");
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text("Download Receipt"),
            content: const Text("Do you want to download the transport receipt?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Download"),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            const SizedBox(width: 8),
            const Text("Success"),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColor.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            const Text("Error"),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


class FeeCard extends StatelessWidget {
  final String title;
  final String amount;
  final String receipt;
  final String date;
  final bool paid;
  final bool isSelected;
  final ValueChanged<bool>? onSelect;
  final VoidCallback onDownload;

  const FeeCard({
    super.key,
    required this.title,
    required this.amount,
    required this.receipt,
    required this.date,
    required this.paid,
    this.isSelected = false,
    this.onSelect,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = paid || isSelected;

    return GestureDetector(
      onTap: () {
        if (!paid) {
          onSelect?.call(!isSelected);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isActive ? CustomColor.colorGreen : CustomColor.colorRed,
            width: 0.25,
          ),
          color: isActive
              // ignore: deprecated_member_use
              ? Colors.green.withOpacity(0.08)
              // ignore: deprecated_member_use
              : Colors.red.withOpacity(0.08),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (paid)
                  GestureDetector(
                    onTap: onDownload,
                    child: Container(
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CustomColor.primaryColor,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.file_download_outlined,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                    ),
                  )
                else
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? CustomColor.primaryColor
                            : CustomColor.colorRed,
                        width: 2,
                      ),
                      color: isSelected
                          ? CustomColor.primaryColor
                          : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 14.sp,
                          )
                        : null,
                  ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: CustomColor.colorBlack,
                      ),
                    ),
                    if (paid) ...[
                      SizedBox(height: 4.h),
                      Text(
                        "Receipt No: $receipt",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? CustomColor.colorGreen
                        : CustomColor.colorRed,
                    fontSize: 16.sp,
                  ),
                ),
                if (paid) ...[
                  SizedBox(height: 4.h),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
