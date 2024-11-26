import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/notification/notification_page.dart';
import 'package:uas_flutter/size_config.dart';
import 'package:uas_flutter/settings/provider/edit_profile_provider.dart';
import 'package:provider/provider.dart';

class EmailNotificationPage extends StatefulWidget {
  const EmailNotificationPage({Key? key}) : super(key: key);

  static String routeName = '/emailnotificationpage';

  @override
  EmailNotificationPageState createState() => EmailNotificationPageState();
}

class EmailNotificationPageState extends State<EmailNotificationPage> {
  Map<String, bool> activityNotificationSettings = {
    "Waiting For Payment": true,
    "Waiting For Confirmation": true,
    "Order In-Progress": true,
    "Order Sent": true,
    "Order Completeted": true,
  };

  bool recommendationForYou = true;

  @override
  Widget build(BuildContext context) {
    // Ambil profil pengguna dari EditProfileProvider
    final provider = Provider.of<EditProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'E-mail Notification',
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
                  'Notification will be sent to:',
                  style: TextStyle(
                    fontSize: getProportionateScreenHeight(15),
                    fontFamily: AppConstants.fontInterSemiBold,
                    color: AppConstants.clrBlackFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  // Menampilkan email pengguna
                  '${provider.profile?.email ?? 'No Email'}',
                  style: const TextStyle(
                    fontSize: 15,
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
                  Icons.shopping_cart_sharp, // Ikon untuk aktivitas
                  color: AppConstants.mainColor, // Warna ikon
                  size: 30, // Ukuran ikon
                ),
                const SizedBox(width: 8), // Jarak antara ikon dan teks
                Text(
                  'Transactions',
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
                  Icons.info_outline_rounded, // Ikon untuk promo
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
              'Get exclusive promo recommendations through email message',
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
