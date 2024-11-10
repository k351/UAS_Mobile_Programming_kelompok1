import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class AppTabs extends StatelessWidget {
  final String text;

  const AppTabs({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Container(
      width: 120,
      height: 50,
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontSize: getProportionateScreenWidth(15),
            fontWeight: FontWeight.w700,
            fontFamily: AppConstants.fontInterRegular),
      ),
    );
  }
}
