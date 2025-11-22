class TransactionResponse {
  final int id;
  final String reference;
  final String typeTransaction;
  final double montant;
  final double frais;
  final double montantTotal;
  final String statut;
  final String? compteExpediteur;
  final String? compteDestinataire;
  final String? telephoneDistributeur;
  final String? nomMarchand;
  final String? description;
  final String dateCreation;
  final double nouveauSolde;

  TransactionResponse({
    required this.id,
    required this.reference,
    required this.typeTransaction,
    required this.montant,
    required this.frais,
    required this.montantTotal,
    required this.statut,
    this.compteExpediteur,
    this.compteDestinataire,
    this.telephoneDistributeur,
    this.nomMarchand,
    this.description,
    required this.dateCreation,
    required this.nouveauSolde,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      reference: json['reference'],
      typeTransaction: json['typeTransaction'],
      montant: (json['montant'] as num).toDouble(),
      frais: (json['frais'] as num).toDouble(),
      montantTotal: (json['montantTotal'] as num).toDouble(),
      statut: json['statut'],
      compteExpediteur: json['compteExpediteur'],
      compteDestinataire: json['compteDestinataire'],
      telephoneDistributeur: json['telephoneDistributeur'],
      nomMarchand: json['nomMarchand'],
      description: json['description'],
      dateCreation: json['dateCreation'],
      nouveauSolde: (json['nouveauSolde'] as num).toDouble(),
    );
  }

  String get formattedMontant => montant.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]} ',
      );

  String get formattedDate {
    try {
      final date = DateTime.parse(dateCreation);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateCreation;
    }
  }
}
