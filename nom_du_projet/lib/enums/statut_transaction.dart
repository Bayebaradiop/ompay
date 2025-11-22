enum StatutTransaction {
  EN_COURS,
  REUSSI,
  ECHOUE,
  ANNULE,
  REMBOURSE;

  static StatutTransaction fromString(String value) {
    return StatutTransaction.values.firstWhere(
      (statut) => statut.name == value,
      orElse: () => StatutTransaction.EN_COURS,
    );
  }

  @override
  String toString() => name;
}
