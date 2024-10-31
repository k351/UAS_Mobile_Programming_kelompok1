import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/HomePage.dart';
import 'package:uas_flutter/Search/SearchPage.dart';

class NavigationUtils {
  static void navigateToPage(BuildContext context, int index) {
    Widget page;

    switch (index) {
      case 0:
        page = Myhomepage();
        break;
      case 1:
        page = Searchpage();
        break;
      default:
        page = Myhomepage();
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
