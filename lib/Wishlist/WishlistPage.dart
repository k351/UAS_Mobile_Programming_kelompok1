import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Wishlist/providers/wishlist_provider.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/bottom_navigator.dart';

class WishlistPage extends StatelessWidget {
  static const String routeName = '/wishlist'; // Route name untuk navigasi
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productDatabaseService = ProductDatabaseService();
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppConstants.clrBackground, // Warna background
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: AppConstants.clrBlackFont, // Warna font hitam
            fontFamily: AppConstants.fontInterSemiBold, // Font semi-bold
          ),
        ),
        centerTitle: true,
        backgroundColor: AppConstants.clrAppBar, // Warna AppBar
        iconTheme: const IconThemeData(color: AppConstants.mainColor), // Ikon
      ),
      body: FutureBuilder(
        future: wishlistProvider.fetchWishlist(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wishlistProvider.wishlistItems.isEmpty) {
            return const Center(
              child: Text(
                'Your wishlist is empty.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.greyColor3, // Warna abu-abu
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: wishlistProvider.wishlistItems.length,
            itemBuilder: (context, index) {
              final productId = wishlistProvider.wishlistItems[index];

              return FutureBuilder<Product?>(
                future: productDatabaseService.fetchProductById(productId),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text(
                        'Loading...',
                        style: TextStyle(color: AppConstants.greyColor4), // Warna teks loading
                      ),
                      leading: CircularProgressIndicator(),
                    );
                  }

                  if (!productSnapshot.hasData || productSnapshot.data == null) {
                    return const ListTile(
                      title: Text(
                        'Failed to load product details',
                        style: TextStyle(color: AppConstants.clrRed), // Warna merah
                      ),
                    );
                  }

                  final product = productSnapshot.data!;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: AppConstants.greyColor1, // Warna background card
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Sudut membulat pada gambar
                        child: Image.network(
                          product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: AppConstants.fontInterMedium,
                          color: AppConstants.clrBlackFont, // Warna teks hitam
                        ),
                      ),
                      subtitle: Text(
                        'Rp ${product.price}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: AppConstants.fontInterRegular,
                          color: AppConstants.greyColor3, // Warna subtitle
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: AppConstants.clrRed), // Ikon merah
                        onPressed: () async {
                          await wishlistProvider.removeFromWishlist(userId, productId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Item removed from wishlist')),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: NavigasiBar(
        selectedIndex: 1, // Index Wishlist
        onTap: (index) {
          NavigationUtils.navigateToPage(context, index);
        },
      ),
    );
  }
}
