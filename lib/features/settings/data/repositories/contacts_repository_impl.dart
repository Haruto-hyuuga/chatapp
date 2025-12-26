import 'package:chatapp/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';
import 'package:chatapp/features/contacts/domain/repositories/contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsRemoteDataSource remoteDataSource;

  ContactsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addContacts({required String email}) async {
    await remoteDataSource.addContacts(email: email);
  }

  @override
  Future<List<ContactEntity>> fetchContacts() async {
    return await remoteDataSource.fetchContacts();
  }
}
