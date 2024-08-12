class AuthResponse {
  final String token;
  final List<String> roles;

  AuthResponse({required this.token, required this.roles});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      roles: List<String>.from(json['roles']),
    );
  }
}
