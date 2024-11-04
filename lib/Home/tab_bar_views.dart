import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class IsiTabs extends StatelessWidget {
  final List<Map<String, dynamic>> list;

  const IsiTabs({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 3,
        childAspectRatio: getProportionateScreenHeight(0.55),
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ItemTabs(isi: list[index]);
      },
    );
  }
}

class ItemTabs extends StatelessWidget {
  final Map<String, dynamic> isi;

  const ItemTabs({super.key, required this.isi});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppConstants.clrBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: const Offset(0, 0),
            color: AppConstants.clrBlack.withOpacity(0.3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: getProportionateScreenHeight(110),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(isi['image']),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(12)),
            Text(
              isi['title'],
              style: TextStyle(
                  fontSize: getProportionateScreenWidth(17),
                  fontWeight: FontWeight.bold,
                  fontFamily: AppConstants.fontInterRegular),
            ),
            SizedBox(height: getProportionateScreenHeight(7)),
            Row(
              children: [
                Icon(Icons.star,
                    size: getProportionateScreenWidth(20),
                    color: AppConstants.star),
                Text(
                  isi['rating'].toString(),
                  style: TextStyle(
                      fontSize: getProportionateScreenWidth(14),
                      fontFamily: AppConstants.fontInterRegular),
                ),
              ],
            ),
            Container(
              height: getProportionateScreenHeight(34),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppConstants.mainColor,
              ),
              alignment: Alignment.center,
              child: Text(
                "Open",
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    color: AppConstants.clrBackground,
                    fontFamily: AppConstants.fontInterRegular),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
