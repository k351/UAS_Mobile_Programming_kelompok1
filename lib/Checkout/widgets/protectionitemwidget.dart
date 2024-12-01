import 'package:flutter/material.dart';
import 'package:uas_flutter/constants.dart'; 

class ProtectionItemWidget extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const ProtectionItemWidget({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isChecked ? AppConstants.clrBlue.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isChecked
              ? AppConstants.clrBlue.withOpacity(0.3)
              : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isChecked
                  ? AppConstants.clrBlue.withOpacity(0.1)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.shield_moon_outlined,
              color: isChecked ? AppConstants.clrBlue : Colors.grey,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Proteksi Kerusakan',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isChecked ? Colors.black87 : Colors.black54,
                  ),
                ),
                Text(
                  'Lindungi barang anda',
                  style: TextStyle(
                    fontSize: 12,
                    color: isChecked ? Colors.black54 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rp4.500',
            style: TextStyle(
              color: isChecked ? Colors.black87 : Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: AppConstants.clrBlue,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
