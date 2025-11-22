class ErrorMessages {
  // ========================================
  // ERREURS D'AUTHENTIFICATION (Backend sync)
  // ========================================
  static const String telephoneRequis = 'Le numéro de téléphone est obligatoire';
  static const String telephoneInvalide = 'Format de téléphone invalide (ex: 771234567)';
  static const String telephoneExiste = 'Ce numéro de téléphone est déjà utilisé';
  static const String emailExiste = 'Cet email est déjà utilisé';
  static const String emailInvalide = 'Format d\'email invalide';
  static const String emailRequis = 'L\'email est obligatoire';
  static const String motDePasseRequis = 'Le mot de passe est obligatoire';
  static const String motDePasseCourt = 'Le mot de passe doit contenir au moins 6 caractères';
  static const String motDePasseIncorrect = 'Mot de passe incorrect';
  static const String codePinRequis = 'Le code PIN est obligatoire';
  static const String codePinInvalide = 'Le code PIN doit contenir exactement 6 chiffres';
  static const String codePinIncorrect = 'Code PIN incorrect';
  static const String codeSecretRequis = 'Le code secret est requis';
  static const String utilisateurNonTrouve = 'Utilisateur non trouvé';
  static const String compteBloque = 'Votre compte est bloqué. Contactez le service client';
  static const String compteInactif = 'Votre compte est inactif';
  static const String compteNonActive = 'Compte non activé. Veuillez utiliser votre code secret pour activer votre compte';
  static const String nonAutorise = 'Vous n\'êtes pas autorisé à effectuer cette action';
  static const String tokenInvalide = 'Token invalide ou expiré';
  static const String sessionExpiree = 'Votre session a expiré. Veuillez vous reconnecter';

  // ========================================
  // ERREURS DE VALIDATION (Backend sync)
  // ========================================
  static const String nomRequis = 'Le nom est obligatoire';
  static const String prenomRequis = 'Le prénom est obligatoire';
  static const String telephoneFormatInvalide = 'Format de téléphone invalide. Doit commencer par 77, 78, 76, 70 ou 75 suivi de 7 chiffres';
  static const String montantRequis = 'Le montant est obligatoire';
  static const String montantInvalide = 'Montant invalide';
  static const String montantNegatif = 'Le montant ne peut pas être négatif';
  static const String montantZero = 'Le montant doit être supérieur à zéro';
  static const String montantTropEleve = 'Le montant dépasse le plafond autorisé';
  static const String numeroCompteInvalide = 'Numéro de compte invalide. Doit commencer par OM suivi de 10 chiffres';
  static const String destinataireRequis = 'Le destinataire est requis';
  static const String codeMarchandRequis = 'Le code marchand est requis';
  static const String champRequis = 'Ce champ est requis';

  // ========================================
  // ERREURS DE COMPTE (Backend sync)
  // ========================================
  static const String compteNonTrouve = 'Compte non trouvé';
  static const String soldeInsuffisant = 'Solde insuffisant pour effectuer cette opération';
  static const String compteEstBloque = 'Ce compte est bloqué';
  static const String compteEstInactif = 'Ce compte est inactif';
  static const String soldeIndisponible = 'Impossible de récupérer le solde';
  static const String numeroCompteIndisponible = 'Impossible de récupérer le numéro de compte';

  // ========================================
  // ERREURS DE TRANSACTION (Backend sync)
  // ========================================
  static const String transactionEchouee = 'La transaction a échoué';
  static const String transactionNonTrouvee = 'Transaction non trouvée';
  static const String plafondDepasse = 'Plafond quotidien dépassé';
  static const String erreurCalculFrais = 'Erreur lors du calcul des frais';
  static const String destinataireInvalide = 'Destinataire invalide';
  static const String expediteurInvalide = 'Expéditeur invalide';
  static const String memeCompte = 'Vous ne pouvez pas transférer vers le même compte';
  static const String transfertEchoue = 'Impossible d\'effectuer le transfert';
  static const String paiementEchoue = 'Impossible d\'effectuer le paiement';
  static const String historiqueIndisponible = 'Impossible de récupérer l\'historique';

  // ========================================
  // ERREURS MARCHAND (Backend sync)
  // ========================================
  static const String marchandNonTrouve = 'Marchand non trouvé';
  static const String codeMarchandInvalide = 'Code marchand invalide';
  static const String marchandInactif = 'Ce marchand est inactif';

  // ========================================
  // ERREURS DISTRIBUTEUR (Backend sync)
  // ========================================
  static const String distributeurNonTrouve = 'Distributeur non trouvé';
  static const String distributeurNonAutorise = 'Vous n\'êtes pas autorisé à effectuer cette opération distributeur';
  static const String distributeurSoldeInsuffisant = 'Le distributeur n\'a pas assez de solde';

  // ========================================
  // ERREURS GÉNÉRALES (Backend sync)
  // ========================================
  static const String erreurInterne = 'Une erreur interne s\'est produite';
  static const String requeteInvalide = 'Requête invalide';
  static const String ressourceNonTrouvee = 'Ressource non trouvée';
  static const String accesRefuse = 'Accès refusé';
  static const String conflitDetecte = 'Conflit détecté';
  static const String erreurReseau = 'Erreur de connexion réseau';
  static const String serveurIndisponible = 'Le serveur est indisponible';
  static const String timeoutConnexion = 'Délai de connexion dépassé';
  
  // Alias pour compatibilité
  static const String connexionEchouee = 'Erreur lors de la connexion';
  static const String inscriptionEchouee = 'Erreur lors de l\'inscription';
  static const String verificationEchouee = 'Erreur lors de la vérification du code secret';
  static const String deconnexionEchouee = 'Erreur lors de la déconnexion';

  // ========================================
  // MESSAGES DE SUCCÈS (Backend sync)
  // ========================================
  static const String inscriptionReussie = 'Inscription réussie';
  static const String connexionReussie = 'Connexion réussie';
  static const String deconnexionReussie = 'Déconnexion réussie';
  static const String motDePasseChange = 'Mot de passe modifié avec succès';
  static const String transfertReussi = 'Transfert effectué avec succès';
  static const String depotReussi = 'Dépôt effectué avec succès';
  static const String retraitReussi = 'Retrait effectué avec succès';
  static const String paiementReussi = 'Paiement effectué avec succès';
  static const String verificationReussie = 'Vérification réussie';

  // ========================================
  // MESSAGES D'INFORMATION
  // ========================================
  static const String pasConnecte = 'Vous devez être connecté';
  static const String dejaConnecte = 'Vous êtes déjà connecté';
  static const String aucuneTransaction = 'Aucune transaction trouvée';

  // ========================================
  // MÉTHODES UTILITAIRES
  // ========================================
  static String avecDetails(String message, dynamic erreur) {
    return '$message: $erreur';
  }

  /// Parse l'erreur retournée par le backend et retourne le message approprié
  static String parseBackendError(dynamic error) {
    if (error == null) return erreurInterne;
    
    final errorString = error.toString().toLowerCase();
    
    // Gestion spéciale pour HTTP 401 (Unauthorized) - Identifiants incorrects
    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return motDePasseIncorrect; // "Mot de passe incorrect"
    }
    
    // Authentification
    if (errorString.contains('identifiants') || errorString.contains('credentials')) return motDePasseIncorrect;
    if (errorString.contains('téléphone') && errorString.contains('obligatoire')) return telephoneRequis;
    if (errorString.contains('téléphone') && (errorString.contains('invalide') || errorString.contains('format'))) return telephoneInvalide;
    if (errorString.contains('téléphone') && errorString.contains('utilisé')) return telephoneExiste;
    if (errorString.contains('email') && errorString.contains('utilisé')) return emailExiste;
    if (errorString.contains('email') && errorString.contains('invalide')) return emailInvalide;
    if (errorString.contains('mot de passe') && errorString.contains('obligatoire')) return motDePasseRequis;
    if (errorString.contains('mot de passe') && errorString.contains('incorrect')) return motDePasseIncorrect;
    if (errorString.contains('mot de passe') && errorString.contains('6')) return motDePasseCourt;
    if (errorString.contains('code pin') && errorString.contains('obligatoire')) return codePinRequis;
    if (errorString.contains('code pin') && errorString.contains('6')) return codePinInvalide;
    if (errorString.contains('code pin') && errorString.contains('incorrect')) return codePinIncorrect;
    if (errorString.contains('code secret')) return codeSecretRequis;
    if (errorString.contains('utilisateur non trouvé')) return utilisateurNonTrouve;
    if (errorString.contains('bloqué')) return compteBloque;
    if (errorString.contains('inactif')) return compteInactif;
    if (errorString.contains('token') || errorString.contains('expiré') || errorString.contains('session')) return sessionExpiree;
    if (errorString.contains('activé') || errorString.contains('activation')) return compteNonActive;
    if (errorString.contains('autorisé') || errorString.contains('autorisation')) return nonAutorise;
    
    // Validation
    if (errorString.contains('nom') && errorString.contains('obligatoire')) return nomRequis;
    if (errorString.contains('prénom') && errorString.contains('obligatoire')) return prenomRequis;
    if (errorString.contains('montant') && errorString.contains('obligatoire')) return montantRequis;
    if (errorString.contains('montant') && errorString.contains('invalide')) return montantInvalide;
    if (errorString.contains('montant') && errorString.contains('négatif')) return montantNegatif;
    if (errorString.contains('montant') && errorString.contains('zéro')) return montantZero;
    if (errorString.contains('montant') && errorString.contains('plafond')) return montantTropEleve;
    if (errorString.contains('numéro de compte') && errorString.contains('invalide')) return numeroCompteInvalide;
    
    // Compte
    if (errorString.contains('solde insuffisant')) return soldeInsuffisant;
    if (errorString.contains('compte non trouvé')) return compteNonTrouve;
    if (errorString.contains('compte') && errorString.contains('bloqué')) return compteEstBloque;
    if (errorString.contains('compte') && errorString.contains('inactif')) return compteEstInactif;
    
    // Transaction
    if (errorString.contains('plafond')) return plafondDepasse;
    if (errorString.contains('transaction') && errorString.contains('échoué')) return transactionEchouee;
    if (errorString.contains('transaction non trouvée')) return transactionNonTrouvee;
    if (errorString.contains('même compte')) return memeCompte;
    if (errorString.contains('destinataire') && errorString.contains('invalide')) return destinataireInvalide;
    if (errorString.contains('expéditeur') && errorString.contains('invalide')) return expediteurInvalide;
    if (errorString.contains('frais')) return erreurCalculFrais;
    
    // Marchand
    if (errorString.contains('marchand non trouvé')) return marchandNonTrouve;
    if (errorString.contains('code marchand') && errorString.contains('invalide')) return codeMarchandInvalide;
    if (errorString.contains('marchand') && errorString.contains('inactif')) return marchandInactif;
    if (errorString.contains('marchand') && errorString.contains('trouvé')) return marchandNonTrouve;
    
    // Ressources non trouvées (404)
    if (errorString.contains('404')) {
      if (errorString.contains('marchand')) return marchandNonTrouve;
      if (errorString.contains('compte')) return compteNonTrouve;
      if (errorString.contains('utilisateur')) return utilisateurNonTrouve;
      if (errorString.contains('transaction')) return transactionNonTrouvee;
      return ressourceNonTrouvee;
    }
    
    // Distributeur
    if (errorString.contains('distributeur non trouvé')) return distributeurNonTrouve;
    if (errorString.contains('distributeur') && errorString.contains('autorisé')) return distributeurNonAutorise;
    if (errorString.contains('distributeur') && errorString.contains('solde')) return distributeurSoldeInsuffisant;
    
    // Réseau
    if (errorString.contains('network') || errorString.contains('connexion')) return erreurReseau;
    if (errorString.contains('timeout')) return timeoutConnexion;
    if (errorString.contains('serveur') || errorString.contains('server')) return serveurIndisponible;
    
    // Général
    if (errorString.contains('accès refusé') || errorString.contains('forbidden')) return accesRefuse;
    if (errorString.contains('ressource non trouvée') || errorString.contains('not found')) return ressourceNonTrouvee;
    if (errorString.contains('conflit') || errorString.contains('conflict')) return conflitDetecte;
    if (errorString.contains('requête invalide') || errorString.contains('bad request')) return requeteInvalide;
    
    // Par défaut, retourner le message d'erreur brut nettoyé ou un message générique
    String cleanError = error.toString()
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .trim();
    
    return cleanError.isNotEmpty ? cleanError : erreurInterne;
  }
}

