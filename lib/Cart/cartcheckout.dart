import 'package:flutter/material.dart';
import 'package:uas_flutter/Utils.dart';

class Cartcheckout extends StatefulWidget {
  const Cartcheckout({super.key});

  @override
  State<Cartcheckout> createState() => CartcheckoutState();
}

class CartcheckoutState extends State<Cartcheckout> {
  num total = 0;
  @override
  void initState() {
    super.initState();
    calculateTotal();
  }

  void calculateTotal() {
    total = cart.where((cartItem) => cartItem['check'] == true).fold(
      0,
      (sum, cartItem) {
        final book = books.firstWhere(
          (book) => book['id'] == cartItem['id'],
        );
        return sum + (book != null ? book['price'] * cartItem['quantity'] : 0);
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  total.toStringAsFixed(2),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.blue,
              ),
              child: Text(
                "Checkout",
                style: TextStyle(
                  color: Colors.white,
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
