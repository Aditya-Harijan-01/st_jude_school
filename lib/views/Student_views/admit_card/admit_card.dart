import 'dart:developer';

import '../../../../constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/Students/admit_card_model.dart';
import '../../../providers/auth_provider/auth_provider.dart';
import '../../../providers/student/admit_card_provider.dart';
import '../../../widgets/common_bottom_sheet.dart';
import 'widgets/admit_card_shimmer.dart';

class AdmitCardScreen extends StatefulWidget {
  const AdmitCardScreen({super.key});
  @override
  State<AdmitCardScreen> createState() => _AdmitCardScreenState();
}

class _AdmitCardScreenState extends State<AdmitCardScreen> {
  String toYear='';
  String fromYear='';
  @override
  void initState() {
    final auth = context.read<AuthProvider>();
    toYear=auth.loginData!.currentyearto;
    fromYear=auth.loginData!.currentyearfrom;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAdmitCardData();
    });
  }

  Future<void> _loadAdmitCardData() async {
    final auth = context.read<AuthProvider>();
    final provider = Provider.of<AdmitCardProvider>(context, listen: false);
    provider.getAllAdmitCard(
      regno: auth.loginData!.regno,
      fromyear: fromYear,
      toyear: toYear,
    );
  }

  Future<void> _downloadAdmitCard(AdmitCardData admitCard) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final provider = Provider.of<AdmitCardProvider>(context, listen: false);
    
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>  Center(
          child: SizedBox(
            height: 300.h,
            child: Lottie.asset(
              'assets/animation/Paper_plane.json',
              fit: BoxFit.fitHeight,
              repeat: true,
            ),
          ),
        ),
      );

      final response = await provider.downloadAdmitCard(
        sl: "",
        sid: 0,
        regno: auth.loginData!.regno,
        fromyear: fromYear,
        toyear: toYear,
        examid: admitCard.examId,
      );
      log('year: ${auth.loginData!.currentyearto}');
      log('year from: ${auth.loginData!.currentyearfrom}');

      Navigator.of(context).pop();

      if (response != null && response['statusCode'] == 'Success') {
        final downloadUrl = response['download_url'] as String;
        
        final fullUrl = downloadUrl.startsWith('http') ? downloadUrl : 'https:$downloadUrl';
        
        final uri = Uri.parse(fullUrl);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          await launchUrl(uri, mode: LaunchMode.platformDefault);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download admit card'),
            backgroundColor: CustomColor.colorRed,
          ),
        );
      }
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: CustomColor.colorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          "Admit Card",
          style: TextStyle(
            color: CustomColor.colorWhite,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: CustomColor.colorWhite,
          ),
        ),
        backgroundColor: CustomColor.primaryColor,
        centerTitle: true,
      ),
      body: Consumer<AdmitCardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const AdmitCardShimmer();
          }

          if (provider.admitCardData == null || provider.admitCardData!.isEmpty) {
            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books, size: 65.sp, color: Colors.grey.shade500,),
                  Text(
                    "No admit cards found",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: CustomColor.colorGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding:  EdgeInsets.all(15.r),
            child: ListView.builder(
              itemCount: provider.admitCardData!.length,
              itemBuilder: (context, index) {
                final admitCard = provider.admitCardData![index];

                return Container(
                  margin:  EdgeInsets.only(bottom: 15.h),
                  height: 80.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: LinearGradient(
                      colors: [
                        CustomColor.primaryColor,
                        CustomColor.secondaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.0, 0.8],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 65.w,
                            padding:  EdgeInsets.all(8.r),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: SvgPicture.asset("assets/icons/svg/Group 325.svg"),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 6.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  admitCard.examName,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: CustomColor.colorWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  admitCard.displaySubtitle,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: CustomColor.colorWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.r),
                        child: IconButton(
                          onPressed: () async {
                              await _downloadAdmitCard(admitCard);
                          },
                          icon: Icon(
                            Icons.file_download_outlined,
                            size: 30.sp,
                            color: CustomColor.colorWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomSheet: CommonBottomSheet(onSessionChange: (from, to) async {
        setState(() {
          toYear=to;
          fromYear=from;
        });
        await _loadAdmitCardData();

      },content: SizedBox.shrink()),
    );
  }
}
