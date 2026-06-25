import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ImageProvider buildProfileImage(String? base64Image) {
    if (base64Image == null || base64Image.isEmpty) {
      // 🔹 default image if none available
      return const NetworkImage(
        "https://cdn-icons-png.flaticon.com/512/847/847969.png",
      );
    }

    try {
      final bytes = base64Decode(base64Image);
      return MemoryImage(bytes);
    } catch (e) {
      // 🔹 fallback if decoding fails
      return const NetworkImage(
        "https://cdn-icons-png.flaticon.com/512/847/847969.png",
      );
    }
  }


ImageProvider buildEmpProfileImage(String? imgUrl) {
  if (imgUrl == null || imgUrl.isEmpty) {
    // 🔹 default image if none available
    return const NetworkImage(
      "https://cdn-icons-png.flaticon.com/512/847/847969.png",
    );
  }

  try {
    return NetworkImage(imgUrl);
    // return 
  } catch (e) {
    // 🔹 fallback if decoding fails
    return const NetworkImage(
      "https://cdn-icons-png.flaticon.com/512/847/847969.png",
    );
  }
}

Widget buildStudentNotificationImage(String? imageUrl) {
  return CircleAvatar(
    radius: 12.r,
    backgroundColor: Colors.grey.shade300,
    backgroundImage:
        (imageUrl != null && imageUrl.isNotEmpty)
            ? NetworkImage(imageUrl)
            : null,
    child: (imageUrl == null || imageUrl.isEmpty)
        ? Icon(
            Icons.person,
            size: 12.sp,
            color: Colors.grey,
          )
        : null,
  );
}
