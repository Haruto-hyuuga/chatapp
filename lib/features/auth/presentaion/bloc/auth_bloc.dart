import 'package:chatapp/features/auth/domain/usecases/check_token_use_case.dart';
import 'package:chatapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:chatapp/features/auth/domain/usecases/register_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_event.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
  final CheckTokenUseCase checkTokenUseCase;
  final _storage = FlutterSecureStorage();

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // print(
      //   "Sending Req: \nusername: ${event.username} \n email: ${event.email} \n password: ${event.password}",
      // );
      await registerUseCase.call(event.username, event.email, event.password);
      emit(AuthSuccess(message: 'Account Registered Successfully.'));
    } catch (e) {
      emit(AuthFailure(error: 'Backend Says:\n$e'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.call(event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'userId', value: user.id);
      emit(AuthAuthenticated(userId: user.id));
      // emit(AuthSuccess(message: 'Account Logged-in  Successfully.'));
    } catch (e) {
      emit(AuthFailure(error: 'Backend Says:\n$e'));
    }
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final token = await _storage.read(key: 'token');
      final userId = await _storage.read(key: 'userId');

      if (token == null || userId == null) {
        emit(AuthUnauthenticated());
        return;
      }
      final isValid = await checkTokenUseCase(token);
      if (!isValid) {
        await _storage.deleteAll();
        emit(AuthUnauthenticated());
        return;
      }
      emit(AuthAuthenticated(userId: userId));
    } catch (e) {
      // Token expired, backend down, malformed response, etc.
      await _storage.deleteAll();
      emit(AuthFailure(error: 'Backend Says:\n$e'));
    }
  }

  AuthBloc({
    required this.registerUseCase,
    required this.loginUseCase,
    required this.checkTokenUseCase,
  }) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<CheckAuthEvent>(_onCheckAuth);
    on<LogoutEvent>((event, emit) async {
      await _storage.deleteAll();
      // print("DELETE LOACL STOARGE");
      emit(AuthUnauthenticated());
    });
  }
}
