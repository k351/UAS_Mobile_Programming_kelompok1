import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';
import 'package:uas_flutter/utils/snackbar.dart';

class TopupsMarketplace extends StatefulWidget {
  final double initialSaldo;

  const TopupsMarketplace({super.key, required this.initialSaldo});

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
    saldo = widget.initialSaldo;
    _getUserSaldo();
  }

  Future<void> _getUserSaldo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userEmail = user.email!;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          final dynamic saldoData =
              (userDoc.data() as Map<String, dynamic>)['saldo'];
          saldo = (saldoData is int) ? saldoData.toDouble() : saldoData ?? 0.0;
        });
      } else {
        setState(() {
          saldo = 0.0;
        });

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'saldo': saldo,
        });
      }
    }
  }

  Future<void> _topUpSaldo() async {
    try {
      final double topUpAmount = double.parse(_topupController.text);

      if (topUpAmount >= 3000) {
        setState(() {
          saldo += topUpAmount - 2500;
          error = "";
        });
        _topupController.clear();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'saldo': saldo.toDouble(),
        });

        SnackbarUtils.showSnackbar(
          context,
          'Balance has been added to your account',
          backgroundColor: AppConstants.clrBlue,
        );

        Navigator.pop(context, saldo);
      } else {
        setState(() {
          error = "Minimum charge is Rp3000!";
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          "Top Up Marketplace",
          style: TextStyle(
            fontFamily: AppConstants.fontInterBold,
            color: Colors.black87,
            fontSize: getProportionateScreenWidth(18),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                decoration: BoxDecoration(
                  color: AppConstants.clrBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Balance",
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(16),
                        color: AppConstants.clrBlack.withOpacity(0.7),
                        fontFamily: AppConstants.fontInterRegular,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    Text(
                      formatCurrency(saldo),
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        fontWeight: FontWeight.w700,
                        fontFamily: AppConstants.fontInterBold,
                        color: AppConstants.clrBlue,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                "Top Up Amount",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(16),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: AppConstants.fontInterRegular,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: getProportionateScreenWidth(15),
                        right: getProportionateScreenWidth(10),
                      ),
                      child: Text(
                        "Rp",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: getProportionateScreenWidth(20),
                          fontFamily: AppConstants.fontInterRegular,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _topupController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(16),
                          fontFamily: AppConstants.fontInterRegular,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Enter amount",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: AppConstants.fontInterRegular,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Text(
                "+ Rp2.500 top up fee",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(14),
                  color: Colors.grey,
                  fontFamily: AppConstants.fontInterRegular,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              if (error.isNotEmpty)
                Text(
                  error,
                  style: TextStyle(
                    color: AppConstants.clrRed,
                    fontSize: getProportionateScreenWidth(14),
                    fontWeight: FontWeight.w600,
                    fontFamily: AppConstants.fontInterBold,
                  ),
                ),
              SizedBox(height: getProportionateScreenHeight(20)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _topUpSaldo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.clrBlue,
                    padding: EdgeInsets.symmetric(
                      vertical: getProportionateScreenHeight(15),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    "Confirm Top Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: getProportionateScreenWidth(16),
                      fontFamily: AppConstants.fontInterBold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
