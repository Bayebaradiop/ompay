import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/carousel_image.dart';
import '../../services/auth_service.dart';
import '../../utils/error_messages.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  String? _phoneError;
  String? _passwordError;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearErrors() {
    setState(() {
      _phoneError = null;
      _passwordError = null;
    });
  }

  void _handleLogin() async {
    _clearErrors();
    
    // Validation locale
    bool hasError = false;
    
    if (_phoneController.text.trim().isEmpty) {
      setState(() => _phoneError = ErrorMessages.telephoneRequis);
      hasError = true;
    } else if (_phoneController.text.trim().length < 9) {
      setState(() => _phoneError = ErrorMessages.telephoneInvalide);
      hasError = true;
    }
    
    if (_passwordController.text.isEmpty) {
      setState(() => _passwordError = ErrorMessages.motDePasseRequis);
      hasError = true;
    } else if (_passwordController.text.length < 6) {
      setState(() => _passwordError = ErrorMessages.motDePasseCourt);
      hasError = true;
    }
    
    if (hasError) return;
    
    setState(() => _isLoading = true);
    
    try {
      await _authService.login(
        telephone: _phoneController.text.trim(),
        motDePasse: _passwordController.text,
      );
      
      setState(() => _isLoading = false);
      
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on PremiereConnexionException catch (e) {
      setState(() {
        _isLoading = false;
        _phoneError = e.message;
      });
      
      if (mounted) {
        // Naviguer vers l'activation après 2 secondes
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushNamed(
              context,
              '/activate',
              arguments: _phoneController.text.trim(),
            );
          }
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      String errorMessage = ErrorMessages.parseBackendError(e);
      
    
      if (errorMessage == ErrorMessages.motDePasseIncorrect ||
          e.toString().toLowerCase().contains('401') ||
          e.toString().toLowerCase().contains('unauthorized')) {
        setState(() => _passwordError = 'Téléphone ou mot de passe incorrect');
      } else if (errorMessage.contains('téléphone') || 
                 errorMessage.contains('utilisateur') ||
                 errorMessage.contains('introuvable') ||
                 errorMessage.contains('n\'existe pas')) {
        setState(() => _phoneError = errorMessage);
      } else if (errorMessage.contains('mot de passe') || 
                 errorMessage.contains('incorrect')) {
        setState(() => _passwordError = errorMessage);
      } else {
        // Pour les autres erreurs (réseau, serveur), afficher sous mot de passe
        setState(() => _passwordError = errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Carousel d'images en haut
              const CarouselImage(),
              
              // Formulaire de connexion
              Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      
                      Text(
                        'Bienvenue sur OM Pay!',
                        style: AppTextStyles.header2,
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'Entrez votre numéro mobile pour vous connecter',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Téléphone
                      CustomTextField(
                        hintText: 'Numéro de téléphone',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: const Icon(Icons.phone, color: AppColors.primaryOrange),
                        errorText: _phoneError,
                        onChanged: (value) {
                          if (_phoneError != null) {
                            setState(() => _phoneError = null);
                          }
                        },
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Mot de passe
                      CustomTextField(
                        hintText: 'Mot de passe',
                        controller: _passwordController,
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock, color: AppColors.primaryOrange),
                        errorText: _passwordError,
                        onChanged: (value) {
                          if (_passwordError != null) {
                            setState(() => _passwordError = null);
                          }
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Mot de passe oublié
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // TODO: Implement forgot password
                          },
                          child: Text(
                            'Mot de passe oublié ?',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Bouton connexion
                      CustomButton(
                        text: 'Se connecter',
                        onPressed: _handleLogin,
                        isLoading: _isLoading,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Inscription
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pas encore de compte ? ',
                            style: AppTextStyles.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            child: Text(
                              'S\'inscrire',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Lien vers activation
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/activate', arguments: _phoneController.text.trim());
                          },
                          child: Text(
                            'Activer mon compte',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}