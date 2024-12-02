import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/cartpage.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/Home/Providers/saldoprovider.dart';
import 'package:uas_flutter/Home/services/firebase_topup.dart';
import 'package:uas_flutter/Home/tabbar/product_tabbar.dart';
import 'package:uas_flutter/Wishlist/providers/wishlist_provider.dart';
import 'package:uas_flutter/bottom_navigator.dart';
import 'package:uas_flutter/Home/search/search_page.dart';
import 'package:uas_flutter/Home/tabbar/tabs.dart';
import 'package:uas_flutter/Home/TopUpMetode/method_top_up.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';
import 'package:uas_flutter/Home/services/carousel.dart';
import 'dart:async'; // Ambil Time

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});
  static String routeName = "/myhomepage";
  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage>
    with SingleTickerProviderStateMixin {
  // Inisialisasi variabel
  double saldo = 0;
  late ScrollController _scrollController;
  late TabController _tabController;
  late PageController _pageController;
  final TextEditingController _searchController = TextEditingController();
  final CartDatabaseService cartDatabaseService = CartDatabaseService();
  late Timer timer; // timer
  int _currentPage = 0; // gambar
  List<String> carousel = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _scrollController = ScrollController();
    _pageController = PageController(viewportFraction: 1);
    _getUserSaldo(); // user saldo di firebase
    _loadCarousel();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    _fetchCartItems();
    wishlistProvider.fetchWishlist(userId);
    // Gambar pindah pindah
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < carousel.length - 1) {
        setState(() {
          _currentPage++;
        });
      } else {
        setState(() {
          _currentPage = 0;
        });
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  // untuk menghindari error
  @override
  void dispose() {
    timer.cancel();
    _pageController.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchCartItems() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      List<Map<String, dynamic>> items =
          await cartDatabaseService.initializeCartItems(userId);
      final cartProvider = Provider.of<Cartprovider>(context, listen: false);
      cartProvider.setCartItems(items);
      cartProvider.calculateTotal();
    }
  }

  // user saldo firebase
  Future<void> _getUserSaldo() async {
    final saldoUser = await FirebaseTopup.getSaldoFromFirestore();
    Provider.of<SaldoProvider>(context, listen: false).updateSaldo(saldoUser);
  }

  Future<void> _loadCarousel() async {
    final fetchedCarousel =
        await FirebaseCarousel.getHomeCarouselFromFirestore();
    setState(() {
      carousel = fetchedCarousel;
    });
  }

  //Update Saldo
  Future<void> _navigateToMethodTopUpPage() async {
    final saldoProvider = Provider.of<SaldoProvider>(context, listen: false);
    final updatedSaldo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MethodTopUps(initialSaldo: saldoProvider.saldo),
      ),
    );

    if (updatedSaldo != null) {
      saldoProvider.updateSaldo(updatedSaldo);
      _updateUserSaldo(updatedSaldo);
    }
  }

  // Update saldo ke databse users
  Future<void> _updateUserSaldo(double newSaldo) async {
    await FirebaseTopup.updateSaldoInFirestore(newSaldo);
  }

  @override
  Widget build(BuildContext context) {
    final saldoProvider = Provider.of<SaldoProvider>(context);
    saldo = saldoProvider.saldo;
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Bagian atas untuk search dan ikon
            Container(
              padding: const EdgeInsets.only(left: 15, top: 4, bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: getProportionateScreenHeight(42),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search products...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: AppConstants.clrBlue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchResultsPage(
                                    isiSearch: _searchController.text,
                                  ),
                                ),
                              );
                            },
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 15,
                          ),
                        ),
                        onSubmitted: (search) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchResultsPage(
                                isiSearch: search,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(10)),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Stack(
                      clipBehavior: Clip
                          .none, // This allows the badge to overflow the stack
                      children: [
                        InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, Cartpage.routeName),
                          child: const Icon(Icons.shopping_cart_sharp,
                              color: Colors.black),
                        ),
                        // Badge Counter
                        Positioned(
                          top: -5, // Move up
                          right: -5, // Move right
                          child: Consumer<Cartprovider>(
                            builder: (context, cartProvider, child) {
                              final cartItemCount = cartProvider.cartQuantity;
                              if (cartItemCount > 0) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppConstants.clrBlue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$cartItemCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Gambar yang bisa pindah-pindah
            SizedBox(
              height: getProportionateScreenHeight(185),
              child: PageView.builder(
                controller: _pageController,
                itemCount: carousel.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(),
                      image: DecorationImage(
                          image: AssetImage(carousel[index]), fit: BoxFit.fill),
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
                            "Cartipay",
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
                              AppTabs(text: "Beauty"),
                              AppTabs(text: "Electronics"),
                              AppTabs(text: "Fashion"),
                              AppTabs(text: "Fitness"),
                              AppTabs(text: "Toys"),
                            ],
                          ),
                        ),
                      ),
                    )
                  ];
                },
                body: TabBarView(
                  controller: _tabController,
                  children: const [
                    IsiTabs(),
                    IsiCategory(category: 'Beauty'),
                    IsiCategory(category: 'Electronics'),
                    IsiCategory(category: 'Fashion'),
                    IsiCategory(category: 'Fitness'),
                    IsiCategory(category: 'Toys'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigasiBar(
        selectedIndex: 0, // Set sesuai index untuk wishlist
        onTap: (index) {
          NavigationUtils.navigateToPage(context, index);
        },
      ),
    );
  }
}
