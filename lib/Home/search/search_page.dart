import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Cart/cartpage.dart';
import 'package:uas_flutter/Cart/providers/cartprovider.dart';
import 'package:uas_flutter/Cart/services/cartdatabaseservices.dart';
import 'package:uas_flutter/Home/tabbar/tab_bar_views.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/utils/size_config.dart';
import 'package:uas_flutter/products/models/product.dart';
import 'package:uas_flutter/products/services/productdatabaseservices.dart';

class SearchResultsPage extends StatefulWidget {
  final String isiSearch;

  const SearchResultsPage({super.key, required this.isiSearch});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final ProductDatabaseService _productService = ProductDatabaseService();
  List<Map<String, dynamic>> _allProducts = [];
  List<Map<String, dynamic>> _searchResults = [];
  final CartDatabaseService cartDatabaseService = CartDatabaseService();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.isiSearch;
    _fetchAllProducts();
  }

  Future<void> _fetchAllProducts() async {
    try {
      List<Map<String, dynamic>> products =
          await _productService.fetchProducts(true);
      setState(() {
        _allProducts = products;
        _applySearch(widget.isiSearch);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applySearch(String query) {
    try {
      final regex = RegExp(query, caseSensitive: false);

      final filteredResults = _allProducts.where((productData) {
        final product = productData['product'] as Product;
        return regex.hasMatch(product.title);
      }).toList();

      setState(() {
        _searchResults = filteredResults;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
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
                fontSize: 14,
              ),
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey.shade500,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.search,
                  color: AppConstants.clrBlue,
                ),
                onPressed: () {
                  _applySearch(_searchController.text);
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 15,
              ),
            ),
            onSubmitted: (search) {
              _applySearch(search);
            },
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Stack(
              clipBehavior:
                  Clip.none, // This allows the badge to overflow the stack
              children: [
                InkWell(
                  onTap: () => Navigator.pushNamed(context, Cartpage.routeName),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 100,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "No products found for \"${widget.isiSearch}\"",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    childAspectRatio: getProportionateScreenHeight(0.74),
                  ),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final product = _searchResults[index]['product'] as Product;
                    final productId = _searchResults[index]['id'] as String;

                    return ItemTabs(
                      product: product,
                      productId: productId,
                    );
                  },
                ),
    );
  }
}
