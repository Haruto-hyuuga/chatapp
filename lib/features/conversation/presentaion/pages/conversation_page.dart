import 'package:chatapp/core/theme.dart';
import 'package:chatapp/features/chat/presentaion/pages/chat_page.dart';
import 'package:chatapp/features/contacts/presentaion/pages/contacts_page.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_bloc.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_event.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_state.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_bloc.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_event.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context).add(FetchConversations());
    BlocProvider.of<RecentsBloc>(context).add(LoadRecentContacts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 70,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Recents",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          BlocBuilder<RecentsBloc, RecentsState>(
            builder: (context, state) {
              if (state is RecentsLoading) {
                return Center(child: CircularProgressIndicator());
              } //
              else if (state is RecentsLoaded) {
                return Container(
                  height: 100,
                  padding: EdgeInsets.all(5),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildRecentContact(
                        context,
                        '0',
                        'Gemini',
                        "assets/img/logo/gemini-color.png",
                        asset: true,
                      ),
                      _buildRecentContact(
                        context,
                        '0',
                        'DSP',
                        "assets/img/extra/RecentContactPlaceholder.jpg",
                        asset: true,
                      ),
                      ...state.recentContacts.map(
                        (c) => _buildRecentContact(
                          context,
                          // TODO   c.id is not conversation id pass conversation id from backend
                          c.id,
                          c.username,
                          c.profileUrl,
                        ),
                      ),
                    ],
                  ),
                );
              } //
              else if (state is RecentsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }
              return Center(
                child: Text(
                  'No recent Contacts Found',
                  style: TextStyle(color: Colors.lightBlue),
                ),
              );
            },
          ),
          SizedBox(height: 2),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state is ConversationsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ConversationsLoaded) {
                    return ListView.builder(
                      itemCount: state.conversations.length,
                      itemBuilder: (context, index) {
                        final conversation = state.conversations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  conversationId: conversation.id,
                                  participantName: conversation.participantName,
                                  participantProfileUrl:
                                      conversation.participantProfileUrl,
                                ),
                              ),
                            );
                          },
                          child: _buildMessageTile(
                            conversation.participantName,
                            conversation.participantProfileUrl,
                            conversation.lastMessage,
                            conversation.lastMessageTime.toString(),
                          ),
                        );
                      },
                    );
                  } else if (state is ConversationsError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return Center(
                    child: Text(
                      'No converstion Found',
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final reRecentsBloc = BlocProvider.of<RecentsBloc>(context);
          var res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactsPage()),
          );
          if (res == null) {
            reRecentsBloc.add(LoadRecentContacts());
          }
        },
        backgroundColor: DefaultColors.contactButtonColor,
        child: Icon(Icons.contacts, color: Colors.white),
      ),
    );
  }

  Widget _buildRecentContact(
    BuildContext context,
    String conversationId,
    String name,
    String profileUrl, {
    bool asset = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                conversationId: conversationId,
                participantName: name,
                participantProfileUrl: profileUrl,
              ),
            ),
          );
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: DefaultColors.profileIconBackground,
              backgroundImage: profileUrl.isNotEmpty
                  ? (asset
                        ? AssetImage(profileUrl) as ImageProvider
                        : NetworkImage(profileUrl))
                  : null,
              child: profileUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 5),
            Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(
    String name,
    String profileUrl,
    String message,
    String time,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(profileUrl),
        backgroundColor: DefaultColors.profileIconBackground,
      ),
      title: Text(
        name,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        message,
        style: TextStyle(color: Colors.grey),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(time, style: TextStyle(color: Colors.grey)),
    );
  }
}
