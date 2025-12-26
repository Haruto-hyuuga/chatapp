import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';

class ContactsModel extends ContactEntity {
  ContactsModel({
    required String id,
    required String username,
    required String email,
    required String profileUrl,
    required String conversationId,
  }) : super(
         id: id,
         username: username,
         email: email,
         profileUrl: profileUrl,
         conversationId: conversationId,
       );

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
      id: json['contact_id'],
      username: json['username'],
      email: json['email'],
      profileUrl: json['profile_url'],
      conversationId:
          json['conversation_id'] ??
          '', // WARNING: Can be null if conversation doesnt exit or Used with FectConntacts valid for RecentContacts
    );
  }
}
