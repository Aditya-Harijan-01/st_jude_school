
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colors.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/employee/emp_communication.dart';
import 'widgets/add_communication.dart';
import 'widgets/emp_shimmer.dart';

class EmpCommunicationlScreen extends StatefulWidget {
  const EmpCommunicationlScreen({super.key});

  @override
  State<EmpCommunicationlScreen> createState() => _EmpCommunicationlScreenState();
}

class _EmpCommunicationlScreenState extends State<EmpCommunicationlScreen>
    with SingleTickerProviderStateMixin {

  final Set<int> _expandedAnnouncements = <int>{};
  late ScrollController _scrollController;
  late EmpCommunicationProvider provider;
  String empId = "";
  String fromyear = "";
  String toyear = "";

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
    provider = Provider.of<EmpCommunicationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchContacts());
  }

  Future<void> _fetchContacts() async {
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      empId = auth.loginData!.empId;
      fromyear = auth.loginData!.currentyearfrom;
      toyear = auth.loginData!.currentyearto;

      await provider.getCommunicationList(
        auth.loginData!.empId,
        auth.loginData!.currentyearfrom,
        auth.loginData!.currentyearto,
        refresh: true,
      );
      // await provider.fetchConcernType();
    } catch (e, s) {
      log('Error fetching contacts: $e');
      debugPrintStack(stackTrace: s);
    }
  }

  Future<void> refreshData() async {
    await provider.getCommunicationList(empId, fromyear, toyear, refresh: true);
  }

  void scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      provider.loadMoreData(empId, fromyear, toyear);
    }
  }

  @override
  void dispose(){
    super.dispose();
    provider.resetAddCommunicationPage();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EmpCommunicationProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Communication'),
            backgroundColor: CustomColor.primaryColor,
            foregroundColor: CustomColor.colorWhite,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
          floatingActionButton: !provider.showAddCommunication
          ? FloatingActionButton(
              backgroundColor: CustomColor.primaryColor,
              onPressed: () {
                provider.showAddConcernForm();
              },
              child: Icon(
                Icons.add, 
                color: Colors.white,
              ),
            )
          : null,
          body: Center(
            child: provider.showAddCommunication
              ? addCommunication(context, provider)
              : RefreshIndicator(
                  onRefresh: refreshData,
                  child: provider.isLoading
                    ? _buildShimmerList()
                    : provider.announcement.isEmpty
                      ? _buildEmptyState()
                      : _buildCommunicationList(provider),
                ),
          ),
        );
      }
    );
  }

  Widget _buildShimmerList() {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          6,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: const EmpConcernTicketCardShimmer(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: 0.6.sh,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.announcement_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No communications found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Pull to refresh or check back later',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunicationList(EmpCommunicationProvider provider) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          ...provider.announcement.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isExpanded = _expandedAnnouncements.contains(idx);

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
                    color: CustomColor.colorWhite,
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
                      /// Title
                      Text(
                        item.announcementTopic.isNotEmpty ? item.announcementTopic : "No Topic",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                          color: CustomColor.colorBlack,
                        ),
                      ),
                      SizedBox(height: 4.h),

                      /// Expandable message
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        firstChild: Text(
                          item.announcementDetails.length > 90
                              ? "${item.announcementDetails.substring(0, 90)}..."
                              : item.announcementDetails,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        secondChild: Text(
                          item.announcementDetails,
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                      ),
                      SizedBox(height: 4.h),

                      /// Read more / less toggle
                      if (item.announcementDetails.length > 90)
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (isExpanded) {
                                _expandedAnnouncements.remove(idx);
                              } else {
                                _expandedAnnouncements.add(idx);
                              }
                            });
                          },
                          child: Text(
                            isExpanded ? "Read less..." : "Read more...",
                            style: TextStyle(
                              color: CustomColor.colorBlue,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),

                      /// Attachments
                      if (item.attachmentDetail.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Column(
                            children: item.attachmentDetail.map((attachment) {
                              return GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri.parse(attachment.filePath);
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Could not open attachment')),
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 6.h),
                                  padding: EdgeInsets.all(5.w),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6.r),
                                          color: const Color.fromARGB(255, 246, 209, 207),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(4.w),
                                          child: Icon(
                                            Icons.edit_document,
                                            size: 20.sp,
                                            color: const Color.fromARGB(255, 211, 30, 17),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Text(
                                          "Attachment", // You might want to extract filename from path if possible, or use 'Attachment'
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: CustomColor.colorBlack,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(
                                        Icons.open_in_new,
                                        size: 18.sp,
                                        color: CustomColor.colorBlack,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      SizedBox(height: 8.h),

                      /// Sender + Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 20.sp,
                                color: CustomColor.colorGrey,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                item.fullName,
                                style: TextStyle(
                                  color: CustomColor.colorBlack,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16.sp,
                                color: CustomColor.colorGrey,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                item.startDate,
                                style: TextStyle(
                                  color: CustomColor.colorBlack,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),

          // Loading indicator for pagination
          if (provider.isLoadingMore)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: const EmpConcernTicketCardShimmer(),
              ),
            ),
          // End of list indicator
          if (!provider.hasMoreData && provider.announcement.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No more communications',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 20), // Extra space at bottom
        ],
      ),
    );
  }
}
