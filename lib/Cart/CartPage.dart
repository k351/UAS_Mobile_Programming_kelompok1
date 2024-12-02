import 'package:flutter/material.dart';
import 'package:uas_flutter/Cart/widget/cartappbar.dart';
import 'package:uas_flutter/Cart/widget/cartitemlist.dart';
import 'package:uas_flutter/Cart/widget/cartcheckout.dart';

//halaman cart page
class Cartpage extends StatelessWidget {
  //route name dari cart page
  static const String routeName = "/Cartpage";
  Cartpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //pemanggilan appbar
            Cartappbar(),
            //pemanggilan itemlist di expanded agar menyesuaikan layar user
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Cartitemlist(),
              ),
            ),
            //pemanggilan checkout
            Cartcheckout(),
          ],
        ),
      ),
    );
  }
}
