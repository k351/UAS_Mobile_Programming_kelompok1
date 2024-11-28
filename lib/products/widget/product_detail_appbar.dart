import 'package:flutter/material.dart';
import 'package:uas_flutter/utils/size_config.dart';

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 30,
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            iconSize: 30,
            icon: const Icon(Icons.favorite_outline),
          ),
        ],
      ),
    );
  }
}
