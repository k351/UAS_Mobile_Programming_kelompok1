import 'package:flutter/material.dart';

class CheckoutProvider with ChangeNotifier {
  bool isProtectionChecked = false;
  double protectionFee = 4500.0; // The cost of protection
  double discount = 0.0; // Discount amount

  // Method to toggle protection option
  void toggleProtection(bool value) {
    isProtectionChecked = value;
    notifyListeners(); // To update UI when protection is checked/unchecked
  }

  // Method to apply a discount
  void applyDiscount(double discountAmount) {
    discount = discountAmount;
    notifyListeners(); // To update UI when a discount is applied
  }

  // Method to calculate the total based on the selected protection and discount
  double calculateTotal(double subTotal) {
    double total = subTotal;

    // Add protection fee if selected
    if (isProtectionChecked) {
      total += protectionFee;
    }

    // Apply discount if any
    total -= discount;

    return total;
  }
}
