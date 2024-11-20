class Transaction {
  final String id;
  final String title;
  final String date;
  final int amount;
  final int quantity;

  const Transaction({
    required this.id,
    required this.title,
    required this.date,
    required this.amount,
    required this.quantity,
  });
}
