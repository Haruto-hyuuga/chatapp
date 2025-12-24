import 'package:chatapp/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String id,
    required String username,
    required String email,
    required String profileUrl,
    required String token,
  }) : super(
         id: id,
         username: username,
         email: email,
         token: token,
         profileUrl: profileUrl,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profileUrl: json['profile_url'],
      token: json['token'],
    );
  }
}
