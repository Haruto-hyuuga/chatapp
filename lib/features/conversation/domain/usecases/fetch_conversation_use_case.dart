import 'package:chatapp/features/conversation/domain/entities/conversation_entity.dart';
import 'package:chatapp/features/conversation/domain/repositories/conversation_repository.dart';

class FetchConversationUseCase {
  final ConversationRepository repository;

  FetchConversationUseCase({required this.repository});

  Future<List<ConversationEntity>> call() async {
    return repository.fetchConversation();
  }
}
