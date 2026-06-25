import 'package:st_jude_school/models/Students/notification_notice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import '../../../constants/colors.dart';
import '../../../models/notificaion_model.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/common/notification_provider.dart';
import '../../../widgets/base64_image.dart';
import 'widget/loader.dart';
import 'widget/notification_attachment.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<bool> isExpandedList = [];
  late final String userType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchNotification());
  }

  Future<void> _fetchNotification() async {
    final auth = context.read<AuthProvider>();
    final provider = context.read<NotificationProvider>();

    userType = auth.loginData!.logintype;

    if (userType == "Student") {
      await provider.getStudentNotification(
        auth.loginData!.regno,
        auth.loginData!.currentyearfrom,
        auth.loginData!.currentyearto,
      );
    } else {
      await provider.getEmployeeNotification(
        empID: auth.loginData!.empId,
        fromYear: auth.loginData!.currentyearfrom,
        toYear: auth.loginData!.currentyearto,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: Consumer<NotificationProvider>(
        builder: (_, provider, __) {
          if (provider.isLoading) {
            return _buildLoader();
          }

          //   final list = userType == "Student"
          //       ? provider.noticeData ?? []
          //       : provider.employeeNotificationItem ?? [];

          //   if (list.isEmpty) {
          //     return const Center(child: Text("No notifications available"));
          //   }

          //   _syncExpandedList(list.length);

          //   return ListView.builder(
          //     padding: EdgeInsets.all(12.w),
          //     itemCount: list.length,
          //     itemBuilder: (_, index) {
          //       return userType == "Student"
          //           ? studentCard(list[index])
          //           : employeeCard(list[index]);
          //     },
          //   );
          // },
          if (userType == "Student") {
            final List<NoticeData> notifications = provider.noticeData ?? [];

            if (notifications.isEmpty) {
              return const Center(child: Text("No notifications available"));
            }

            _syncExpandedList(notifications.length);

            return ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: notifications.length,
              itemBuilder: (_, index) {
                return studentCard(notifications[index]);
              },
            );
          } else {
            final List<EmployeeNotificationItem> notifications =
                provider.employeeNotificationItem ?? [];

            if (notifications.isEmpty) {
              return const Center(child: Text("No notifications available"));
            }

            _syncExpandedList(notifications.length);

            return ListView.builder(
              padding: EdgeInsets.all(12.w),
              itemCount: notifications.length,
              itemBuilder: (_, index) {
                return employeeCard(notifications[index]);
              },
            );
          }
        },
      ),
    );
  }

  void _syncExpandedList(int length) {
    if (isExpandedList.length != length) {
      isExpandedList = List.generate(length, (_) => false);
    }
  }

  AppBar _buildAppBar() => AppBar(
    backgroundColor: CustomColor.primaryOne,
    title: Text(
      "Notification",
      style: TextStyle(
        color: CustomColor.colorWhite,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
      ),
    ),
    centerTitle: true,
    leading: BackButton(color: Colors.white),
  );

  Widget _buildLoader() => ListView.builder(
    padding: EdgeInsets.all(12.w),
    itemCount: 6,
    itemBuilder: (_, __) => const NotificationShimmerCard(),
  );

  Widget baseNotificationCard({
    required String title,
    required String description,
    required String name,
    required String image,
    required String date,
    required List attachments,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: CustomColor.primaryOne,
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: CustomColor.colorShadow,
                blurRadius: 4.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.notifications_active_outlined),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 4.h),

              ReadMoreText(
                description,
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read more',
                trimExpandedText: ' Read less',
                style: TextStyle(fontSize: 14.sp),
                moreStyle: TextStyle(
                  color: CustomColor.colorBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),

              if (attachments.isNotEmpty && userType == "Student")
                AttachmentNotification(attachments: attachments),
              if (attachments.isNotEmpty && userType != "Student")
                EmpAttachmentNotification(attachments: attachments),

              SizedBox(height: 8.h),

              Row(
                children: [
                  buildStudentNotificationImage(image),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                  Icon(Icons.access_time, size: 14.sp),
                  SizedBox(width: 4.w),
                  Text(date, style: TextStyle(fontSize: 12.sp)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget studentCard(NoticeData n) => baseNotificationCard(
    title: n.noticeTopic,
    description: n.noticeDetail,
    name: n.postedBy,
    image: n.uploaderImage,
    date: n.publishDate,
    attachments: n.noticeAttachments,
  );

  Widget employeeCard(EmployeeNotificationItem n) => baseNotificationCard(
    title: n.announcementTopic,
    description: n.announcementDetails,
    name: n.fullname,
    image: n.profileImage,
    date: n.publishedDate,
    attachments: n.noticeAttachments,
  );
}
