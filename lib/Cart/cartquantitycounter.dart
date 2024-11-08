import 'package:flutter/material.dart';
import 'package:uas_flutter/Utils.dart';

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

  @override
  void initState() {
    super.initState();
    quantity = widget.counterData['quantity'];
  }

  void updatingUtils(int newQuantity) {
    int index =
        cart.indexWhere((item) => item['id'] == widget.counterData['id']);
    if (index != -1) {
      cart[index]['quantity'] = newQuantity;
    }
  }

  void increaseQuantity() {
    setState(() {
      quantity += 1;
      updatingUtils(quantity);
      widget.quantityChange();
    });
  }

  void decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity -= 1;
        updatingUtils(quantity);
        widget.quantityChange();
      });
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
