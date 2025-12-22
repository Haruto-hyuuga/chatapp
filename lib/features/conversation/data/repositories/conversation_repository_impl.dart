import 'package:chatapp/features/conversation/data/datasources/conversations_remote_data_source.dart';
import 'package:chatapp/features/conversation/domain/entities/conversation_entity.dart';
import 'package:chatapp/features/conversation/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationsRemoteDataSource conversationremoteDataSource;

  ConversationRepositoryImpl({required this.conversationremoteDataSource});

  @override
  Future<List<ConversationEntity>> fetchConversation() async {
    return await conversationremoteDataSource.fetchConversations();
  }
}
