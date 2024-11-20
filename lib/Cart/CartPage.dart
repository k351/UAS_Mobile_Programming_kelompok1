import 'package:flutter/material.dart';
import 'package:uas_flutter/Cart/cartappbar.dart';
import 'package:uas_flutter/Cart/cartitemlist.dart';
import 'package:uas_flutter/Cart/cartcheckout.dart';

class Cartpage extends StatelessWidget {
  static const String routeName = "/Cartpage";
  Cartpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Cartappbar(),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: Cartitemlist(),
              ),
            ),
            Cartcheckout(),
          ],
        ),
      ),
    );
  }
}
