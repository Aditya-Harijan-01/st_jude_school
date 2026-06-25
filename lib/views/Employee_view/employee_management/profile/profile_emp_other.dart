import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../models/employee/employee_profile.dart';
import '../../../../providers/employee/other_employee_profile_provider.dart';
import '../../../../widgets/base64_image.dart';
import '../../emp_profile/components/address_details_card.dart';
import '../../emp_profile/components/bank_details.dart';
import '../../emp_profile/components/officials_card.dart';
import '../../emp_profile/widgets/basic_tab.dart';
import '../../emp_profile/widgets/experience_tab.dart';
import '../../emp_profile/widgets/qualification_tab.dart';

import 'widgets/other_profile_shimmer.dart';

class EmployeeProfileScreen2 extends StatefulWidget {
  final String employeeId;

  const EmployeeProfileScreen2({
    super.key,
    required this.employeeId,
  });

  @override
  State<EmployeeProfileScreen2> createState() => _OtherEmployeeProfileScreenState();
}

class _OtherEmployeeProfileScreenState extends State<EmployeeProfileScreen2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _bottomIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OtherEmployeeProfileProvider>(context, listen: false)
          .getEmployeeProfile(widget.employeeId);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OtherEmployeeProfileProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const OtherProfileShimmer();
        }

        final allData = provider.employeeDataResponse;

        if (allData == null) {
          return Scaffold(
            backgroundColor: CustomColor.primaryOne,
            appBar: AppBar(
              backgroundColor: CustomColor.primaryOne,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Text(
                "No profile data available",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          );
        }

        final basicInfo = allData.dataBasic;
        final imageUrl = basicInfo.isNotEmpty ? basicInfo.first.profileImage : '';
        final dataAddress = allData.dataAddress;
        final dataExperience = allData.dataExperience;
        final dataOffice = allData.dataOffice;
        final dataQualification = allData.dataQualification;
        final dataBank = allData.dataBank;

        return Scaffold(
          backgroundColor: CustomColor.primaryOne,
          body: Container(
            width: double.infinity,
            height: 1.sh,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/profile_background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60.r,
                          backgroundImage: buildEmpProfileImage(imageUrl),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      basicInfo.isNotEmpty ? basicInfo.first.employeeName : 'N/A',
                      style: TextStyle(
                        color: CustomColor.colorWhite,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      dataOffice.isNotEmpty ? dataOffice.first.designation : 'N/A',
                      style: TextStyle(
                        color: CustomColor.colorWhite,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: _buildSelectedCard(
                    index: _bottomIndex,
                    basicInfo: basicInfo,
                    dataQualification: dataQualification,
                    dataExperience: dataExperience,
                    dataAddress: dataAddress,
                    dataOffice: dataOffice,
                    dataBank: dataBank,
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _bottomIndex,
            onTap: (index) {
              setState(() {
                _bottomIndex = index;
              });
            },
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 10.sp),
            selectedItemColor: CustomColor.primaryOne,
            unselectedItemColor: Colors.grey.shade400,
            items:  [
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 26.sp),
                label: 'Personal Info',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.badge_outlined, size: 26.sp),
                label: 'Official Details',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined, size: 26.sp),
                label: 'Address Details',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_outlined, size: 26.sp),
                label: 'Bank Details',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedCard({
    required int index,
    required List<EmployeeBasic> basicInfo,
    required List<EmployeeQualification> dataQualification,
    required List<EmployeeExperience> dataExperience,
    required List<EmployeeAddress>? dataAddress,
    required List<EmployeeOffice>? dataOffice,
    required List<EmployeeBank>? dataBank,
  }) {
    switch (index) {
      case 0: // Personal Info
        return _buildCard(
          title: "Personal Information",
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: CustomColor.primaryColor,
                unselectedLabelColor: Colors.black54,
                indicatorColor: CustomColor.primaryColor,
                indicatorWeight: 1,
                tabs: const [
                  Tab(text: "Basics"),
                  Tab(text: "Qualification"),
                  Tab(text: "Experience"),
                ],
              ),

              // SizedBox(height: 10),

              /// --- TAB CONTENT ---
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildBasicsTab(basicInfo),
                    buildQualificationTab(dataQualification),
                    buildExperienceTab(dataExperience),
                  ],
                ),
              ),
            ],
          ),
        );

      case 1: // Official Details
        return
          _buildCard(
          title: "Official Details",
          child:
          dataOffice != null ? buildOfficialDetails(dataOffice) : SizedBox.shrink(),
        );

      case 2: // Address
        return _buildCard(
          title: "Address Details",
          child: dataAddress != null ? buildAddressDetails(dataAddress): SizedBox.shrink(),
        );

      case 3: // Bank Details
        return _buildCard(
          title: "Bank Details",
          child: dataBank != null ? buildBankDetails(dataBank) : SizedBox.shrink(),
        );

      default:
        return Container();
    }
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorBlack.withAlpha(50),
            blurRadius: 8.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Text(
            title,
            style:  TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
              color: Colors.black87,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
