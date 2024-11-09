import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/Cart/CartQuantityCounter.dart';
import 'package:uas_flutter/Cart/cartcheckbox.dart';

class Cartitem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;
  final VoidCallback cartItemChange;

  const Cartitem({
    super.key,
    required this.data,
    required this.onDelete,
    required this.cartItemChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          subtitle: Container(
            height: 110,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Cartcheckbox(
                  checkbox: {
                    'id': data['id'],
                    'check': data['check'],
                  },
                  cartCheckBoxChange: cartItemChange,
                ),
                Container(
                  height: 70,
                  width: 70,
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    data['image'],
                    fit: BoxFit.fitHeight,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'],
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\$${data['price']}",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                          Spacer(),
                          Icon(
                            CupertinoIcons.heart_fill,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: onDelete,
                        child: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      Spacer(),
                      Cartquantitycounter(
                        counterData: {
                          'id': data['id'],
                          'cartQuantity': data['cartQuantity'],
                        },
                        quantityChange: cartItemChange,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
