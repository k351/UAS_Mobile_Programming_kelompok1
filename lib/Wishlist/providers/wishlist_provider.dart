import 'package:flutter/material.dart';
import 'package:uas_flutter/Wishlist/services/wishlistdatabaseservices.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistDatabaseServices _wishlistService = WishlistDatabaseServices();

  // Penyimpanan data wishlist per pengguna
  final Map<String, List<String>> _userWishlist = {};

  // Mendapatkan wishlist untuk pengguna tertentu
  List<String> getWishlist(String userId) {
    return _userWishlist[userId] ?? [];
  }

bool isWishlistFetched(String userId) {
  // Check if the wishlist for the given user is non-empty
  return _userWishlist[userId]?.isNotEmpty ?? false;
}

  // Mengambil data wishlist dari database untuk pengguna tertentu
  Future<void> fetchWishlist(String userId) async {
    final wishlistItems = await _wishlistService.getUserWishlist(userId);
    _userWishlist[userId] = wishlistItems;
    notifyListeners();
  }

  // Menambahkan produk ke wishlist pengguna tertentu
  Future<void> addToWishlist(String userId, String productId) async {
    await _wishlistService.addToWishlist(userId, productId);

    if (_userWishlist[userId] == null) {
      _userWishlist[userId] = [];
    }
    if (!_userWishlist[userId]!.contains(productId)) {
      _userWishlist[userId]!.add(productId);
      notifyListeners();
    }
  }

  // Menghapus produk dari wishlist pengguna tertentu
  Future<void> removeFromWishlist(String userId, String productId) async {
    await _wishlistService.removeFromWishlist(userId, productId);

    if (_userWishlist[userId] != null && _userWishlist[userId]!.contains(productId)) {
      _userWishlist[userId]!.remove(productId);
      notifyListeners();
    }
  }

  // Mengecek apakah produk ada di wishlist pengguna tertentu
  bool isInWishlist(String userId, String productId) {
    return _userWishlist[userId]?.contains(productId) ?? false;
  }

  Future<void> refreshWishlist(String userId) async {
    final wishlistItems = await _wishlistService.getUserWishlist(userId);
    _userWishlist[userId] = wishlistItems;
    notifyListeners();
  }
}
