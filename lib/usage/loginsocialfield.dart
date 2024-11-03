import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/size_config.dart';

class SocialLoginButton extends StatelessWidget {
  final String image;
  final String text;

  const SocialLoginButton({
    Key? key,
    required this.image,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(350),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(
          width: 1,
          color: AppConstants.greyColor1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: getProportionateScreenWidth(15)),
          SvgPicture.asset(image, width: getProportionateScreenWidth(25)),
          SizedBox(width: getProportionateScreenWidth(15)),
          Text(
            text,
            style: TextStyle(
              fontFamily: AppConstants.fontInterMedium,
              color: AppConstants.clrBlack,
              fontSize: getProportionateScreenWidth(16),
            ),
          ),
        ],
      ),
    );
  }
}
