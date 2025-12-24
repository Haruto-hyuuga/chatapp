import 'package:chatapp/core/socket_service.dart';
import 'package:chatapp/di_container.dart';
import 'package:chatapp/features/chat/presentaion/bloc/chat_bloc.dart';
import 'package:chatapp/core/theme.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:chatapp/features/auth/presentaion/pages/login_page.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_bloc.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_bloc.dart';
import 'package:chatapp/features/conversation/presentaion/pages/conversation_page.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentaion/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupDependencies();

  final socketService = sl<SocketService>();
  await socketService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(registerUseCase: sl(), loginUseCase: sl()),
        ),
        BlocProvider(
          create: (_) => ConversationBloc(
            fetchConversationUseCase: sl(),
            socketService: sl(),
          ),
        ),
        BlocProvider(
          create: (_) =>
              ChatBloc(fetchMessagesUseCase: sl(), socketService: sl()),
        ),
        BlocProvider(create: (_) => RecentsBloc(recentContactsUseCase: sl())),
        BlocProvider(
          create: (_) => ContactsBloc(
            fetchContactsUseCase: sl(),
            addContactUseCase: sl(),
            checkOrCreateConversationUseCase: sl(),
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
