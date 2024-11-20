import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/Wishlist/WishlistPage.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/history/history_screen.dart';
import 'package:uas_flutter/settings/settings_page.dart';

class NavigationUtils {
  static void navigateToPage(BuildContext context, int index) {
    String routeName;

    switch (index) {
      case 0:
        routeName = Myhomepage.routeName;
        break;
      case 1:
        routeName = HistoryPage.routeName;
        break;
      case 2:
        routeName = WishlistPage.routeName;
        break;
      case 3:
        routeName = SettingsPage.routeName;
        break;
      default:
        routeName = Myhomepage.routeName;
    }

    Navigator.pushNamed(
      context,
      routeName,
    );
  }
}

class NavigasiBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  const NavigasiBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Transaction',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Account',
        ),
      ],
      selectedItemColor: AppConstants.mainColor,
      unselectedItemColor: AppConstants.greyColor,
      type: BottomNavigationBarType.fixed,
    );
  }
}
