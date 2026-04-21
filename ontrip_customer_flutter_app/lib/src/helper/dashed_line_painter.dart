import '../../app_export.dart';

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double progress;

  DashedLinePainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final totalWidth = dashWidth + dashSpace;

    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2), Offset(startX + dashWidth, size.height / 2), paint);
      startX += totalWidth;
    }

    if (progress > 0) {
      final progressPaint = Paint()
        ..color = Colors.green.shade600
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width * progress, size.height / 2), progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
