import 'package:flutter/material.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';

class Cartquantitycounter extends StatefulWidget {
  final Map<String, dynamic> counterData;
  final VoidCallback quantityChange;

  const Cartquantitycounter(
      {super.key, required this.counterData, required this.quantityChange});

  @override
  _CartquantitycounterState createState() => _CartquantitycounterState();
}

class _CartquantitycounterState extends State<Cartquantitycounter> {
  late int quantity;
  Product? product;
  final CartDatabaseService cartDatabaseService =
      CartDatabaseService(productDatabase: ProductDatabaseService());

  @override
  void initState() {
    super.initState();
    quantity = widget.counterData['cartQuantity'];
    _initializeProduct();
  }

  Future<void> _initializeProduct() async {
    try {
      product = await cartDatabaseService
          .fetchProductByCartId(widget.counterData['id']);
      setState(() {});
    } catch (e) {
      print("Gagal mengambil produk: $e");
    }
  }

  void increaseQuantity() {
    if (product != null && product!.quantity > 0) {
      setState(() {
        if (product!.quantity > quantity) {
          quantity++;
        } else {
          quantity = product!.quantity;
        }
      });
      cartDatabaseService.updateCartQuantity(
          widget.counterData['id'], quantity);
      widget.quantityChange();
    } else {
      print("Produk tidak ditemukan atau produk habis");
    }
  }

  void decreaseQuantity() async {
    if (product != null && quantity > 1 && product!.quantity > 0) {
      setState(() {
        quantity--;
      });
      cartDatabaseService.updateCartQuantity(
          widget.counterData['id'], quantity);
      widget.quantityChange();
    } else {
      print("Produk tidak ditemukan atau produk habis");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: decreaseQuantity,
          child: Icon(
            Icons.remove_circle_outline,
            size: 22,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$quantity',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: increaseQuantity,
          child: Icon(
            Icons.add_circle_outline,
            size: 22,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
