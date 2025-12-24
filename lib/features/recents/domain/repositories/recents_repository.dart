import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';

abstract class RecentsRepository {
  Future<List<ContactEntity>> getRecentContacts();
}
