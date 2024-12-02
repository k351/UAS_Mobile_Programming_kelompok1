import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';

// Class untuk rating dan stock
class ProductRatingStock extends StatelessWidget {
  final double rating;
  final int stock;

  const ProductRatingStock({
    super.key,
    required this.rating,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppConstants.clrBlue.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star,
                size: 16,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Text(
          "Stock: $stock",
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
