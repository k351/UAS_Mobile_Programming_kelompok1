import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/Checkout/checkout_page.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';

class Cartcheckout extends StatefulWidget {
  const Cartcheckout({super.key});

  @override
  State<Cartcheckout> createState() => CartcheckoutState();
}

class CartcheckoutState extends State<Cartcheckout> {
  final CartDatabaseService cartDatabaseService = CartDatabaseService();
  num total = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cartprovider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                      color: AppConstants.greyColor3,
                      fontSize: 14,
                      fontFamily: AppConstants.fontInterMedium,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  formatCurrency(cartProvider.total),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              if (cartProvider.checkedItems.isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  CheckoutPage.routeName,
                );
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppConstants.clrBlue,
              ),
              child: const Text(
                "Checkout",
                style: TextStyle(
                  color: AppConstants.clrBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
