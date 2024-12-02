import 'package:flutter/material.dart';

class CheckoutProvider with ChangeNotifier {
  bool isProtectionChecked = false;
  double protectionFee = 4500.0; 
  bool _isCouponApplied = false; 
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
    notifyListeners();
  }

  // Method to apply a discount
  void applyDiscount(String couponCode, num discount) {
    _appliedCouponCode = couponCode;
    _discountValue = discount;
    _isCouponApplied = true;
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
    notifyListeners(); 
  }

  // R
  void resetCheckout() {
    isProtectionChecked = false; 
    _isCouponApplied = false; 
    _discountValue = 0.0; 
    _appliedCouponCode = null; 
    notifyListeners(); 
  }
}
