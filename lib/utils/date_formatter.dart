import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }
}