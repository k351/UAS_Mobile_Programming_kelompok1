import 'package:flutter/material.dart';
import 'package:uas_flutter/settings/settings_page.dart';

class Cartappbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white60,
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.grey,
              )),
          const Padding(
            padding: EdgeInsets.only(left: 30),
            child: Text(
              "Cart",
              style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
            child: const Icon(
              Icons.settings,
              size: 23,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
