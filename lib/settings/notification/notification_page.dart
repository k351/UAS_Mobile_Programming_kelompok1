import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/notification/email_notif.dart';
import 'package:uas_flutter/settings/notification/push_notif.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  static String routeName = '/notificationpage';

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notification',
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
          // Deskripsi halaman
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Set how you receive shopping and activity notifications in this application.',
              style: TextStyle(
                fontSize: 14,
                fontFamily: AppConstants.fontInterRegular,
                color: AppConstants.greyColor5,
              ),
            ),
          ),
          // Push Notification
          ListTile(
            leading:
                const Icon(Icons.notifications, color: AppConstants.mainColor),
            title: const Text(
              'Push Notification',
              style: TextStyle(
                fontFamily: AppConstants.fontInterMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppConstants.greyColor5),
            onTap: () {
              Navigator.pushNamed(context, PushNotificationPage.routeName);
            },
          ),
          const Divider(color: AppConstants.greyColor7),
          // Email
          ListTile(
            leading: const Icon(Icons.email, color: AppConstants.mainColor),
            title: const Text(
              'E-mail',
              style: TextStyle(
                fontFamily: AppConstants.fontInterMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: AppConstants.greyColor5),
            onTap: () {
              Navigator.pushNamed(context, EmailNotificationPage.routeName);
            },
          ),
          const Divider(color: AppConstants.greyColor7),
        ],
      ),
    );
  }
}
