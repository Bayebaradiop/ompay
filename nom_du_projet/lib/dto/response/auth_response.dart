import 'user_response.dart';

class AuthResponse {
  final bool success;
  final String message;
  final String? token;
  final String? codeSecret;
  final UserResponse? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.token,
    this.codeSecret,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Le backend peut retourner les données dans 'data' ou directement à la racine
    final data = json['data'] ?? json;
    
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: data['token'],
      codeSecret: data['codeSecret'],
      user: data['user'] != null 
          ? UserResponse.fromJson(data['user'])
          : null,
    );
  }
}
