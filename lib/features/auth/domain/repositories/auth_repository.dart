import 'package:chatapp/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<void> register(String username, String email, String password);
  Future<bool> validateToken(String? token);
}
