import '../dto/request/login_request.dart';
import '../dto/request/register_request.dart';
import '../dto/request/verify_code_request.dart';
import '../dto/response/auth_response.dart';
import '../api_service/api_service.dart';
import '../utils/constants.dart';
import '../utils/error_messages.dart';

class PremiereConnexionException implements Exception {
  final String message;
  PremiereConnexionException(this.message);
  
  @override
  String toString() => message;
}

/// Service d'authentification
class AuthService {
  final ApiService _apiService = ApiService();

  Future<AuthResponse> register({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String motDePasse,
    String? codePin,
  }) async {
    try {
      final request = RegisterRequest(
        nom: nom,
        prenom: prenom,
        telephone: telephone,
        email: email,
        motDePasse: motDePasse,
        codePin: codePin,
      );

      final response = await _apiService.post(
        ApiConstants.registerEndpoint,
        request.toJson(),
      );
      
      return AuthResponse.fromJson(response);
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }

  Future<void> verifyCodeSecret({
    required String telephone,
    required String codeSecret,
  }) async {
    try {
      final request = VerifyCodeRequest(
        telephone: telephone,
        codeSecret: codeSecret,
      );

      final response = await _apiService.post(
        ApiConstants.verifyCodeSecretEndpoint,
        request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response);
      
      if (authResponse.token != null) {
        _apiService.token = authResponse.token!;
      }
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }

  /// Connexion d'un utilisateur
  Future<void> login({
    required String telephone,
    required String motDePasse,
  }) async {
    try {
      final request = LoginRequest(
        telephone: telephone,
        motDePasse: motDePasse,
      );

      final response = await _apiService.post(
        ApiConstants.loginEndpoint,
        request.toJson(),
      );

      final data = response['data'] as Map<String, dynamic>;
      final token = data['token'] as String;

      _apiService.token = token;
    } catch (e) {
      final errorMessage = e.toString().toLowerCase();
      
      // Détecter si c'est une première connexion non activée
      if (errorMessage.contains('première connexion') || 
          errorMessage.contains('activer') ||
          errorMessage.contains('code secret') ||
          errorMessage.contains('compte non activé')) {
        throw PremiereConnexionException(ErrorMessages.compteNonActive);
      }
      
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }

  /// Vérifie si l'utilisateur est connecté
  bool isLoggedIn() {
    return _apiService.token != null && _apiService.token!.isNotEmpty;
  }

  /// Récupère le token actuel
  String? getToken() {
    return _apiService.token;
  }

  /// Récupère le profil de l'utilisateur connecté
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.getWithAuth(
        ApiConstants.profilEndpoint,
      );

      return response['data'] as Map<String, dynamic>;
    } catch (e) {
      throw Exception(ErrorMessages.parseBackendError(e));
    }
  }

  /// Déconnexion
  void logout() {
    _apiService.token = null;
  }
}