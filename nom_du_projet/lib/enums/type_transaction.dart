enum TypeTransaction {
  TRANSFERT,
  DEPOT,
  RETRAIT,
  PAIEMENT,
  RECHARGE;

  static TypeTransaction fromString(String value) {
    return TypeTransaction.values.firstWhere(
      (type) => type.name == value,
      orElse: () => TypeTransaction.TRANSFERT,
    );
  }

  @override
  String toString() => name;
}
