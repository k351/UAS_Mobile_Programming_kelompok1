import 'package:flutter/material.dart';
import 'package:uas_flutter/bottom_navigator.dart';
import 'package:uas_flutter/Home/search_page.dart';
import 'package:uas_flutter/Home/tab_bar_views.dart';
import 'package:uas_flutter/Home/tabs.dart';
import 'package:uas_flutter/Home/TopUpMetode/method_top_up.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';
import 'dart:async'; // Ambil Time
import 'package:uas_flutter/utils.dart';

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});
  static String routeName = "/myhomepage";
  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage>
    with SingleTickerProviderStateMixin {
  // Inisialisasi variabel
  double saldo = 100000.0;
  late ScrollController _scrollController;
  late TabController _tabController;
  late PageController _pageController;
  final TextEditingController _searchController = TextEditingController();
  late Timer timer;
  int _currentPage = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _pageController = PageController(viewportFraction: 1);

    // Timer untuk pindah gambar
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < books.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
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

  // Fungsi untuk berpindah halaman pada navigator bawah
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    NavigationUtils.navigateToPage(context, index);
  }

  //Update Saldo
  Future<void> _navigateToMethodTopUpPage() async {
    final updatedSaldo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MethodTopUps(initialSaldo: saldo),
      ),
    );

    if (updatedSaldo != null) {
      setState(() {
        saldo = updatedSaldo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas untuk search dan ikon
            Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      height: getProportionateScreenHeight(42),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: AppConstants.clrGreyBg.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search products...',
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.search,
                              color: AppConstants.greyColor4),
                        ),
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(16),
                            fontFamily: AppConstants.fontInterRegular),
                        onSubmitted: (search) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultsPage(
                                isiSearch: search,
                                books: books,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(10)),
                  Row(
                    children: [
                      const Icon(Icons.shopping_cart_sharp),
                      SizedBox(width: getProportionateScreenWidth(10)),
                      const Icon(Icons.settings),
                    ],
                  ),
                ],
              ),
            ),
            // Gambar yang bisa pindah-pindah
            SizedBox(
              height: getProportionateScreenHeight(185),
              child: PageView.builder(
                controller: _pageController,
                itemCount: books.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(),
                      image: DecorationImage(
                          image: AssetImage(books[index]['image']),
                          fit: BoxFit.fill),
                    ),
                  );
                },
              ),
            ),
            // Bagian untuk saldo atau dana dan top up
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(Icons.account_balance_wallet,
                            color: AppConstants.clrBlue,
                            size: getProportionateScreenWidth(28)),
                      ),
                      SizedBox(width: getProportionateScreenWidth(10)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Saldo",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(13),
                                color: AppConstants.greyColor,
                                fontFamily: AppConstants.fontInterRegular),
                          ),
                          Text(
                            "Rp $saldo",
                            style: TextStyle(
                                fontSize: getProportionateScreenWidth(15),
                                fontWeight: FontWeight.bold,
                                fontFamily: AppConstants.fontInterRegular),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppConstants.clrBlue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      onTap: _navigateToMethodTopUpPage,
                      child: Row(
                        children: [
                          Text(
                            "Top Up",
                            style: TextStyle(
                                color: AppConstants.clrBackground,
                                fontSize: getProportionateScreenWidth(15),
                                fontFamily: AppConstants.fontInterRegular),
                          ),
                          SizedBox(width: getProportionateScreenWidth(5)),
                          const Icon(
                            Icons.add,
                            color: AppConstants.clrBackground,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tab bar
            Expanded(
              child: NestedScrollView(
                controller: _scrollController,
                headerSliverBuilder: (BuildContext context, bool isScroll) {
                  return [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: AppConstants.clrBackground,
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(0),
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
                            indicatorColor: AppConstants.clrBlue,
                            labelColor: AppConstants.clrBlue,
                            tabs: const [
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
                    IsiTabs(list: books),
                    IsiTabs(list: anjay),
                    const Center(child: Text("Popular Books")),
                    const Center(child: Text("Brand Books")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigasiBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
