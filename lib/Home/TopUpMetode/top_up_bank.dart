import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class TopUpBanks extends StatefulWidget {
  final double initialSaldo;

  const TopUpBanks({super.key, required this.initialSaldo});

  @override
  TopUpBanksState createState() => TopUpBanksState();
}

class TopUpBanksState extends State<TopUpBanks> {
  late double saldo;
  String error = "";
  final TextEditingController _topupController = TextEditingController();
  String? selectedBank;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    saldo = widget.initialSaldo;
    _getUserSaldo();
  }

  // Ambil user saldo
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
          saldo = 0; // kalau blm ada saldo 0
        });
      }
    }
  }

  // Top up saldo
  Future<void> _topUpSaldo() async {
    try {
      final double topUpAmount = double.parse(_topupController.text);

      if (selectedBank == null) {
        setState(() {
          error = "Choose the bank first!";
        });
        return;
      }

      if (topUpAmount >= 3000) {
        setState(() {
          saldo += topUpAmount - 2500;
          error = "";
        });
        _topupController.clear();

        // Update ke firebase
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

  final List<Map<String, String>> banks = [
    {'name': 'BCA', 'logo': 'assets/bank/bca.jpg'},
    {'name': 'Mandiri', 'logo': 'assets/bank/mandiri.jpg'},
    {'name': 'BNI', 'logo': 'assets/bank/bni.jpg'},
    {'name': 'BRI', 'logo': 'assets/bank/bri.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Top Up via m-Banking",
          style: TextStyle(fontFamily: AppConstants.fontInterRegular),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Saldo: Rp${saldo.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                fontWeight: FontWeight.w500,
                fontFamily: AppConstants.fontInterBold,
              ),
            ),
            const Divider(color: AppConstants.greyColor),
            SizedBox(height: getProportionateScreenHeight(12)),
            Text(
              "Choose Bank",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.fontInterRegular,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            SizedBox(
              height: getProportionateScreenHeight(105),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: banks.length,
                itemBuilder: (context, index) {
                  final bank = banks[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedBank = bank['name'];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: selectedBank == bank['name']
                            ? AppConstants.clrBlue
                            : AppConstants.clrBackground,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 2,
                            offset: const Offset(0, 0),
                            color: AppConstants.clrBlack.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            bank['logo']!,
                            width: getProportionateScreenWidth(50),
                            height: getProportionateScreenHeight(50),
                          ),
                          Text(
                            bank['name']!,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(14),
                              fontFamily: AppConstants.fontInterRegular,
                              color: selectedBank == bank['name']
                                  ? AppConstants.clrBackground
                                  : AppConstants.clrBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(12)),
            Text(
              "Nominal Top Up",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(20),
                fontWeight: FontWeight.w600,
                color: AppConstants.greyColor,
                fontFamily: AppConstants.fontInterRegular,
              ),
            ),
            Row(
              children: [
                Text(
                  "Rp",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: getProportionateScreenWidth(25),
                    fontFamily: AppConstants.fontInterRegular,
                  ),
                ),
                SizedBox(width: getProportionateScreenWidth(12)),
                Expanded(
                  child: TextFormField(
                    controller: _topupController,
                    decoration: const InputDecoration(
                      hintText: "Enter nominal",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppConstants.clrBlue),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(12)),
            Text(
              "+ Rp2.500 cost top up",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(18),
                color: AppConstants.greyColor,
                fontFamily: AppConstants.fontInterRegular,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(5)),
            Text(
              error,
              style: TextStyle(
                color: AppConstants.clrRed,
                fontSize: getProportionateScreenWidth(14),
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.fontInterBold,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            ElevatedButton(
              onPressed: _topUpSaldo,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.clrBlue,
              ),
              child: const Text(
                "Confirmation Top Up",
                style: TextStyle(
                  color: AppConstants.clrAppBar,
                  fontFamily: AppConstants.fontInterRegular,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
