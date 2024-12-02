import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/Cart/models/cart.dart';
import 'package:uas_flutter/Cart/models/cartitem.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';

//String berisi referensi ke carts collection di firebase
const String CARTS_COLLECTION_REF = "carts";

//String berisi referensi ke cart items collection di firebase
const String CART_ITEMS_COLLECTION_REF = "cartItems";

class CartDatabaseService {
  // Instance Firebase Firestore untuk berkomunikasi dengan database Firestore
  final _firestore = FirebaseFirestore.instance;

  // Referensi koleksi untuk Cart dan CartItem di Firestore
  late final CollectionReference<Cart> _cartsRef;
  late final CollectionReference<CartItem> _cartItemsRef;

  // Instance untuk ProductDatabaseService (mengelola produk di database)
  late ProductDatabaseService productDatabase;

  // Konstruktor untuk menginisialisasi referensi koleksi dengan konverter
  CartDatabaseService() {
    // Koleksi untuk cart dengan konverter JSON ke model Cart
    _cartsRef = _firestore.collection(CARTS_COLLECTION_REF).withConverter<Cart>(
          fromFirestore: (snapshots, _) => Cart.fromJson(snapshots.data()!),
          toFirestore: (cart, _) => cart.toJson(),
        );

    // Koleksi untuk cart item dengan konverter JSON ke model CartItem
    _cartItemsRef = _firestore
        .collection(CART_ITEMS_COLLECTION_REF)
        .withConverter<CartItem>(
          fromFirestore: (snapshots, _) => CartItem.fromJson(snapshots.data()!),
          toFirestore: (cartItem, _) => cartItem.toJson(),
        );

    // Inisialisasi ProductDatabaseService
    productDatabase = ProductDatabaseService();
  }

  // Mengambil semua data cart dari Firestore
  Future<List<Cart>> fetchCarts() async {
    try {
      QuerySnapshot<Cart> snapshot = await _cartsRef.get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Mengambil cart berdasarkan userId, dengan opsi menyertakan ID dokumen Firestore
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

  // Mengambil cart berdasarkan userId, dengan opsi menyertakan ID dokumen Firestore
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

  // Mengambil produk berdasarkan ID item di cart
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

  // Mengambil data item cart berdasarkan ID-nya
  Future<CartItem?> fetchCartItemById(String cartItemId) async {
    try {
      DocumentSnapshot<CartItem> doc =
          await _cartItemsRef.doc(cartItemId).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      rethrow;
    }
  }

  // Menginisialisasi semua item cart dengan detail produk terkait
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
        // Mengecek apakah product masih tersedia
        if (product != null) {
          if (product.quantity != 0) {
            int finalCartQuantity = cartItemData.cartQuantity;
            // Mengecek stock yang tersedia cukup untuk di cart
            if (cartItemData.cartQuantity > product.quantity) {
              // Menganti item cart dengan stock yang tersedia
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
          }
        } else {
          //Bila product sudah
          removeCartItem(item['id']);
        }
      }
      return cartItemsWithDetails;
    } catch (e) {
      rethrow;
    }
  }

  // Memperbarui item cart dengan data baru berdasarkan ID cart item
  Future<void> updateCartItem(String cartItemId, CartItem cartItem) async {
    try {
      await _cartItemsRef.doc(cartItemId).set(cartItem);
    } catch (e) {
      rethrow;
    }
  }

  // Menghapus item dari cart berdasarkan ID-nya
  Future<void> removeCartItem(String cartItemId) async {
    try {
      //Mengecek apakah item cart ada
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

  // Memperbarui kuantitas item di cart
  Future<void> updateCartQuantity(String cartItemId, int newQuantity) async {
    try {
      //Mengecek apakah item cart ada
      CartItem? cartItem = await fetchCartItemById(cartItemId);
      if (cartItem != null) {
        //Mengecek apakah product ada
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

  // Menambahkan item baru ke cart atau memperbarui jika item sudah ada
  Future<String> addCartItemToCart(
      String userId, String productId, int quantity) async {
    try {
      Product? product =
          await ProductDatabaseService().fetchProductById(productId);

      // Mengecek apakah product masih tersedia
      if (product != null) {
        if (product.quantity == 0) {
          return ('Stock limit Reached');
        }
        Map<String, dynamic> cart = await fetchCartByUserId(userId, true);

        List<Map<String, dynamic>> cartItems =
            await fetchCartItemsbyCartId(cart['id'], true);

        List<Map<String, dynamic>> matchingCartItems = cartItems.where((item) {
          CartItem cartItem = item['cartItem'];
          return cartItem.productId == productId;
        }).toList();

        // Mengecek apakah item sudah ada di cart
        if (matchingCartItems.isNotEmpty) {
          Map<String, dynamic> productExistsAtCart = matchingCartItems.first;
          String existingCartItemId = productExistsAtCart['id'];
          CartItem existingCartItem = productExistsAtCart['cartItem'];
          if (existingCartItem.cartQuantity == product.quantity) {
            return ('Stock limit Reached');
          }
          int newQuantity = existingCartItem.cartQuantity + quantity;

          // Mengecek apakah quantity baru lebih banyak dari sctock tersedia
          if (newQuantity > product.quantity) {
            final newquantitadded =
                product.quantity - existingCartItem.cartQuantity;
            newQuantity = product.quantity;
            await _cartItemsRef
                .doc(existingCartItemId)
                .update({'cartQuantity': newQuantity});
            return ('Updated cart until stock limit ${newquantitadded}');
          } else {
            await _cartItemsRef
                .doc(existingCartItemId)
                .update({'cartQuantity': newQuantity});
            return ('Updated cart item');
          }
        }
        // Pembuatan item cart baru bila tidak ada
        else {
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
          return ('Added item to cart');
        }
      } else {
        return ('Error adding item, try again.');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Memperbarui status 'check' untuk item di cart (misalnya, dicentang untuk checkout)
  Future<void> updateCheckStatus(String cartItemId, bool newCheckValue) async {
    try {
      await _cartItemsRef.doc(cartItemId).update({
        'check': newCheckValue,
      });
    } catch (e) {
      rethrow;
    }
  }
}
