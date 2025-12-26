import 'package:chatapp/features/contacts/domain/repositories/contacts_repository.dart';

class AddContactUseCase {
  final ContactsRepository contactsRepository;

  AddContactUseCase({required this.contactsRepository});

  Future<void> call({required String email}) async {
    return await contactsRepository.addContacts(email: email);
  }
}
