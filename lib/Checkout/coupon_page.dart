import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_flutter/Checkout/providers/checkoutprovider.dart';
import 'package:uas_flutter/Checkout/services/discountdatabaseservice.dart';
import 'package:uas_flutter/Checkout/models/discount.dart';
import 'package:uas_flutter/constants.dart';

class CouponPage extends StatefulWidget {
  const CouponPage({Key? key}) : super(key: key);

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  String? _selectedCouponCode;
  String? _manualCouponCode; // Store manual coupon input
  String? errorMessage;

  final DiscountDatabaseService _discountService = DiscountDatabaseService();

  @override
  void initState() {
    super.initState();
    final appliedCouponCode =
        context.read<CheckoutProvider>().appliedCouponCode;
    _selectedCouponCode = appliedCouponCode; // Set initially applied coupon
  }

  void _applyCoupon() async {
    if (_selectedCouponCode == null &&
        (_manualCouponCode == null || _manualCouponCode!.isEmpty)) {
      setState(() {
        errorMessage = "Pilih kupon atau masukkan kode promo terlebih dahulu!";
      });
      return;
    }

    final couponCodeToApply = _selectedCouponCode ?? _manualCouponCode;
    final checkoutProvider = context.read<CheckoutProvider>();

    try {
      final discountAmount =
          await _discountService.fetchDiscountAmountByCode(couponCodeToApply!);

      if (discountAmount != null) {
        final discounts = await _discountService.fetchDiscounts();
        final discount = discounts.firstWhere(
          (d) => d.code == couponCodeToApply,
          orElse: () => Discount(
            code: 'INVALID',
            validTo: DateTime(1970),
            discountValue: 0,
          ),
        );

        if (discount.code == 'INVALID') {
          setState(() {
            errorMessage = "Kode kupon tidak valid!";
          });
        } else if (discount.validTo.isBefore(DateTime.now())) {
          setState(() {
            errorMessage = "Kupon telah kedaluwarsa!";
          });
        } else {
          checkoutProvider.applyDiscount(couponCodeToApply, discountAmount);
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Kupon berhasil diterapkan! Diskon Rp${discountAmount}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        setState(() {
          errorMessage = "Kode kupon tidak valid!";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan, coba lagi nanti.";
      });
      print('Error applying coupon: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final checkoutProvider = context.watch<CheckoutProvider>();
    final appliedCouponCode = checkoutProvider.appliedCouponCode;

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Discount>>(
              future: _discountService.fetchDiscounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Terjadi kesalahan.'));
                } else if (snapshot.hasData) {
                  final discounts = snapshot.data!;
                  if (discounts.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada kupon tersedia.'),
                    );
                  }
                  return SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: discounts.length,
                      itemBuilder: (context, index) {
                        final discount = discounts[index];
                        final isSelected = _selectedCouponCode == discount.code;
                        final isApplied = appliedCouponCode == discount.code;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCouponCode = discount.code;
                              errorMessage = null;
                            });
                          },
                          child: Stack(
                            children: [
                              Card(
                                color:
                                    isApplied ? Colors.blue[100] : Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  width: 200,
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        discount.code,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Diskon: Rp${discount.discountValue}\nEXP: ${discount.validTo.toLocal()}",
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Icon(
                                    Icons.check_circle,
                                    color:
                                        AppConstants.clrBlue, // Blue checkmark
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('Tidak ada kupon.'));
                }
              },
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Punya kode promo? masukin disini',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _manualCouponCode = value;
                setState(() {
                  errorMessage = null;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyCoupon,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.clrBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Terapkan Kupon',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
