import 'package:flutter/material.dart';

class CheckoutProvider with ChangeNotifier {
  bool isProtectionChecked = false;
  double protectionFee = 4500.0; // The cost of protection
  bool _isCouponApplied = false; // Status kupon
  num _discountValue = 0.0;

  String? _selectedAddress;
  String? _appliedCouponCode;

  bool get isCouponApplied => _isCouponApplied;
  num get discountValue => _discountValue;
  String? get appliedCouponCode => _appliedCouponCode;
  String? get selectedAddress => _selectedAddress;

  // Method to toggle protection option
  void toggleProtection(bool value) {
    isProtectionChecked = value;
    notifyListeners(); // To update UI when protection is checked/unchecked
  }

  // Method to apply a discount
  void applyDiscount(String couponCode, num discount) {
    _appliedCouponCode = couponCode;
    _discountValue = discount;
    _isCouponApplied = true;
    notifyListeners();
  }

  void resetCoupon() {
    _isCouponApplied = false;
    _discountValue = 0.0;
    _appliedCouponCode = null;
    notifyListeners();
  }

  // Method to calculate the total based on the selected protection and discount
  double calculateTotal(double subTotal) {
    double total = subTotal;

    // Add protection fee if selected
    if (isProtectionChecked) {
      total += protectionFee;
    }

    // Apply discount if any
    total -= discountValue.toDouble();

    return total;
  }

  void setSelectedAddress(String address) {
    _selectedAddress = address;
    notifyListeners(); // To update UI when the selected address changes
  }

  void resetCheckout() {
    isProtectionChecked = false; // Reset protection option
    _isCouponApplied = false; // Reset coupon applied status
    _discountValue = 0.0; // Reset discount value
    _appliedCouponCode = null; // Reset applied coupon code
    notifyListeners(); // To update UI when all values are reset
  }
}
