class ApiConstants {
  
  static const String baseUrl = 'https://om-pay-spring-boot-1.onrender.com/api';
  
  
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String verifyCodeSecretEndpoint = '/auth/verify-code-secret';
  static const String profilEndpoint = '/auth/me';
  static const String soldeEndpoint = '/comptes/solde';
  static const String transfertEndpoint = '/transactions/transfert';
  static const String paiementEndpoint = '/transactions/paiement';
  static const String historiqueEndpoint = '/transactions/historique';
}