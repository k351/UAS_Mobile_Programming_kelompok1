import 'package:flutter/material.dart';
import 'package:uas_flutter/BottomNavigator.dart';
import 'package:uas_flutter/Home/TabBarViews.dart';
import 'package:uas_flutter/Home/Tabs.dart';
import 'dart:async';
import 'package:uas_flutter/Utils.dart'; // Ambil Timer

class Myhomepage extends StatefulWidget {
  @override
  static const String routeName = '/home';
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage>
    with SingleTickerProviderStateMixin {
  // Initialization
  late ScrollController _scrollController;
  late TabController _tabController;
  late PageController _pageController;
  late Timer timer;
  int _currentPage = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _pageController = PageController(viewportFraction: 1);

    timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < books.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _pageController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    NavigationUtils.navigateToPage(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // paling atas tempat search dan notif ama cart
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 235, 235, 235)
                            .withOpacity(0.6),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                        ),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Row(
                    children: [
                      Icon(Icons.shopping_cart_sharp),
                      SizedBox(width: 10),
                      Icon(Icons.settings),
                    ],
                  ),
                ],
              ),
            ),
            // gambar yang bisa pindah pindah
            Container(
              height: 160,
              child: PageView.builder(
                controller: _pageController,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(),
                      image: DecorationImage(
                          image: AssetImage(books[index]['image']),
                          fit: BoxFit.fill),
                    ),
                  );
                },
              ),
            ),
            // Tempat duit atau dana atau topup
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.account_balance_wallet,
                            color: Colors.blue, size: 30),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Saldo",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "Rp 20.000",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Top Up",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // tabbarnya
            Expanded(
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScroll) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: Colors.white,
                      bottom: PreferredSize(
                        preferredSize: Size.fromHeight(0),
                        child: Container(
                          margin: const EdgeInsets.all(0),
                          child: TabBar(
                            indicatorPadding: const EdgeInsets.all(0),
                            indicatorSize: TabBarIndicatorSize.label,
                            labelPadding:
                                const EdgeInsets.only(right: 5, left: 5),
                            tabAlignment: TabAlignment.center,
                            controller: _tabController,
                            isScrollable: true,
                            indicatorColor: Colors.blue,
                            labelColor: Colors.blue,
                            tabs: [
                              // filenya tabs.dart
                              AppTabs(text: "All"),
                              AppTabs(text: "New"),
                              AppTabs(text: "Popular"),
                              AppTabs(text: "Brand"),
                            ],
                          ),
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    // file TabBarViews.dart
                    isiTabs(list: books),
                    isiTabs(list: anjay),
                    Center(child: Text("Popular Books")),
                    Center(child: Text("Brand Books")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // navigation bawah
      bottomNavigationBar: NavigasiBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
