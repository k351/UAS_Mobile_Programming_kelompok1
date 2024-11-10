import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/Cart/models/cart.dart';
import 'package:uas_flutter/Cart/models/cartitem.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';

const String CARTS_COLLECTION_REF = "carts";
const String CART_ITEMS_COLLECTION_REF = "cartItems";

class CartDatabaseService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference<Cart> _cartsRef;
  late final CollectionReference<CartItem> _cartItemsRef;
  final ProductDatabaseService productDatabase;

  CartDatabaseService({required this.productDatabase}) {
    _cartsRef = _firestore.collection(CARTS_COLLECTION_REF).withConverter<Cart>(
          fromFirestore: (snapshots, _) => Cart.fromJson(snapshots.data()!),
          toFirestore: (cart, _) => cart.toJson(),
        );

    _cartItemsRef = _firestore
        .collection(CART_ITEMS_COLLECTION_REF)
        .withConverter<CartItem>(
          fromFirestore: (snapshots, _) => CartItem.fromJson(snapshots.data()!),
          toFirestore: (cartItem, _) => cartItem.toJson(),
        );
  }

  Future<List<Cart>> fetchCarts() async {
    try {
      QuerySnapshot<Cart> snapshot = await _cartsRef.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<Cart?> fetchCartByUserId(String userId) async {
    try {
      final querySnapshot =
          await _cartsRef.where('userId', isEqualTo: userId).get();
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CartItem>> fetchCartItemsbyCartId(String cartId) async {
    try {
      QuerySnapshot<CartItem> snapshot =
          await _cartItemsRef.where('cartId', isEqualTo: cartId).get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCartItemsWithProductDetails(
      String userId) async {
    try {
      QuerySnapshot<Cart> cartSnapshot =
          await _cartsRef.where('userId', isEqualTo: userId).get();
      String cartId = cartSnapshot.docs.first.id;
      QuerySnapshot<CartItem> snapshot =
          await _cartItemsRef.where('cartId', isEqualTo: cartId).get();

      List<Map<String, dynamic>> cartItemsWithDetails = [];
      for (var doc in snapshot.docs) {
        CartItem cartItem = doc.data();
        Product? product =
            await productDatabase.fetchProductById(cartItem.productId);

        if (product != null) {
          int finalCartQuantity = cartItem.cartQuantity;
          if (cartItem.cartQuantity > product.quantity) {
            finalCartQuantity = product.quantity;
            await updateCartItem(
                doc.id, cartItem.copyWith(cartQuantity: product.quantity));
          }

          cartItemsWithDetails.add({
            'id': doc.id,
            'title': product.title,
            'image': product.image,
            'price': product.price,
            'quantity': product.quantity,
            'cartQuantity': finalCartQuantity,
            'check': cartItem.check,
          });
        }
      }
      return cartItemsWithDetails;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCartItem(String cartItemId, CartItem cartItem) async {
    try {
      await _cartItemsRef.doc(cartItemId).set(cartItem);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeCartItem(String cartItemId) async {
    try {
      DocumentSnapshot<CartItem> cartItemDoc =
          await _cartItemsRef.doc(cartItemId).get();
      CartItem? cartItem = cartItemDoc.data();

      if (cartItem != null) {
        String cartId = cartItem.cartId;
        await _cartItemsRef.doc(cartItemId).delete();
        DocumentReference cartDocRef = _cartsRef.doc(cartId);
        await cartDocRef.update({
          'cartList': FieldValue.arrayRemove([cartItemId]),
        });
        await _cartItemsRef.doc(cartItemId).delete();
      } else {
        throw Exception("CartItem not found for ID: $cartItemId");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Product?> fetchProductByCartId(String cartItemId) async {
    try {
      DocumentSnapshot<CartItem> cartItemSnapshot =
          await _cartItemsRef.doc(cartItemId).get();
      CartItem? cartItem = cartItemSnapshot.data();

      if (cartItem != null) {
        Product? product =
            await productDatabase.fetchProductById(cartItem.productId);
        return product;
      } else {
        throw Exception("Cart item not found for ID: $cartItemId");
      }
    } catch (e) {
      throw Exception("Failed to fetch product: $e");
    }
  }

  Future<void> updateCartQuantity(String cartItemId, int newQuantity) async {
    DocumentSnapshot<CartItem> cartItemSnapshot =
        await _cartItemsRef.doc(cartItemId).get();
    CartItem? cartItem = cartItemSnapshot.data();
    if (cartItem != null) {
      Product? product =
          await productDatabase.fetchProductById(cartItem.productId);
      if (product != null) {
        await _cartItemsRef
            .doc(cartItemId)
            .update({'cartQuantity': newQuantity});
      } else {
        throw Exception("Product not found for ID: ${cartItem.productId}");
      }
    } else {
      throw Exception("Cart item not found for ID: $cartItemId");
    }
  }
}
