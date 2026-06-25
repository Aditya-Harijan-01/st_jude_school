import 'package:flutter/material.dart';

class TreeLinePainter extends CustomPainter {
  final bool isLast;

  TreeLinePainter({required this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double centerY = size.height / 2;
    final double startX = size.width * 0.3;
    final double endX = size.width * 0.9;

    if (isLast) {
      // └─ for last item
      canvas.drawLine(Offset(startX, 0), Offset(startX, centerY), paint);
      canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), paint);
    } else {
      // ├─ for non-last items
      canvas.drawLine(Offset(startX, 0), Offset(startX, size.height), paint);
      canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}