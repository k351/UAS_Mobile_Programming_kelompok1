import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/widget/cartquantitycounter.dart';
import 'package:uas_flutter/Cart/widget/cartcheckbox.dart';
import 'package:uas_flutter/Wishlist/providers/wishlist_provider.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/products/product_detail_screen.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';

//widget cart item di cart
class Cartitem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete; //pemangilan fungsi ondelete cartitemlist agar dilakukan setstate

  const Cartitem({
    super.key,
    required this.data,
    required this.onDelete,
  });

  //fungsi menyala matikan wishlist
  void toggleWishlist(WishlistProvider wishlistProvider, String userId) {
    if (wishlistProvider.isInWishlist(userId, data['productId'])) {
      wishlistProvider.removeFromWishlist(userId, data['productId']);
    } else {
      wishlistProvider.addToWishlist(userId, data['productId']);
    }
  }

  @override
  Widget build(BuildContext context) {
    //pemanggilan wishlist provider
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    //pengambilan user id dari firebase
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return Column(
      children: [
        ListTile(
          subtitle: Container(
            height: 126,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: AppConstants.clrBackground,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Cartcheckbox( // pemanggilan widget checkbox
                  id: data['id'],
                ),
                Container(
                  height: 70,
                  width: 70,
                  margin: const EdgeInsets.only(right: 10),
                  child: Image.asset(
                    data['image'],
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell( // Fungsi Ke product detail screen dari cart
                        onTap: () async {
                          final productService = ProductDatabaseService();

                          final product = await productService
                              .fetchProductById(data['productId']);

                          if (product != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  product: product,
                                  productId: data['productId'],
                                ),
                              ),
                            );
                          }
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              data['title'],
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppConstants.fontInterMedium),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        formatCurrency(data['price']),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.greyColor4),
                      ),
                      const Spacer(),
                      IconButton( // Button wishlist
                        onPressed: () =>
                            toggleWishlist(wishlistProvider, userId),
                        icon: Icon(
                          wishlistProvider.isInWishlist( // pengecekan apakah item di wishlist
                                  userId, data['productId'])
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: AppConstants.clrRed,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell( // tombol delete cart item
                        onTap: onDelete,
                        child: const Icon(
                          Icons.delete,
                          color: AppConstants.clrRed,
                        ),
                      ),
                      const Spacer(),
                      Cartquantitycounter( // pemanggilan widget quantity counter cart
                        id: data['id'],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
