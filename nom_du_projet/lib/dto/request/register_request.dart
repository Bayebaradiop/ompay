class RegisterRequest {
  final String nom;
  final String prenom;
  final String telephone;
  final String email;
  final String motDePasse;
  final String? codePin;
  final String role;

  RegisterRequest({
    required this.nom,
    required this.prenom,
    required this.telephone,
    required this.email,
    required this.motDePasse,
    this.codePin,
    this.role = 'CLIENT',
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'motDePasse': motDePasse,
      if (codePin != null) 'codePin': codePin,
      'role': role,
    };
  }
}
