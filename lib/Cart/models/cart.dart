class Cart {
  final String userId;
  final List<String> cartItemIds;

  Cart({
    required this.userId,
    required this.cartItemIds,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      userId: json['userId'] as String,
      cartItemIds: List<String>.from(json['cartList'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cartList': cartItemIds,
    };
  }

  Cart copyWith({
    String? userId,
    List<String>? cartItemIds,
  }) {
    return Cart(
      userId: userId ?? this.userId,
      cartItemIds: cartItemIds ?? this.cartItemIds,
    );
  }
}
