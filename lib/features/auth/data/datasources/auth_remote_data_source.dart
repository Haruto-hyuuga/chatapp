import 'dart:convert';
import 'package:chatapp/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  final String baseUrl;
  AuthRemoteDataSource({required this.baseUrl});

  Future<bool> validateToken({required String token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/validate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 500) {
      // ignore: avoid_print
      print("BACKEND_SERVER_ERROR: ${response.body}");
      throw Exception(
        'BACKEND_SERVER_ERROR:500\nCheck console for more details',
      );
    } else if (response.statusCode != 200) {
      String errorMessage = jsonDecode(response.body)['error'];
      throw Exception('${response.statusCode}: BACKEND WARNING\n$errorMessage');
    }
    // print("validateToken Response: ${response.body}");
    return jsonDecode(response.body)['valid'] == true;
  }

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
    if (response.statusCode == 500) {
      // ignore: avoid_print
      print("BACKEND_SERVER_ERROR: ${response.body}");
      throw Exception(
        'BACKEND_SERVER_ERROR:500\nCheck console for more details',
      );
    } else if (response.statusCode != 200) {
      String errorMessage = jsonDecode(response.body)['error'];
      throw Exception('${response.statusCode}: BACKEND WARNING\n$errorMessage');
    }
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
    if (response.statusCode == 500) {
      // ignore: avoid_print
      print("BACKEND_SERVER_ERROR: ${response.body}");
      throw Exception(
        'BACKEND_SERVER_ERROR:500\nCheck console for more details',
      );
    } else if (response.statusCode != 200) {
      String errorMessage = jsonDecode(response.body)['error'];
      throw Exception('${response.statusCode}: BACKEND WARNING\n$errorMessage');
    }
  }
}
