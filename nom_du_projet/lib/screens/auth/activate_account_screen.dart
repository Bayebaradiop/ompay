import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_snackbar.dart';
import '../../services/auth_service.dart';
import '../../utils/error_messages.dart';

class ActivateAccountScreen extends StatefulWidget {
  final String phoneNumber;

  const ActivateAccountScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<ActivateAccountScreen> createState() => _ActivateAccountScreenState();
}

class _ActivateAccountScreenState extends State<ActivateAccountScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final _authService = AuthService();
  bool _isLoading = false;
  String? _codeError;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleVerification() async {
    setState(() => _codeError = null);
    
    final code = _controllers.map((c) => c.text).join();
    
    if (code.length != 6) {
      setState(() => _codeError = ErrorMessages.codeSecretRequis);
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await _authService.verifyCodeSecret(
        telephone: widget.phoneNumber,
        codeSecret: code,
      );
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      String errorMessage = ErrorMessages.parseBackendError(e);
      setState(() => _codeError = errorMessage);
    }
  }

  void _handleResend() {
    if (mounted) {
      CustomSnackbar.showSuccess(
        context,
        'Code renvoyé avec succès',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.mark_email_read,
                    size: 50,
                    color: AppColors.primaryOrange,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Activation du compte',
                style: AppTextStyles.header2,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              Text(
                'Un code secret à 6 chiffres a été envoyé au',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                widget.phoneNumber,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              // Code input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildCodeBox(index)),
              ),
              
              // Message d'erreur
              if (_codeError != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.redError.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.redError),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppColors.redError, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _codeError!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.redError,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // Renvoyer le code
              Center(
                child: TextButton(
                  onPressed: _handleResend,
                  child: Text(
                    'Renvoyer le code',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Bouton valider
              CustomButton(
                text: 'Activer mon compte',
                onPressed: _handleVerification,
                isLoading: _isLoading,
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeBox(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _controllers[index].text.isNotEmpty
              ? AppColors.primaryOrange
              : Colors.grey.withOpacity(0.3),
          width: _controllers[index].text.isNotEmpty ? 3 : 1,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.text,
        maxLength: 1,
        obscureText: false,
        cursorColor: AppColors.primaryOrange,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        ],
        onChanged: (value) {
          if (_codeError != null) {
            setState(() => _codeError = null);
          }
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }
}
