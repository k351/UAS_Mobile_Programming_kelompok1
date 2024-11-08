import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

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
            style: IconButton.styleFrom(
              backgroundColor: AppConstants.greyColor1,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            iconSize: 30,
            icon: const Icon(Icons.arrow_back),
          ),
          const Spacer(),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppConstants.greyColor1,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {},
            iconSize: 30,
            icon: const Icon(Icons.favorite_outline),
          ),
          SizedBox(width: getProportionateScreenWidth(10)),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: AppConstants.greyColor1,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {},
            iconSize: 30,
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
    );
  }
}
