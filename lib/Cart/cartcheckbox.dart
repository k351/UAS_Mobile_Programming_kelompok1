import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cartcheckbox extends StatefulWidget {
  final Map<String, dynamic> checkbox;
  final VoidCallback cartCheckBoxChange;
  const Cartcheckbox({
    super.key,
    required this.checkbox,
    required this.cartCheckBoxChange,
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
    await _firestore.collection('cartItems').doc(widget.checkbox['id']).update({
      'check': check,
    });
    widget.cartCheckBoxChange();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          toggleCheck();
        },
        child: Icon(check ? Icons.check_box : Icons.check_box_outline_blank),
      ),
    );
  }
}
