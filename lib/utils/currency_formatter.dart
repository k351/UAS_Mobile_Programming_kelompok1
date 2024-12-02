import 'package:intl/intl.dart';

/// Fungsi untuk memformat angka menjadi format mata uang Rupiah (IDR).
/// [amount] adalah nilai numerik yang akan diformat menjadi string mata uang
/// dengan format lokal Indonesia (id_ID) dan simbol mata uang Rupiah (Rp).
String formatCurrency(num amount) {
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 2,
  );
  return currencyFormatter.format(amount);
}