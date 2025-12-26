import 'dart:convert';
import 'package:chatapp/features/conversation/data/models/conversation_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ConversationsRemoteDataSource {
  final String baseUrl;
  final _storage = FlutterSecureStorage();

  ConversationsRemoteDataSource({required this.baseUrl});

  Future<List<ConversationModel>> fetchConversations() async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/conversation'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 500) {
      // ignore: avoid_print
      print("BACKEND_SERVER_ERROR: ${response.body}");
      throw Exception(
        'BACKEND_SERVER_ERROR:500\nfaild to fetch conversation\nCheck console for more details',
      );
    } else if (response.statusCode != 200) {
      String errorMessage = jsonDecode(response.body)['error'];
      throw Exception('${response.statusCode}: BACKEND WARNING\n$errorMessage');
    }

    List data = jsonDecode(response.body);
    return data.map((json) => ConversationModel.fromJson(json)).toList();
  }

  Future<String> checkOrCreateConversation({required String contactId}) async {
    String token = await _storage.read(key: 'token') ?? '';

    final response = await http.post(
      Uri.parse('$baseUrl/conversation/check-or-create'),
      body: jsonEncode({'contactId': contactId}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 500) {
      // ignore: avoid_print
      print("BACKEND_SERVER_ERROR: ${response.body}");
      throw Exception(
        'BACKEND_SERVER_ERROR:500\nFailed to check or create conversation\nCheck console for more details',
      );
    } else if (response.statusCode != 200) {
      String errorMessage = jsonDecode(response.body)['error'];
      throw Exception('${response.statusCode}: BACKEND WARNING\n$errorMessage');
    }
    var data = jsonDecode(response.body);
    return data['conversationId'];
  }
}
