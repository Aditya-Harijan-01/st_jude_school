import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';
import '../../../../models/Students/syllabus_model.dart';

class SubjectListWithArrows extends StatefulWidget {
  final List<SubjectData> subjects;
  final String selectedSubject;
  final Function(String, String?) onSubjectTap;

  const SubjectListWithArrows({
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectTap,
    super.key,
  });

  @override
  State<SubjectListWithArrows> createState() => _SubjectListWithArrowsState();
}

class _SubjectListWithArrowsState extends State<SubjectListWithArrows> {
  final ScrollController _scrollController = ScrollController();
  bool showLeftArrow = false;
  bool showRightArrow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateArrowVisibility();
    });
  }

  void _scrollListener() {
    _updateArrowVisibility();
  }

  void _updateArrowVisibility() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.offset;

    setState(() {
      showLeftArrow = offset > 0;
      showRightArrow = offset < maxScroll;
    });
  }

  void _scrollBy(double offset) {
    _scrollController.animateTo(
      _scrollController.offset + offset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 40.h,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.subjects.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final subject = widget.subjects[index];
              final subName = subject.subName?.trim() ?? '';
              final isSelected = widget.selectedSubject == subName;

              return GestureDetector(
                onTap: () => widget.onSubjectTap(subName, subject.subCode),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? CustomColor.primaryColor
                        : CustomColor.colorGreyBack,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      subName,
                      style: TextStyle(
                        color: isSelected
                            ? CustomColor.colorWhite
                            : CustomColor.colorBlack,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Left Arrow
        if (showLeftArrow)
          Positioned(
            left: 0,
            child: GestureDetector(
              onTap: () => _scrollBy(-100),
              child: Container(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: const Color.fromARGB(255, 169, 168, 168).withOpacity(0.3), // semi-transparent background
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: CustomColor.colorBlack.withOpacity(0.2),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(3.w),
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: CustomColor.colorWhite,
                  size: 20.sp,
                ),
              ),
            ),
          ),

        // Right Arrow
        if (showRightArrow)
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => _scrollBy(100),
              child: Container(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: const Color.fromARGB(255, 169, 168, 168).withOpacity(0.3), // semi-transparent background
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: CustomColor.colorBlack.withOpacity(0.2),
                      offset: Offset(2, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(3.w),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: CustomColor.colorWhite,
                  size: 20.sp,
                ),
              ),
            ),
          ),

      ],
    );
  }
}
