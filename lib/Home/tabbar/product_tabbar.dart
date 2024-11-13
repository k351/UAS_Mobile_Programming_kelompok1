import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/tabbar/tab_bar_views.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:uas_flutter/size_config.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 9,
            mainAxisSpacing: 12,
            childAspectRatio: getProportionateScreenHeight(0.75),
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

class IsiCategory extends StatelessWidget {
  final String category;
  const IsiCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ProductDatabaseService().fetchProductsByCategory(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
              child: Text('No products available in this category'));
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
