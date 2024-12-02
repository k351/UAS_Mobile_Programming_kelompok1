class Cart {
  final String userId; // ID pengguna yang memiliki keranjang
  final List<String> cartItemIds; // Daftar ID item di dalam keranjang

  // Konstruktor untuk menginisialisasi cart
  Cart({
    required this.userId,
    required this.cartItemIds,
  });

  // Mengonversi data JSON ke objek Cart
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      userId: json['userId'] as String,
      cartItemIds: List<String>.from(json['cartList'] as List<dynamic>),
    );
  }

  // Mengonversi objek Cart menjadi Map untuk JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cartList': cartItemIds,
    };
  }

  // Membuat salinan objek Cart dengan nilai yang diubah
  Cart copyWith({
    String? userId,
    List<String>? cartItemIds,
  }) {
    return Cart(
      userId: userId ?? this.userId, // Gunakan nilai baru atau tetap yang lama
      cartItemIds: cartItemIds ?? this.cartItemIds,
    );
  }
}
