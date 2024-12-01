import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/cartitem.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';

class Cartitemlist extends StatefulWidget {
  const Cartitemlist({
    super.key,
  });

  @override
  State<Cartitemlist> createState() => _CartitemlistState();
}

class _CartitemlistState extends State<Cartitemlist> {
  final CartDatabaseService cartDatabaseService = CartDatabaseService();

  late Future<void> _cartItemsFuture;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      List<Map<String, dynamic>> items =
          await cartDatabaseService.initializeCartItems(userId);
      final cartProvider = Provider.of<Cartprovider>(context, listen: false);
      cartProvider.setCartItems(items);
      cartProvider.calculateTotal();
    }
  }

  Future<void> removeItem(String cartItemId) async {
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    cartProvider.removeItem(cartItemId);
    await cartDatabaseService.removeCartItem(cartItemId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cartItemsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else {
          return Consumer<Cartprovider>(
            builder: (context, cartProvider, child) {
              final cartItems = cartProvider.cartItems;
              if (cartItems.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.remove_shopping_cart,
                        size: 100,
                        color: AppConstants.clrBackground,
                      ),
                      SizedBox(height: getProportionateScreenHeight(8)),
                      const Text(
                        "Your cart is empty",
                        style: TextStyle(
                          fontFamily: AppConstants.fontInterMedium,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.greyColor3,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return Cartitem(
                    data: cartItems[index],
                    onDelete: () {
                      removeItem(cartItems[index]['id']);
                    },
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
