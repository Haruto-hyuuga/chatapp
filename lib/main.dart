import 'package:chatapp/core/socket_service.dart';
import 'package:chatapp/features/chat/data/datasources/messages_remote_data_source.dart';
import 'package:chatapp/features/chat/data/repositories/message_repository_impl.dart';
import 'package:chatapp/features/chat/domain/usecases/fetch_messages_use_case.dart';
import 'package:chatapp/features/chat/presentaion/bloc/chat_bloc.dart';
import 'package:chatapp/core/theme.dart';
import 'package:chatapp/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:chatapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:chatapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:chatapp/features/auth/domain/usecases/register_use_case.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:chatapp/features/auth/presentaion/pages/login_page.dart';
import 'package:chatapp/features/contacts/data/datasources/contacts_remote_data_source.dart';
import 'package:chatapp/features/contacts/data/repositories/contacts_repository_impl.dart';
import 'package:chatapp/features/contacts/domain/usecases/add_contact_use_case.dart';
import 'package:chatapp/features/contacts/domain/usecases/fetch_contacts_use_case.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_bloc.dart';
import 'package:chatapp/features/conversation/data/datasources/conversations_remote_data_source.dart';
import 'package:chatapp/features/conversation/data/repositories/conversation_repository_impl.dart';
import 'package:chatapp/features/conversation/domain/usecases/check_or_create_conversation_use_case.dart';
import 'package:chatapp/features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_bloc.dart';
import 'package:chatapp/features/conversation/presentaion/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentaion/pages/register_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final authRepository = AuthRepositoryImpl(
    authRemoteDataSource: AuthRemoteDataSource(),
  );
  final conversationRepository = ConversationRepositoryImpl(
    conversationremoteDataSource: ConversationsRemoteDataSource(),
  );
  final messagesRepository = MessageRepositoryImpl(
    remoteDataSource: MessagesRemoteDataSource(),
  );
  final contactsRepository = ContactsRepositoryImpl(
    remoteDataSource: ContactsRemoteDataSource(),
  );

  runApp(
    MyApp(
      socketService: SocketService(),
      authRepository: authRepository,
      conversationRepository: conversationRepository,
      messagesRepository: messagesRepository,
      contactsRepository: contactsRepository,
    ),
  );
}

class MyApp extends StatefulWidget {
  final SocketService socketService;
  final AuthRepositoryImpl authRepository;
  final ConversationRepositoryImpl conversationRepository;
  final MessageRepositoryImpl messagesRepository;
  final ContactsRepositoryImpl contactsRepository;

  const MyApp({
    super.key,
    required this.socketService,
    required this.authRepository,
    required this.conversationRepository,
    required this.messagesRepository,
    required this.contactsRepository,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    widget.socketService.initSocket();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUseCase: RegisterUseCase(repository: widget.authRepository),
            loginUseCase: LoginUseCase(repository: widget.authRepository),
          ),
        ),

        BlocProvider(
          create: (_) => ConversationBloc(
            fetchConversationUseCase: FetchConversationUseCase(
              repository: widget.conversationRepository,
            ),
          ),
        ),

        BlocProvider(
          create: (_) => ChatBloc(
            fetchMessagesUseCase: FetchMessagesUseCase(
              messagesRepository: widget.messagesRepository,
            ),
          ),
        ),

        BlocProvider(
          create: (_) => ContactsBloc(
            fetchContactsUseCase: FetchContactsUseCase(
              contactsRepository: widget.contactsRepository,
            ),
            addContactUseCase: AddContactUseCase(
              contactsRepository: widget.contactsRepository,
            ),
            checkOrCreateConversationUseCase: CheckOrCreateConversationUseCase(
              conversationsRepository:
                  widget.conversationRepository, //ConversationRepositoryImpl
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          // '/chatpage': (_) => ChatPage(),
          '/conversationspage': (_) => ConversationPage(),
        },
      ),
    );
  }
}
