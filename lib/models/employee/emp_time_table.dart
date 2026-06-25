
import 'dart:ui';

import 'package:flutter/cupertino.dart';

class TimetableResponse {
  final String statusCode;
  final List<TimetableItem> data;

  TimetableResponse({
    required this.statusCode,
    required this.data,
  });

  factory TimetableResponse.fromJson(Map<String, dynamic> json) {
    return TimetableResponse(
      statusCode: json['statusCode'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => TimetableItem.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class TimetableItem {
  final String subject;
  final String teacher;
  final String period;
  final String parallelType;
  final String parallelNo;
  final String dayName;
  final String teacherImage;

  TimetableItem({
    required this.subject,
    required this.teacher,
    required this.period,
    required this.parallelType,
    required this.parallelNo,
    required this.dayName,
    required this.teacherImage,
  });

  factory TimetableItem.fromJson(Map<String, dynamic> json) {
    return TimetableItem(
      subject: json['subject'] ?? '',
      teacher: json['teacher'] ?? '',
      period: json['period'] ?? '',
      parallelType: json['paralleltype'] ?? '',
      parallelNo: json['parallelno'] ?? '',
      dayName: json['day_name'] ?? '',
      teacherImage: json['teacher_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'teacher': teacher,
      'period': period,
      'paralleltype': parallelType,
      'parallelno': parallelNo,
      'day_name': dayName,
      'teacher_image': teacherImage,
    };
  }

  @override
  String toString() {
    return 'TimetableItem(subject: $subject, teacher: $teacher, period: $period, parallelType: $parallelType, parallelNo: $parallelNo, dayName: $dayName, teacherImage: $teacherImage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimetableItem &&
        other.subject == subject &&
        other.teacher == teacher &&
        other.period == period &&
        other.parallelType == parallelType &&
        other.parallelNo == parallelNo &&
        other.dayName == dayName &&
        other.teacherImage == teacherImage;
  }

  @override
  int get hashCode {
    return Object.hash(
      subject,
      teacher,
      period,
      parallelType,
      parallelNo,
      dayName,
      teacherImage,
    );
  }
}
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
            size.width - strokeWidth, size.height - strokeWidth),
        Radius.circular(borderRadius),
      ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        double nextDistance = distance + dashWidth;
        if (nextDistance > pathMetric.length) {
          nextDistance = pathMetric.length;
        }
        Path extractPath = pathMetric.extractPath(distance, nextDistance);
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}