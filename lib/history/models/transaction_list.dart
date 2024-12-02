/// Class [TransactionList] merepresentasikan detail dari setiap item dalam transaksi.
/// Berisi informasi produk seperti ID, nama, gambar, harga, dan kuantitas.
class TransactionList {
  // ID produk dalam transaksi
  final String productId;
  
  // Nama atau judul produk
  final String title;

  // URL atau path gambar produk
  final String image;

  // Harga satuan produk
  final num price;

  // Jumlah produk yang dibeli
  final int quantity;

  /// Konstruktor utama untuk [TransactionList].
  TransactionList({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  /// Factory constructor untuk membuat instance [TransactionList] dari data JSON.
  factory TransactionList.fromJson(Map<String, dynamic> json) {
    return TransactionList(
      productId: json['productId'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      price: json['price'] as double,
      quantity: json['quantity'] as int,
    );
  }

  /// Mengonversi instance [TransactionList] ke dalam bentuk JSON.
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  /// Membuat salinan baru dari [TransactionList] dengan properti yang dapat diubah.
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
