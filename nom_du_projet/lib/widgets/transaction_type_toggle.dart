import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum TransactionType { pay, transfer }

class TransactionTypeToggle extends StatelessWidget {
  final TransactionType selectedType;
  final Function(TransactionType) onChanged;

  const TransactionTypeToggle({
    Key? key,
    required this.selectedType,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildToggleOption(
          icon: Icons.radio_button_checked,
          label: 'Payer',
          type: TransactionType.pay,
        ),
        const SizedBox(width: 32),
        _buildToggleOption(
          icon: Icons.radio_button_checked,
          label: 'Transférer',
          type: TransactionType.transfer,
        ),
        const Spacer(),
        // Icône wallet
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.account_balance_wallet,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption({
    required IconData icon,
    required String label,
    required TransactionType type,
  }) {
    final isSelected = selectedType == type;
    
    return GestureDetector(
      onTap: () => onChanged(type),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: isSelected ? AppColors.primaryOrange : AppColors.textSecondary,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTextStyles.bodyLarge.copyWith(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
