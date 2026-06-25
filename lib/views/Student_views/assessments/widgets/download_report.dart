import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../../../../providers/auth_provider/auth_provider.dart';
import '../../../../providers/student/students_report_cards_provider.dart';

Future<void> downloadReportCard(String regNo,String report, String to, String from, context) async {
  // final auth = Provider.of<AuthProvider>(context, listen: false);
  final reportProvider = Provider.of<StudentsReportCardsProvider>(context, listen: false);


  try {
    showDialog(
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
      ), context: context,
    );

    final response = await reportProvider.downloadReportCard(
     regNo: regNo, reportId: report, fromYear: from , toYear: to,
    );

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
        const SnackBar(
          content: Text('Failed to download admit card'),
          backgroundColor: Colors.red,
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
        backgroundColor: Colors.red,
      ),
    );
  }
}
