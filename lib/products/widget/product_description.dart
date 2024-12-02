import 'package:flutter/material.dart';

// Class untuk deskripsi produk
class ProductDescription extends StatelessWidget {
  final String description;

  const ProductDescription({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: TextStyle(
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }
}