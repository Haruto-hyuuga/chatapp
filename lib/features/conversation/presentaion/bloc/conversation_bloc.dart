import 'package:chatapp/core/socket_service.dart';
import 'package:chatapp/features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_event.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationUseCase fetchConversationUseCase;
  final SocketService _socketService = SocketService();

  Future<void> _onFetchConversations(
    FetchConversations event,
    Emitter<ConversationState> emit,
  ) async {
    emit(ConversationsLoading());
    try {
      final conversations = await fetchConversationUseCase();
      emit(ConversationsLoaded(conversations));
    } catch (error) {
      emit(ConversationsError('Failed to load conversations'));
    }
  }

  void _onConversationUpdated(data) {
    add(FetchConversations());
  }

  void _initializeSocketListener() {
    try {
      _socketService.socket.on('conversationUpdated', _onConversationUpdated);
    } catch (e) {
      print("ERROR.ConversationBloc: initializing socket listener: $e");
    }
  }

  ConversationBloc({required this.fetchConversationUseCase})
    : super(ConversationsInitial()) {
    _initializeSocketListener();
    on<FetchConversations>(_onFetchConversations);
  }
}
