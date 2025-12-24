import 'package:chatapp/features/contacts/domain/entities/contact_entity.dart';
import 'package:chatapp/features/recents/data/datasources/recents_remote_data_source.dart';
import 'package:chatapp/features/recents/domain/repositories/recents_repository.dart';

class RecentsRepositoryImpl implements RecentsRepository {
  final RecentsRemoteDataSource recentsRemoteDataSource;

  RecentsRepositoryImpl({required this.recentsRemoteDataSource});

  @override
  Future<List<ContactEntity>> getRecentContacts() async {
    return await recentsRemoteDataSource.fetchRecentContacts();
  }
}
