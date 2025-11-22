import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../services/auth_service.dart';
import '../../utils/error_messages.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _nomError;
  String? _prenomError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _nomError = null;
      _prenomError = null;
      _phoneError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
    });
  }

  void _handleRegister() async {
    _clearErrors();
    
    // Validation locale
    bool hasError = false;
    
    if (_nomController.text.trim().isEmpty) {
      setState(() => _nomError = ErrorMessages.nomRequis);
      hasError = true;
    }
    
    if (_prenomController.text.trim().isEmpty) {
      setState(() => _prenomError = ErrorMessages.prenomRequis);
      hasError = true;
    }
    
    if (_phoneController.text.trim().isEmpty) {
      setState(() => _phoneError = ErrorMessages.telephoneRequis);
      hasError = true;
    } else if (_phoneController.text.trim().length < 9) {
      setState(() => _phoneError = ErrorMessages.telephoneInvalide);
      hasError = true;
    }
    
    if (_emailController.text.trim().isEmpty) {
      setState(() => _emailError = ErrorMessages.emailRequis);
      hasError = true;
    } else if (!_emailController.text.contains('@')) {
      setState(() => _emailError = ErrorMessages.emailInvalide);
      hasError = true;
    }
    
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = ErrorMessages.motDePasseRequis);
      hasError = true;
    } else if (_passwordController.text.length < 6) {
      setState(() => _passwordError = ErrorMessages.motDePasseCourt);
      hasError = true;
    }
    
    if (_confirmPasswordController.text.isEmpty) {
      setState(() => _confirmPasswordError = 'Veuillez confirmer votre mot de passe');
      hasError = true;
    } else if (_confirmPasswordController.text != _passwordController.text) {
      setState(() => _confirmPasswordError = 'Les mots de passe ne correspondent pas');
      hasError = true;
    }
    
    if (hasError) return;
    
    setState(() => _isLoading = true);
    
    try {
      await _authService.register(
        nom: _nomController.text.trim(),
        prenom: _prenomController.text.trim(),
        telephone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        motDePasse: _passwordController.text,
      );
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/activate',
          arguments: _phoneController.text.trim(),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      String errorMessage = ErrorMessages.parseBackendError(e);
      
      // Analyser et afficher l'erreur sous le champ approprié
      if (errorMessage.contains('nom') && !errorMessage.contains('prénom')) {
        setState(() => _nomError = errorMessage);
      } else if (errorMessage.contains('prénom')) {
        setState(() => _prenomError = errorMessage);
      } else if (errorMessage.contains('téléphone') || errorMessage.contains('existe déjà')) {
        setState(() => _phoneError = errorMessage);
      } else if (errorMessage.contains('email') || errorMessage.contains('e-mail')) {
        setState(() => _emailError = errorMessage);
      } else if (errorMessage.contains('mot de passe')) {
        setState(() => _passwordError = errorMessage);
      } else {
        // Erreur générale sous le dernier champ
        setState(() => _confirmPasswordError = errorMessage);
      }
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Inscription', style: AppTextStyles.header1),
                const SizedBox(height: 8),
                Text(
                  'Créez votre compte Orange Money',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Nom
                CustomTextField(
                  hintText: 'Nom',
                  controller: _nomController,
                  prefixIcon: const Icon(Icons.person, color: AppColors.primaryOrange),
                  errorText: _nomError,
                  onChanged: (value) {
                    if (_nomError != null) setState(() => _nomError = null);
                  },
                ),
                const SizedBox(height: 16),
                
                // Prénom
                CustomTextField(
                  hintText: 'Prénom',
                  controller: _prenomController,
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryOrange),
                  errorText: _prenomError,
                  onChanged: (value) {
                    if (_prenomError != null) setState(() => _prenomError = null);
                  },
                ),
                const SizedBox(height: 16),
                
                // Téléphone
                CustomTextField(
                  hintText: 'Numéro de téléphone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone, color: AppColors.primaryOrange),
                  errorText: _phoneError,
                  onChanged: (value) {
                    if (_phoneError != null) setState(() => _phoneError = null);
                  },
                ),
                const SizedBox(height: 16),
                
                // Email
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email, color: AppColors.primaryOrange),
                  errorText: _emailError,
                  onChanged: (value) {
                    if (_emailError != null) setState(() => _emailError = null);
                  },
                ),
                const SizedBox(height: 16),
                
                // Mot de passe
                CustomTextField(
                  hintText: 'Mot de passe',
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock, color: AppColors.primaryOrange),
                  errorText: _passwordError,
                  onChanged: (value) {
                    if (_passwordError != null) setState(() => _passwordError = null);
                  },
                ),
                const SizedBox(height: 16),
                
                // Confirmer mot de passe
                CustomTextField(
                  hintText: 'Confirmer le mot de passe',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primaryOrange),
                  errorText: _confirmPasswordError,
                  onChanged: (value) {
                    if (_confirmPasswordError != null) setState(() => _confirmPasswordError = null);
                  },
                ),
                const SizedBox(height: 32),
                
                // Bouton inscription
                CustomButton(
                  text: 'S\'inscrire',
                  onPressed: _handleRegister,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
                
                // Connexion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Déjà un compte ? ', style: AppTextStyles.bodyMedium),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Se connecter',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
