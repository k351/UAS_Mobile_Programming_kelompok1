import 'package:flutter/material.dart';
import 'package:uas_flutter/Utils.dart';

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
  void toggleCheck() {
    setState(() {
      widget.checkbox['check'] = !widget.checkbox['check'];
      final index =
          cart.indexWhere((item) => item['id'] == widget.checkbox['id']);
      if (index != -1) {
        cart[index]['check'] = widget.checkbox['check'];
      }
      widget.cartCheckBoxChange();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          toggleCheck();
        },
        child: Icon(widget.checkbox['check']
            ? Icons.check_box
            : Icons.check_box_outline_blank),
      ),
    );
  }
}
