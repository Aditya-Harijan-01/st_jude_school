// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../models/common/book_response.dart';
import '../../../models/common/category_response.dart';
import '../../../models/common/class_response.dart';
import '../../../models/common/subject_response.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/employee/emp_syllabus.dart';
import '../../../providers/employee/employee_profile.dart';
import '../../../providers/student/get_session.dart';
import '../widget/top_card.dart';
import '../widget/access_denied_dialog.dart';

class EmployeeSyllabusScreen extends StatefulWidget {
  const EmployeeSyllabusScreen({super.key});

  @override
  State<EmployeeSyllabusScreen> createState() => _EmployeeSyllabusScreenState();
}

class _EmployeeSyllabusScreenState extends State<EmployeeSyllabusScreen> {
  String? selectedClass;
  String? selectedCategory;
  String? selectedSubject;
  String? selectedBook;

  String? className;
  String? stream = "";
  String? subjectType;

  String? fromYear;
  String? toYear;
  bool _hasShownAccessDeniedDialog = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthProvider>();
      final syllabus = context.read<EmployeeSyllabusProvider>();

      fromYear = auth.loginData?.currentyearfrom;
      toYear = auth.loginData?.currentyearto;

      _loadInitial(syllabus);
    });
  }

  Future<void> _loadInitial(EmployeeSyllabusProvider syllabus) async {
    final auth = context.read<AuthProvider>();
    final empId = auth.loginData?.empId ?? "";

    await syllabus.activeClassList(empId, fromYear, toYear);
    await syllabus.subjectType(empId, fromYear, toYear);
  }

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionProvider>();
    final auth = context.read<AuthProvider>();
    final empProvider = context.watch<EmployeeProfileProvider>();
    final syllabus = context.watch<EmployeeSyllabusProvider>();

    final empId = auth.loginData?.empId ?? "-";

    if (syllabus.classResponse != null &&
        syllabus.classResponse!.userAccessValue != 0 &&
        !_hasShownAccessDeniedDialog) {
      _hasShownAccessDeniedDialog = true;
      Navigator.pop(context);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAccessDeniedDialog(context, 'You do not have permission to view syllabus data.');
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        title: Text("SYLLABUS",
          style: TextStyle(
            color: CustomColor.colorWhite, 
            fontSize: 18.sp
          )
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            buildTopCard(
              (from, to) async {
                fromYear = from;
                toYear = to;
                selectedClass = null;
                selectedCategory = null;
                selectedSubject = null;
                selectedBook = null;

                await _loadInitial(syllabus);
                setState(() {});
              },
              session,
              empProvider,
              empId,
              "",
              "",
              true
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Class"),
                  _dropdown<ClassData>(
                    hint: "Choose Class",
                    isLoading: syllabus.isLoadingClass,
                    value: selectedClass,
                    items: syllabus.classData?.map((e) => e.className).toList(),
                    onChanged: (value) async {
                      selectedClass = value;
                      selectedCategory = null;
                      selectedSubject = null;
                      selectedBook = null;

                      final selectedObj = syllabus.classData!
                          .firstWhere((e) => e.className == value);

                      className = selectedObj.className;
                      stream = selectedObj.classId.split('_')[1];

                      final auth = context.read<AuthProvider>();
                      final empId = auth.loginData!.empId;

                      await syllabus.subjectType(empId, fromYear, toYear);
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20.h),

                  _label("Category"),
                  _dropdown<CategoryData>(
                    hint: "Choose Category",
                    isLoading: syllabus.isLoadingCategory,
                    value: selectedCategory,
                    items: syllabus.categroyDate
                        ?.map((e) => e.typeName)
                        .toList(),
                    onChanged: (value) async {
                      selectedCategory = value;
                      selectedSubject = null;
                      selectedBook = null;

                      final selectedObj = syllabus.categroyDate!
                          .firstWhere((e) => e.typeName == value);

                      subjectType = selectedObj.typeId;

                      final auth = context.read<AuthProvider>();
                      final empId = auth.loginData!.empId;

                      await syllabus.allSubjectList(empId, className!, stream!,
                          subjectType!, fromYear, toYear);

                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20.h),

                  _label("Subject"),
                  _dropdown<SubjectData>(
                    hint: "Choose Subject",
                    isLoading: syllabus.isLoadingSubject,
                    value: selectedSubject,
                    items: syllabus.subjectData
                        ?.map((e) => e.subjectName)
                        .toList(),
                    onChanged: (value) async {
                      selectedSubject = value;
                      selectedBook = null;

                      final selectedObj = syllabus.subjectData!
                          .firstWhere((e) => e.subjectName == value);

                      final subCode = selectedObj.subjectCode;

                      final auth = context.read<AuthProvider>();
                      final empId = auth.loginData!.empId;

                      await syllabus.bookList(
                          empId, className!, stream!, subCode, fromYear);

                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20.h),

                  _label("Book"),
                  _dropdown<BookData>(
                    hint: "Choose Book",
                    isLoading: syllabus.isLoadingBook,
                    value: selectedBook,
                    items:
                        syllabus.bookData?.map((e) => e.bookName).toList(),
                    onChanged: (value) async {
                      selectedBook = value;

                      final bookObj = syllabus.bookData!
                          .firstWhere((e) => e.bookName == value);

                      final subjectObj = syllabus.subjectData!.firstWhere(
                          (e) => e.subjectName == selectedSubject);

                      final auth = context.read<AuthProvider>();
                      final empId = auth.loginData!.empId;

                      await syllabus.getSyllabusByBook(
                        empId,
                        fromYear,
                        toYear,
                        subjectObj.subjectCode,
                        bookObj.bookId,
                      );

                      setState(() {});
                    },
                  ),

                  SizedBox(height: 30.h),
                  _buildChapterList(syllabus),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text,
      style: TextStyle(
        fontSize: 14.sp, 
        fontWeight: FontWeight.w600
      )
    );
  }

  Widget _dropdown<T>({
    required String hint,
    required bool isLoading,
    required String? value,
    required List<String>? items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: CustomColor.colorWhite,
        border: Border.all(color: CustomColor.primaryColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                hint: Text(hint),
                items: items?.map((text) {
                  return DropdownMenuItem(value: text, child: Text(text));
                }).toList(),
                onChanged: isLoading ? null : onChanged,
              ),
            ),
          ),
          if (isLoading)
            SizedBox(
              width: 18.h,
              height: 18.h,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  Widget _buildChapterList(EmployeeSyllabusProvider syllabus) {
    if (syllabus.isLoadingChapter) {
      return const Center(child: CircularProgressIndicator());
    }

    if (syllabus.syllabusChapter == null) {
      return const SizedBox();
    }

    if (syllabus.syllabusChapter!.isEmpty) {
      return const Text("No chapters available");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: syllabus.syllabusChapter!.map((chap) {
        return Container(
          padding: EdgeInsets.all(10.w),
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            color: CustomColor.colorWhite,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12, 
                blurRadius: 4, 
                offset: Offset(0, 2)
              )
            ],
          ),
          child: Text(
            chap.chapterName ,
            style: TextStyle(
              fontSize: 15.sp, 
              fontWeight: FontWeight.w500
            ),
          ),
        );
      }).toList(),
    );
  }
}


