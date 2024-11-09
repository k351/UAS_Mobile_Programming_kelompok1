import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_flutter/Cart/cartitem.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';

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
final CartDatabaseService cartDatabaseService =
      CartDatabaseService(productDatabase: ProductDatabaseService());

  List<Map<String, dynamic>> cartItems = []; 

  @override
  void initState() {
    super.initState();
    _fetchCartItems(); 
  }

  Future<void> _fetchCartItems() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      List<Map<String, dynamic>> items = await cartDatabaseService.fetchCartItemsWithProductDetails(userId);
      setState(() {
        cartItems = items; 
      });
    }
  }

  Future<void> removeItem(String cartItemId) async {
    await cartDatabaseService.removeCartItem(cartItemId);
    await _fetchCartItems(); 
    widget.cartItemListChange();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        return Cartitem(
          data: cartItems[index],
          onDelete: () => removeItem(cartItems[index]['id']),
          cartItemChange: () {
            widget.cartItemListChange();
            _fetchCartItems();
          },
        );
      },
    );
  }
}
