class CartItem {
  final String cartId;
  final String productId;
  final int cartQuantity;
  final bool check;

  CartItem({
    required this.cartId,
    required this.productId,
    required this.cartQuantity,
    required this.check,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      cartId: json['cartId'] as String,
      productId: json['productId'] as String,
      cartQuantity: json['cartQuantity'] as int,
      check: json['check'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'productId': productId,
      'cartQuantity': cartQuantity,
      'check': check,
    };
  }

  CartItem copyWith({
    String? cartId,
    String? productId,
    int? cartQuantity,
    bool? check,
  }) {
    return CartItem(
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
      cartQuantity: cartQuantity ?? this.cartQuantity,
      check: check ?? this.check,
    );
  }
}
