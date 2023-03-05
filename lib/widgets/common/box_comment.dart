import 'package:flutter/material.dart';

class BoxComment extends CustomPainter {
  final Color? color;

  BoxComment({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = color!;
    var path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 10);
    path.lineTo(30, size.height - 10);
    path.lineTo(20, size.height);
    path.lineTo(20, size.height - 10);
    path.lineTo(0, size.height - 10);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
