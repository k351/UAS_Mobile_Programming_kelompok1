import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistDatabaseServices {
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addToWishlist(String userId, String productId) async {
    final userDoc = _userCollection.doc(userId);

    await userDoc.set({
      'wishlist': FieldValue.arrayUnion([productId]),
    }, SetOptions(merge: true));
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    final userDoc = _userCollection.doc(userId);

    await userDoc.update({
      'wishlist': FieldValue.arrayRemove([productId]),
    });
  }

  Future<List<String>> getUserWishlist(String userId) async {
    final userDoc = await _userCollection.doc(userId).get();

    if (userDoc.exists) {
      final data = userDoc.data() as Map<String, dynamic>;
      return List<String>.from(data['wishlist'] ?? []);
    }
    return [];
  }
}
