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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              item['image'],
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16), // Add spacing between image and text

          // Product details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Title
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),

                // Product Description
                const SizedBox(height: 4),
                Text(
                  item['description'],
                  style: TextStyle(
                    fontSize: 13,
                    color: AppConstants.greyColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),

                // Spacer
                const SizedBox(height: 8),

                // Price and Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item['cartQuantity']} x',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      'Rp ${NumberFormat("#,##0", "id_ID").format(item['price'])}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
