import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/employee/employee_appraisal_provider.dart';
import '../../../providers/student/get_session.dart';
import '../appraisal/widgets/appraisal_card.dart';
import '../appraisal/widgets/aprraisal_shimmer.dart';
import '../students_management/Session/bottom_sheet_with_session.dart';

class AppraisalEmpManagementScreen extends StatefulWidget {
  final String empId;
  final String name;
  const AppraisalEmpManagementScreen(
      {
        super.key,
        required this.empId,
        required this.name
      });

  @override
  State<AppraisalEmpManagementScreen> createState() => _AppraisalScreenState();
}

class _AppraisalScreenState extends State<AppraisalEmpManagementScreen> {
  String toYear = "";
  String fromYear = "";
  bool _isSessionLoaded = false;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    toYear = auth.loginData!.currentyearto;
    fromYear = auth.loginData!.currentyearfrom;
    
    // Use addPostFrameCallback to avoid 'setState() or markNeedsBuild() called during build'
    // error when calling providers that notify listeners.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _sessionLoad(fromYear, toYear);
        _fetchAppraisal();
      }
    });
  }
  Future<void> _sessionLoad(String fYear, String tYear) async {
    final sessProvider = Provider.of<SessionProvider>(context, listen: false);
    sessProvider.selectedSession2 = null;
    await sessProvider.getSessionSecondary(widget.empId, fYear, tYear, "Emp");
    if (mounted) {
      setState(() {
        _isSessionLoaded = true;
      });
    }
  }
  Future<void> _fetchAppraisal() async {
    try {
      final provider = Provider.of<EmployeeAppraisalProvider>(context, listen: false);
      provider.clearAppraisalData();
      await provider.getEmployeeAppraisalReport(empId: widget.empId , fromYear: fromYear, toYear: toYear);

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
          if (provider.isDataLoading) {
            return Column(
              children: [
                AppraisalCardShimmer(),
              ],
            );
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
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Colors.grey[600],
                    ),
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
      bottomNavigationBar: _isSessionLoaded ? BottomSheet2(
        content: SizedBox.shrink(),
        onSessionChange: (from,to) async {
          log("to: $to, from: $from");
          setState(() {
            toYear = to;
            fromYear = from;
          });
          _fetchAppraisal();
        },
        name: widget.name,
        fYear: fromYear,
        tYear: toYear,
        emp: 'emp',
      ) : const SizedBox.shrink(),
    );
  }
}
