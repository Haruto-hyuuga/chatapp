abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  AuthAuthenticated({required this.userId});
}

class AuthUnauthenticated extends AuthState {}

class AuthSuccess extends AuthState {
  final String message;

  AuthSuccess({required this.message});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}
