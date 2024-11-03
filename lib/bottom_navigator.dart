import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/home_page.dart';
import 'package:uas_flutter/Search/search_page.dart';
import 'package:uas_flutter/settings/settings_page.dart';
import 'package:uas_flutter/routes.dart';

class NavigationUtils {
  static void navigateToPage(BuildContext context, int index) {
    String routeName;

    switch (index) {
      case 0:
        routeName = Myhomepage.routeName;
        break;
      case 1:
        routeName = Searchpage.routeName;
        break;
      case 3:
        routeName = SettingsPage.routeName;
        break;
      default:
        routeName = Myhomepage.routeName;
    }

    Navigator.pushNamed(context, routeName);
  }
}

class NavigasiBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  const NavigasiBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);
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
          icon: Icon(Icons.search),
          label: 'Search',
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
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    );
  }
}