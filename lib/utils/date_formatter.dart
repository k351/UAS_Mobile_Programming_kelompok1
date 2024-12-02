import 'package:intl/intl.dart';

/// Kelas utilitas untuk memformat tanggal menjadi string dalam format yang lebih ramah pengguna.
class DateFormatter {
  static String formatDate(DateTime date) {
    /// Memformat objek [DateTime] ke dalam format string yang lebih deskriptif.
    /// - Sebuah string yang merepresentasikan tanggal dalam format yang diinginkan.
    return DateFormat('EEEE, d MMMM yyyy').format(date);
  }
}