import 'dart:developer';
import 'package:st_jude_school/views/Student_views/contact_to_school/widgets/message_container.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/student/contact_to_school.dart';
import 'widgets/message_loader.dart';

class ContactSchoolMessageScreen extends StatefulWidget {
  final String id;
  final String type;
  final String from;
  final String to;
  final String shift;
  final img;

  const ContactSchoolMessageScreen({
    super.key,
    required this.id,
    required this.type,
    required this.from,
    required this.to,
    required this.shift,
    required this.img,
  });

  @override
  State<ContactSchoolMessageScreen> createState() =>
      _ContactSchoolMessageScreenState();
}

class _ContactSchoolMessageScreenState
    extends State<ContactSchoolMessageScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // List<PlatformFile> selectedFile = [];
  List<PlatformFile> _selectedFiles = [];
  late ContactToSchoolProvider contactProvider;

  @override
  void initState() {
    super.initState();
    contactProvider = Provider.of<ContactToSchoolProvider>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchContacts());
  }

  @override
  void dispose() {
    if (mounted) {
      contactProvider.concern = null;
      contactProvider.concernTicket = [];
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchContacts() async {
    try {
      // final auth = Provider.of<AuthProvider>(context, listen: false);
      // contactProvider =
      //     Provider.of<ContactToSchoolProvider>(context, listen: false);
      await contactProvider.getQueryHistory(widget.id, widget.from, widget.to);
      _scrollToBottom();
    } catch (e, s) {
      log('Error fetching contacts: $e');
      debugPrintStack(stackTrace: s);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    final concernProvider = Provider.of<ContactToSchoolProvider>(context);

    final concernData = concernProvider.concern;
    final messages = (concernData != null && concernData.data.isNotEmpty)
        ? concernData.data.first.messages
        : [];

    final auth = Provider.of<AuthProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: CustomColor.primaryColor,
      appBar: AppBar(
        backgroundColor: CustomColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CustomColor.colorWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact the School',
          style: TextStyle(
            color: CustomColor.colorWhite,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: CustomColor.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: concernProvider.isLoading && messages.isEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 80.h, top: 16.h),
                itemCount: 6,
                itemBuilder: (context, index) {
                  bool isLeft = index % 2 == 0; // alternate left/right
                  return Align(
                    alignment: isLeft
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: MessageContainerShimmer(
                      // isLeft: isLeft,
                    ),
                  );
                },
              )
            : messages.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 80.h),
                  child: Text(
                    "No messages found",
                    style: TextStyle(
                      color: CustomColor.colorGrey,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: 80.h, top: 16.h),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return MessageContainer(
                    receiver: true,
                    message: msg,
                    concern: concernData,
                    img: widget.img,
                    type: widget.type,
                  );
                },
              ),
      ),
      bottomSheet: widget.type != "0"
          ? Container(
              decoration: BoxDecoration(
                color: CustomColor.colorWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              const Icon(
                                Icons.insert_drive_file,
                                color: Color(0xFF00796B),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      file.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Text(formatBytes(file.size),
                                    //     style: TextStyle(
                                    //         fontSize: 12.sp, color: Colors.grey)),
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],

                  widget.shift == "STD"
                      ? SizedBox.shrink()
                      : Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  decoration: InputDecoration(
                                    hintText: 'Type message...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: CustomColor.colorGrey,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            IconButton(
                              onPressed: () {
                                _pickAttachment();
                              },
                              icon: Icon(Icons.attach_file),
                              iconSize: 28.sp,
                              color: CustomColor.colorBlack,
                            ),
                            contactProvider.isLoading == false
                                ? IconButton(
                                    onPressed: () {
                                      contactProvider.sendMessage(
                                        auth.loginData!.regno,
                                        auth.loginData!.currentyearfrom,
                                        auth.loginData!.currentyearto,
                                        concernData!.data.first.complaintRegNo,
                                        _messageController.text,
                                        _selectedFiles,
                                      );
                                      setState(() {
                                        _messageController.text = '';
                                        _selectedFiles.clear();
                                      });
                                    },
                                    icon: Icon(Icons.send),
                                    iconSize: 28.sp,
                                    color: CustomColor.primaryColor,
                                  )
                                : CircularProgressIndicator(),
                          ],
                        ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
