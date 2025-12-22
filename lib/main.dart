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
import 'package:chatapp/features/conversation/data/datasources/conversations_remote_data_source.dart';
import 'package:chatapp/features/conversation/data/repositories/conversation_repository_impl.dart';
import 'package:chatapp/features/conversation/domain/usecases/fetch_conversation_use_case.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_bloc.dart';
import 'package:chatapp/features/conversation/presentaion/pages/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentaion/pages/register_page.dart';

void main() {
  final authRepository = AuthRepositoryImpl(
    authRemoteDataSource: AuthRemoteDataSource(),
  );
  final conversationRepository = ConversationRepositoryImpl(
    conversationremoteDataSource: ConversationsRemoteDataSource(),
  );
  final messagesRepository = MessageRepositoryImpl(
    remoteDataSource: MessagesRemoteDataSource(),
  );
  runApp(
    MyApp(
      authRepository: authRepository,
      conversationRepository: conversationRepository,
      messagesRepository: messagesRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepository;
  final ConversationRepositoryImpl conversationRepository;
  final MessageRepositoryImpl messagesRepository;

  const MyApp({
    super.key,
    required this.authRepository,
    required this.conversationRepository,
    required this.messagesRepository,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUseCase: RegisterUseCase(repository: authRepository),
            loginUseCase: LoginUseCase(repository: authRepository),
          ),
        ),

        BlocProvider(
          create: (_) => ConversationBloc(
            fetchConversationUseCase: FetchConversationUseCase(
              repository: conversationRepository,
            ),
          ),
        ),

        BlocProvider(
          create: (_) => ChatBloc(
            fetchMessagesUseCase: FetchMessagesUseCase(
              messagesRepository: messagesRepository,
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
