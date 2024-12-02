import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/settings_page.dart';

//Widget appbar pada cart
class Cartappbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          //Tombol back atau keluar dari cart
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 30,
                color: AppConstants.greyColor3,
              )),
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              "Cart",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.greyColor3),
            ),
          ),
          const Spacer(),
          // tombol yang menuju setting di cart
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
            child: const Icon(
              Icons.settings,
              size: 23,
              color: AppConstants.greyColor3,
            ),
          ),
        ],
      ),
    );
  }
}
