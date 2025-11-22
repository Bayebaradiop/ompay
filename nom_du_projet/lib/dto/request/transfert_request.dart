class TransfertRequest {
  final String telephoneDestinataire;
  final double montant;

  TransfertRequest({
    required this.telephoneDestinataire,
    required this.montant,
  });

  Map<String, dynamic> toJson() {
    return {
      'telephoneDestinataire': telephoneDestinataire,
      'montant': montant,
    };
  }
}
