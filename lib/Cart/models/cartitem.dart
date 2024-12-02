class CartItem {
  final String cartId; // ID keranjang
  final String productId; // ID produk
  final int cartQuantity; // Jumlah item di keranjang
  final bool check; // Status apakah item telah dipilih untuk checkout

// Konstruktor untuk menginisialisasi item cart
  CartItem({
    required this.cartId,
    required this.productId,
    required this.cartQuantity,
    required this.check,
  });

  // Mengonversi data JSON ke objek CartItem
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cartId'] as String,
      productId: json['productId'] as String,
      cartQuantity: json['cartQuantity'] as int,
      check: json['check'] as bool,
    );
  }

  // Mengonversi objek CartItem menjadi Map untuk JSON
  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'productId': productId,
      'cartQuantity': cartQuantity,
      'check': check,
    };
  }

  // Membuat salinan objek CartItem dengan nilai yang diubah
  CartItem copyWith({
    String? cartId,
    String? productId,
    int? cartQuantity,
    bool? check,
  }) {
    return CartItem(
      cartId: cartId ?? this.cartId, // Gunakan nilai baru atau tetap yang lama
      productId: productId ?? this.productId,
      cartQuantity: cartQuantity ?? this.cartQuantity,
      check: check ?? this.check,
    );
  }
}
