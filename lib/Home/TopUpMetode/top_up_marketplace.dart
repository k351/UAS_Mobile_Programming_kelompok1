import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class TopupsMarketplace extends StatefulWidget {
  final double initialSaldo;

  const TopupsMarketplace(
      {super.key, required this.initialSaldo}); 

  @override
  TopupsMarketplaceState createState() => TopupsMarketplaceState();
}

class TopupsMarketplaceState extends State<TopupsMarketplace> {
  late double saldo;
  String error = "";
  final TextEditingController _topupController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    saldo =widget.initialSaldo; 
    _getUserSaldo();
  }

  // Ambil user saldo di firebase
  Future<void> _getUserSaldo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userEmail = user.email!;
      DocumentSnapshot userSaldoDoc = await FirebaseFirestore.instance
          .collection('saldo')
          .doc(userEmail)
          .get();

      if (userSaldoDoc.exists) {
        setState(() {
          saldo = userSaldoDoc['saldo'];
        });
      } else {
        setState(() {
          saldo =
              0;
        });
      }
    }
  }

  // Top up saldo
  Future<void> _topUpSaldo() async {
    try {
      final double topUpAmount = double.parse(_topupController.text);

      if (topUpAmount >= 3000) {
        setState(() {
          saldo += topUpAmount - 2500; 
          error = "";
        });
        _topupController.clear();

        // Update saldo di firebase
        await FirebaseFirestore.instance
            .collection('saldo') // nama database di firebase
            .doc(userEmail) // user emailnya
            .set({
          'saldo': saldo, // nama saldo isi saldo 
        }, SetOptions(merge: true)); // disatuin

        Navigator.pop(context, saldo); 
      } else {
        setState(() {
          error = "Minimum charge is Rp3000!!!";
        });
      }
    } catch (e) {
      setState(() {
        error = "Enter a valid number!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Top Up",
          style: TextStyle(fontFamily: AppConstants.fontInterRegular),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Your saldo: Rp${saldo.toStringAsFixed(0)}",
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(15),
                      fontWeight: FontWeight.w500,
                      fontFamily: AppConstants.fontInterBold),
                ),
              ],
            ),
            SizedBox(
              width: getProportionateScreenWidth(378),
              height: getProportionateScreenHeight(1),
              child: const DecoratedBox(
                decoration: BoxDecoration(color: AppConstants.greyColor),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(12)),
            Row(
              children: [
                Text(
                  "Nominal Top Up",
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(24),
                      fontWeight: FontWeight.w600,
                      color: AppConstants.greyColor,
                      fontFamily: AppConstants.fontInterRegular),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(9)),
            Row(
              children: [
                Text(
                  "Rp",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: getProportionateScreenWidth(25),
                      fontFamily: AppConstants.fontInterRegular),
                ),
                SizedBox(width: getProportionateScreenWidth(12)),
                Expanded(
                  child: TextFormField(
                    controller: _topupController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter nominal",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppConstants.clrBlue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(12)),
            Row(
              children: [
                Text(
                  "+ Rp2.500 cost top up",
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(18),
                      color: AppConstants.greyColor,
                      fontFamily: AppConstants.fontInterRegular),
                ),
              ],
            ),
            SizedBox(
              height: getProportionateScreenHeight(5),
            ),
            Row(
              children: [
                Text(
                  error,
                  style: TextStyle(
                      color: AppConstants.clrRed,
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.fontInterBold),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(7)),
            ElevatedButton(
              onPressed: _topUpSaldo,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.clrBlue),
              child: const Text(
                "Confirmation Top Up",
                style: TextStyle(
                    color: AppConstants.clrAppBar,
                    fontFamily: AppConstants.fontInterRegular),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
