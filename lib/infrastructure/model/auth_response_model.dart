import '../../domain/entities/user_entity.dart';
import 'user_model.dart';

class AuthResponseModel {
  final UserModel user;
  final String token;

  const AuthResponseModel({
    required this.user,
    required this.token,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: user.id,
      username: user.username,
      email: user.email,
      token: token,
    );
  }
}