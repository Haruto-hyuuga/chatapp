import 'dart:convert';
import 'package:chatapp/core/globals.dart';
import 'package:chatapp/features/contacts/data/models/contacts_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class RecentsRemoteDataSource {
  final String baseUrl = backendApiBaseUrl;
  final _storage = FlutterSecureStorage();

  Future<List<ContactsModel>> fetchRecentContacts() async {
    String token = await _storage.read(key: 'token') ?? '';
    final response = await http.get(
      Uri.parse('$baseUrl/contacts/recent'),
      headers: {'Authorization': 'Bearer $token'},
    );
    // print(response.body);
    if (response.statusCode == 201) {
      List data = jsonDecode(response.body);
      return data.map((json) => ContactsModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch recent contacts');
    }
  }
}
