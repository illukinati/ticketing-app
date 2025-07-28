class UserEntity {
  final int id;
  final String username;
  final String email;
  final String? token;

  const UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.token,
  });

  UserEntity copyWith({
    int? id,
    String? username,
    String? email,
    String? token,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.token == token;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ email.hashCode ^ token.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, username: $username, email: $email, token: $token)';
}