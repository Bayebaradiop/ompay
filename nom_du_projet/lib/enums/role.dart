enum Role {
  CLIENT,
  DISTRIBUTEUR,
  MARCHAND;

  static Role fromString(String value) {
    return Role.values.firstWhere(
      (role) => role.name == value,
      orElse: () => Role.CLIENT,
    );
  }

  @override
  String toString() => name;
}
