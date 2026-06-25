import 'dart:developer';
import '../widget/common_bottom_sheet_emp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/employee/employee_appraisal_provider.dart';
import '../widget/access_denied_dialog.dart';
import 'widgets/appraisal_card.dart';
import 'widgets/aprraisal_shimmer.dart';

class AppraisalScreen extends StatefulWidget {
  const AppraisalScreen({super.key});

  @override
  State<AppraisalScreen> createState() => _AppraisalScreenState();
}

class _AppraisalScreenState extends State<AppraisalScreen> {
  String toYear = "";
  String fromYear = "";
  bool _hasShownAccessDeniedDialog = false;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    toYear = auth.loginData!.currentyearto;
    fromYear = auth.loginData!.currentyearfrom;
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchAppraisal());
  }

  Future<void> _fetchAppraisal() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final provider = Provider.of<EmployeeAppraisalProvider>(
        context,
        listen: false,
      );
      await provider.getEmployeeAppraisalReport(
        empId: auth.loginData!.empId,
        fromYear: fromYear,
        toYear: toYear,
      );
    } catch (e, s) {
      log('error: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Appraisal'),
        backgroundColor: CustomColor.primaryColor,
        foregroundColor: CustomColor.colorWhite,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<EmployeeAppraisalProvider>(
        builder: (context, provider, child) {
          if (provider.accessValue != null &&
              provider.accessValue != 0 &&
              !_hasShownAccessDeniedDialog) {
            _hasShownAccessDeniedDialog = true;
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showAccessDeniedDialog(
                context,
                'You do not have permission to view appraisal data.',
              );
            });
          }

          if (provider.isDataLoading) {
            return Column(children: [AppraisalCardShimmer()]);
          }

          if (!provider.hasAppraisalData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assessment_outlined,
                    size: 64.r,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No appraisal data available',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 2.h),
            itemCount: provider.appraisalList!.length,
            itemBuilder: (context, index) {
              final reverseIndex = provider.appraisalList!.length - 1 - index;
              final appraisal = provider.appraisalList![reverseIndex];
              return AppraisalCard(appraisal: appraisal);
            },
          );
        },
      ),
      bottomNavigationBar: CommonBottomSheetEmp(
        content: SizedBox.shrink(),
        onSessionChange: (from, to) async {
          log("to: $to, from: $from");
          setState(() {
            toYear = to;
            fromYear = from;
          });
          _fetchAppraisal();
        },
      ),
    );
  }
}
