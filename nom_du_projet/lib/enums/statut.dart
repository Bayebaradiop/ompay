enum Statut {
  ACTIF,
  INACTIF,
  SUSPENDU,
  BLOQUE;

  static Statut fromString(String value) {
    return Statut.values.firstWhere(
      (statut) => statut.name == value,
      orElse: () => Statut.INACTIF,
    );
  }

  @override
  String toString() => name;
}
