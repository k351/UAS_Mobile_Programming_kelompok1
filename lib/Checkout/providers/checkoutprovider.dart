  import 'package:flutter/material.dart';

  class CheckoutProvider with ChangeNotifier {
    bool isProtectionChecked = false;
    double protectionFee = 4500.0; // The cost of protection
    bool _isCouponApplied = false; // Status kupon
    double _discountValue = 0.0;

    String? _selectedAddress;

    bool get isCouponApplied => _isCouponApplied;
    double get discountValue => _discountValue;
    String? get selectedAddress => _selectedAddress;

    // Method to toggle protection option
    void toggleProtection(bool value) {
      isProtectionChecked = value;
      notifyListeners(); // To update UI when protection is checked/unchecked
    }

    // Method to apply a discount
    void applyDiscount(double discount) {
      _discountValue = discount;
      _isCouponApplied = true;
      notifyListeners(); 
    }

    void resetCoupon() {
      _isCouponApplied = false;
      _discountValue = 0.0;
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
      total -= discountValue;

      return total;
    }

    void setSelectedAddress(String address) {
    _selectedAddress = address;
    notifyListeners(); // To update UI when the selected address changes
  }

  }
