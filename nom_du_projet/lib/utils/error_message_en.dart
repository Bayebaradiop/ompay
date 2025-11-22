class ErrorMessages {

  static const String loginFailed = 'Login failed';
  static const String signupFailed = 'Registration failed';
  static const String verificationFailed = 'Secret code verification failed';
  static const String accountNotActive = 'Account not activated. Please use your secret code to activate your account (Option 2).';
  static const String logoutFailed = 'Logout failed';


  static const String balanceUnavailable = 'Unable to retrieve balance';
  static const String accountNumberUnavailable = 'Unable to retrieve account number';


  static const String transferFailed = 'Unable to complete the transfer';
  static const String paymentFailed = 'Unable to complete the payment';
  static const String historyUnavailable = 'Unable to retrieve history';


  static const String fieldRequired = 'This field is required';
  static const String nameRequired = 'Name is required';
  static const String firstNameRequired = 'First name is required';
  static const String phoneRequired = 'Phone number is required';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';
  static const String secretCodeRequired = 'Secret code is required';
  static const String amountRequired = 'Amount is required';
  static const String recipientRequired = 'Recipient is required';
  static const String merchantCodeRequired = 'Merchant code is required';

  // Network messages
  static const String networkError = 'Network connection error';
  static const String serverUnavailable = 'Server is unavailable';
  static const String connectionTimeout = 'Connection timeout exceeded';

  // Success messages
  static const String loginSuccess = 'Login successful';
  static const String signupSuccess = 'Registration successful';
  static const String verificationSuccess = 'Verification successful';
  static const String transferSuccess = 'Transfer completed successfully';
  static const String paymentSuccess = 'Payment completed successfully';
  static const String logoutSuccess = 'Logout successful';

  // Information messages
  static const String notLoggedIn = 'You must be logged in';
  static const String alreadyLoggedIn = 'You are already logged in';
  static const String noTransactionFound = 'No transaction found';

  // Utility method for formatting error messages
  static String withDetails(String message, dynamic error) {
    return '$message: $error';
  }
}
