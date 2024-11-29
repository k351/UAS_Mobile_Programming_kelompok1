class TransactionList {
  final String productId;
  final String title;
  final String image;
  final num price;
  final int quantity;

  TransactionList({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory TransactionList.fromJson(Map<String, dynamic> json) {
    return TransactionList(
      productId: json['productId'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      price: json['price'] as double,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  TransactionList copyWith({
    String? transactionListId,
    String? productId,
    String? title,
    String? image,
    double? price,
    int? quantity,
  }) {
    return TransactionList(
      productId: productId ?? this.productId,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
