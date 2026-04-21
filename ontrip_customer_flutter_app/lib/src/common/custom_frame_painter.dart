import '../../app_export.dart';

class CustomFramePainter extends CustomPainter {
  CustomFramePainter({
    required this.width,
    this.paintingStyle,
    this.borderColor,
    this.fillColor,
  });
  final double width;
  final PaintingStyle? paintingStyle;
  final Color? borderColor;
  final Color? fillColor;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor ?? Colors.white
      ..style = paintingStyle ?? PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final rectWidth = width - 20;
    final rectHeight = 220.0;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final rect = Rect.fromCenter(
      center: Offset(centerX, centerY),
      width: rectWidth,
      height: rectHeight,
    );

    canvas.drawRect(rect, paint);

    final fillPaint = Paint()
      ..color = fillColor ?? Colors.black26
      ..style = PaintingStyle.fill;

    canvas.drawRect(Offset(0, 0) & size, fillPaint);
    canvas.drawRect(rect, Paint()..color = Colors.transparent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
