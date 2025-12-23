import 'package:chatapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:chatapp/features/auth/domain/usecases/register_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_event.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUseCase registerUseCase;
  final LoginUseCase loginUseCase;
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
      emit(AuthFailure(error: 'Registration Failed. $e'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.call(event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      await _storage.write(key: 'userId', value: user.id);
      emit(AuthSuccess(message: 'Account Logged-in  Successfully.'));
    } catch (e) {
      emit(AuthFailure(error: 'Login Failed.'));
    }
  }

  AuthBloc({required this.registerUseCase, required this.loginUseCase})
    : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
  }
}
