import 'package:flutter/material.dart';
import 'colors.dart';

class AppBarPainter extends CustomPainter {
  double x;
  AppBarPainter(this.x);

  double height = 80.0;
  double start = 20.0;
  double end = 120;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = const Color(0xFF1D1D1D)
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0.0, start);
    path.lineTo((x) < 20.0 ? 20.0 : x, start);
    path.quadraticBezierTo(20.0 + x, start, 30.0 + x, start + 30.0);
    path.quadraticBezierTo(40.0 + x, start + 55.0, 70.0 + x, start + 55.0);
    path.quadraticBezierTo(100.0 + x, start + 55.0, 110.0 + x, start + 30.0);
    path.quadraticBezierTo(
        120.0 + x,
        start,
        (140.0 + x) > (size.width - 20.0) ? (size.width - 20.0) : 140.0 + x,
        start);
    path.lineTo(size.width - 20.0, start);
    path.quadraticBezierTo(size.width, start, size.width, start + 25.0);
    path.lineTo(size.width, end - 25.0);
    path.quadraticBezierTo(size.width, end, size.width - 25.0, end);
    path.lineTo(25.0, end);
    path.quadraticBezierTo(0.0, end, 0.0, end - 25.0);
    path.lineTo(0.0, start + 25.0);
    path.quadraticBezierTo(0.0, start, 20.0, start);
    path.close();

    canvas.drawPath(path, paint);

    var circlePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x + 70.0, 30.0), 35.0, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}