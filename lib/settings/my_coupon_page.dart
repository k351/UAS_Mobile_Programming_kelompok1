import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';

class MyCouponsPage extends StatelessWidget {
  const MyCouponsPage({Key? key}) : super(key: key);
  static String routeName = '/mycouponspage';

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Coupons',
          style: TextStyle(
            fontFamily: AppConstants.fontInterMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppConstants.clrBackground,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: AppConstants.mainColor.withOpacity(0.1),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text(
              'Your Active Coupons',
              style: TextStyle(
                fontSize: getProportionateScreenHeight(22),
                fontFamily: AppConstants.fontInterBold,
                color: AppConstants.clrBlackFont,
              ),
            ),
            const SizedBox(height: 16),

            CouponTile(
              title: '25%',
              description: 'Valid until: 31/12/2024',
              bannerColor: Colors.orange,
              couponType: 'DISCOUNT COUPON',
              icon: Icons.local_offer,
            ),
            const SizedBox(height: 16),

            CouponTile(
              title: 'FREE',
              description: 'Valid until: 31/12/2024',
              bannerColor: Colors.lightBlue,
              couponType: 'FREE SHIPPING',
              icon: Icons.local_shipping,
            ),
          ],
        ),
      ),
    );
  }
}

class CouponTile extends StatelessWidget {
  final String title;
  final String description;
  final Color bannerColor;
  final String couponType;
  final IconData icon;

  const CouponTile({
    Key? key,
    required this.title,
    required this.description,
    required this.bannerColor,
    required this.couponType,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [bannerColor.withOpacity(0.7), bannerColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: AppConstants.fontInterBold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  couponType,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(18),
                    fontFamily: AppConstants.fontInterBold,
                    color: AppConstants.clrBlackFont,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(14),
                    fontFamily: AppConstants.fontInterRegular,
                    color: AppConstants.greyColor5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          Icon(
            icon,
            size: getProportionateScreenHeight(30),
            color: bannerColor,
          ),
        ],
      ),
    );
  }
}
