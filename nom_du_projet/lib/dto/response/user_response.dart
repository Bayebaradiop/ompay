import '../../enums/role.dart';
import '../../enums/statut.dart';

class UserResponse {
  final int? id;
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final Role role;
  final Statut statut;
  final bool? premiereConnexion;
  final String? dateCreation;

  UserResponse({
    this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.role,
    required this.statut,
    this.premiereConnexion,
    this.dateCreation,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      email: json['email'] ?? '',
      role: Role.fromString(json['role']),
      statut: json['statut'] != null
          ? Statut.fromString(json['statut'])
          : Statut.ACTIF,
      premiereConnexion: json['premiereConnexion'],
      dateCreation: json['dateCreation'],
    );
  }

  String get fullName => '$prenom $nom';
}
