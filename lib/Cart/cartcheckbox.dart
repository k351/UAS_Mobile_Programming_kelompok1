import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';

class Cartcheckbox extends StatefulWidget {
  final Map<String, dynamic> checkbox;
  const Cartcheckbox({
    super.key,
    required this.checkbox,
  });

  @override
  State<Cartcheckbox> createState() => _CartcheckboxState();
}

class _CartcheckboxState extends State<Cartcheckbox> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late bool check;

  @override
  void initState() {
    super.initState();
    check = widget.checkbox['check'];
  }

  void toggleCheck() async {
    setState(() {
      check = !check;
    });
    final cartProvider = Provider.of<Cartprovider>(context, listen: false);
    cartProvider.check(widget.checkbox['id'], widget.checkbox['cartQuantity'],
        widget.checkbox['price'], check);
    await _firestore.collection('cartItems').doc(widget.checkbox['id']).update({
      'check': check,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          toggleCheck();
        },
        child: Icon(check ? Icons.check_box : Icons.check_box_outline_blank),
      ),
    );
  }
}
