import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistDatabaseServices {
  final CollectionReference _wishlistCollection =
      FirebaseFirestore.instance.collection('wishlist');

  Future<void> addToWishlist(String userId, String productId) async {
    // Cek apakah produk sudah ada di wishlist
    QuerySnapshot existingWishlist = await _wishlistCollection
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .get();

    if (existingWishlist.docs.isEmpty) {
      // Tambahkan ke wishlist jika belum ada
      await _wishlistCollection.add({
        'userId': userId,
        'productId': productId,
      });
    }
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    QuerySnapshot snapshot = await _wishlistCollection
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<List<String>> getUserWishlist(String userId) async {
    QuerySnapshot snapshot = await _wishlistCollection
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc['productId'] as String).toList();
  }

  Future<bool> isProductInWishlist(String userId, String productId) async {
    QuerySnapshot snapshot = await _wishlistCollection
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}