import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class BalanceCard extends StatefulWidget {
  final double balance;
  final String userName;
  final VoidCallback onQrCodeTap;
  final VoidCallback onMenuTap;

  const BalanceCard({
    Key? key,
    required this.balance,
    required this.userName,
    required this.onQrCodeTap,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 195,
      // margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Icône menu en haut à gauche
          Positioned(
          
            child: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: widget.onMenuTap,
              padding: EdgeInsets.zero,
            ),
          ),
          // Contenu centré
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bonjour ', style: AppTextStyles.bodyLarge),
                    Text(
                      widget.userName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.primaryOrange,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isBalanceVisible
                          ? '${widget.balance.toStringAsFixed(0)} FCFA'
                          : '******* FCFA',
                      style: AppTextStyles.balance.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      child: Icon(
                        _isBalanceVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // QR Code en bas à droite
          Positioned(
            bottom: 20,
            right: 8,
            child: GestureDetector(
              onTap: widget.onQrCodeTap,
              child: Container(
                height: 120,
                width: 120,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                      child: const Icon(
                    Icons.qr_code,
                    size:90,
                    color: Colors.black,
                  ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
