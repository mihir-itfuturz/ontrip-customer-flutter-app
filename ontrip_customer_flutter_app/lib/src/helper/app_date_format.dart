import 'package:intl/intl.dart';

class AppDateFormat {
  AppDateFormat._();

  factory AppDateFormat() => AppDateFormat._();

  static String hhmma(DateTime date) => DateFormat('hh:mm a').format(date);
  static String ddMMMYyyy(DateTime date) => DateFormat('dd/MMM/yyyy').format(date);
  static String monthDayYear(DateTime date) => DateFormat('MMM dd, yyyy').format(date);

  static String ddMMMMYyyy(DateTime date) => DateFormat('dd/MMMM/yyyy').format(date);

  static String ddMMYyyy(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  static String calenderHeader(DateTime date) => DateFormat('MMM,yyyy').format(date);

  static String notification(DateTime date) => DateFormat('dd-MMM-yyyy | hh:mm a').format(date);

  static String notification2(DateTime date) => DateFormat('dd MMM, yyyy || hh:mm a').format(date);

  static String notification3(DateTime date) => DateFormat('dd MMM, yyyy').format(date);

  static String announce(DateTime date) => DateFormat('dd-MM-yyyy | EEEE').format(date);

  static String day(DateTime date) => DateFormat('dd').format(date);

  static String month(DateTime date) => DateFormat('MMM').format(date);

  static String formatToGoogleCalendarDateISTAdjusted(DateTime dateTime) {
    final adjustedTime = dateTime.subtract(const Duration(hours: 5, minutes: 30));
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return "${formatter.format(adjustedTime)}+00:00";
  }

  static String formatTimeZoneOffset(Duration offset) {
    final String sign = offset.isNegative ? '-' : '+';
    final int hours = offset.inHours.abs();
    final int minutes = offset.inMinutes.abs() % 60;
    return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }
}
