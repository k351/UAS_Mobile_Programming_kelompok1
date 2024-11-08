import 'package:flutter/material.dart';
import 'package:uas_flutter/Home/tab_bar_views.dart';
import 'package:uas_flutter/size_config.dart';

class SearchResultsPage extends StatelessWidget {
  final String isiSearch;
  final List<Map<String, dynamic>> books;

  const SearchResultsPage(
      {super.key, required this.isiSearch, required this.books});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    final filteredBooks = books
        .where((index) => index['title']
            .toString()
            .toLowerCase()
            .contains(isiSearch.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Search Results: ")),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 3,
          mainAxisSpacing: 3,
          childAspectRatio: getChildAspectRatio(),
        ),
        itemCount: filteredBooks.length,
        itemBuilder: (context, index) {
          return ItemTabs(
            isi: filteredBooks[index],
            index: index,
          );
        },
      ),
    );
  }
}
