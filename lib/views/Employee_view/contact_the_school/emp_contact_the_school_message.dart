import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/employee/emp_contact_the_school.dart';
import '../../Student_views/contact_to_school/widgets/message_loader.dart';
import 'widgets/message_container.dart';

class EmpContactSchoolMessageScreen extends StatefulWidget {
  final String id;
  final String type;
  const EmpContactSchoolMessageScreen({
    super.key, 
    required this.id,
    required this.type
  });

  @override
  State<EmpContactSchoolMessageScreen> createState() =>
      _EmpContactSchoolMessageScreenState();
}

class _EmpContactSchoolMessageScreenState
    extends State<EmpContactSchoolMessageScreen> {
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
  PlatformFile? _selectedFile;
  late EmpContactToSchoolProvider empContactProvider;

  @override
  void initState() {
    super.initState();
    empContactProvider = Provider.of<EmpContactToSchoolProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchContacts());
  }

  @override
  void dispose(){
    if(mounted){
      empContactProvider.concern = null;
      empContactProvider.concernTicket = [];
    }
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchContacts() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      // contactProvider =
      //     Provider.of<ContactToSchoolProvider>(context, listen: false);
      await empContactProvider.fetchQueryHistory(
        widget.id,
        auth.loginData!.currentyearfrom,
        auth.loginData!.currentyearto,
      );
      _scrollToBottom();
    } catch (e, s) {
      log('Error fetching contacts: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.any,
        withData: false,
      );
      if (result == null || result.files.isEmpty) return;

      final file = result.files.first;
      const maxSize = 10 * 1024 * 1024; // 10 MB limit

      if (file.size > maxSize) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("File Too Large"),
            content: const Text("Selected file exceeds 10MB limit."),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
            ],
          ),
        );
        return;
      }

      setState(() {
        _selectedFile = file;
      });
    } catch (e) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Failed to pick file: $e"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final concernProvider = Provider.of<EmpContactToSchoolProvider>(context);

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
          icon: Icon(
            Icons.arrow_back, 
            color: CustomColor.colorWhite
          ),
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
        child: concernProvider.isLoading && messages.isEmpty ? 
          ListView.builder(
            padding: EdgeInsets.only(bottom: 80.h, top: 16.h),
            itemCount: 6,
            itemBuilder: (context, index) {
              bool isLeft = index % 2 == 0; // alternate left/right
              return Align(
                alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
                child: MessageContainerShimmer(
                  // isLeft: isLeft,
                ),
              );
            },
          ):
      messages.isEmpty
        ? Center(
          child: Padding(
            padding: EdgeInsets.only(top: 80.h),
            child: Text(
              "No messages found",
              style:
                TextStyle(
                  color: CustomColor.colorGrey, 
                  fontSize: 15.sp
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
            return MessageContainer(receiver: true,
              message: msg,
              concern: concernData,
            );
          },
        ),
      ),
      bottomSheet:widget.type != "0" ?
      Container(
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
            if (_selectedFile != null)
              Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file, color: CustomColor.primaryColor, size: 22.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        _selectedFile!.name,
                        style: TextStyle(
                          color: CustomColor.colorBlack,
                          fontSize: 14.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedFile = null);
                      },
                      child: Icon(Icons.close, color: Colors.red, size: 20.sp),
                    ),
                  ],
                ),
              ),

            Row(
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
                empContactProvider.isLoading == false ?
                IconButton(
                  onPressed: () {
                    empContactProvider.sendEmpMessage(
                      auth.loginData!.empId,
                      auth.loginData!.currentyearfrom,
                      auth.loginData!.currentyearto,
                      concernData!.data.first.complaintRegNo,
                      _messageController.text,
                      _selectedFile != null ? [_selectedFile!] : [],
                    );
                    _messageController.text = '';
                  },
                  icon: Icon(Icons.send),
                  iconSize: 28.sp,
                  color: CustomColor.primaryColor,
                )
                : CircularProgressIndicator()
              ],
            ),
          ],
        ),
      ):
      SizedBox.shrink()
    );
  }
}
