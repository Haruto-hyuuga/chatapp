import 'package:chatapp/features/chat/data/datasources/messages_remote_data_source.dart';
import 'package:chatapp/features/chat/domain/entities/message_entity.dart';
import 'package:chatapp/features/chat/domain/repositories/messages_repository.dart';

class MessageRepositoryImpl implements MessagesRepository {
  final MessagesRemoteDataSource remoteDataSource;

  MessageRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    return await remoteDataSource.fetchMessages(conversationId);
  }

  @override
  Future<void> sendMessages(MessageEntity message) {
    throw UnimplementedError();
  }
}
