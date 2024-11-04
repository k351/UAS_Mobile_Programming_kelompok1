import 'package:flutter/material.dart';
import 'package:uas_flutter/Utils.dart';
import 'package:uas_flutter/bottom_navigator.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});
  static const String routeName = '/wishlistpage';

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  int _selectedIndex = 1;
  List<bool> likedStatus = List.generate(books.length, (_) => true); // Initialize all as liked

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    NavigationUtils.navigateToPage(context, index);
  }

  void _toggleLike(int index) {
    setState(() {
      likedStatus[index] = !likedStatus[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Wishlist",
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppConstants.fontInterRegular),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Row(
                        children: [
                          Image.asset(
                            books[index]['image'],
                            width: 80,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: getProportionateScreenWidth(20)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      books[index]['title'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: AppConstants.fontInterRegular),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: likedStatus[index] ? Colors.red : Colors.black,
                                      ),
                                      onPressed: () => _toggleLike(index),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text('Rating: ${books[index]['rating']}'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigasiBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
