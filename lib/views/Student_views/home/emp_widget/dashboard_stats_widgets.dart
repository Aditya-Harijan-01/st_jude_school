
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../constants/colors.dart';

class EmployeeAttendanceStats extends StatefulWidget {
  const EmployeeAttendanceStats({super.key});

  @override
  State<EmployeeAttendanceStats> createState() => _EmployeeAttendanceStatsState();
}

class _EmployeeAttendanceStatsState extends State<EmployeeAttendanceStats> {
  String selectedStat = "Total";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorShadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: CustomColor.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.people_alt_rounded,
                    color: CustomColor.primaryColor, size: 20.sp),
              ),
              SizedBox(width: 10.w),
              Text(
                "Employee Attendance",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                  child: _buildStatItem("Total", "150", CustomColor.colorBlue)),
              Expanded(
                  child:
                      _buildStatItem("Present", "120", CustomColor.colorGreen)),
              Expanded(
                  child: _buildStatItem("Absent", "15", CustomColor.colorRed)),
              Expanded(
                  child:
                      _buildStatItem("On Leave", "15", CustomColor.barYellow)),
            ],
          ),
          SizedBox(height: 15.h),
         if(selectedStat.isNotEmpty) _buildEmployeeList(),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String count, Color color) {
    final isSelected = selectedStat == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStat = label;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: isSelected ? Border.all(color: color, width: 1) : null,
              boxShadow: isSelected ? [
                BoxShadow(
                  color: color.withAlpha(100),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ] : []
            ),
            child: Text(
              count,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: isSelected ? color : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeList() {
    return Container(
      height: 235.h,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: _getEmployees().map((e) => _buildEmployeeRow(e)).toList(),
        ),
      ),
    );
  }

  Widget _buildEmployeeRow(Map<String, String> employee) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Center(
              child: Text(
                employee["name"]![0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomColor.primaryColor,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee["name"]!,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  employee["designation"]!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: _getStatusColor(employee["status"]!).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              employee["status"]!,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(employee["status"]!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Present": return CustomColor.colorGreen;
      case "Absent": return CustomColor.colorRed;
      case "On Leave": return CustomColor.barYellow;
      default: return Colors.grey;
    }
  }

  List<Map<String, String>> _getEmployees() {
    List<Map<String, String>> all = [
  {"name": "Rakesh Sharma", "designation": "Senior Math Teacher", "status": "Present"},
  {"name": "Neha Verma", "designation": "Science Lab Admin", "status": "Present"},
  {"name": "Sanjay Kumar", "designation": "Bus Driver", "status": "Absent"},
  {"name": "Anita Das", "designation": "Bus Driver", "status": "On Leave"},
  {"name": "Amitabh Singh", "designation": "Vice Principal", "status": "Present"},
  {"name": "Pooja Mehta", "designation": "English Teacher", "status": "Present"},
  {"name": "Rahul Chatterjee", "designation": "Advanced Sport Coach", "status": "Present"},
  {"name": "Sneha Iyer", "designation": "Physics Teacher", "status": "Absent"},
  {"name": "Vikram Malhotra", "designation": "Head of Security", "status": "Present"},
  {"name": "Kavita Nair", "designation": "Assamese Teacher", "status": "On Leave"},
]
;

    if (selectedStat == "Total") return all;
    return all.where((e) => e["status"] == selectedStat).toList();
  }
}

class StudentAttendanceStats extends StatefulWidget {
  const StudentAttendanceStats({super.key});

  @override
  State<StudentAttendanceStats> createState() => _StudentAttendanceStatsState();
}

class _StudentAttendanceStatsState extends State<StudentAttendanceStats> {
  bool isWholeSchool = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: CustomColor.secondaryColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorShadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.school_rounded,
                        color: Colors.white, size: 20.sp),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    "Student Attendance",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15.h),
          // Toggle
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isWholeSchool = true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isWholeSchool
                            ? CustomColor.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: isWholeSchool
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                )
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Whole School",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isWholeSchool
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isWholeSchool = false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      decoration: BoxDecoration(
                        color: !isWholeSchool
                            ? CustomColor.primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: !isWholeSchool
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                )
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Per Class",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: !isWholeSchool
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isWholeSchool) _buildWholeSchoolStats() else _buildPerClassStats(),
        ],
      ),
    );
  }

  Widget _buildWholeSchoolStats() {
    return Container(

      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 20.h),

          _buildCircularProgressIndicator("1200", 0.92), // 92% present
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               _buildStatDetail("Total", "1300", CustomColor.primaryColor),
               Container(width: 1, height: 30.h, color: Colors.grey[300]),
               _buildStatDetail("Present", "1200", CustomColor.attendanceGreen),
               Container(width: 1, height: 30.h, color: Colors.grey[300]),
               _buildStatDetail("Absent", "100", CustomColor.colorRedAccent),
            ],
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildPerClassStats() {
    final classes = [
      {"name": "Class 10", "present": "45", "total": "50"},
      {"name": "Class 9", "present": "48", "total": "50"},
      {"name": "Class 8", "present": "40", "total": "45"},
      {"name": "Class 7", "present": "55", "total": "60"},
      {"name": "Class 6", "present": "52", "total": "55"},
      {"name": "Class 5", "present": "65", "total": "75"},
      {"name": "Class 4", "present": "45", "total": "55"},
      {"name": "Class 3", "present": "54", "total": "55"},
      {"name": "Class 2", "present": "63", "total": "65"},
      {"name": "Class 1", "present": "33", "total": "46"},
      {"name": "Class kg", "present": "67", "total": "67"},
      {"name": "Class NRY", "present": "72", "total": "74"},

    ];

    return Container(
      height: 235.h,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12.r),
          bottomRight: Radius.circular(12.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: classes.map((c) => _buildClassRow(c)).toList(),
        ),
      ),
    );
  }

  Widget _buildClassRow(Map<String, String> data) {
    final present = int.parse(data["present"]!);
    final total = int.parse(data["total"]!);
    final percent = present / total;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data["name"]!,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "students: ",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: "$present / $total",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.attendanceGreen,
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                  percent > 0.8 ? CustomColor.attendanceGreen : CustomColor.colorRedAccent),
              minHeight: 6.h,
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildCircularProgressIndicator(String count, double percent) {
     return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 120.w,
            height: 120.w,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 10.w,
              backgroundColor: CustomColor.primaryLight,
              valueColor: AlwaysStoppedAnimation<Color>(CustomColor.attendanceGreen),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                "${(percent*100).toInt()}%",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.attendanceGreen,
                ),
              ),
              Text(
                "Present",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStatDetail(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}


class PaymentCollectedStats extends StatelessWidget {
  const PaymentCollectedStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h),
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: CustomColor.barYellow, width: 2),
        boxShadow: [
          BoxShadow(
            color: CustomColor.colorShadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: CustomColor.barYellow.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.payments_rounded,
                    color: CustomColor.barYellow, size: 20.sp),
              ),
              SizedBox(width: 10.w),
              Text(
                "Payment Collected",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: CustomColor.barYellow,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [CustomColor.barYellow, CustomColor.yellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                 BoxShadow(
                  color: CustomColor.barYellow.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Collected Today",
                       style: TextStyle(
                         color: Colors.white.withOpacity(0.8),
                         fontSize: 12.sp,
                       ),
                    ),
                    SizedBox(height: 4.h),
                    Text("₹ 45,200",
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 26.sp,
                         fontWeight: FontWeight.bold,
                       ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.show_chart, color: Colors.white, size: 24.sp),
                )
              ],
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "Breakd own",
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 10.h),
          _buildSectorRow("Tuition Fees", "25,000", Colors.blue),
          _buildSectorRow("Transport", "10,200", Colors.orange),
          _buildSectorRow("Hostel", "8,000", Colors.purple),
          _buildSectorRow("Library", "2,000", Colors.teal),
        ],
      ),
    );
  }

  Widget _buildSectorRow(String sector, String amount, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              sector,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            "₹ $amount",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
