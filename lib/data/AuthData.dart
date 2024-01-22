class AuthData {
  final String token;
  final String username;
  final String refreshToken;

  AuthData(this.token, this.username, this.refreshToken);

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        "token" : String token,
        "username": String username,
        "refreshToken": String refreshToken,
        "role": String role,
      } =>
      AuthData(token, username, refreshToken),
    _ => throw const FormatException('Failed to get user auth response'),
    };
  }
}