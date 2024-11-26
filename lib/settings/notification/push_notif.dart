import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/notification/notification_page.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/settings/provider/edit_profile_provider.dart';
import 'package:provider/provider.dart';

class PushNotificationPage extends StatefulWidget {
  const PushNotificationPage({Key? key}) : super(key: key);

  static String routeName = '/pushnotificationpage';

  @override
  PushNotificationPageState createState() => PushNotificationPageState();
}

class PushNotificationPageState extends State<PushNotificationPage> {
  Map<String, bool> activityNotificationSettings = {
    "Seller's Recommendation": true,
    "Feed": true,
    "Product Discussion": true,
    "Games": true,
  };

  bool recommendationForYou = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Push Notification',
          style: TextStyle(
            fontFamily: AppConstants.fontInterMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppConstants.clrAppBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppConstants.clrBlack),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set your push notification preferences.',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(20),
                    fontFamily: AppConstants.fontInterSemiBold,
                    color: AppConstants.clrBlackFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Adjust notification settings to get relevant info.',
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: AppConstants.fontInterRegular,
                    color: AppConstants.greyColor5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppConstants.greyColor7),
          // Aktivitas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.run_circle_outlined, // Pilih ikon sesuai kebutuhan
                  color: AppConstants.mainColor, // Warna ikon
                  size: 35, // Ukuran ikon
                ),
                const SizedBox(width: 8), // Jarak antara ikon dan teks
                Text(
                  'Activity',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(20),
                    fontFamily: AppConstants.fontInterBold,
                    color: AppConstants.clrBlackFont,
                  ),
                ),
              ],
            ),
          ),
          ...activityNotificationSettings.keys.map((key) {
            return SwitchListTile(
              title: Text(
                key,
                style: const TextStyle(
                  fontFamily: AppConstants.fontInterMedium,
                  color: AppConstants.clrBlackFont,
                ),
              ),
              value: activityNotificationSettings[key]!,
              activeColor: AppConstants.mainColor,
              onChanged: (value) {
                setState(() {
                  activityNotificationSettings[key] = value;
                });
              },
            );
          }).toList(),
          const Divider(color: AppConstants.greyColor7),
          // Promo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(
                  Icons.discount_outlined, // Pilih ikon sesuai kebutuhan
                  color: AppConstants.mainColor, // Warna ikon
                  size: 30, // Ukuran ikon
                ),
                const SizedBox(width: 8), // Jarak antara ikon dan teks
                Text(
                  'Promo',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(20),
                    fontFamily: AppConstants.fontInterBold,
                    color: AppConstants.clrBlackFont,
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text(
              'Recommendation',
              style: TextStyle(
                fontFamily: AppConstants.fontInterMedium,
                color: AppConstants.clrBlackFont,
              ),
            ),
            subtitle: const Text(
              'Get exclusive promo recommendations through the application.',
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppConstants.fontInterRegular,
                color: AppConstants.greyColor5,
              ),
            ),
            value: recommendationForYou,
            activeColor: AppConstants.mainColor,
            onChanged: (value) {
              setState(() {
                recommendationForYou = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
