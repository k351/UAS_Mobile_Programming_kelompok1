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

  Future<Map<String, dynamic>> fetchCartByUserId(String userId,
      [bool withId = false]) async {
    try {
      QuerySnapshot<Cart> snapshot =
          await _cartsRef.where('userId', isEqualTo: userId).get();
      if (snapshot.docs.isNotEmpty) {
        if (withId == true) {
          return {
            'id': snapshot.docs.first.id,
            'cart': snapshot.docs.first.data()
          };
        } else {
          return {'cart': snapshot.docs.first.data()};
        }
      }
      throw Exception("Cart not Found");
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchCartItemsbyCartId(String cartId,
      [bool withId = false]) async {
    try {
      QuerySnapshot<CartItem> snapshot =
          await _cartItemsRef.where('cartId', isEqualTo: cartId).get();
      if (withId == true) {
        return snapshot.docs
            .map((doc) => {'id': doc.id, 'cartItem': doc.data()})
            .toList();
      } else {
        return snapshot.docs.map((doc) => {'cartItem': doc.data()}).toList();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Product?> fetchProductByCartItemId(String cartItemId) async {
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

  Future<CartItem?> fetchCartItemById(String cartItemId) async {
    try {
      DocumentSnapshot<CartItem> doc =
          await _cartItemsRef.doc(cartItemId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> initializeCartItems(String userId) async {
    try {
      Map<String, dynamic> cart = await fetchCartByUserId(userId, true);
      List<Map<String, dynamic>> cartItems =
          await fetchCartItemsbyCartId(cart['id'], true);
      List<Map<String, dynamic>> cartItemsWithDetails = [];
      for (Map<String, dynamic> item in cartItems) {
        CartItem cartItemData = item['cartItem'];
        Product? product =
            await productDatabase.fetchProductById(cartItemData.productId);
        if (product != null) {
          int finalCartQuantity = cartItemData.cartQuantity;
          if (cartItemData.cartQuantity > product.quantity) {
            finalCartQuantity = product.quantity;
            await _cartItemsRef
                .doc(item['id'])
                .update({'cartQuantity': product.quantity});
          }
          cartItemsWithDetails.add({
            'id': item['id'],
            'productId': cartItemData.productId,
            'description': product.description,
            'title': product.title,
            'image': product.image,
            'price': product.price,
            'quantity': product.quantity,
            'cartQuantity': finalCartQuantity,
            'check': cartItemData.check,
          });
        } else {
          removeCartItem(item['id']);
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
      CartItem? cartItem = await fetchCartItemById(cartItemId);
      if (cartItem != null) {
        String cartId = cartItem.cartId;
        DocumentReference cartDocRef = _cartsRef.doc(cartId);
        await cartDocRef.update({
          'cartList': FieldValue.arrayRemove([cartItemId]),
        });
        await _cartItemsRef.doc(cartItemId).delete();
      }
    } catch (e) {
      print("Cart Item not found or have been deleted");
    }
  }

  Future<void> updateCartQuantity(String cartItemId, int newQuantity) async {
    try {
      CartItem? cartItem = await fetchCartItemById(cartItemId);
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
    } catch (e) {
      print("Cart Item not found or Product not found");
    }
  }

  Future<void> addCartItemToCart(
      String userId, String productId, int quantity) async {
    try {
      Product? product =
          await ProductDatabaseService().fetchProductById(productId);
      if (product != null) {
        Map<String, dynamic> cart = await fetchCartByUserId(userId, true);
        List<Map<String, dynamic>> cartItems =
            await fetchCartItemsbyCartId(cart['id'], true);
        List<Map<String, dynamic>> matchingCartItems = cartItems.where((item) {
          CartItem cartItem = item['cartItem'];
          return cartItem.productId == productId;
        }).toList();
        if (matchingCartItems.isNotEmpty) {
          Map<String, dynamic> productExistsAtCart = matchingCartItems.first;
          String existingCartItemId = productExistsAtCart['id'];
          CartItem existingCartItem = productExistsAtCart['cartItem'];
          int newQuantity = existingCartItem.cartQuantity + quantity;
          int availableQuantity = product.quantity;
          if (newQuantity > availableQuantity) {
            newQuantity = availableQuantity;
            print('Quantity limited to available stock: $availableQuantity');
          }
          await _cartItemsRef
              .doc(existingCartItemId)
              .update({'cartQuantity': newQuantity});
        } else {
          String newCartItemId = _cartItemsRef.doc().id;
          CartItem newCartItem = CartItem(
            cartId: cart['id'],
            productId: productId,
            cartQuantity: quantity,
            check: true,
          );
          await _cartItemsRef.doc(newCartItemId).set(newCartItem);
          await _cartsRef
              .doc(
            cart['id'],
          )
              .update({
            'cartList': FieldValue.arrayUnion([newCartItemId]),
          });
        }
      } else {
        throw Exception("Product not found.");
      }
    } catch (e) {
      rethrow;
    }
  }
}
