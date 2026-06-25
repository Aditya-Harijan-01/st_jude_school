// ignore_for_file: deprecated_member_use

import 'dart:developer';
import '../../../../constants/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../models/Students/add_concern.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/student/contact_to_school.dart';
import '../../../widgets/data_format.dart';
import '../../../widgets/top_toggle_bar.dart';
import 'contact_school_message_screen.dart';
import 'widgets/loader.dart';
import 'widgets/text_field.dart';

class ContactToSchoolScreen extends StatefulWidget {
  final String regNo;
  final tYear;
  final fYear;
  final type;
  final img;
  const ContactToSchoolScreen({super.key, required this.regNo, this.tYear, this.fYear, this.type, this.img});

  @override
  State<ContactToSchoolScreen> createState() => _ContactToSchoolScreenState();
}

class _ContactToSchoolScreenState extends State<ContactToSchoolScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool _showAddConcern = false;
  String selectedTab = "1";
  List<PlatformFile> _selectedFiles = [];

  // ============================
  // Add these at class level
  // ============================
  final TextEditingController concernController = TextEditingController();
  CategoryType? selectedCategory;
  String? selectedSubCategoryName;
  List<SubType> subCategoryList = [];
  List<PlatformFile> selectedFile = [];


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchContacts());
    tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _fetchContacts() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final contactProvider =
          Provider.of<ContactToSchoolProvider>(context, listen: false);

      widget.type == "STD"
      ?await contactProvider.getContactDetails(
        widget.regNo,
        widget.fYear,
        widget.tYear,
      ): await contactProvider.getContactDetails(
        auth.loginData!.regno,
        auth.loginData!.currentyearfrom,
        auth.loginData!.currentyearto,
      );
      await contactProvider.getConcernType();
    } catch (e, s) {
      log('Error fetching contacts: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactToSchoolProvider>(context);
    final allTickets = contactProvider.contactToSchoolTicket ?? [];

    //   Filter data based on status
    final activeConcerns =
        allTickets.where((t) => t.status == "1").toList(); // Active (status 1)
    final completedConcerns =
        allTickets.where((t) => t.status == "100").toList(); // Completed (status 100)

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColor.primaryColor,
        title: Text('Contact the School', style: TextStyle(color: CustomColor.colorWhite, fontSize: 24.sp)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CustomColor.colorWhite, size: 24.sp,),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // --- Toggle Bar ---
          TopToggleBar(
            selectedTab: selectedTab,
            issuedCount: activeConcerns.length,
            returnedCount: completedConcerns.length,
            onTabChange: (tab) {
              setState(() {
                selectedTab = tab;
              });
            },
            title:  ["Active", "Completed"],
          ),

          SizedBox(height: 8.h),

          // --- Concern Lists ---
          Expanded(
            child: contactProvider.isLoading
            ?  buildConcernListShimmer()
            : selectedTab == "1"
            ? _buildConcernList(activeConcerns, selectedTab)
            : _buildConcernList(completedConcerns, selectedTab),
          ),
          // --- Add Concern Section ---
          widget.type == "STD" ?
          SizedBox.shrink()
          : AnimatedCrossFade(
            firstChild: _buildAddConcernButton(),
            secondChild: _buildAddConcernSheet(),
            crossFadeState: _showAddConcern
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  // ===============================
  // Concern List Builder
  // ===============================
  Widget _buildConcernList(List concerns, String type) {
    if (concerns.isEmpty) {
      return Center(
        child: Text(
          'No concerns found.',
          style: TextStyle(color: Colors.grey, fontSize: 20.sp),
        ),
      );
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: concerns.length,
      itemBuilder: (context, index) {
        final item = concerns[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactSchoolMessageScreen(
                id: item.complaintRegNo,
                type: type,
                from: widget.type == "STD" ? widget.fYear : auth.loginData!.currentyearfrom,
                to: widget.type == "STD" ? widget.tYear : auth.loginData!.currentyearto,
                shift: widget.type == "STD" ? widget.type : "",
                img: widget.type == "STD" ? widget.img : ""
              )),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            decoration: BoxDecoration(
              color: CustomColor.colorWhite,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20.r,
                backgroundColor: const Color(0xFF00796B),
                child: Text(
                  item.postedBy.isNotEmpty ? item.postedBy[0] : '?',
                  style: TextStyle(color: CustomColor.colorWhite, fontSize: 18.sp),
                ),
              ),
              title: Text(
                item.complaintRegNo,
                style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              subtitle: Padding(
                padding:  EdgeInsets.only(top: 4.h),
                child: Text(
                  "${item.contentCategoryName}: ${item.contentDetail}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
              trailing: Text(
                item.postedOn.split(',').first, // shows date like "12/05/2025"
                style:  TextStyle(color: Colors.grey, fontSize: 13.sp),
              ),
            ),
          ),
        );
      },
    );
  }

  // ===============================
  // Add Concern UI
  // ===============================
  Widget _buildAddConcernButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
          onTap: () => setState(() => _showAddConcern = true),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 20.w),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Concern',
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: CustomColor.colorWhite,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Report a new concern you may have',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: CustomColor.colorWhite.withOpacity(0.9),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: CustomColor.colorWhite, size: 18.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget _buildAddConcernSheet() {
  final contactProvider = Provider.of<ContactToSchoolProvider>(context);
  final auth = context.read<AuthProvider>();
  String reg = auth.loginData!.regno;
  String fromYear = auth.loginData!.currentyearfrom;
  String toyear = auth.loginData!.currentyearto;
  final categoryList = contactProvider.categoryType ?? [];

  // final TextEditingController concernController = TextEditingController();
  // CategoryType? selectedCategory;
  // String? selectedSubCategoryName; // store name
  // List<SubType> subCategoryList = [];
  // List<PlatformFile> selectedFile = [];

  Future<void> handleSubmitConcern() async {
    if (selectedCategory == null || selectedSubCategoryName == null || concernController.text.trim().isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Missing Fields"),
          content: const Text("Please fill all required fields before submitting."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
      return;
    }

    final subType = selectedCategory!.subTypes.firstWhere(
      (sub) => sub.contentCategoryName == selectedSubCategoryName,
      orElse: () => SubType(contentCategoryId: '', contentCategoryName: ''),
    );

    if (subType.contentCategoryId.isEmpty) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Selection"),
          content: const Text("Invalid sub-category selection."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
      return;
    }

    //   API call with all parameters
    final success = await Provider.of<ContactToSchoolProvider>(context, listen: false)
    .submitConcern(
      selectedCategory!.categoryType,
      subType.contentCategoryId,
      selectedSubCategoryName!,
      concernController.text.trim(),
      _selectedFiles,
      reg,
      fromYear,
      toyear,
    );

    if (success) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Concern submitted successfully!"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );

      //   Clear form & close only the bottomsheet
      setState(() {
        concernController.clear();
        selectedCategory = null;
        selectedSubCategoryName = null;
        _selectedFiles.clear();
        _showAddConcern = false;
      });
    } else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Failed"),
          content: const Text("Something went wrong. Please try again later."),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
    }
  }


  return StatefulBuilder(
    builder: (context, setSheetState) {
      return Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [CustomColor.primaryColor, CustomColor.colorBlack],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 0.8],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Concern',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: CustomColor.colorWhite),
                ),
                IconButton(
                  onPressed: () => setState(() => _showAddConcern = false),
                  icon: Icon(Icons.keyboard_arrow_down,
                    color: CustomColor.colorWhite, size: 35.sp),
                ),
              ],
            ),
            Text('Report a new concern you may have',
                style: TextStyle(color: CustomColor.colorWhite, fontSize: 14.sp)),
             SizedBox(height: 10.h),

            // --- Form Card ---
            Container(
              decoration: BoxDecoration(
                color: CustomColor.colorWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              padding:  EdgeInsets.all(10.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextField(
                    label: 'Enter your Concern',
                    hint: 'Concern details',
                    controller: concernController,
                  ),
                   SizedBox(height: 10.h),

                  // ===== CATEGORY DROPDOWN =====
                   Text('Subject',
                      style: TextStyle(
                        fontWeight: FontWeight.w500, 
                        fontSize: 14.sp
                      )
                    ),
                   SizedBox(height: 6.h),
                  DropdownButtonFormField<CategoryType>(
                    borderRadius: BorderRadius.circular(12),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedCategory,
                    hint:  Text('Select Category',                  style: TextStyle(
                        fontSize: 16.sp
                    ),),
                    items: categoryList
                        .map((cat) => DropdownMenuItem<CategoryType>(
                              value: cat,
                              child: Text(cat.categoryTypeName),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setSheetState(() {
                        selectedCategory = value;
                        selectedSubCategoryName = null;
                        subCategoryList = value?.subTypes ?? [];
                      });
                    },
                  ),
                   SizedBox(height: 10.h),

                  // ===== SUB CATEGORY DROPDOWN =====
                  Text('Category',
                    style: TextStyle(
                      fontWeight: FontWeight.w500, 
                      fontSize: 14.sp
                    )
                  ),
                  SizedBox(height: 6.h),
                  DropdownButtonFormField<String>(
                    borderRadius: BorderRadius.circular(12),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    value: selectedSubCategoryName,
                    hint: Text('Select Category type', style: TextStyle(fontSize: 16.sp),),
                    items: subCategoryList
                      .map((sub) => DropdownMenuItem<String>(
                        value: sub.contentCategoryName,
                        child: Text(sub.contentCategoryName),
                      ))
                      .toList(),
                    onChanged: selectedCategory == null
                    ? null
                    : (value) {
                        setSheetState(() {
                          selectedSubCategoryName = value;
                        });
                      },
                  ),

                   SizedBox(height: 12.h),

                  // ===== ATTACHMENT FIELD =====
                  InkWell(
                    // onTap: pickAttachment,
                    child: _buildAttachmentField(),
                  ),
                   SizedBox(height: 16.h),

                  // ===== SUBMIT BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColor.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r)),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      onPressed: handleSubmitConcern,
                      child: Text('Submit',
                          style: TextStyle(
                              color: CustomColor.colorWhite, fontSize: 20.sp)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}



  // Widget _buildAttachmentField() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //        Text('Attachment',
  //           style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp)),
  //        SizedBox(height: 6.h),
  //       GestureDetector(
  //         onTap: _pickAttachment,
  //         child: Container(
  //           width: double.infinity,
  //           padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
  //           decoration: BoxDecoration(
  //             border: Border.all(color: Colors.grey.shade300),
  //             borderRadius: BorderRadius.circular(10.r),
  //           ),
  //           child: _selectedFile == null
  //               ? Column(
  //                   children:  [
  //                     Icon(Icons.cloud_upload_outlined,
  //                         color: Colors.grey, size: 28.sp),
  //                     SizedBox(height: 8.h),
  //                     Text('Click to upload a file',
  //                         style: TextStyle(color: Colors.grey)),
  //                     SizedBox(height: 4.h),
  //                     Text('Max file size: 10MB',
  //                         style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
  //                   ],
  //                 )
  //               : Row(
  //                   children: [
  //                      Icon(Icons.insert_drive_file,
  //                         color: Color(0xFF00796B), size: 28.sp),
  //                     SizedBox(width: 10.w),
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text(
  //                             _selectedFile!.name,
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                             style:
  //                                  TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp),
  //                           ),
  //                            SizedBox(height: 2.h),
  //                           Text(
  //                             formatBytes(_selectedFile!.size),
  //                             style:  TextStyle(
  //                                 color: Colors.grey, fontSize: 12.sp),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     IconButton(
  //                       icon: const Icon(Icons.close, color: Colors.grey),
  //                       onPressed: () =>
  //                           setState(() => _selectedFile = null),
  //                       tooltip: 'Remove',
  //                     ),
  //                   ],
  //                 ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
  Widget _buildAttachmentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Attachments',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.sp)),
        SizedBox(height: 6.h),

        GestureDetector(
          onTap: _pickAttachment,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              children: [
                Icon(Icons.cloud_upload_outlined,
                    color: Colors.grey, size: 28.sp),
                SizedBox(height: 8.h),
                Text('Click to upload files',
                    style: TextStyle(color: Colors.grey)),
                Text('Max 10MB per file',
                    style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
              ],
            ),
          ),
        ),

        if (_selectedFiles.isNotEmpty) ...[
          SizedBox(height: 12.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _selectedFiles.length,
            itemBuilder: (_, index) {
              final file = _selectedFiles[index];
              return Container(
                margin: EdgeInsets.only(bottom: 6.h),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file,
                        color: Color(0xFF00796B)),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(file.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          Text(formatBytes(file.size),
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        setState(() {
                          _selectedFiles.removeAt(index);
                        });
                      },
                    )
                  ],
                ),
              );
            },
          )
        ]
      ],
    );
  }

  
  // Future<void> _pickAttachment() async {
  //   try {
  //     final result = await FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //       type: FileType.any,
  //       withData: false,
  //     );
  //     if (result == null || result.files.isEmpty) return;

  //     final file = result.files.first;
  //     const maxSize = 10 * 1024 * 1024; // 10 MB limit

  //     if (file.size > maxSize) {
  //       await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text("File Too Large"),
  //           content: const Text("Selected file exceeds 10MB limit."),
  //           actions: [
  //             TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
  //           ],
  //         ),
  //       );
  //       return;
  //     }

  //     setState(() {
  //       _selectedFile = file;
  //     });
  //   } catch (e) {
  //     await showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text("Error"),
  //         content: Text("Failed to pick file: $e"),
  //         actions: [
  //           TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
  //         ],
  //       ),
  //     );
  //   }
  // }
  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
        withData: false,
      );

      if (result == null || result.files.isEmpty) return;

      const maxSize = 10 * 1024 * 1024; // 10MB per file

      for (final file in result.files) {
        if (file.size > maxSize) {
          await showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              title: Text("File Too Large"),
              content: Text("Each file must be under 10MB."),
            ),
          );
          return;
        }
      }

      setState(() {
        _selectedFiles.addAll(result.files);
      });
    } catch (e) {
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to pick files: $e"),
        ),
      );
    }
  }

}
