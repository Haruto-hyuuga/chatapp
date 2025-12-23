import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';

class ContactsModel extends ContactEntity {
  ContactsModel({
    required String id,
    required String username,
    required String email,
  }) : super(id: id, username: username, email: email);

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    return ContactsModel(
      id: json['contact_id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
