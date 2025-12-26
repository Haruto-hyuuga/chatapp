import 'dart:convert';
import 'package:chatapp/features/contacts/data/models/contacts_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RecentsRemoteDataSource {
  final String baseUrl;
  final _storage = FlutterSecureStorage();

  RecentsRemoteDataSource({required this.baseUrl});

  Future<List<ContactsModel>> fetchRecentContacts() async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/contacts/recent'),
      headers: {'Authorization': 'Bearer $token'},
    );
    // print(response.body);
    // print(response.statusCode);

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
    List data = jsonDecode(response.body);
    return data.map((json) => ContactsModel.fromJson(json)).toList();
  }
}
