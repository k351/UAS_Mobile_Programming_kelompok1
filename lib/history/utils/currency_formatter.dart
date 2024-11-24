class CurrencyFormatter {
  static String formatCurrency(int amount) {
    String price = amount.toString();
    String result = '';
    int count = 0;

    for (int i = price.length - 1; i >= 0; i--) {
      count++;
      result = price[i] + result;
      if (count % 3 == 0 && i > 0) {
        result = '.' + result;
      }
    }
    return 'Rp $result';
  }
}
