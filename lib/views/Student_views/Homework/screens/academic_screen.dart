import 'dart:developer';
import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/student/get_assignment.dart';
import '../widgets/loader.dart';
import '../widgets/search_bar.dart' as academic_search_bar;
import '../widgets/homework_card.dart';
import '../widgets/academic_bottom_sheet.dart';
import 'academic_detail_screen.dart';


class AcademicScreen extends StatefulWidget {
   const AcademicScreen({super.key});

   @override
   State<AcademicScreen> createState() => _AcademicScreenState();
 }

 class _AcademicScreenState extends State<AcademicScreen> {
  bool _showActiveOnly = true;
  bool _showFilters = false;

  String _searchQuery = "";
  String _selectedSubject = "All";
  String _selectedClass = "All";

  late StudentAssignmentProvider assignmentProvider;


  @override
  void initState() {
    super.initState();
    assignmentProvider = Provider.of<StudentAssignmentProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => 
    _fetchStudentAssignment());
  }

  void _openSubjectFilter(BuildContext context) {
    final provider = context.read<StudentAssignmentProvider>();
    final subjects = ["All Subject", ...{
      for (var a in provider.studentAssignment ?? []) a.subjectName
    }];

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        padding: EdgeInsets.all(12.w),
        children: subjects.map((sub) {
          return ListTile(
            title: Text(sub),
            onTap: () {
              setState(() => _selectedSubject = sub);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _fetchStudentAssignment() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final userID = auth.loginData!.regno;
      final fromYear = auth.loginData!.currentyearfrom;
      final toYear = auth.loginData!.currentyearto;

      await assignmentProvider.getAssignment(userID, fromYear, toYear);
    } catch (e, s) {
      log('Error fetching assignments: $e');
      debugPrintStack(stackTrace: s);
    }
  }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: CustomColor.colorWhite,
       appBar: AppBar(
         title:  Text('Assignment',
         style: TextStyle(
           fontSize: 24.sp
         ) ,),
         backgroundColor: CustomColor.primaryColor,
         foregroundColor: CustomColor.colorWhite,
         leading: IconButton(
           icon: Icon(Icons.arrow_back, size: 24.sp,),
           onPressed: () => Navigator.pop(context),
         ),
       ),
       body: Column(
         children: [
           Container(
             decoration: BoxDecoration(
               color: Colors.grey.shade50,
               borderRadius: BorderRadius.circular(20.r),
               border: Border.all(
                 color: CustomColor.primaryColor,
                 width: 1.2.w,
               ),
             ),
             margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
             padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   _showActiveOnly ? 'Active Homeworks' : 'Completed Homeworks',
                   style: TextStyle(
                     fontSize: 18.sp,
                     fontWeight: FontWeight.w600,
                     color: CustomColor.primaryColor,
                   ),
                 ),
                 SizedBox(
                   height: 20.h,
                   child: Transform.scale(
                     scale: 0.8,
                     child: Switch(
                       value: _showActiveOnly,
                       onChanged: (value) {
                         setState(() {
                           _showActiveOnly = value;
                         });
                       },
                       activeThumbColor: CustomColor.primaryColor,
                       inactiveThumbColor: Colors.grey.shade300,
                       inactiveTrackColor: Colors.grey.shade400,
                     ),
                   ),
                 ),
               ],
             ),
           ),

           academic_search_bar.SearchBar(
            onChanged: (value) {
              setState(() {
                _searchQuery = value.toLowerCase().trim();
              });
            },
            onFilterTap: (){
              setState(() {
                _showFilters = !_showFilters;
              });
            }
           ),
           _showFilters ?
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildFilterButton(
                    label: _selectedSubject,
                    onTap: () => _openSubjectFilter(context),
                  ),
                  // SizedBox(width: 10.w),
                  // _buildFilterButton(
                  //   label: _selectedClass,
                  //   onTap: () => _openClassFilter(context),
                  // ),
                ],
              ),
            )
            : SizedBox.shrink(),
           Expanded(
             child: Consumer<StudentAssignmentProvider>(
               builder: (context, provider, _) {
                 if (provider.isLoading) {
                   return ListView.builder(
                     itemCount: 5,
                     itemBuilder: (context, index) => Padding(
                       padding: EdgeInsets.only(bottom: 12.h, left: 10.h, right: 10.h),
                       child: const HomeworkCardShimmer(),
                     ),
                   );
                 }
             
                 final assignments = provider.studentAssignment ?? [];

                final filteredAssignments = assignments.where((item) {
                final isCompleted = item.displayStatus.toLowerCase() == "completed";

                // 1️⃣ Active/Completed toggle
                final statusMatch =
                    _showActiveOnly ? !isCompleted : isCompleted;

                // 2️⃣ Search filtering
                final searchMatch = _searchQuery.isEmpty ||
                    item.subjectName.toLowerCase().contains(_searchQuery) ||
                    item.chapterName.toLowerCase().contains(_searchQuery) ||
                    item.teacherName.toLowerCase().contains(_searchQuery) ||
                    item.assignmentDetails.toLowerCase().contains(_searchQuery);

                // 3️⃣ Subject filter
                final subjectMatch =
                    _selectedSubject == "All" || item.subjectName == _selectedSubject;

                // 4️⃣ Class filter
                final classMatch =
                    _selectedClass == "All" || item.className == _selectedClass;

                return statusMatch && searchMatch && subjectMatch && classMatch;
              }).toList();

             
                 if (filteredAssignments.isEmpty) {
                   return Center(
                     child: Text(
                       "No Assignment Available",
                       style: TextStyle(
                         color: CustomColor.colorGrey, 
                         fontSize: 20.sp
                       )
                     )
                   );
                 }
             
                 return ListView.builder(
                    padding: EdgeInsets.only(
                     left: 16.w,
                     right: 16.w,
                     top: 8.h,
                     bottom: 135.h, // Add bottom padding to account for bottom sheet
                   ),
                   itemCount: filteredAssignments.length,
                   itemBuilder: (context, index) {
                     final assignment = filteredAssignments[index];
                     return Column(
                       children: [
                         GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) =>  AcademicDetailScreen(assignment: assignment)));
                            },
                            child: HomeworkCard(
                              subject: assignment.subjectName,
                              chapter: assignment.chapterName,
                              teacher: assignment.teacherName,
                              dueDate: assignment.assignmentSubmissionDate,
                              // isOverdue: false,
                              isCompleted: assignment.displayStatus.toLowerCase() == "completed",
                              imageUrl: assignment.teacherImage,
                              attachments: assignment.docList,
                            ),
                         ),
                         SizedBox(height: 12.h),
                       ],
                     );
                   },
                 );
               },
             ),
           ),

        ],
      ),
      bottomSheet: Consumer<StudentAssignmentProvider>(
        builder: (context, provider, _) {
          return AcademicBottomSheet(
            title: _showActiveOnly
                ? "Active Assignments"
                : "Completed Assignments",
            total: _showActiveOnly
                ? provider.activeCount
                : provider.completedCount,
          );
        },
      ),
    );
  }
}


Widget _buildFilterButton({required String label, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp)),
          SizedBox(width: 6.w),
          const Icon(Icons.arrow_drop_down, size: 20),
        ],
      ),
    ),
  );
}
