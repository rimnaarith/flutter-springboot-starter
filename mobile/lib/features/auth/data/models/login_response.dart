class LoginResponse {
  final String email;
  final String accessToken;

  LoginResponse({
    required this.email,
    required this.accessToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      email: json['email'],
      accessToken: json['accessToken'],
    );
  }
}