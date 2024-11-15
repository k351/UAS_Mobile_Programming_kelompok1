import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/tabbar/tab_bar_views.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';
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
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    try {
      List<Map<String, dynamic>> results =
          await _productService.fetchProductByTitle(widget.isiSearch);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      // Handle any errors here
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      appBar: AppBar(title: Text("Search Results: ${widget.isiSearch}",style: const TextStyle(fontFamily: AppConstants.fontInterRegular),)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text("No products found"))
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
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
