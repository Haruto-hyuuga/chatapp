import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';
import 'package:chatapp/features/contacts/domain/repositories/contacts_repository.dart';

class FetchContactsUseCase {
  final ContactsRepository contactsRepository;

  FetchContactsUseCase({required this.contactsRepository});

  Future<List<ContactEntity>> call() async {
    return await contactsRepository.fetchContacts();
  }
}
