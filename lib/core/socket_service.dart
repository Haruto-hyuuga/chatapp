import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final String baseUrl;
  final FlutterSecureStorage _storage;

  late IO.Socket _socket;

  SocketService({required this.baseUrl, FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> init() async {
    final token = await _storage.read(key: 'token');

    _socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({
            if (token != null) 'Authorization': 'Bearer $token',
          })
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      debugPrint('Socket connected');
    });

    _socket.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });
  }

  IO.Socket get socket => _socket;

  void dispose() {
    _socket.dispose();
  }
}

// LEGACY CODE
// class SocketService {
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;

//   late IO.Socket _socket;
//   final _storage = FlutterSecureStorage();

//   SocketService._internal() {
//     initSocket();
//   }
//   Future<void> initSocket() async {
//     String token = await _storage.read(key: 'token') ?? ' ';
//     _socket = IO.io(
//       backendApiBaseUrl,
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .disableAutoConnect()
//           .setExtraHeaders({'Authorization': 'Bearer $token'})
//           .build(),
//     );
//     _socket.connect();
//     _socket.onConnect((_) {});

//     _socket.onDisconnect((_) {});
//   }

//   IO.Socket get socket => _socket;
// }
