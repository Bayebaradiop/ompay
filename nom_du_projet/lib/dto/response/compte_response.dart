import '../../enums/statut.dart';

class CompteResponse {
  final int? id;
  final String numeroCompte;
  final double solde;
  final String typeCompte;
  final Statut statut;
  final String? dateCreation;

  CompteResponse({
    this.id,
    required this.numeroCompte,
    required this.solde,
    required this.typeCompte,
    required this.statut,
    this.dateCreation,
  });

  factory CompteResponse.fromJson(Map<String, dynamic> json) {
    return CompteResponse(
      id: json['id'],
      numeroCompte: json['numeroCompte'],
      solde: (json['solde'] as num).toDouble(),
      typeCompte: json['typeCompte'],
      statut: Statut.fromString(json['statut']),
      dateCreation: json['dateCreation'],
    );
  }
}
