import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';

abstract class ContactsRepository {
  Future<List<ContactEntity>> fetchContacts();
  Future<void> addContacts({required String email});
}
