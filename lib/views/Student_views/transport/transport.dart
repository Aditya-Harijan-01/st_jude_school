// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/common/common_Session.dart';
import '../../../providers/student/get_student_profile.dart';
import '../../../providers/student/transport_provider.dart';
import 'get_new_transport.dart';
import 'widget/fee_details_tab.dart';
import 'widget/live_tracking.dart';
import 'widget/route_details_tab.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  int selectedTab = 0;


  String? yesNoSelection;
  DateTime? selectedDate;
  String? selectedTransportPointId;
  String? selectedTransportPointName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTransportPageDetails();
    });
  }

  @override
  void dispose(){
    final provider = Provider.of<TransportProvider>(context, listen: false);
    provider.clearTransportData();
    super.dispose();
  }

  Future<void> _fetchTransportPageDetails() async {
    final provider = Provider.of<TransportProvider>(context, listen: false);
    // provider.clearTransportData();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final loginData = authProvider.loginData;
    if (loginData == null) return;

    await provider.getTransportStatus(
      loginData.regno,
      loginData.currentyearfrom,
      loginData.currentyearto,
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<TransportProvider>(context);
    final student = Provider.of<StudentProfileProvider>(context);
    final transportStatus = data.transportResponseModel;
    final isRegistrationOn =
        (transportStatus?.registrationMode ?? '').toLowerCase() == 'on';
    final isTransportTaken = transportStatus?.isTransportTaken == '1';

    final registrationDetails = student.registrationDetails;
    final academicDetails = student.academicDetails;
    final hasStudentMeta = registrationDetails != null &&
        registrationDetails.isNotEmpty &&
        academicDetails != null &&
        academicDetails.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: Text(
          "Transport",
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
            size: 20.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),

      body: data.isLoading
          ? _buildShimmerLoader()
          : transportStatus == null
          ? _buildEmptyState()
          : isRegistrationOn
          ? isTransportTaken
          ? _buildTransportTabs(data)
          : Center(
        child: buildTransportForm(data),
      )
          : Center(child: buildTransportNotRegistered()),

      bottomNavigationBar:
        isRegistrationOn && isTransportTaken && hasStudentMeta
        ? _buildBottomTabs(
          data,
          registrationDetails.first.regno,
          academicDetails.first.className,
          academicDetails.first.section,
          academicDetails.first.stream,
          registrationDetails.first.fname
        )
        : const SizedBox.shrink(),
    );
  }

  Widget _buildTransportTabs(TransportProvider data) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: IndexedStack(
        index: selectedTab,
        children: const [
          FeeDetailsTab(),
          RouteDetailsTab(),
          LiveTrackingTab(),
        ],
      ),
    );
  }

  Widget buildTransportForm(TransportProvider data) {
  return Padding(
    padding: EdgeInsets.all(16.w),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 22.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: LinearGradient(
                colors: [
                  CustomColor.primaryColor,
                  CustomColor.primaryColor.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(
                  Icons.directions_bus_rounded,
                  size: 50.sp,
                  color: Colors.white,
                ),
                SizedBox(height: 10.h),
                Text(
                  "Transport Service",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Request & schedule transport",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          /// 🧾 Main Form Card
          Container(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ✅ Yes / No
                _fancyLabel(Icons.help_outline, "Use Transport Service"),
                _styledDropdown(
                  value: yesNoSelection,
                  hint: "Select option",
                  items: const ["Yes", "No"],
                  onChanged: (v) => setState(() => yesNoSelection = v),
                ),

                SizedBox(height: 18.h),

                /// 📅 Date Picker
                _fancyLabel(Icons.calendar_month_outlined, "Start Date"),
                GestureDetector(
                  onTap: _pickDate,
                  child: _fancyField(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate == null
                              ? "Choose date"
                              : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: selectedDate == null
                              ? CustomColor.colorGrey
                              : Colors.black87,
                          ),
                        ),
                        Icon(Icons.event, color: CustomColor.primaryColor),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 18.h),

                /// 📍 Transport Point
                _fancyLabel(Icons.location_on_outlined, "Pickup Point"),
                DropdownButtonFormField<String>(
                  value: selectedTransportPointId,
                  hint: const Text("Select pickup point"),
                  decoration: _fancyInputDecoration(),
                  items: (data.transportPoint ?? [])
                    .map(
                      (point) => DropdownMenuItem<String>(
                        value: point.pointId,
                        child: Text(point.pointName),
                      ),
                    )
                    .toList(),
                  onChanged: (value) {
                    String? pointName;
                    for (final point in (data.transportPoint ?? [])) {
                      if (point.pointId == value) {
                        pointName = point.pointName;
                        break;
                      }
                    }

                    setState(() {
                      selectedTransportPointId = value;
                      selectedTransportPointName = pointName;
                    });
                  },
                ),

                SizedBox(height: 30.h),

                /// 🚀 CTA Button
                GestureDetector(
                  onTap: () {
                    if ((yesNoSelection?.isEmpty ?? true) ||
                        selectedDate == null ||
                        (selectedTransportPointId?.isEmpty ?? true)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                            const Text("Please complete all fields"),
                          backgroundColor:
                            CustomColor.colorRedAccent,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GetNewTransportScreen(
                            yesNoSelection: yesNoSelection,
                            selectedDate: selectedDate,
                            selectedTransportPointId:
                              selectedTransportPointId,
                            selectedTransportPointName:
                              selectedTransportPointName,
                          ),
                        ),
                      );
                    }
                  },
                  child: Container(
                    height: 52.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          CustomColor.primaryColor,
                          CustomColor.primaryColor.withOpacity(0.85),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColor.primaryColor.withOpacity(0.35),
                          blurRadius: 14,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget buildTransportNotRegistered() {
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
                  Icons.directions_bus_rounded,
                  size: 80.sp,
                  color: CustomColor.primaryColor,
                ),
                SizedBox(height: 12.h),
                Text(
                  "You are not Registered for Transport",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Transport service is not registered for your account.\nPlease contact the school administration.",
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

  Widget _fancyLabel(IconData icon, String text) => Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      children: [
        Icon(icon, size: 18.sp, color: CustomColor.primaryColor),
        SizedBox(width: 6.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _fancyField({required Widget child}) => Container(
    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12.r),
      color: Colors.grey.shade50,
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: child,
  );

  InputDecoration _fancyInputDecoration() => InputDecoration(
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    contentPadding:
      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
  );

  Widget _styledDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      decoration: _fancyInputDecoration(),
      items: items
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
        .toList(),
      onChanged: onChanged,
    );
  }


  Widget _buildEmptyState() {
    return Center(
      child: Text(
        "No transport data found.",
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

  Widget _buildBottomTabs(
    TransportProvider data,
    reg,
    className,
    section,
    stream,
    fullName
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            tabButton("Fee Details", 0),
            tabButton("Route Details", 1),
            tabButton("Live Tracking", 2),
          ],
        ),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
            color: CustomColor.primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    fullName,
                    style: TextStyle(
                      color: CustomColor.colorWhite,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    "Class ${className+ stream+""+ section}",
                    style: TextStyle(
                      color: CustomColor.colorWhite,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(right: 12.w),
                child: SessionDropdown(
                  onSessionChanged: (from, to) async {
                    await data.getTransportStatus(reg, from,to);
                  },
                  disable: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget tabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: (){
        if (index == 2) {
        // SHOW POPUP
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.info_outline, 
                  color: CustomColor.primaryColor,
                  size: 28.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Information",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Text(
              "Live tracking is not available!.",
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        // NORMAL TAB SELECTION
        setState(() => selectedTab = index);
      }
    
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: isSelected
            ? EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h)
            : EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        decoration: BoxDecoration(
          color:
              isSelected ? CustomColor.primaryColor : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.r),
            topRight: Radius.circular(8.r),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }
}
