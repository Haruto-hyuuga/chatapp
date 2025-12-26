import 'package:chatapp/core/animated_gradient_background.dart';
import 'package:chatapp/core/show_error.dart';
import 'package:chatapp/core/theme.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_event.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_state.dart';
import 'package:chatapp/features/auth/presentaion/wigets/auth_button.dart';
import 'package:chatapp/features/auth/presentaion/wigets/auth_input_field.dart';
import 'package:chatapp/features/auth/presentaion/wigets/login_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final bool isLogout;
  const LoginPage({super.key, this.isLogout = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorPopup(
        context: context,
        errorName: "LOGIN ERROR",
        errorType: "user-input-invalid",
        errorText: "Please fill in both email and password",
        errorColor: Colors.orange,
      );
      return;
    }
    BlocProvider.of<AuthBloc>(
      context,
    ).add(LoginEvent(email: email, password: password));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DefaultColors.authPageBg,
      body: Stack(
        children: [
          const DarkGlassBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  AuthInputField(
                    hint: 'Email',
                    icon: Icons.mail,
                    controllerT: _emailController,
                  ),
                  SizedBox(height: 20),
                  AuthInputField(
                    hint: 'Password',
                    icon: Icons.lock,
                    controllerT: _passwordController,
                    isPassword: true,
                  ),
                  SizedBox(height: 20),

                  BlocConsumer<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return AuthButton(text: 'Login', onPressed: _onLogin);
                    },
                    listener: (context, state) {
                      if (state is AuthAuthenticated) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/conversationspage',
                          (route) => false,
                        );
                      } else if (state is AuthUnauthenticated &&
                          widget.isLogout) {
                        showErrorPopup(
                          context: context,
                          errorName: "Session Expired",
                          errorType: "security-measure",
                          errorText:
                              "Your session token expired. Please login again.",
                          errorColor: Colors.green,
                        );
                      } else if (state is AuthFailure) {
                        showErrorPopup(
                          context: context,
                          errorName: "LOGIN FAILED",
                          errorType: "External-error",
                          errorText: state.error,
                          errorIcon: Icons.warning_amber_rounded,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  LoginPrompt(
                    title: 'Dont have an account? ',
                    subtitle: ' Click here to register',
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
