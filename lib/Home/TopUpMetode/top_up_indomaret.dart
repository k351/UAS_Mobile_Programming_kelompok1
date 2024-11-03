import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class TopupsIndomaret extends StatefulWidget {
  final double initialSaldo;

  const TopupsIndomaret({super.key, required this.initialSaldo});
  @override
  TopupsState createState() => TopupsState();
}

class TopupsState extends State<TopupsIndomaret> {
  late double saldo;

  @override
  void initState() {
    super.initState();
    saldo = widget.initialSaldo;
  }

  String error = "";
  final TextEditingController _topupController = TextEditingController();

  void _topUpSaldo() {
    try {
      final double topUpAmount = double.parse(_topupController.text);

      if (topUpAmount >= 3000) {
        setState(() {
          saldo += topUpAmount - 2500;
          error = "";
        });
        _topupController.clear();

        Navigator.pop(context, saldo);
      } else {
        setState(() {
          error = "Minimum pengisian 3000!!!";
        });
      }
    } catch (e) {
      setState(() {
        error = "Masukkan angka yang valid!";
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
                  "Duit anda sekarang: Rp${saldo.toStringAsFixed(0)}",
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
                    decoration: const InputDecoration(
                      hintText: "Masukkan nominal",
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
                  "+ Rp2.500 biaya top up",
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
                "Top Up",
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
