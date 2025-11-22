class PaiementRequest {
  final String codeMarchand;
  final double montant;

  PaiementRequest({
    required this.codeMarchand,
    required this.montant,
  });

  Map<String, dynamic> toJson() {
    return {
      'codeMarchand': codeMarchand,
      'montant': montant,
    };
  }
}
