import 'package:flutter/material.dart';
import 'package:uas_flutter/Wishlist/services/wishlistdatabaseservices.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistDatabaseServices _wishlistService = WishlistDatabaseServices();
  List<String> _wishlistItems = [];

  List<String> get wishlistItems => _wishlistItems;

  Future<void> fetchWishlist(String userId) async {
    _wishlistItems = await _wishlistService.getUserWishlist(userId);
    notifyListeners();
  }

  Future<void> addToWishlist(String userId, String productId) async {
    await _wishlistService.addToWishlist(userId, productId);
    _wishlistItems.add(productId);
    notifyListeners();
  }

  Future<void> removeFromWishlist(String userId, String productId) async {
    await _wishlistService.removeFromWishlist(userId, productId);
    _wishlistItems.remove(productId);
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _wishlistItems.contains(productId);
  }
}
