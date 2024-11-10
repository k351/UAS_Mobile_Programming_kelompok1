import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';

class ProductTitlePrice extends StatelessWidget {
  final String title;
  final double price;

  const ProductTitlePrice({
    super.key,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          "\$$price",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.clrBlack,
          ),
        ),
      ],
    );
  }
}