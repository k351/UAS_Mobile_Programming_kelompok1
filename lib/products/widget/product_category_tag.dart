import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';

class ProductCategoryTag extends StatelessWidget {
  final String category;

  const ProductCategoryTag({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppConstants.clrBlack.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: const TextStyle(
          color: AppConstants.clrBlack,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
