import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userPhone;
  final bool isDarkMode;
  final bool isScannerEnabled;
  final String selectedLanguage;
  final VoidCallback onThemeToggle;
  final VoidCallback onScannerToggle;
  final Function(String) onLanguageChanged;
  final VoidCallback onLogout;

  const CustomDrawer({
    Key? key,
    required this.userName,
    required this.userPhone,
    required this.isDarkMode,
    required this.isScannerEnabled,
    required this.selectedLanguage,
    required this.onThemeToggle,
    required this.onScannerToggle,
    required this.onLanguageChanged,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.drawerBackground,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Profile Section
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.cardBackground,
              child: Icon(
                Icons.person,
                size: 50,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(userName, style: AppTextStyles.header3),
            const SizedBox(height: 8),
            Text(userPhone, style: AppTextStyles.bodyLarge),
            const SizedBox(height: 32),
            const Divider(color: AppColors.cardBackground),
            const SizedBox(height: 16),
            
            // Theme Toggle
            _buildSwitchTile(
              icon: Icons.wb_sunny_outlined,
              label: 'Sombre',
              value: isDarkMode,
              onChanged: (_) => onThemeToggle(),
            ),
            
            // Scanner Toggle
            _buildSwitchTile(
              icon: Icons.qr_code_scanner,
              label: 'Scanner',
              value: isScannerEnabled,
              onChanged: (_) => onScannerToggle(),
            ),
            
            const SizedBox(height: 16),
            
            // Language Selector
            _buildLanguageTile(context),
            
            const SizedBox(height: 16),
            
            // Logout
            _buildLogoutTile(),
            
            const Spacer(),
            
            // Version
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                'OMPAY Version - 1.1.0(35)',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryOrange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 28),
          const SizedBox(width: 16),
          Text(label, style: AppTextStyles.bodyLarge),
          const Spacer(),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.language, color: AppColors.textPrimary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: selectedLanguage,
              dropdownColor: AppColors.cardBackground,
              isExpanded: true,
              underline: Container(),
              style: AppTextStyles.bodyLarge,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
              items: ['Français', 'Wolof', 'English'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onLanguageChanged(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutTile() {
    return GestureDetector(
      onTap: onLogout,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.logout, color: AppColors.textPrimary, size: 28),
            const SizedBox(width: 16),
            Text('Se déconnecter', style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }
}
