import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';

//widget checkbox pada setiap item cart
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
    //Pemanggilan provider
    final cartProvider = Provider.of<Cartprovider>(context);
    //Boolean pengecek apakah checkbox menyala atau mati
    final isChecked = cartProvider.getCheckStatusById(widget.id);

    //fungsi menyala matikan checkbox
    void toggleCheck() {
      cartProvider.check(widget.id, !isChecked);
      final CartDatabaseService cartDatabaseService = CartDatabaseService();
      cartDatabaseService.updateCheckStatus(widget.id, !isChecked);
    }

    return Container(
      margin: const EdgeInsets.only(right: 5),
      //Icon checkbox
      child: IconButton(
        //Pemanggilan fungsi untuk mengangti state checkbox
        onPressed: toggleCheck,
        //Pengecekan checkbox menyala atau mati
        icon: Icon(isChecked ? Icons.check_box : Icons.check_box_outline_blank),
      ),
    );
  }
}
