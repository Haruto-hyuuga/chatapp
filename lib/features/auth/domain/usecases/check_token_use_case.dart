import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';

class CheckTokenUseCase {
  final AuthRepository repository;

  CheckTokenUseCase({required this.repository});

  Future<bool> call(String token) {
    return repository.validateToken(token);
  }
}
