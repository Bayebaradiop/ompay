class VerifyCodeRequest {
  final String telephone;
  final String codeSecret;

  VerifyCodeRequest({
    required this.telephone,
    required this.codeSecret,
  });

  Map<String, dynamic> toJson() {
    return {
      'telephone': telephone,
      'codeSecret': codeSecret,
    };
  }
}
