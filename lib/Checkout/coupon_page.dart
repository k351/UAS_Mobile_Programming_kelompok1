import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Checkout/providers/checkoutprovider.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  final TextEditingController _couponController = TextEditingController();
  String? errorMessage;

  void _applyCoupon() {
    final couponCode = _couponController.text.trim();
    final checkoutProvider = context.read<CheckoutProvider>();

    // Example logic for applying a discount
    if (couponCode == "DISCOUNT30") {
      checkoutProvider.applyDiscount(30000.0); // Apply a 30k discount
      Navigator.pop(context); // Close the bottom sheet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kupon berhasil diterapkan! Diskon Rp30.000'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      setState(() {
        errorMessage = "Kode kupon tidak valid!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // Handle keyboard overlap
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Masukkan Kode Kupon',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _couponController,
              decoration: InputDecoration(
                hintText: 'Contoh: DISCOUNT30',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Terapkan Kupon',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
