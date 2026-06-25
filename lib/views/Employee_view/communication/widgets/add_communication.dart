// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import '../../../../constants/colors.dart';
import '../../../../models/common/class_response.dart';
import '../../../../models/employee/announcment_category.dart';
import '../../../../models/employee/class_data.dart';
import '../../../../models/employee/group_category.dart';
import '../../../../providers/employee/emp_communication.dart';
import 'attachment_field.dart';
import 'date_picker.dart';
import 'detail_feild.dart';
import 'topic_subject_filed.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/show_loading_dialog.dart';


Widget addCommunication(
  BuildContext context,
  EmpCommunicationProvider controller,
) {
  return SingleChildScrollView(
    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Title
        Text(
          "New Announcement",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: CustomColor.colorBlack,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Fill in the details below to send a notice.",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: 24.h),

        // Message Type Selector
        Text(
          "Message Type",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        messageTypeSelector(controller),
        SizedBox(height: 24.h),

        // Announcement Type Dropdown
        _buildSectionHeader("Announcement Type"),
        _buildDropdownWithLoader<ClassItem>(
          hint: 'Select Announcement Type',
          value: controller.selectedAnnouncementType,
          items: controller.announcementTypes,
          getLabel: (item) => item.className,
          getValue: (item) => item.classId,
          onChanged: (selected) {
            controller.updateSelectedAnnouncementType(context, selected);
          },
          isLoading: controller.isLoadingClasses,
        ),

        SizedBox(height: 16.h),

        // Category Type Dropdown (Dynamic based on selection)
        if (controller.selectedAnnouncementType == "EMP") ...[
          _buildSectionHeader("Category"),
          if (controller.announcementCategory != null &&
              controller.announcementCategory!.isNotEmpty)
            _buildDropdownWithLoader<AnnouncementCategory>(
              hint: 'Select Employee Category',
              value: controller.selectedCategory,
              items: controller.announcementCategory,
              getLabel: (item) => item.categoryName,
              getValue: (item) => item.categoryId,
              onChanged: (selected) {
                controller.updateSelectedCategoryType(context, selected, "EMP");
              },
              isLoading: controller.isLoadingAnnouncment,
            )
          else if (controller.isLoadingAnnouncment)
            _buildLoadingDropdown('Loading categories...')
          else
            _buildDisabledDropdown('No categories available'),
        ],

        if (controller.selectedAnnouncementType == "STD") ...[
           _buildSectionHeader("Class"),
          if (controller.classData != null &&
              controller.classData!.isNotEmpty)
            _buildDropdownWithLoader<ClassData>(
              hint: 'Select Class',
              value: controller.selectedCategory,
              items: controller.classData,
              getLabel: (item) => item.className,
              getValue: (item) => item.classId,
              onChanged: (selected) {
                controller.updateSelectedCategoryType(context, selected, "STD");
              },
              isLoading: controller.isLoadingAnnouncment,
            )
          else if (controller.isLoadingAnnouncment)
            _buildLoadingDropdown('Loading categories...')
          else
            _buildDisabledDropdown('No categories available'),
        ],

        if (controller.selectedAnnouncementType == "GRP") ...[
           _buildSectionHeader("Group"),
           _buildDropdownWithLoader<GroupCategory>(
            hint: 'Select Group',
            value: controller.selectedCategory,
            items: controller.groupCategory,
            getLabel: (item) => item.groupName,
            getValue: (item) => item.groupId,
            onChanged: (selected) {
              controller.updateSelectedCategoryType(context, selected, "GRP");
            },
            isLoading: controller.isLoadingClasses,
          ),
        ],

        SizedBox(height: 16.h),

        // Date Picker
        const DatePickerField(),
        SizedBox(height: 20.h),

        // Topic & Details
        TopicSubjectField(controller: controller),
        SizedBox(height: 20.h),

        DetailsField(controller: controller),
        SizedBox(height: 20.h),

        // Attachments
        AttachmentField(controller: controller),
        
        SizedBox(height: 40.h),

        // Action Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: OutlinedButton(
                  onPressed: controller.hideAddConcernForm,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: CustomColor.colorRedAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    foregroundColor: CustomColor.colorRedAccent,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    _validateAndSubmit(context, controller);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 4,
                    shadowColor: CustomColor.primaryColor.withOpacity(0.4),
                  ),
                  child: Text(
                    'Send Notice',
                    style: TextStyle(
                      color: CustomColor.colorWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    ),
  );
}

void _validateAndSubmit(BuildContext context, EmpCommunicationProvider controller) async {

  if (controller.formattedDate == 'xx/xx/xx') {
    _showErrorSnackBar(context, 'Please select a date');
    return;
  }
  if (controller.topicController.text.isEmpty) {
     _showErrorSnackBar(context, 'Please enter a topic');
    return;
  }
  if (controller.descriptionController.text.isEmpty) {
    _showErrorSnackBar(context, 'Please enter a description');
    return;
  }
  if (controller.selectedMessageTypes.isEmpty) {
    _showErrorSnackBar(context, 'Please select at least one message type');
    return;
  }

  showLoadingDialog(context);
  await controller.submitNotice(context);
  Navigator.pop(context);
}

void _showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.redAccent,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
    ),
  );
}

Widget _buildSectionHeader(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    ),
  );
}

Widget _buildDropdownWithLoader<T>({
  required String hint,
  required String? value,
  required List<T>? items,
  required String Function(T) getLabel,
  required String Function(T) getValue,
  required ValueChanged<String?> onChanged,
  required bool isLoading,
}) {
  return Container(
    height: 56.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: CustomColor.colorWhite,
      border: Border.all(color: Colors.grey.shade300, width: 1.w),
      borderRadius: BorderRadius.circular(12.r),
      boxShadow: [
        BoxShadow(
          color: CustomColor.colorGrey.withOpacity(0.05),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              menuMaxHeight: 300.h,
              value: value,
              isExpanded: true,
              hint: Text(
                hint,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15.sp,
                ),
              ),
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: CustomColor.primaryColor),
              iconSize: 24.sp,
              dropdownColor: CustomColor.colorWhite,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              items: items?.map((item) {
                return DropdownMenuItem<String>(
                  value: getValue(item),
                  child: Text(
                    getLabel(item),
                    style: TextStyle(fontSize: 15.sp),
                  ),
                );
              }).toList() ??
                  [],
              onChanged: isLoading ? null : onChanged,
            ),
          ),
        ),
        if (isLoading)
          SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.w,
              valueColor: AlwaysStoppedAnimation<Color>(CustomColor.primaryColor),
            ),
          ),
      ],
    ),
  );
}

Widget messageTypeSelector(EmpCommunicationProvider controller) {
  final messageTypes = {
    "APO": "App",
    "AWA": "WhatsApp",
    "Email": "Email",
  };

  return Wrap(
    spacing: 12.w,
    children: messageTypes.entries.map((entry) {
      final isSelected = controller.selectedMessageTypes.contains(entry.key);
      return ChoiceChip(
        label: Text(
          entry.value,
          style: TextStyle(
            fontSize: 14.sp,
            color: isSelected ? CustomColor.colorWhite : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal
          ),
        ),
        selected: isSelected,
        onSelected: (_) => controller.toggleMessageType(entry.key),
        selectedColor: CustomColor.primaryColor,
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: isSelected ? CustomColor.primaryColor : Colors.grey.shade300,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        showCheckmark: false, // Cleaner look without checkmark, color change is enough
        avatar: isSelected ? Icon(Icons.check, color: CustomColor.colorWhite, size: 18.sp) : null,
      );
    }).toList(),
  );
}


// Disabled dropdown for unavailable options
Widget _buildDisabledDropdown(String text) {
  return Container(
    height: 56.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      border: Border.all(color: Colors.grey[300]!, width: 1.w),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 15.sp,
            ),
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Colors.grey[400],
          size: 24.sp,
        ),
      ],
    ),
  );
}


// Loading dropdown (Skeleton style could be better but sticking closer to original structure)
Widget _buildLoadingDropdown(String text) {
  return Container(
    height: 56.h,
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      border: Border.all(color: CustomColor.primaryColor.withOpacity(0.3), width: 1.w),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15.sp,
            ),
          ),
        ),
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(CustomColor.primaryColor),
          ),
        ),
      ],
    ),
  );
}
