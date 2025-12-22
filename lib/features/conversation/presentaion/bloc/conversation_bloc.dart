import 'package:chatapp/features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_event.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationUseCase fetchConversationUseCase;

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

  ConversationBloc({required this.fetchConversationUseCase})
    : super(ConversationsInitial()) {
    on<FetchConversations>(_onFetchConversations);
  }
}
