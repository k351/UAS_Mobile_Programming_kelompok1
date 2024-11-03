import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/Wishlist/WishlistPage.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/settings_page.dart';
import 'package:uas_flutter/size_config.dart';

class NavigationUtils {
  static void navigateToPage(BuildContext context, int index) {
    Widget page;

    switch (index) {
      case 0:
        page = const Myhomepage();
        break;
      case 1:
        page = const WishlistPage();
        break;
      case 2:
        page = const WishlistPage();
        break;
      case 3:
        page = const SettingsPage();
        break;
      default:
        page = const Myhomepage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
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
    SizeConfig.init(context);
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      selectedItemColor: AppConstants.mainColor,
      unselectedItemColor: AppConstants.greyColor,
      type: BottomNavigationBarType.fixed,
    );
  }
}
