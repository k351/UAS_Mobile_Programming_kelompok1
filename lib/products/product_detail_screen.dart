import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/products/widget/image_slider.dart';
import 'package:uas_flutter/products/widget/product_detail_appbar.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/utils/size_config.dart';
import 'package:uas_flutter/products/widget/product_category_tag.dart';
import 'package:uas_flutter/products/widget/product_title_price.dart';
import 'package:uas_flutter/products/widget/product_rating_stock.dart';
import 'package:uas_flutter/products/widget/product_description.dart';
import 'package:uas_flutter/products/widget/add_to_cart_button.dart';
import 'package:uas_flutter/utils/snackbar.dart';

class DetailScreen extends StatefulWidget {
  static const String routeName = 'details';
  final Product product;
  final String productId;
  const DetailScreen(
      {super.key, required this.product, required this.productId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int currentImage = 0;
  int quantity = 1;
  bool _isProcessing = false;
  final CartDatabaseService cartDatabaseService = CartDatabaseService();

  // Fungsi future untuk menambahkan item ke cart
  Future<void> addCartItemToCart(BuildContext context) async {
    // Mengecek apakah fungsi ini udah dipanggil dan selesai sebelumnya
    if (_isProcessing) return;
    _isProcessing = true;
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final cartDatabaseService = CartDatabaseService();
      final cartProvider = Provider.of<Cartprovider>(context, listen: false);

      // Memasukan item atau menaikan quantity ke database
      final message = await cartDatabaseService.addCartItemToCart(
          userId, widget.productId, quantity);
      //Menaikan counter apabila batas product belom tercapai
      if (message != "Stock limit Reached" ||
          message.startsWith("Updated cart until stock limit")) {
        if (message.startsWith("Updated cart until stock limit")) {
          int quantityadded = int.parse(message.split(' ').last);
          cartProvider.increaseCartQuantity(quantityadded);
        } else {
          cartProvider.increaseCartQuantity(1);
        }
      }
      SnackbarUtils.showSnackbar(context, message);
    } catch (e) {
      SnackbarUtils.showSnackbar(context, 'Failed to add item to cart',
          backgroundColor: AppConstants.clrRed);
    } finally {
      _isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailAppBar(productId: widget.productId),
                    ImageSlider(
                      onChange: (index) {
                        setState(() {
                          if (index <= 5) {
                            currentImage = index % 5;
                          }
                        });
                      },
                      image: widget.product.image,
                    ),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    ProductImageIndicators(currentImage: currentImage),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductCategoryTag(category: widget.product.category),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          ProductTitlePrice(
                            title: widget.product.title,
                            price: widget.product.price.toDouble(),
                          ),
                          SizedBox(height: getProportionateScreenHeight(15)),
                          ProductRatingStock(
                            rating: widget.product.rate.toDouble(),
                            stock: widget.product.quantity,
                          ),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          ProductDescription(
                              description: widget.product.description),
                          SizedBox(height: getProportionateScreenHeight(20)),
                          Row(
                            children: [
                              const Text(
                                "Quantity:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (quantity > 1) {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      },
                                    ),
                                    Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        if (quantity <
                                            widget.product.quantity) {
                                          setState(() {
                                            quantity++;
                                          });
                                        }
                                      },
                                    ),
                                  ],
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
            ),
            AddToCartButton(
              onPressed: () {
                addCartItemToCart(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
