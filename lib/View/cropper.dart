import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_fill_0 = Paint()
      ..color = const Color.fromARGB(255, 206, 187, 247)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * -0.0026167, size.height * 0.0042857);
    path_0.quadraticBezierTo(size.width * 0.4642917, size.height * 0.0987857,
        size.width * 0.3405083, size.height * 0.5342143);
    path_0.cubicTo(
        size.width * 0.2862083,
        size.height * 0.9559714,
        size.width * 0.5725333,
        size.height * 0.8676143,
        size.width * 0.6180833,
        size.height * 0.8748143);
    path_0.quadraticBezierTo(size.width * 0.8919917, size.height * 0.7756571,
        size.width * 1.0022500, size.height * 0.9928571);
    path_0.lineTo(size.width * 0.9991667, size.height * -0.0020286);

    canvas.drawPath(path_0, paint_fill_0);

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 116, 114, 121)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
