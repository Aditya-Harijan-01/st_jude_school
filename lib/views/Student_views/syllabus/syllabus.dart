import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/common/common_Session.dart';
import '../../../providers/student/syllabuss.dart';
import 'widgets/arrow_widget.dart';
import 'widgets/search_widget.dart';
import 'widgets/shimmer_loader.dart';
import 'widgets/sub_topic.dart';
import 'widgets/syllabus_bottom_sheet.dart';
import 'widgets/syllabus_tiles.dart';

class SyllabusScreen extends StatefulWidget {
  const SyllabusScreen({super.key});

  @override
  State<SyllabusScreen> createState() => _SyllabusScreenState();
}

class _SyllabusScreenState extends State<SyllabusScreen> {
  String selectedSubject = '';
  String? selectedSubCode;
  String? selectedExamId;
  String _searchQuery = '';
  String? selectedFromYear;
  String? selectedToYear;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initSessionAndSyllabus();
    });
  }

  Future<void> _initSessionAndSyllabus() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    selectedFromYear = auth.loginData!.currentyearfrom;
    selectedToYear = auth.loginData!.currentyearto;

    await _fetchStudentSyllabus(selectedFromYear!, selectedToYear!);
  }

  Future<void> _fetchStudentSyllabus(String fromYear, String toYear) async {
    final syllabusProvider = Provider.of<SubjectSyllabusProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    String userID = authProvider.loginData!.regno;

    await syllabusProvider.getExaminationList(userID, fromYear, toYear);
    await syllabusProvider.getStudentSyllabus(userID, fromYear, toYear);

    if (syllabusProvider.subjectData != null && syllabusProvider.subjectData!.isNotEmpty) {
      setState(() {
        selectedSubject = syllabusProvider.subjectData!.first.subName?.trim() ?? '';
        selectedSubCode = syllabusProvider.subjectData!.first.subCode;
        if (syllabusProvider.examinationData != null && syllabusProvider.examinationData!.isNotEmpty) {
          selectedExamId = syllabusProvider.examinationData!.first.examId;
        }
      });

      if (selectedSubCode != null && selectedExamId != null) {
        await syllabusProvider.getSyllabusDetailsByExam(
          userID,
          fromYear,
          toYear,
          selectedSubCode,
          selectedExamId,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final syllabusProvider = Provider.of<SubjectSyllabusProvider>(context);
    final subjectList = syllabusProvider.subjectData;
    final filteredSubjects = subjectList
      ?.where((s) => (s.subName ?? '')
        .toLowerCase()
        .contains(_searchQuery.toLowerCase()))
      .toList();

    final selectedSyllabusData = syllabusProvider.syllabusData;

    return Scaffold(
      backgroundColor: CustomColor.colorWhite,
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
          "Syllabus",
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 22.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchWidget(
              onChanged: (query) {
                setState(() => _searchQuery = query);
              },
            ),
            SizedBox(height: 16.h),

            if (filteredSubjects != null && filteredSubjects.isNotEmpty)
              SubjectListWithArrows(
                subjects: filteredSubjects,
                selectedSubject: selectedSubject,
                onSubjectTap: (subName, subCode) async {
                  setState(() {
                    selectedSubject = subName;
                    selectedSubCode = subCode;
                  });
                  final authProvider = Provider.of<AuthProvider>(context, listen: false);

                  if (selectedExamId != null) {
                    await syllabusProvider.getSyllabusDetailsByExam(
                      authProvider.loginData!.regno,
                      selectedFromYear!,
                      selectedToYear!,
                      selectedSubCode,
                      selectedExamId,
                    );
                  }
                },
              ),

            SizedBox(height: 20.h),

            // Syllabus List
            Expanded(
              child: syllabusProvider.isLoading
              ? ListView.builder(
                itemCount: 16,
                itemBuilder: (_, __) => buildSyllabusTileShimmer(),
              )
              : selectedSyllabusData == null || selectedSyllabusData.isEmpty
                ? Center(
                  child: Text(
                    "No syllabus found",
                    style: TextStyle(
                      color: CustomColor.colorGrey
                    ),
                  )
                )
                :
              ListView.builder(
                    itemCount: selectedSyllabusData.length,
                    itemBuilder: (context, index) {
                      final syllabusBook = selectedSyllabusData[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildSyllabusTile(
                            title: syllabusBook.bookName ?? "N/a",
                            details: syllabusBook.syllabus
                              ?.map(
                                (item) => buildSubTopic(
                                  item.chapterName ?? "-",
                                  "Page: ${item.pages ?? "-"}",
                                  "Period: ${item.periods ?? "-"}",
                                  item.examName ?? "-",
                                ),
                              )
                              .toList() ??
                            [],
                            context: context,
                            isInitiallyExpanded: true,
                          ),
                          SizedBox(height: 12.h),
                        ],
                      );
                    },
                  ),
              // SizedBox()
            ),
          ],
        ),
      ),
      bottomNavigationBar: SyllabusBottomSheet(
        selectedExamId: selectedExamId,
        onSessionChange: (from, to) async {
          await _fetchStudentSyllabus(from, to);
        },
        onExamChange: (examId) async {
          setState(() {
            selectedExamId = examId;
          });
          if (selectedSubCode != null && selectedFromYear != null && selectedToYear != null) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            final syllabusProvider = Provider.of<SubjectSyllabusProvider>(context, listen: false);
            await syllabusProvider.getSyllabusDetailsByExam(
              authProvider.loginData!.regno,
              selectedFromYear!,
              selectedToYear!,
              selectedSubCode,
              examId,
            );
          }
        },
      ),
    );
  }
}

