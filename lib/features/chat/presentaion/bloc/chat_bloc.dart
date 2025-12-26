import 'package:chatapp/core/socket_service.dart';
import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:chatapp/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:chatapp/features/chat/presentaion/bloc/chat_event.dart';
import 'package:chatapp/features/chat/presentaion/bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessagesUseCase fetchMessagesUseCase;
  final SocketService socketService;
  final List<MessageEntity> _messages = [];
  final _storage = FlutterSecureStorage();

  ChatBloc({required this.fetchMessagesUseCase, required this.socketService})
    : super(ChatLoadingState()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
  }

  Future<void> _onLoadMessages(
    LoadMessagesEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoadingState());
    try {
      final messages = await fetchMessagesUseCase(event.conversationId);
      _messages.clear();
      _messages.addAll(messages);
      emit(ChatLoadedState(List.from(_messages)));

      socketService.socket.off('newMessage');

      socketService.socket.emit('joinConversation', event.conversationId);
      socketService.socket.on('newMessage', (data) {
        add(ReceiveMessageEvent(data));
      });
    } catch (e) {
      emit(ChatErrorState(error: 'Backend Says:\n$e'));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    String userId = await _storage.read(key: 'userId') ?? '';

    final newMessage = {
      'conversationId': event.conversationId,
      'content': event.content,
      'senderId': userId,
    };
    socketService.socket.emit('sendMessage', newMessage);
  }

  Future<void> _onReceiveMessage(
    ReceiveMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    final message = MessageEntity(
      id: event.message['id'],
      conversationId: event.message['conversation_id'],
      senderId: event.message['sender_id'],
      content: event.message['content'],
      createdAt: event.message['created_at'],
    );
    _messages.add(message);
    emit(ChatLoadedState(List.from(_messages)));
  }
}
