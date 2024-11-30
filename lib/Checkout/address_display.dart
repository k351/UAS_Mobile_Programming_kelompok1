import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart';
import 'package:uas_flutter/settings/provider/address_provider.dart';

class AddressDisplay extends StatelessWidget {
  final String? selectedAddress;
  final AddressProvider addressProvider;

  const AddressDisplay({
    Key? key,
    required this.selectedAddress,
    required this.addressProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final address = addressProvider.addresses.firstWhere(
      (addr) => addr.fullAddress == selectedAddress,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on, color: Colors.green, size: 20),
            const SizedBox(width: 6),
            Text(
              address.addressLabel,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          address.recipientName,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppConstants.clrBlack,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          address.fullAddress,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppConstants.clrBlack,
          ),
        ),
        
      ],
    );
  }
}
