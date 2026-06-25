import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/employee/emp_compensation.dart';
import '../../../providers/employee/employee_profile.dart';
import '../../../providers/student/get_session.dart';
import '../widget/top_card.dart';
import 'widgets/compensation_list.dart';
import 'widgets/compensation_loader.dart';


class EmpCompensationScreen extends StatefulWidget {
  const EmpCompensationScreen({super.key});

  @override
  State<EmpCompensationScreen> createState() => _EmpCompensationScreenState();
}

class _EmpCompensationScreenState extends State<EmpCompensationScreen> {

  @override
  void initState(){
    super.initState();
    final empComp = Provider.of<EmpCompensationProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen:  false);
    String emp = auth.loginData!.empId;
    String fromYr = auth.loginData!.currentyearfrom;
    String toYr = auth.loginData!.currentyearto;
    empComp.fetchCompensationHistory(emp, fromYr, toYr);
  }


  @override
  Widget build(BuildContext context) {
    // listen to provider changes so UI rebuilds on notifyListeners()
    final empComp = context.watch<EmpCompensationProvider>();
    final empProvider = Provider.of<EmployeeProfileProvider>(context);
    final session = context.read<SessionProvider>();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final empId = auth.loginData?.empId ?? "-";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColor.primaryColor,
        title: Text(
          'Conpensession',
          style: TextStyle(color: CustomColor.colorWhite, fontSize: 24.sp),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
            color: CustomColor.colorWhite, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildTopCard(
            (from, to) async {
              empComp.fetchCompensationHistory(empId, from, to);
            },
            session,
            empProvider,
            empId,
            "",
            "",
            true
          ),

          empComp.isLoading
          ? buildSalaryShimmer()
          : (empComp.salaryHistory.isEmpty
            ? Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.do_disturb_alt_sharp,
                        size: 80.sp,
                        color: CustomColor.colorGrey,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'No salary records found',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: CustomColor.colorGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : buildSalaryList(context, empComp.salaryHistory)),
        ],
      ),
    );
  }
}

