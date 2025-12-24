import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';
import 'package:chatapp/features/recents/domain/repositories/recents_repository.dart';

class RecentContactsUseCase {
  final RecentsRepository recentsRepository;

  RecentContactsUseCase({required this.recentsRepository});

  Future<List<ContactEntity>> call() async {
    return await recentsRepository.getRecentContacts();
  }
}
