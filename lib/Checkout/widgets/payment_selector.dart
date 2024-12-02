import 'package:flutter/material.dart';
import 'package:uas_flutter/Checkout/payment_method.dart';
import 'package:uas_flutter/constants.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<PaymentMethod> paymentMethods;
  final String? selectedPaymentMethod;
  final bool showAllMethods;
  final ValueChanged<String?> onPaymentMethodChanged;
  final VoidCallback onToggleShowMore;

  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    required this.selectedPaymentMethod,
    required this.showAllMethods,
    required this.onPaymentMethodChanged,
    required this.onToggleShowMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Metode Pembayaran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: showAllMethods ? paymentMethods.length : 2,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade300,
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                PaymentMethod method = paymentMethods[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(
                      method.icon,
                      color: AppConstants.clrBlue,
                      size: 32,
                    ),
                  ),
                  title: Text(
                    method.methodName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: Radio<String>(
                    value: method.methodName,
                    groupValue: selectedPaymentMethod,
                    onChanged: onPaymentMethodChanged,
                  ),
                  onTap: () {
                    onPaymentMethodChanged(method.methodName);
                  },
                );
              },
            ),
          ),
          // Show More/Close Button
          Center(
            child: TextButton(
              onPressed: onToggleShowMore,
              child: Text(
                showAllMethods ? 'Tutup' : 'Lihat Lebih Banyak',
                style: const TextStyle(
                  color: AppConstants.clrBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
