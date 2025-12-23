import 'package:chatapp/features/conversation/domain/repositories/conversation_repository.dart';

class CheckOrCreateConversationUseCase {
  final ConversationRepository conversationsRepository;

  CheckOrCreateConversationUseCase({required this.conversationsRepository});

  Future<String> call({required String contactId}) async {
    return conversationsRepository.checkOrCreateConversation(
      contactId: contactId,
    );
  }
}
