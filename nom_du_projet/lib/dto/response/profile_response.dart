import 'compte_response.dart';

class ProfileResponse {
  final int id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String role;
  final String statut;
  final CompteResponse? compte;

  ProfileResponse({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.role,
    required this.statut,
    this.compte,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    
    return ProfileResponse(
      id: data['id'],
      nom: data['nom'],
      prenom: data['prenom'],
      telephone: data['telephone'],
      email: data['email'] ?? '',
      role: data['role'],
      statut: data['statut'],
      compte: data['compte'] != null 
          ? CompteResponse.fromJson(data['compte'])
          : null,
    );
  }

  String get fullName => '$prenom $nom';
}
