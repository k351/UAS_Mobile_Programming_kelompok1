import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider to access CheckoutProvider
import 'package:uas_flutter/Checkout/providers/checkoutprovider.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/models/address_model.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final VoidCallback onTap;

  const AddressCard({
    Key? key,
    required this.address,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the CheckoutProvider to check the selected address
    final checkoutProvider = Provider.of<CheckoutProvider>(context);

    // Check if this address is the selected one
    bool isSelected = checkoutProvider.selectedAddress == address.fullAddress;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.shade100
              : AppConstants.clrBackground, // Change color if selected
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: isSelected
                  ? AppConstants.mainColor
                  : AppConstants.clrBlack), // Different border color if selected
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Address Label
                Text(
                  address.addressLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.clrBlue,
                  ),
                ),
                // Recipient Name
                Text(
                  address.recipientName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.clrBlack,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Full Address (Truncated with Ellipsis if needed)
            Text(
              address.fullAddress,
              style: const TextStyle(
                fontSize: 13,
                color: AppConstants.clrBlack,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
