import 'package:chatapp/core/socket_service.dart';
import 'package:chatapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:chatapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chatapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:chatapp/features/auth/domain/usecases/check_token_use_case.dart';
import 'package:chatapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:chatapp/features/auth/domain/usecases/register_use_case.dart';
import 'package:chatapp/features/chat/data/datasources/messages_remote_data_source.dart';
import 'package:chatapp/features/chat/data/repositories/message_repository_impl.dart';
import 'package:chatapp/features/chat/domain/repositories/messages_repository.dart';
import 'package:chatapp/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:chatapp/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:chatapp/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:chatapp/features/contacts/domain/repositories/contacts_repository.dart';
import 'package:chatapp/features/contacts/domain/usecases/add_contact_use_case.dart';
import 'package:chatapp/features/contacts/domain/usecases/fetch_contacts_use_case.dart';
import 'package:chatapp/features/conversation/data/datasources/conversations_remote_data_source.dart';
import 'package:chatapp/features/conversation/data/repositories/conversation_repository_impl.dart';
import 'package:chatapp/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:chatapp/features/conversation/domain/usecases/check_or_create_conversation_use_case.dart';
import 'package:chatapp/features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'package:chatapp/features/recents/data/datasources/recents_remote_data_source.dart';
import 'package:chatapp/features/recents/data/repositories/recents_repository_impl.dart';
import 'package:chatapp/features/recents/domain/repositories/recents_repository.dart';
import 'package:chatapp/features/recents/domain/usecases/recent_contacts_use_case.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  const String backendApiBaseUrl = "https://chatapp-backend-1b8y.onrender.com";

  // SOCKET.io
  sl.registerLazySingleton<SocketService>(
    () => SocketService(baseUrl: backendApiBaseUrl),
  );

  // DATA SOURCES
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(baseUrl: backendApiBaseUrl),
  );
  sl.registerLazySingleton<ConversationsRemoteDataSource>(
    () => ConversationsRemoteDataSource(baseUrl: backendApiBaseUrl),
  );
  sl.registerLazySingleton<MessagesRemoteDataSource>(
    () => MessagesRemoteDataSource(baseUrl: backendApiBaseUrl),
  );
  sl.registerLazySingleton<ContactsRemoteDataSource>(
    () => ContactsRemoteDataSource(baseUrl: backendApiBaseUrl),
  );
  sl.registerLazySingleton<RecentsRemoteDataSource>(
    () => RecentsRemoteDataSource(baseUrl: backendApiBaseUrl),
  );

  // REPOSITORIES
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authRemoteDataSource: sl()),
  );
  sl.registerLazySingleton<ConversationRepository>(
    () => ConversationRepositoryImpl(conversationremoteDataSource: sl()),
  );
  sl.registerLazySingleton<MessagesRepository>(
    () => MessageRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<ContactsRepository>(
    () => ContactsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<RecentsRepository>(
    () => RecentsRepositoryImpl(recentsRemoteDataSource: sl()),
  );

  // USE CASES
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => RegisterUseCase(repository: sl()));
  sl.registerLazySingleton(() => CheckTokenUseCase(repository: sl()));
  sl.registerLazySingleton(() => FetchConversationUseCase(repository: sl()));
  sl.registerLazySingleton(
    () => FetchMessagesUseCase(messagesRepository: sl()),
  );
  sl.registerLazySingleton(
    () => FetchContactsUseCase(contactsRepository: sl()),
  );
  sl.registerLazySingleton(() => AddContactUseCase(contactsRepository: sl()));
  sl.registerLazySingleton(
    () => CheckOrCreateConversationUseCase(conversationsRepository: sl()),
  );
  sl.registerLazySingleton(
    () => RecentContactsUseCase(recentsRepository: sl()),
  );
}
