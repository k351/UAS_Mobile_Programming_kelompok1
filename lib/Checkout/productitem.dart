import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uas_flutter/constants.dart';

class ProductItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const ProductItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image
        Image.asset(
          item['image'],
          width: 80,
          height: 80,
        ),
        const SizedBox(width: 16), // Add spacing between image and text
        // Product details
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              Text(
                item['description'],
                style: const TextStyle(
                  fontSize: 13,
                  color: AppConstants.greyColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${item['quantity']} x Rp ${NumberFormat("#,##0", "id_ID").format(item['price'])}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
