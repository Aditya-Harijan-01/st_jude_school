
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../constants/colors.dart';
import '../../../../models/Students/album_model.dart';

class AlbumBottomSheet extends StatelessWidget {
  const AlbumBottomSheet({
    super.key,
    required this.album,
  });

  final PhotoAlbum album;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColor.primaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: CustomColor.colorBlack.withOpacity(0.1),
            blurRadius: 10.r,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.w),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    album.heading ?? '',
                    style: TextStyle(
                      color: CustomColor.colorWhite,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: CustomColor.colorWhite, size: 14.sp),
                      SizedBox(width: 8.w),
                      Text(
                        album.uploadDate ?? '',
                        style: TextStyle(
                          color: CustomColor.colorWhite,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: CustomColor.colorWhite.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.photo_library,
                      color: CustomColor.colorWhite, size: 20.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${album.images!.length} Photos',
                  style: TextStyle(
                    color: CustomColor.colorWhite,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}