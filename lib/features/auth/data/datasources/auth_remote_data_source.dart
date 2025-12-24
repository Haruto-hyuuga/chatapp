import 'dart:convert';
import 'package:chatapp/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl;
  AuthRemoteDataSource({required this.baseUrl});

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    // print(response.body);
    return UserModel.fromJson(jsonDecode(response.body)['user']);
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    // print(
    //   "Sending Req: \nusername: $username \n email: $email \n password: $password",
    // );
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    // print("Response Body:");
    // print(response.body);
    if (response.statusCode != 201) {
      throw Exception('Registration failed: ${response.body}');
    }
  }
}
