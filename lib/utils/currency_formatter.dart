import 'package:intl/intl.dart';

String formatCurrency(num amount) {
  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 2,
  );
  return currencyFormatter.format(amount);
}