import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/TopUpMetode/top_up_bank.dart';
import 'package:uas_flutter/Home/TopUpMetode/top_up_marketplace.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class MethodTopUps extends StatelessWidget {
  final double initialSaldo;

  const MethodTopUps({super.key, required this.initialSaldo});

  // Navigasi ke halaman Top Up Banks
  Future<void> _navigateToTopUpBanks(BuildContext context) async {
    final updatedSaldo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopUpBanks(initialSaldo: initialSaldo),
      ),
    );

    if (updatedSaldo != null && context.mounted) {
      Navigator.pop(context, updatedSaldo);
    }
  }

  // Navigasi ke halaman Top Up Indomaret
  Future<void> _navigateToTopUpIndomaret(BuildContext context) async {
    final updatedSaldo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopupsMarketplace(initialSaldo: initialSaldo),
      ),
    );

    if (updatedSaldo != null && context.mounted) {
      Navigator.pop(context, updatedSaldo);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Top Up",style: TextStyle(fontFamily: AppConstants.fontInterRegular),),
      ),
      backgroundColor: AppConstants.greyColor1,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Payment Method",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(19),
                fontWeight: FontWeight.w600,
                fontFamily: AppConstants.fontInterRegular,
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            // Pilihan Top Up Bank
            Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppConstants.clrBackground,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.greyColor1.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _navigateToTopUpBanks(context),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.credit_card),
                                SizedBox(width: getProportionateScreenWidth(12)),
                                Text(
                                  "Bank Transfer",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(14),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppConstants.fontInterRegular,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.navigate_next),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getProportionateScreenHeight(15)),
            // Pilihan Top Up Indomaret
            Row(
              children: [
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppConstants.clrBackground,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppConstants.greyColor1.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () => _navigateToTopUpIndomaret(context),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.store),
                                SizedBox(width: getProportionateScreenWidth(12)),
                                Text(
                                  "Market Place",
                                  style: TextStyle(
                                    fontSize: getProportionateScreenWidth(14),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppConstants.fontInterRegular,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(Icons.navigate_next),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
