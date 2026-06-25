// import '../../../../constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class DashedBorderPainter extends CustomPainter {
//   final Color color;
//   final double strokeWidth;
//   final double dashWidth;
//   final double dashSpace;
//   final double borderRadius;
//
//   DashedBorderPainter({
//     required this.color,
//     required this.strokeWidth,
//     required this.dashWidth,
//     required this.dashSpace,
//     required this.borderRadius,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..strokeWidth = strokeWidth
//       ..style = PaintingStyle.stroke;
//
//     final path = Path()
//       ..addRRect(RRect.fromRectAndRadius(
//         Rect.fromLTWH(0, 0, size.width, size.height),
//         Radius.circular(borderRadius),
//       ));
//
//     final dashPath = _createDashedPath(path, dashWidth, dashSpace);
//     canvas.drawPath(dashPath, paint);
//   }
//
//   Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
//     final dashedPath = Path();
//     for (final metric in source.computeMetrics()) {
//       double distance = 0;
//       while (distance < metric.length) {
//         final nextDistance = distance + dashWidth;
//         final extractPath = metric.extractPath(
//           distance,
//           nextDistance > metric.length ? metric.length : nextDistance,
//         );
//         dashedPath.addPath(extractPath, Offset.zero);
//         distance = nextDistance + dashSpace;
//       }
//     }
//     return dashedPath;
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// // TimetableItem model
// class TimetableItem {
//   final String subjectName;
//   final String teacher;
//   final String img;
//   final String time;
//   final String room;
//
//   TimetableItem({
//     required this.subjectName,
//     required this.teacher,
//     required this.img,
//     required this.time,
//     required this.room,
//   });
// }
//
// class TimetableCards extends StatelessWidget {
//   final String period;
//   final List<TimetableItem> items;
//
//   const TimetableCards({
//     super.key,
//     required this.period,
//     required this.items,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     bool hasMultipleItems = items.length > 1;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 12.h),
//       decoration: BoxDecoration(
//         color: hasMultipleItems ? Colors.yellow[100] : Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(12.r),
//           bottomLeft: Radius.circular(12.r),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: hasMultipleItems
//           ? CustomPaint(
//         painter: DashedBorderPainter(
//           color: CustomColor.primaryColor,
//           strokeWidth: 2,
//           dashWidth: 8,
//           dashSpace: 4,
//           borderRadius: 12,
//         ),
//         child: _buildCardContent(),
//       )
//           : Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(12.r),
//             bottomLeft: Radius.circular(12.r),
//           ),
//           border: Border(
//             left: BorderSide(
//               color: CustomColor.primaryColor,
//               width: 6.w,
//             ),
//             top: BorderSide(
//               color: CustomColor.primaryColor,
//               width: 1.w,
//             ),
//             bottom: BorderSide(
//               color: CustomColor.primaryColor,
//               width: 1.w,
//             ),
//           ),
//         ),
//         child: _buildCardContent(),
//       ),
//     );
//   }
//
//   Widget _buildCardContent() {
//     return Column(
//       children: items.asMap().entries.map((entry) {
//         int index = entry.key;
//         TimetableItem item = entry.value;
//         bool isLast = index == items.length - 1;
//
//         return Column(
//           children: [
//             _buildSingleItem(item),
//             if (!isLast)
//               Divider(
//                 color: CustomColor.primaryColor.withOpacity(0.3),
//                 thickness: 1,
//                 height: 1,
//               ),
//           ],
//         );
//       }).toList(),
//     );
//   }
//
//   Widget _buildSingleItem(TimetableItem item) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         children: [
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item.subjectName,
//                   style: TextStyle(
//                     fontSize: 22.sp,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 18.r,
//                       backgroundImage: NetworkImage(item.img),
//                     ),
//                     SizedBox(width: 10.w),
//                     Expanded(
//                       child: Text(
//                         item.teacher,
//                         style: TextStyle(
//                           fontSize: 18.sp,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 5.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 if (items.indexOf(item) == 0)
//                   Container(
//                     width: 75.w,
//                     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                     decoration: BoxDecoration(
//                       color: CustomColor.primaryColor,
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(8.r),
//                         bottomRight: Radius.circular(8.r),
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(
//                         period,
//                         style: TextStyle(
//                           fontSize: 15.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 SizedBox(height: 8.h),
//                 Container(
//                   width: 75.w,
//                   padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
//                   decoration: BoxDecoration(
//                     color: CustomColor.primaryColor,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(8.r),
//                       topRight: Radius.circular(8.r),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         item.time,
//                         style: TextStyle(
//                           fontSize: 15.sp,
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.symmetric(vertical: 1.h),
//                         color: Colors.white,
//                         height: 1.w,
//                         width: 45.w,
//                       ),
//                       Text(
//                         item.room,
//                         style: TextStyle(
//                           fontSize: 20.sp,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }