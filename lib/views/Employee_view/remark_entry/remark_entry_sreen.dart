import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants/colors.dart';
import '../../../widgets/info_card_shimmer.dart';
import '../widget/common_bottom_sheet_emp.dart';
import 'remark_student_card.dart';
import 'package:provider/provider.dart';
import '../../../providers/employee/remark_entry_provider.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../models/employee/remark_entry_model.dart';

class RemarkEntrySreen extends StatefulWidget {
  const RemarkEntrySreen({super.key});

  @override
  State<RemarkEntrySreen> createState() => _RemarkEntrySreenState();
}

class _RemarkEntrySreenState extends State<RemarkEntrySreen> {
  String toYear = '';
  String fromYear = '';
  String empId = '';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final provider = context.read<RemarkEntryProvider>();
      provider.clearStudent();
      setState(() {
        toYear = auth.loginData?.currentyearto ?? '';
        fromYear = auth.loginData?.currentyearfrom ?? '';
        empId = auth.loginData?.empId ?? '';
      });

      if (empId.isNotEmpty && fromYear.isNotEmpty && toYear.isNotEmpty) {
        provider.getClassForRemarkEntry(empId: empId, fromYear: fromYear, toYear: toYear);
        provider.getTermForRemarkEntry(empId: empId, fromYear: fromYear, toYear: toYear);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }


  Future<void> _onSessionChange(String from, String to) async {
    setState(() {
      toYear = to;
      fromYear = from;
    });

    if (empId.isNotEmpty) {
      final provider = context.read<RemarkEntryProvider>();
      provider.clearStudent();
      await provider.getClassForRemarkEntry(empId: empId, fromYear: fromYear, toYear: toYear);
      await provider.getTermForRemarkEntry(empId: empId, fromYear: fromYear, toYear: toYear);
    }
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required IconData icon,
    required String Function(T) getLabel,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: CustomColor.primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          dropdownColor: Colors.white,
          menuMaxHeight: 200.h,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black54),
          hint: Row(
            children: [
               CircleAvatar(
                radius: 16.r,
                backgroundColor: CustomColor.primaryColor,
                child: Icon(icon, color: Colors.white, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((T item) {
              return Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: CustomColor.primaryColor,
                    child: Icon(icon, color: Colors.white, size: 18.sp),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    getLabel(item),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }).toList();
          },
          items: items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                getLabel(item),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: 'Search for students...',
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.6),
              fontSize: 16.sp,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 22.sp),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            isDense: true,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
            size: 20.sp,
          ),
        ),
        title: Text(
            "Examination Remarks",
            style:TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 20.sp)
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  CustomColor.primaryColor,
                  CustomColor.secondaryColor,
                ]),
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(8.r), bottom: Radius.zero),
                border: Border(
                    bottom: BorderSide(
                        color: CustomColor.primaryColor, width: 2))),
            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Reg No.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.white),
                  ),
                  SizedBox(width: 20.w),
                  Text(
                    'Student Name',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.white),
                  )
            ]
            ),
          ),
          Expanded(
            child: Consumer<RemarkEntryProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return  ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index)
                      {
                        return Column(
                          children: [
                            InfoCardShimmer(),
                            SizedBox(height: 10.h)
                          ],
                        );
                      }
                  );;
                }

                final filteredList = provider.studentList.where((student) {
                  final name = (student.studentName ?? '').toLowerCase();
                  final reg = (student.regno ?? '').toLowerCase();
                  return name.contains(_searchQuery) ||
                      reg.contains(_searchQuery);
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      "No students found",
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final student = filteredList[index];
                    return Card(
                      color: Colors.white,
                      elevation: 1,
                      margin: EdgeInsets.only(bottom: 10.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        splashColor: CustomColor.primaryColor.withAlpha(50),
                        highlightColor: CustomColor.secondaryColor.withAlpha(50),
                        onTap: () {
                           final academicOptions = student.accademicRemarkHeads?.map((e) => e.remarkHead ?? '').toList();
                           final attendanceOptions = student.attendanceRemarkHeads?.map((e) => e.remarkHead ?? '').toList();
                           final resultOptions = student.resultRemarkHeads?.map((e) => e.remarkHead ?? '').toList();

                           String? initialAcademic;
                           try {
                             initialAcademic = student.accademicRemarkHeads?.firstWhere(
                               (e) => e.isAccademicRemarkSelected?.toLowerCase() == 'yes',
                             ).remarkHead;
                           } catch (_) {}

                           String? initialAttendance;
                           try {
                             initialAttendance = student.attendanceRemarkHeads?.firstWhere(
                               (e) => e.isAccademicRemarkSelected?.toLowerCase() == 'yes',
                             ).remarkHead;
                           } catch (_) {}

                           String? initialResult;
                           try {
                             initialResult = student.resultRemarkHeads?.firstWhere(
                               (e) => e.isResultRemarkSelected?.toLowerCase() == 'yes',
                             ).remarkHead;
                           } catch (_) {}
                           showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => RemarkStudentCard(
                              studentName: student.studentName ?? '',
                              sid: student.sid ?? '',
                              termId: provider.selectedTerm?.examId ?? '',
                              fromYear: fromYear,
                              toYear: toYear,
                              studentId: student.regno ?? '',
                              academicPercentage: student.accademicPercent ?? '',
                              attendancePercentage: student.attendancePercent ?? '',
                              academicFlag: student.accademicSection == true ? "true" : "false",
                              attendanceFlag: student.attendanceSection == true ? "true" : "false",
                              resultFlag: student.resultSection == true ? "true" : "false",

                              academicOptions: academicOptions,
                              attendanceOptions: attendanceOptions,
                              resultOptions: resultOptions,
                              initialAcademicRemark: initialAcademic,
                              initialAttendanceRemark: initialAttendance,
                              initialResultRemark: initialResult,
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(color: Colors.transparent),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        CustomColor.primaryColor.withAlpha(150),
                                        CustomColor.primaryOne
                                      ],
                                      begin: AlignmentGeometry.topLeft,
                                      end: AlignmentGeometry.bottomRight),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8.r),
                                      bottomLeft: Radius.circular(8.r)),
                                ),
                                child: Text(
                                  student.regno ?? '',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 18.w),
                              Expanded(
                                child: Text(
                                  student.studentName ?? '',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(2.w),
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: CustomColor.primaryColor,
                                        width: 1)),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 14.sp,
                                  color: CustomColor.primaryColor,
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CommonBottomSheetEmp(
        onSessionChange: _onSessionChange,
        content: Container(
          color: CustomColor.primaryColor,
          child: Column(
            children: [
              Consumer<RemarkEntryProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      _buildDropdown<RemarkProfileClass>(
                        label: "Select Class",
                        value: provider.selectedClass,
                        items: provider.classList,
                        icon: Icons.person_outline,
                        getLabel: (item) => item.className ?? '',
                        onChanged: (val) {
                          provider.setSelectedClass(val);
                        },
                      ),
                      SizedBox(height: 8.h),
                      _buildDropdown<RemarkTerm>(
                        label: "Select Term",
                        value: provider.selectedTerm,
                        items: provider.termList,
                        icon: Icons.description_outlined,
                        getLabel: (item) => item.examName ?? '',
                        onChanged: (val) {
                          provider.setSelectedTerm(val);
                        },
                      ),
                      if (provider.selectedClass != null && provider.selectedTerm != null &&  !provider.isLoading) ...[
                        SizedBox(height: 8.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              provider.getStudentRemarkEntryList(
                                fromYear: fromYear,
                                toYear: toYear,
                                classId: provider.selectedClass?.classId ?? '',
                                examId: provider.selectedTerm?.examId ?? '',
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CustomColor.colorSessionBorder,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                                side: BorderSide(
                                  color: CustomColor.secondaryColor,
                                  width: 2,            
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                                    'Continue',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: CustomColor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
