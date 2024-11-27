import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/Cart/CartQuantityCounter.dart';
import 'package:uas_flutter/Cart/cartcheckbox.dart';
import 'package:uas_flutter/products/product_detail_screen.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';

class Cartitem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;

  const Cartitem({
    super.key,
    required this.data,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          subtitle: Container(
            height: 110,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Cartcheckbox(
                  checkbox: {
                    'id': data['id'],
                    'check': data['check'],
                    'cartQuantity': data['cartQuantity'],
                    'price': data['price'],
                  },
                ),
                Container(
                  height: 70,
                  width: 70,
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    data['image'],
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
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
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        formatCurrency(data['price']),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      const Spacer(),
                      const Icon(
                        CupertinoIcons.heart_fill,
                        color: Colors.grey,
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
                      InkWell(
                        onTap: onDelete,
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      Spacer(),
                      Cartquantitycounter(
                        counterData: {
                          'id': data['id'],
                          'cartQuantity': data['cartQuantity'],
                          'price': data['price'],
                        },
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
