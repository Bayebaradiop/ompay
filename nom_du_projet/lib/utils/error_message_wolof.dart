class ErrorMessages {
  static const String loginFailed = 'Njumté ci jokkoo bi';
  static const String signupFailed = 'Njumté ci inscripción bi';
  static const String verificationFailed = 'Njumté ci wóoral kóodu bi';
  static const String accountNotActive = 'Kompu bi du aktive. Jëfandikoo sa kóodu sargal ngir aktive sa kompu (Option 2).';
  static const String logoutFailed = 'Njumté ci génn bi';

  static const String balanceUnavailable = 'Mënula am solde bi';
  static const String accountNumberUnavailable = 'Mënula am numérou kompu bi';

  static const String transferFailed = 'Mënula def transfert bi';
  static const String paymentFailed = 'Mënula def peyima bi';
  static const String historyUnavailable = 'Mënula am liste transaction yi';

  static const String fieldRequired = 'Bëgg na ñu indil';
  static const String nameRequired = 'Tur bi war na am';
  static const String firstNameRequired = 'Sang bi war na am';
  static const String phoneRequired = 'Téléfoon bi war na am';
  static const String emailRequired = 'Email bi war na am';
  static const String passwordRequired = 'Katu baatu wi war na am';
  static const String secretCodeRequired = 'Kóodu sargi bi war na am';
  static const String amountRequired = 'Luy jar ñi war na am';
  static const String recipientRequired = 'Ku nara jot bi war na am';
  static const String merchantCodeRequired = 'Kóodu marchandi bi war na am';


  static const String networkError = 'Njumté ci réseau bi';
  static const String serverUnavailable = 'Serveur bi nekkul';
  static const String connectionTimeout = 'Juroom-jurom benn waxtu jokkoo bi weesu';


  static const String loginSuccess = 'Jokkoo bi am na';
  static const String signupSuccess = 'Inscripción bi am na';
  static const String verificationSuccess = 'Wóoral bi am na';
  static const String transferSuccess = 'Transfert bi am na ci ndam';
  static const String paymentSuccess = 'Peyima bi am na ci ndam';
  static const String logoutSuccess = 'Génn bi am na';


  static const String notLoggedIn = 'Faw nga dugg ci sa kompu';
  static const String alreadyLoggedIn = 'Dugg nga ba pare ba pare';
  static const String noTransactionFound = 'Amu transaction bu ñu gis';

  static String withDetails(String message, dynamic error) {
    return '$message: $error';
  }
}
