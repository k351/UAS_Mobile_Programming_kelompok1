import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Wishlist/providers/wishlist_provider.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/bottom_navigator.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';

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
    _wishlistFuture = _fetchWishlistProducts();
  }

  Future<List<Map<String, dynamic>>> _fetchWishlistProducts() async {
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final productIds = wishlistProvider.getWishlist(userId);
    final ProductDatabaseService productDatabaseService =
        ProductDatabaseService();
    final productsData = await Future.wait(
      productIds.map((id) async {
        final product = await productDatabaseService.fetchProductById(id);
        return {
          'id': id,
          'product': product,
        };
      }),
    );
    return productsData.where((element) => element['product'] != null).toList();
  }

  Future<void> _removeFromWishlist(String productId) async {
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await wishlistProvider.removeFromWishlist(userId, productId);
    setState(() {
      _wishlistFuture = _fetchWishlistProducts();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from wishlist'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppConstants.clrBlue,
        action: SnackBarAction(
          label: 'Undo',
          textColor: AppConstants.clrBackground,
          onPressed: () async {
            wishlistProvider.addToWishlist(userId, productId);
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              _wishlistFuture = _fetchWishlistProducts();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.clrBackground,
      appBar: AppBar(
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: AppConstants.clrBlackFont,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.fontInterSemiBold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppConstants.clrAppBar,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _wishlistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 100,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your wishlist is empty.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.greyColor3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Add products to save them for later!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: AppConstants.greyColor3,
                      ),
                    ),
                  ],
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
                  margin:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppConstants.clrBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image(
                              image: AssetImage(product.image),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppConstants.fontInterMedium,
                                    color: AppConstants.clrBlackFont,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formatCurrency(product.price),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: AppConstants.fontInterRegular,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstants.greyColor3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppConstants.clrRed,
                            ),
                            onPressed: () => _removeFromWishlist(productId),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: NavigasiBar(
        selectedIndex: 2, // Set sesuai index untuk wishlist
        onTap: (index) {
          NavigationUtils.navigateToPage(context, index);
        },
      ),
    );
  }
}
