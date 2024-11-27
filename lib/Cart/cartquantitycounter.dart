import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';

class Cartquantitycounter extends StatefulWidget {
  final Map<String, dynamic> counterData;

  const Cartquantitycounter({super.key, required this.counterData});

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
          .fetchProductByCartItemId(widget.counterData['id']);
      setState(() {});
    } catch (e) {
      print("Gagal mengambil produk: $e");
    }
  }

  void increaseQuantity() {
    if (product != null && product!.quantity > 0) {
      final cartProvider = Provider.of<Cartprovider>(context, listen: false);
      setState(() {
        if (product!.quantity > quantity) {
          quantity++;
          cartProvider.increase(
              widget.counterData['id'], widget.counterData['price']);
        } else {
          quantity = product!.quantity;
        }
      });
      cartDatabaseService.updateCartQuantity(
          widget.counterData['id'], quantity);
    } else {
      print("Produk tidak ditemukan atau produk habis");
    }
  }

  void decreaseQuantity() async {
    if (product != null && quantity > 1 && product!.quantity > 0) {
      final cartProvider = Provider.of<Cartprovider>(context, listen: false);
      setState(() {
        quantity--;
        cartProvider.decrease(
            widget.counterData['id'], widget.counterData['price']);
      });
      cartDatabaseService.updateCartQuantity(
          widget.counterData['id'], quantity);
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
          child: const Icon(
            Icons.remove_circle_outline,
            size: 22,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$quantity',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: increaseQuantity,
          child: const Icon(
            Icons.add_circle_outline,
            size: 22,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
