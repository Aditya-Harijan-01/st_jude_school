// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import '../../../../constants/colors.dart';
import '../../../../models/employee/book_model.dart';
import '../../../../models/employee/chapter_model.dart';
import '../../../../models/employee/class_model.dart';
import '../../../../models/employee/subject_model.dart';
import '../../../../providers/employee/emp_assignment_from.dart';

class AddHomeworkWidget extends StatelessWidget {
  final String? empId;
  final String? year;
  final String? toYear;
  final String? empName;

  const AddHomeworkWidget({
    super.key,
    required this.empId,
    required this.year,
    required this.toYear,
    required this.empName,
  });

  @override
  Widget build(BuildContext context) {
    final form = context.watch<AssignmentFormProvider>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: CustomColor.colorWhite,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: CustomColor.primaryColor.withOpacity(0.1),
              blurRadius: 15.r,
              offset: Offset(0, 8.h),
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------------------------------
            // HEADER (Optional, adds context)
            // --------------------------------------------------
            Center(
              child: Container(
                width: 60.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Text(
              "Assign Homework",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: CustomColor.colorBlack,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 20.h),

            // --------------------------------------------------
            // TEACHER TYPE SELECTION
            // --------------------------------------------------
            _label("Teacher Type"),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: CustomColor.primaryLight,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _toggleButton(
                      label: "Own",
                      isSelected: form.isOwnChecked,
                      onTap: () => form.isOwnChecked ? null : form.toggleOwn(),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: _toggleButton(
                      label: "All Classes",
                      isSelected: !form.isOwnChecked,
                      onTap: () => !form.isOwnChecked ? null : form.toggleOwn(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // --------------------------------------------------
            // CLASS SELECTION
            // --------------------------------------------------
            _dropdown<ClassData>(
              label: "Select Class",
              value: form.selectedClass,
              items: form.classList,
              isLoading: form.isLoadingClasses,
              getLabel: (c) => c.className,
              getValue: (c) => c.classId,
              onChanged: (v) => form.onClassChanged(v),
              hint: 'Choose Class',
              icon: Icons.class_outlined,
            ),
            SizedBox(height: 20.h),

            // --------------------------------------------------
            // SUBJECT SELECTION
            // --------------------------------------------------
            if (form.isLoadingSubjects)
              _loadingWidget("Fetching subjects...")
            else if (form.subjectList == null)
              _disabledText("No subjects available for this class.")
            else
              _dropdown<SubjectData>(
                label: "Select Subject",
                value: form.selectedSubject,
                items: form.subjectList,
                isLoading: false,
                getLabel: (s) => s.subjectName,
                getValue: (s) => s.subjectCode,
                onChanged: (v) => form.onSubjectChanged(v),
                hint: 'Choose Subject',
                icon: Icons.menu_book_rounded,
              ),

            SizedBox(height: 20.h),

            // --------------------------------------------------
            // BOOK SELECTION
            // --------------------------------------------------
            if (form.isLoadingBooks)
              _loadingWidget("Fetching books...")
            else if (form.bookList == null)
              _disabledText("No books available.")
            else
              _dropdown<BookData>(
                label: "Select Book",
                value: form.selectedBook,
                items: form.bookList,
                isLoading: false,
                getLabel: (b) => b.bookName,
                getValue: (b) => b.bookId,
                onChanged: (v) => form.onBookChanged(v),
                hint: 'Choose Book',
                icon: Icons.library_books_outlined,
              ),

            SizedBox(height: 20.h),

            // --------------------------------------------------
            // CHAPTER SELECTION (MultiSelect)
            // --------------------------------------------------
            if (form.isLoadingChapters)
              _loadingWidget("Fetching chapters...")
            else if (form.chapterList == null)
              _disabledText("No chapters available.")
            else ...[
              _label("Select Chapters"),
              SizedBox(height: 8.h),

              MultiSelectDialogField<ChapterData>(
                backgroundColor: Colors.white,
                items: form.chapterList!
                    .map((c) => MultiSelectItem(c, c.chapterName))
                    .toList(),
                title: Text("Select Chapters",
                    style: TextStyle(
                        fontSize: 18.sp, fontWeight: FontWeight.w600)),
                selectedColor: CustomColor.primaryColor,
                decoration: BoxDecoration(
                  color: CustomColor.primaryLight.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                      color: CustomColor.primaryColor.withOpacity(0.3)),
                ),
                buttonIcon: Icon(Icons.arrow_drop_down_circle_outlined,
                    color: CustomColor.primaryColor, size: 24.sp),
                buttonText: Text(
                  "Tap to select chapters",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14.sp,
                  ),
                ),
                chipDisplay: MultiSelectChipDisplay.none(),
                onConfirm: form.onChapterConfirm,
                itemsTextStyle:
                    TextStyle(fontSize: 14.sp, color: Colors.black87),
                selectedItemsTextStyle: TextStyle(
                    fontSize: 14.sp, color: CustomColor.primaryColor),
              ),

              SizedBox(height: 12.h),

              if (form.selectedChapters.isNotEmpty)
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: form.selectedChapters.map((c) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: CustomColor.primaryColor,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                            color: CustomColor.primaryColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            c.chapterName,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          InkWell(
                            onTap: () => form.removeChapter(c),
                            child: Icon(Icons.close,
                                size: 16.sp,
                                color: Colors.white),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],

            SizedBox(height: 24.h),

            // --------------------------------------------------
            // DATES ROW
            // --------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: _dateField(
                    label: "Issue Date",
                    controller: form.issueDateController,
                    onTap: () => form.pickIssueDate(context),
                    icon: Icons.calendar_today_outlined,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _dateField(
                    label: "Submission Date",
                    controller: form.submissionDateController,
                    onTap: () => form.pickSubmissionDate(context),
                    icon: Icons.event_available_outlined,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // --------------------------------------------------
            // FILE ATTACHMENT
            // --------------------------------------------------
            _label("Attachments"),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: CustomColor.colorGrey.withOpacity(0.5), width: 1),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: TextField(
                        controller: form.attachmentController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: "No file chosen",
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400, fontSize: 13.sp),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      ),
                    ),
                  ),
                  _browseButton(() => form.pickFiles()),
                ],
              ),
            ),
            
            if (form.existingFiles.isNotEmpty) ...[
              SizedBox(height: 12.h),
              _existingFilesBox(form),
            ],

            SizedBox(height: 24.h),

            // --------------------------------------------------
            // DETAILS
            // --------------------------------------------------
            _label("Assignment Details"),
            SizedBox(height: 8.h),
            Container(
              decoration: BoxDecoration(
                color: CustomColor.primaryLight.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: TextField(
                controller: form.detailsController,
                maxLines: 5,
                style: TextStyle(fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: "Enter comprehensive details about the assignment...",
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500, fontSize: 13.sp),
                  contentPadding: EdgeInsets.all(16.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                        color: CustomColor.primaryColor.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                        color: CustomColor.primaryColor.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                        color: CustomColor.primaryColor, width: 1.5),
                  ),
                  filled: true,
                  fillColor: CustomColor.primaryLight.withOpacity(0.3),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // --------------------------------------------------
            // ACTION BUTTONS
            // --------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: "Cancel",
                    bgColor: Colors.white,
                    textColor: CustomColor.colorRed,
                    borderColor: CustomColor.colorRed.withOpacity(0.2),
                    onTap: form.cancelForm,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _actionButton(
                    label: form.isSubmitting ? "Saving..." : "Create Assignment",
                    bgColor: form.isSubmitting
                        ? CustomColor.colorGrey
                        : CustomColor.primaryColor,
                    textColor: Colors.white,
                    onTap: form.isSubmitting
                        ? null
                        : () async {
                            bool success = await form.submitAssignment(
                                context, empName ?? "");

                            if (success) {
                              form.isSubmitting = false;
                              form.isEditMode = false;
                              form.isAdding = false;
                              form.clearForm();
                              form.showSuccessDialog(context);
                            } else {
                              form.showErrorDialog(context);
                            }
                          },
                    isPrimary: true,
                    isLoading: form.isSubmitting,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------
  // WIDGET HELPERS
  // -------------------------------------------------------------------

  Widget _toggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? CustomColor.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : CustomColor.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: CustomColor.colorBlack.withOpacity(0.8),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required String? value,
    required List<T>? items,
    required bool isLoading,
    required String Function(T) getLabel,
    required String Function(T) getValue,
    required ValueChanged<String?> onChanged,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: CustomColor.primaryLight.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
                color: CustomColor.primaryColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(icon, color: CustomColor.primaryColor, size: 20.sp),
              SizedBox(width: 12.w),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: Builder(
                    builder: (context) {
                      final list = items ?? <T>[];
                      final seen = <String>{};
                      final dropdownItems = <DropdownMenuItem<String>>[];
                      
                      for (final i in list) {
                        final v = getValue(i);
                        if (seen.add(v)) {
                          dropdownItems.add(
                            DropdownMenuItem(
                              value: v,
                              child: Text(
                                getLabel(i),
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.black87),
                              ),
                            ),
                          );
                        }
                      }
                      
                      final effectiveValue = dropdownItems
                                  .where((e) => e.value == value)
                                  .length == 1
                          ? value
                          : null;

                      return DropdownButton<String>(
                        hint: Text(hint,
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13.sp)),
                        value: effectiveValue,
                        isExpanded: true,
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: CustomColor.primaryColor),
                        items: dropdownItems,
                        onChanged: isLoading ? null : onChanged,
                        dropdownColor: Colors.white,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (isLoading)
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: SizedBox(
                    width: 16.w,
                    height: 16.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation(CustomColor.primaryColor),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: CustomColor.primaryLight.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                  color: CustomColor.primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(icon, color: CustomColor.primaryColor, size: 20.sp),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    controller.text.isNotEmpty ? controller.text : "Select Date",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: controller.text.isNotEmpty
                          ? Colors.black87
                          : Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _browseButton(VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: CustomColor.primaryColor,
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(11.r),
            left: Radius.zero
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            Icon(Icons.folder_open, color: Colors.white, size: 18.sp),
            SizedBox(width: 6.w),
            Text(
              "Browse",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _existingFilesBox(AssignmentFormProvider form) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Attached Files (${form.existingFiles.length})",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              InkWell(
                onTap: form.clearAllExistingFiles,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  child: Text(
                    "Remove All",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: CustomColor.colorRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(height: 16.h, color: Colors.blue.withOpacity(0.1)),
          ...form.existingFiles.map((f) {
            return Container(
              margin: EdgeInsets.only(bottom: 6.h),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.05),
                    blurRadius: 4,
                  )
                ]
              ),
              child: Row(
                children: [
                  Icon(Icons.insert_drive_file_outlined,
                      size: 20.sp, color: Colors.blue.shade300),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      f.fileName,
                      style: TextStyle(
                          fontSize: 13.sp, color: Colors.black87),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () => form.removeExistingFile(f.fileId),
                    child: Icon(Icons.close_rounded,
                        color: CustomColor.colorRed.withOpacity(0.7), size: 18.sp),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required Color bgColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback? onTap,
    bool isPrimary = false,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Ink(
          height: 48.h,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.r),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1.w)
                : null,
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: CustomColor.primaryColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: textColor,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _loadingWidget(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(
            width: 14.w,
            height: 14.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(CustomColor.primaryColor),
            ),
          ),
          SizedBox(width: 10.w),
          Text(text,
              style: TextStyle(
                  fontSize: 13.sp, color: CustomColor.primaryColor)),
        ],
      ),
    );
  }

  Widget _disabledText(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 13.sp, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
      ),
    );
  }
}
