import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/employee/teacher_mark_entry_provider.dart';
import '../../../../../models/employee/teacher_mark_entry_model.dart';

class TeacherDropdown extends StatefulWidget {
  final String empId;
  final String to;
  final String from;
  final VoidCallback? onTeacherChanged;
  const TeacherDropdown({
    super.key,
    required this.empId,
    required this.to,
    required this.from,
    this.onTeacherChanged,
  });

  @override
  State<TeacherDropdown> createState() => _TeacherDropdownState();
}

class _TeacherDropdownState extends State<TeacherDropdown> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final teacherProvider = context.read<TeacherMarkEntryProvider>();
      await teacherProvider.getTeacherForMarkEntry(
        empId: widget.empId,
        fromYear: widget.from,
        toYear: widget.to,
      );

      final available = teacherProvider.availableTeachers;
      if (available.isNotEmpty && teacherProvider.selectedTeacher == null) {
        final first = available.first;
        teacherProvider.setSelectedTeacher(first);
        await _loadClassesForSelectedTeacher(teacherProvider);
      } else if (teacherProvider.selectedTeacher != null) {
        await _loadClassesForSelectedTeacher(teacherProvider);
      }
    });
  }

  Future<void> _loadClassesForSelectedTeacher(
      TeacherMarkEntryProvider teacherProvider) async {
    final selected = teacherProvider.selectedTeacher;
    if (selected == null) return;

    // Reset all dependent dropdowns when teacher changes
    teacherProvider.setSelectedClass(null);
    
    await teacherProvider.getClassForMarkEntry(
      empId: selected.empId,
      fromYear: widget.from,
      toYear: widget.to,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TeacherMarkEntryProvider>(
      builder: (context, teacherProvider, child) {
        final teachers = teacherProvider.availableTeachers;
        
        // Validate that selected teacher still exists in the list
        final selectedTeacher = teacherProvider.selectedTeacher;
        final isSelectedTeacherValid = selectedTeacher != null &&
            teachers.any((teacher) => teacher.empId == selectedTeacher.empId);
        
        // Clear selected teacher if it's no longer valid
        if (selectedTeacher != null && !isSelectedTeacherValid) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            teacherProvider.setSelectedTeacher(null);
          });
        }
        
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TeacherMarkEntryData>(
              value: isSelectedTeacherValid ? selectedTeacher : null,
              isExpanded: true,
              hint: Row(
                children: [
                  CircleAvatar(
                    radius: 14.r,
                    backgroundColor: CustomColor.primaryColor,
                    child: Icon(Icons.person, color: Colors.white, size: 18.sp),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    teachers.isEmpty
                        ? "Loading teachers..."
                        : "Select a Teacher",
                    style: TextStyle(color: Colors.black87, fontSize: 16.sp),
                  ),
                ],
              ),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: teachers.map((TeacherMarkEntryData teacher) {
                return DropdownMenuItem<TeacherMarkEntryData>(
                  value: teacher,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14.r,
                        backgroundColor: CustomColor.primaryColor,
                        child: Icon(Icons.person, color: Colors.white, size: 18.sp),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          teacher.empName,
                          style: TextStyle(color: Colors.black87, fontSize: 15.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: teachers.isEmpty
                  ? null
                  : (TeacherMarkEntryData? value) async {
                      if (value == null) return;
                      
                      widget.onTeacherChanged?.call();
                      
                      teacherProvider.setSelectedTeacher(value);
                      await _loadClassesForSelectedTeacher(teacherProvider);
                    },
            ),
          ),
        );
      },
    );
  }
}
