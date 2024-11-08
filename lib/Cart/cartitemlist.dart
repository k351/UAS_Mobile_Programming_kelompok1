import 'package:flutter/material.dart';
import 'package:uas_flutter/Cart/cartitem.dart';
import 'package:uas_flutter/Utils.dart';

class Cartitemlist extends StatefulWidget {
  final VoidCallback cartItemListChange;
  const Cartitemlist({
    super.key,
    required this.cartItemListChange,
  });

  @override
  State<Cartitemlist> createState() => _CartitemlistState();
}

class _CartitemlistState extends State<Cartitemlist> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    cartItems = cart.map((cartItem) {
      final book = books.firstWhere((book) => book['id'] == cartItem['id']);
      return {
        'id': book['id'],
        'title': book['title'],
        'price': book['price'],
        'image': book['image'],
        'quantity': cartItem['quantity'],
        'check': cartItem['check']
      };
    }).toList();
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      cart.removeAt(index);
    });
    widget.cartItemListChange();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return Cartitem(
          data: cartItems[index],
          onDelete: () => removeItem(index),
          cartItemChange: () {
            widget.cartItemListChange();
          },
        );
      },
    );
  }
}
