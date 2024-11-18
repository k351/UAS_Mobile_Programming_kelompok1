  class Product {
    final String title;
    final String description;
    final String image;
    final num price;
    final String category;
    final num rate;
    int quantity;

    Product(
        {required this.title,
        required this.description,
        required this.image,
        required this.price,
        required this.category,
        required this.rate,
        required this.quantity});

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
        title: title ?? this.title,
        description: description ?? this.description,
        image: image ?? this.image,
        price: price ?? this.price,
        category: category ?? this.category,
        rate: rate ?? this.rate,
        quantity: quantity ?? this.quantity,
      );
    }
  }
