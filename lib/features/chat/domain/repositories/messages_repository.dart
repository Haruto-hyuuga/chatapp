import 'package:chatapp/features/chat/domain/entities/message_entity.dart';

abstract class MessagesRepository {
  Future<List<MessageEntity>> fetchMessages(String conversationId);

  Future<void> sendMessages(MessageEntity message);
}
