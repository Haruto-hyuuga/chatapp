import 'package:chatapp/features/conversation/domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required String id,
    required String participantName,
    required String participantProfileUrl,
    required String lastMessage,
    required DateTime lastMessageTime,
  }) : super(
         id: id,
         participantName: participantName,
         participantProfileUrl: participantProfileUrl,
         lastMessage: lastMessage,
         lastMessageTime: lastMessageTime,
       );
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['conversation_id'],
      participantName: json['participant_name'],
      participantProfileUrl: json['participant_profile_url'],
      lastMessage: json['last_message'],
      lastMessageTime: DateTime.parse(json['last_message_time']),
    );
  }
}
