import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase({required this.repository});

  Future<void> call(String username, String email, String password) {
    return repository.register(username, email, password);
  }
}
