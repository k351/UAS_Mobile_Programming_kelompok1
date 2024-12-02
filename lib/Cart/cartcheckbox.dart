import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';

class Cartcheckbox extends StatefulWidget {
  final String id;
  const Cartcheckbox({
    super.key,
    required this.id,
  });

  @override
  State<Cartcheckbox> createState() => _CartcheckboxState();
}

class _CartcheckboxState extends State<Cartcheckbox> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cartprovider>(context);
    final isChecked = cartProvider.getCheckStatusById(widget.id);
    void toggleCheck() {
      cartProvider.check(widget.id, !isChecked);
      final cartDatabaseService = CartDatabaseService();
      cartDatabaseService.updateCheckStatus(widget.id, !isChecked);
    }

    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: IconButton(
        onPressed: toggleCheck,
        icon: Icon(isChecked ? Icons.check_box : Icons.check_box_outline_blank),
      ),
    );
  }
}
