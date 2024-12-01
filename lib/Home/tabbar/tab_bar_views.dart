import 'package:flutter/material.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';
import 'package:uas_flutter/utils/snackbar.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/product_detail_screen.dart';
import 'package:uas_flutter/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/Wishlist/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class ItemTabs extends StatelessWidget {
  final Product product;
  final String productId;

  const ItemTabs({super.key, required this.product, required this.productId});

  Future<void> addCartItemToCart(BuildContext context) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final cartDatabaseService = CartDatabaseService();
      final cartProvider = Provider.of<Cartprovider>(context, listen: false);
      final message =
          await cartDatabaseService.addCartItemToCart(userId, productId, 1);
      if (message != "Stock limit Reached") {
        cartProvider.increaseCartQuantity(1);
      }

      SnackbarUtils.showSnackbar(
        context,
        message,
      );
    } catch (e) {
      SnackbarUtils.showSnackbar(
        context,
        'Failed to add item to cart',
        backgroundColor: AppConstants.clrRed,
      );
    }
  }

  Future<void> toggleWishlist(BuildContext context) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final wishlistProvider =
          Provider.of<WishlistProvider>(context, listen: false);

      if (wishlistProvider.isInWishlist(userId, productId)) {
        await wishlistProvider.removeFromWishlist(userId, productId);
        SnackbarUtils.showSnackbar(
          context,
          'Removed from wishlist',
        );
      } else {
        await wishlistProvider.addToWishlist(userId, productId);
        SnackbarUtils.showSnackbar(
          context,
          'Added to wishlist',
        );
      }
    } catch (e) {
      SnackbarUtils.showSnackbar(
        context,
        'Failed to update wishlist',
        backgroundColor: AppConstants.clrRed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isInWishlist = wishlistProvider.isInWishlist(userId, productId);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(product: product, productId: productId),
          ),
        );
      },
      child: Container(
        width: getProportionateScreenWidth(160),
        margin: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(8),
            horizontal: getProportionateScreenWidth(4)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wishlist Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  isInWishlist ? Icons.favorite : Icons.favorite_border,
                  color: isInWishlist
                      ? AppConstants.clrRed
                      : AppConstants.greyColor,
                  size: getProportionateScreenWidth(20),
                ),
                onPressed: () => toggleWishlist(context),
              ),
            ),

            // Product Image
            Center(
              child: Container(
                height: getProportionateScreenHeight(75),
                width: getProportionateScreenWidth(90),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(product.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // Product Details
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Title
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: getProportionateScreenHeight(3)),

                  // Rating
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: 12,
                          color: AppConstants.clrBlue.withOpacity(0.8),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rate.toString(),
                          style: TextStyle(
                            color: AppConstants.clrBlue.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Price and Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatCurrency(product.price),
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(14),
                          fontWeight: FontWeight.bold,
                          color: AppConstants.mainColor,
                        ),
                      ),
                      InkWell(
                        onTap: () => addCartItemToCart(context),
                        child: Container(
                          height: getProportionateScreenHeight(30),
                          width: getProportionateScreenWidth(30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppConstants.mainColor,
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: getProportionateScreenWidth(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
