import 'package:chatapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:chatapp/features/auth/domain/entities/user_entity.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;

  AuthRepositoryImpl({required this.authRemoteDataSource});

  @override
  Future<bool> validateToken(String? token) async {
    if (token == null) return false;
    return await authRemoteDataSource.validateToken(token: token);
  }

  @override
  Future<UserEntity> login(String email, String password) async {
    return await authRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> register(String username, String email, String password) async {
    await authRemoteDataSource.register(
      username: username,
      email: email,
      password: password,
    );
  }
}
