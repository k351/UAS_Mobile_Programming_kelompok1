import 'package:flutter/material.dart';
import 'package:uas_flutter/utils/size_config.dart';
import 'package:uas_flutter/utils/snackbar.dart';
import 'package:uas_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/Wishlist/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';
 
class DetailAppBar extends StatelessWidget {
  final String productId;
  const DetailAppBar({super.key, required this.productId});
 
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
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final isInWishlist = wishlistProvider.isInWishlist(userId, productId);
    SizeConfig.init(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 30,
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              color:
                  isInWishlist ? AppConstants.clrRed : AppConstants.greyColor,
              size: getProportionateScreenWidth(30),
            ),
            onPressed: () => toggleWishlist(context),
          ),
        ],
      ),
    );
  }
}