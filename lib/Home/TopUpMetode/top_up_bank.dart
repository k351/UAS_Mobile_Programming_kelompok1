import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/utils/currency_formatter.dart';
import 'package:uas_flutter/utils/snackbar.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';

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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          // Mengambil saldo dengan nilai default 0.0 dan konversi ke double
          final dynamic saldoData =
              (userDoc.data() as Map<String, dynamic>)['saldo'];
          saldo = (saldoData is int) ? saldoData.toDouble() : saldoData ?? 0.0;
        });
      } else {
        // Inisialisasi saldo kalau belum terisi 0
        setState(() {
          saldo = 0.0;
        });

        // Buat saldo di users
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'saldo': saldo,
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

        // Update saldo ke firestore
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
      backgroundColor: AppConstants.clrBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Top Up M-Banking",
          style: TextStyle(
            fontFamily: AppConstants.fontInterBold,
            color: AppConstants.clrBlack,
            fontSize: getProportionateScreenWidth(20),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppConstants.clrBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenHeight(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Saldo Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(getProportionateScreenWidth(15)),
                decoration: BoxDecoration(
                  color: AppConstants.clrBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
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

              // Bank Selection
              Text(
                "Choose Bank",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.fontInterRegular,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              SizedBox(
                height: getProportionateScreenHeight(110),
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
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: selectedBank == bank['name']
                              ? AppConstants.clrBlue
                              : AppConstants.clrBackground,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                              color: AppConstants.clrBlack.withOpacity(0.1),
                            ),
                          ],
                          border: Border.all(
                            color: selectedBank == bank['name']
                                ? Colors.transparent
                                : AppConstants.greyColor.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              bank['logo']!,
                              width: getProportionateScreenWidth(60),
                              height: getProportionateScreenHeight(55),
                              fit: BoxFit.contain,
                            ),
                            SizedBox(height: getProportionateScreenHeight(8)),
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

              SizedBox(height: getProportionateScreenHeight(20)),

              // Top Up Amount
              Text(
                "Top Up Amount",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.w600,
                  color: AppConstants.clrBlack,
                  fontFamily: AppConstants.fontInterRegular,
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(10)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(15),
                  vertical: getProportionateScreenHeight(5),
                ),
                decoration: BoxDecoration(
                  color: AppConstants.clrBackground,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: AppConstants.greyColor.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "Rp",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: getProportionateScreenWidth(22),
                        fontFamily: AppConstants.fontInterRegular,
                      ),
                    ),
                    SizedBox(width: getProportionateScreenWidth(12)),
                    Expanded(
                      child: TextFormField(
                        controller: _topupController,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                          fontFamily: AppConstants.fontInterRegular,
                        ),
                        decoration: const InputDecoration(
                          hintText: "Enter amount",
                          hintStyle: TextStyle(
                            color: AppConstants.greyColor,
                            fontFamily: AppConstants.fontInterRegular,
                          ),
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.number,
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
                  color: AppConstants.greyColor,
                  fontFamily: AppConstants.fontInterRegular,
                ),
              ),

              // Error Text
              if (error.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(
                    top: getProportionateScreenHeight(10),
                  ),
                  child: Text(
                    error,
                    style: TextStyle(
                      color: AppConstants.clrRed,
                      fontSize: getProportionateScreenWidth(14),
                      fontWeight: FontWeight.w600,
                      fontFamily: AppConstants.fontInterBold,
                    ),
                  ),
                ),

              SizedBox(height: getProportionateScreenHeight(20)),

              // Confirmation Button
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "Confirm Top Up",
                    style: TextStyle(
                      color: AppConstants.clrBackground,
                      fontFamily: AppConstants.fontInterBold,
                      fontSize: getProportionateScreenWidth(16),
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
