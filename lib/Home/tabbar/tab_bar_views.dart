import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/product_detail_screen.dart';
// import 'package:uas_flutter/products/models/product.dart';
// import 'package:uas_flutter/products/product_detail_screen.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';

class IsiTabs extends StatelessWidget {
  const IsiTabs({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ProductDatabaseService().fetchProductsWithId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products available'));
        }
        List<Map<String, dynamic>> products = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3,
            childAspectRatio: getProportionateScreenHeight(0.74),
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            String productId = products[index]['id'];
            Product product = products[index]['product'];
            return ItemTabs(product: product, productId: productId);
          },
        );
      },
    );
  }
}

class ItemTabs extends StatelessWidget {
  final Product product;
  final String productId;
  const ItemTabs({super.key, required this.product, required this.productId});

  Future<void> addCartItemToCart(BuildContext context) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final cartDatabaseService = CartDatabaseService(
        productDatabase: ProductDatabaseService(),
      );
      await cartDatabaseService.addCartItemToCart(userId, productId, 1);
      print('Item added to cart successfully');
    } catch (e) {
      print('Failed to add item to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppConstants.clrBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 2,
              offset: const Offset(0, 0),
              color: AppConstants.clrBlack.withOpacity(0.3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: getProportionateScreenHeight(110),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage(product.image),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(12)),
              Text(
                product.title,
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(17),
                    fontWeight: FontWeight.bold,
                    fontFamily: AppConstants.fontInterRegular),
              ),
              SizedBox(height: getProportionateScreenHeight(7)),
              Row(
                children: [
                  Icon(Icons.star,
                      size: getProportionateScreenWidth(20),
                      color: AppConstants.star),
                  Text(
                    product.rate.toString(),
                    style: TextStyle(
                        fontSize: getProportionateScreenWidth(14),
                        fontFamily: AppConstants.fontInterRegular),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    height: getProportionateScreenHeight(34),
                    width: getProportionateScreenWidth(130),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppConstants.mainColor,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Open",
                      style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          color: AppConstants.clrBackground,
                          fontFamily: AppConstants.fontInterRegular),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () => addCartItemToCart(context),
                    child: Container(
                      height: getProportionateScreenHeight(34),
                      width: getProportionateScreenWidth(34),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppConstants.mainColor,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.grey[100],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
