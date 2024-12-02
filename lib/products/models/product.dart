class Product {
  final String title; // Nama produk
  final String description; // Deskripsi produk
  final String image; // URL gambar produk
  final num price; // Harga produk
  final String category; // Kategori produk
  final num rate; // Rating produk
  int quantity; // Stok yang tersedia untuk produk

  // Konstruktor untuk menginisialisasi produk
  Product(
      {required this.title,
      required this.description,
      required this.image,
      required this.price,
      required this.category,
      required this.rate,
      required this.quantity});

// Mengonversi data JSON ke objek Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      title: json['title'] as String,
      description: json['description'] as String,
      image: json['image'] as String,
      price: json['price'] as num,
      category: json['category'] as String,
      rate: json['rate'] as num,
      quantity: json['quantity'] as int,
    );
  }

  // Mengonversi objek Product menjadi Map untuk JSON
  Map<String, Object?> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'category': category,
      'rate': rate,
      'quantity': quantity,
    };
  }

  // Membuat salinan objek Product dengan nilai yang diubah
  Product copyWith({
    String? category,
    String? description,
    String? image,
    num? price,
    int? quantity,
    int? rate,
    String? title,
  }) {
    return Product(
      title: title ?? this.title, // Gunakan nilai baru atau tetap yang lama
      description: description ?? this.description,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      rate: rate ?? this.rate,
      quantity: quantity ?? this.quantity,
    );
  }
}
