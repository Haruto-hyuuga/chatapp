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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showErrorPopup(
        context: context,
        errorName: "REGISTRATION ERROR",
        errorText: "Please fill in all fields",
        errorColor: Colors.orange,
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      showErrorPopup(
        context: context,
        errorName: "INVALID EMAIL",
        errorText: "Please enter a valid email address",
        errorColor: Colors.orange,
      );
      return;
    }

    if (password.length < 6) {
      showErrorPopup(
        context: context,
        errorName: "WEAK PASSWORD",
        errorText: "Password must be at least 6 characters long",
        errorColor: Colors.orange,
      );
      return;
    }

    BlocProvider.of<AuthBloc>(
      context,
    ).add(RegisterEvent(username: username, email: email, password: password));
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
                  AuthInputField(
                    hint: 'Username',
                    icon: Icons.person,
                    controllerT: _usernameController,
                  ),
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
                      return AuthButton(
                        text: 'Register',
                        onPressed: _onRegister,
                      );
                    },
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              state.message,
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        );
                        Navigator.pushNamed(context, '/login');
                      } else if (state is AuthFailure) {
                        showErrorPopup(
                          context: context,
                          errorName: "REGISTRATION FAILED",
                          errorType: "External-error",
                          errorText: state.error,
                          errorIcon: Icons.warning_amber_rounded,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  LoginPrompt(
                    title: "Already have an account? ",
                    subtitle: " Click here to login",
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
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
