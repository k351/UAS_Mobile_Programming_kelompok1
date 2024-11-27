import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Wishlist/providers/wishlist_provider.dart';
import 'package:uas_flutter/Wishlist/services/wishlistdatabaseservices.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/bottom_navigator.dart';
import 'package:uas_flutter/size_config.dart';

class WishlistPage extends StatefulWidget {
  static const String routeName = '/wishlist';

  const WishlistPage({Key? key}) : super(key: key);

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Future<List<Map<String, dynamic>>> _wishlistFuture;
  @override
  void initState() {
    super.initState();
    
  }

  Future<List<Map<String, dynamic>>> _fetchWishlistProducts(
    String userId,
    WishlistProvider wishlistProvider,
    ProductDatabaseService productDatabaseService,
  ) async {
    final productIds = wishlistProvider.getWishlist(userId);

    // Fetch products using their IDs
    final productsData = await Future.wait(
      productIds.map((id) async {
        final product = await productDatabaseService.fetchProductById(id);
        return {
          'id': id,
          'product': product,
        };
      }),
    );

    // Filter valid products (non-null)
    return productsData.where((element) => element['product'] != null).toList();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: AppConstants.clrBlackFont,
            fontFamily: AppConstants.fontInterSemiBold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppConstants.clrAppBar,
        iconTheme: const IconThemeData(color: AppConstants.mainColor),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Your wishlist is empty.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.greyColor3,
                ),
              ),
            );
          }

          final productsData = snapshot.data!;
          return ListView.builder(
            itemCount: productsData.length,
            itemBuilder: (context, index) {
              final productMap = productsData[index];
              final product = productMap['product'] as Product;
              final productId = productMap['id'] as String;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: AppConstants.greyColor1,
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: AssetImage(product.image),
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
                      color: AppConstants.clrBlackFont,
                    ),
                  ),
                  subtitle: Text(
                    'Rp ${product.price}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: AppConstants.fontInterRegular,
                      color: AppConstants.greyColor3,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: AppConstants.clrRed),
                    onPressed: () async {
                      await wishlistProvider.removeFromWishlist(
                          FirebaseAuth.instance.currentUser!.uid, productId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Item removed from wishlist'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () {
                              wishlistProvider.addToWishlist(
                                  FirebaseAuth.instance.currentUser!.uid,
                                  productId);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: NavigasiBar(
        selectedIndex: 2,
        onTap: (index) {
          NavigationUtils.navigateToPage(context, index);
        },
      ),
    );
  }
}