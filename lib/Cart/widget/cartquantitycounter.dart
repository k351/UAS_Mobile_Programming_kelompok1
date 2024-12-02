import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/constants.dart';

//widget counter pada cart
class Cartquantitycounter extends StatefulWidget {
  final String id;
  const Cartquantitycounter({super.key, required this.id});

  @override
  _CartquantitycounterState createState() => _CartquantitycounterState();
}

class _CartquantitycounterState extends State<Cartquantitycounter> {
  //inisiasi variabel timer
  Timer? _timer;
  //inisiasi database service cart
  final CartDatabaseService cartDatabaseService = CartDatabaseService();

  //Fungsi menaikan quantity item ketika di hold
  void _startIncreaseQuantity(String id) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      increaseQuantity(id);
    });
  }

//Fungsi mengurangi quantity item ketika di hold
  void _startDecreaseQuantity(String id) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      decreaseQuantity(id);
    });
  }

  //fungsi mematikan timer
  void _stopTimer() {
    _timer?.cancel();
  }

  //fungsi menaikan quantity item
  void increaseQuantity(String id) {
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    final quantities = cartProvider.getQuantityById(id);
    if (quantities['cartQuantity']! < quantities['quantity']!) {
      cartProvider.increase(id);
      cartDatabaseService.updateCartQuantity(
          id, quantities['cartQuantity']! + 1);
      cartProvider.increaseCartQuantity(1);
    }
  }

  // fungsi menuruni quantity item
  void decreaseQuantity(String id) {
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    final quantities = cartProvider.getQuantityById(id);
    if (quantities['cartQuantity']! > 1) {
      cartProvider.decrease(id);
      cartDatabaseService.updateCartQuantity(
          id, quantities['cartQuantity']! - 1);
      cartProvider.decreaseCartQuantity(1);
    }
  }

  //fungsi dispose untuk menghancurkan timer secara benar
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //inisiasi provider cart dan mendapatkan quantitiesnya
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    final quantities = cartProvider.getQuantityById(widget.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //button decrease cart quantity counter
        GestureDetector(
          //decrease quantity item setiap kali di klik
          onTap: () => decreaseQuantity(widget.id),
          //decrease quantity item setiap 0,1 detik di hold
          onLongPress: () => _startDecreaseQuantity(widget.id),
          //mematikan timer fungsi hold bila hold dilepas
          onLongPressUp: _stopTimer,
          child: const Icon(
            Icons.remove_circle_outline,
            size: 22,
            color: AppConstants.greyColor3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${quantities['cartQuantity']!}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        //button increase cart quantity counter
        GestureDetector(
          //increase quantity item setiap kali di klik
          onTap: () => increaseQuantity(widget.id),
          //increase quantity item setiap 0,1 detik di hold
          onLongPress: () => _startIncreaseQuantity(widget.id),
          //mematikan timer fungsi hold bila hold dilepas
          onLongPressUp: _stopTimer,
          child: const Icon(
            Icons.add_circle_outline,
            size: 22,
            color: AppConstants.greyColor3,
          ),
        ),
      ],
    );
  }
}
