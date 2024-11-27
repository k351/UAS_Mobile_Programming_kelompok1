import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';

class Cartquantitycounter extends StatefulWidget {
  final String id;
  const Cartquantitycounter({super.key, required this.id});

  @override
  _CartquantitycounterState createState() => _CartquantitycounterState();
}

class _CartquantitycounterState extends State<Cartquantitycounter> {
  Timer? _timer;
  final CartDatabaseService cartDatabaseService = CartDatabaseService();

  void _startIncreaseQuantity(String id) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      increaseQuantity(id);
    });
  }

  void _startDecreaseQuantity(String id) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      decreaseQuantity(id);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  void increaseQuantity(String id) {
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    final quantities = cartProvider.getQuantityById(id);
    if (quantities['cartQuantity']! < quantities['quantity']!) {
      cartProvider.increase(id);
      cartDatabaseService.updateCartQuantity(
          id, quantities['cartQuantity']! + 1);
    }
  }

  void decreaseQuantity(String id) {
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    final quantities = cartProvider.getQuantityById(id);
    if (quantities['cartQuantity']! > 1) {
      cartProvider.decrease(id);
      cartDatabaseService.updateCartQuantity(
          id, quantities['cartQuantity']! - 1);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    final quantities = cartProvider.getQuantityById(widget.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => decreaseQuantity(widget.id),
          onLongPress: () => _startDecreaseQuantity(widget.id),
          onLongPressUp: _stopTimer,
          child: const Icon(
            Icons.remove_circle_outline,
            size: 22,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '${quantities['cartQuantity']!}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        GestureDetector(
          onTap: () => increaseQuantity(widget.id),
          onLongPress: () => _startIncreaseQuantity(widget.id),
          onLongPressUp: _stopTimer,
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
