import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

class _CouponPageState extends State<CouponPage>
    with SingleTickerProviderStateMixin {
  String? _selectedCouponCode;
  String? _manualCouponCode;
  String? errorMessage;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final DiscountDatabaseService _discountService = DiscountDatabaseService();
  final TextEditingController _couponController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final appliedCouponCode =
        context.read<CheckoutProvider>().appliedCouponCode;
    _selectedCouponCode = appliedCouponCode;

    // Animation setup
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

    void _applyCoupon() async {
    final couponCodeToApply = _manualCouponCode?.isNotEmpty == true
        ? _manualCouponCode
        : _selectedCouponCode;

    if (couponCodeToApply == null || couponCodeToApply.isEmpty) {
      setState(() {
        errorMessage = "Pilih kupon atau masukkan kode promo terlebih dahulu!";
      });
      return;
    }

    final checkoutProvider = context.read<CheckoutProvider>();

    try {
      final discountAmount =
          await _discountService.fetchDiscountAmountByCode(couponCodeToApply);

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
          _showErrorDialog("Kode kupon tidak valid!");
        } else if (discount.validTo.isBefore(DateTime.now())) {
          _showErrorDialog("Kupon telah kedaluwarsa!");
        } else {
          checkoutProvider.applyDiscount(couponCodeToApply, discountAmount);

          setState(() {
            _selectedCouponCode = couponCodeToApply;
            _couponController.clear();
          });

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Kupon berhasil diterapkan! Diskon ' +
                    'Rp${NumberFormat("#,##0", "id_ID").format(checkoutProvider.discountValue)}',
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      } else {
        _showErrorDialog("Kode kupon tidak valid!");
      }
    } catch (e) {
      _showErrorDialog("Terjadi kesalahan, coba lagi nanti.");
      print('Error applying coupon: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Peringatan'),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 25,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pilih Kupon Diskon',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.blue.shade900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 15),
              FutureBuilder<List<Discount>>(
                future: _discountService.fetchDiscounts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
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
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: discounts.length,
                        itemBuilder: (context, index) {
                          final discount = discounts[index];
                          final isSelected =
                              _selectedCouponCode == discount.code;

                          return ScaleTransition(
                            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                              CurvedAnimation(
                                parent: _animationController,
                                curve: Interval(index * 0.1, 1.0,
                                    curve: Curves.elasticOut),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCouponCode = discount.code;
                                  errorMessage = null;
                                });
                              },
                              child: Container(
                                width: 250,
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isSelected
                                        ? [
                                            Colors.blue.shade300,
                                            Colors.blue.shade100
                                          ]
                                        : [Colors.white, Colors.blue.shade50],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.blue.shade400
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.blue.shade100.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          discount.code,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.blue.shade900,
                                          ),
                                        ),
                                        if (isSelected)
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Diskon: Rp${NumberFormat("#,##0", "id_ID").format(discount.discountValue)}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? Colors.white70
                                            : Colors.blue.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Berlaku hingga: ${DateFormat('dd MMM yyyy').format(discount.validTo)}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white54
                                            : Colors.blue.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
              TextField(
                controller: _couponController,
                decoration: InputDecoration(
                  labelText: 'Kode Promo',
                  hintText: 'Masukkan kode promo Anda',
                  prefixIcon: Icon(Icons.discount, color: Colors.blue.shade300),
                  suffixIcon: _manualCouponCode != null &&
                          _manualCouponCode!.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.blue.shade300),
                          onPressed: () {
                            _couponController.clear();
                            setState(() {
                              _manualCouponCode = null;
                              errorMessage = null;
                            });
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.blue.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide:
                        BorderSide(color: Colors.blue.shade500, width: 2),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _manualCouponCode = value;
                    errorMessage = null;
                  });
                },
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  errorMessage!,
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _applyCoupon,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Terapkan Kupon',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
