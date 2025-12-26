import 'package:chatapp/core/show_error.dart';
import 'package:chatapp/core/theme.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_bloc.dart';
import 'package:chatapp/features/auth/presentaion/bloc/auth_event.dart';
import 'package:chatapp/features/auth/presentaion/pages/login_page.dart';
import 'package:chatapp/features/chat/presentaion/pages/chat_page.dart';
import 'package:chatapp/features/contacts/presentaion/pages/contacts_page.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_bloc.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_event.dart';
import 'package:chatapp/features/conversation/presentaion/bloc/conversation_state.dart';
import 'package:chatapp/features/rushed/dsp_page.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_bloc.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_event.dart';
import 'package:chatapp/features/recents/presentaion/bloc/recents_state.dart';
import 'package:chatapp/features/rushed/gemini_page.dart';
import 'package:chatapp/features/rushed/settings_page.dart';
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

  bool isSentWithinLast2Minutes(DateTime lastMessageTime) {
    return DateTime.now().difference(lastMessageTime).inSeconds < 120;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header Area
            _buildCustomHeader(context),
            const SizedBox(height: 8),

            // Recents List
            BlocBuilder<RecentsBloc, RecentsState>(
              builder: (context, state) {
                if (state is RecentsLoading) {
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is RecentsLoaded) {
                  return SizedBox(
                    height: 100,
                    child: ListView(
                      padding: const EdgeInsets.only(left: 15),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildRecentContact(
                          context,
                          'local',
                          'Gemini',
                          "assets/img/logo/gemini-color.png",
                          asset: true,
                          statusEffect: [Colors.blue, Colors.purple],
                        ),
                        _buildRecentContact(
                          context,
                          'creator',
                          'DSP',
                          "assets/img/extra/dsp.png",
                          asset: true,
                          statusEffect: [
                            Colors.white,
                            const Color.fromARGB(255, 253, 115, 191),
                          ],
                        ),
                        ...state.recentContacts.map(
                          (c) => _buildRecentContact(
                            context,
                            c.conversationId,
                            c.username,
                            c.profileUrl,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is RecentsError) {
                  showErrorPopup(
                    context: context,
                    errorName: "RECENTS FAILED",
                    errorType: "External-error",
                    errorText: state.error,
                    errorIcon: Icons.warning_amber_rounded,
                  );
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Text(
                        "Failed to fetch recent contacts.",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            const SizedBox(height: 5),

            // Message List Container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // Use your DefaultColors.messageListPage here if preferred
                  color: const Color(0xFF1E1E1E),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: BlocBuilder<ConversationBloc, ConversationState>(
                    builder: (context, state) {
                      if (state is ConversationsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ConversationsLoaded) {
                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 10, bottom: 80),
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.conversations.length,
                          itemBuilder: (context, index) {
                            final conversation = state.conversations[index];
                            return _buildMessageTile(
                              context: context,
                              conversationId: conversation.id,
                              name: conversation.participantName,
                              profileUrl: conversation.participantProfileUrl,
                              message: conversation.lastMessage,
                              time: conversation.lastMessageTime.toString(),
                              isOnline: isSentWithinLast2Minutes(
                                conversation.lastMessageTime,
                              ),
                            );
                          },
                        );
                      } else if (state is ConversationsError) {
                        showErrorPopup(
                          context: context,
                          errorName: "CONVERSATIONS FAILED",
                          errorType: "External-error",
                          errorText: state.error,
                          errorIcon: Icons.warning_amber_rounded,
                        );
                        return Center(
                          child: Text(
                            "Failed to load conversation",
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 50,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No conversations yet',
                              style: TextStyle(color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () async {
          final reRecentsBloc = BlocProvider.of<RecentsBloc>(context);
          var res = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactsPage()),
          );
          if (res == null) {
            reRecentsBloc.add(LoadRecentContacts());
          }
        },
        backgroundColor: DefaultColors.contactButtonColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: const Icon(Icons.contacts, color: Colors.white, size: 28),
      ),
    );
  }

  // --- Widgets ---

  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Messages",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: .2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 22,
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    showErrorPopup(
                      context: context,
                      errorName: "WARNING",
                      errorType: "unimplemented-warning",
                      errorText:
                          "This feature is not yet implemented\n~lazy developer.",
                      errorIcon: Icons.construction,
                      errorColor: Colors.green,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: .2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 22,
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SettingsPage()),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: .2),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  splashRadius: 22,
                  icon: const Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () async {
                    final confirm = await showLogoutConfirmation(context);
                    if (confirm == true) {
                      // ignore: use_build_context_synchronously
                      context.read<AuthBloc>().add(LogoutEvent());
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const LoginPage(isLogout: true),
                        ),
                        (_) => false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentContact(
    BuildContext context,
    String conversationId,
    String name,
    String profileUrl, {
    bool asset = false,
    List<Color> statusEffect = const [
      Color(0xFFA4A0A0),
      Color(0xFF757575), // grey 600
    ],
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {
          Widget page;
          if (conversationId == 'local') {
            page = LocalGeminiChat(
              participantName: name,
              participantProfileUrl: profileUrl,
              isAsset: asset,
            );
          } else if (conversationId == 'creator') {
            page = const DspPage();
          } else {
            page = ChatPage(
              conversationId: conversationId,
              participantName: name,
              participantProfileUrl: profileUrl,
              ass: asset,
            );
          }
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Gradient Ring Effect
                gradient: LinearGradient(colors: statusEffect),
              ),
              child: Container(
                padding: const EdgeInsets.all(
                  2,
                ), // White space between ring and image
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: CircleAvatar(
                  radius: 28,
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
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 70,
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile({
    required BuildContext context,
    required String conversationId,
    required String name,
    required String profileUrl,
    required String message,
    required String time,
    bool isOnline = false,
  }) {
    return InkWell(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Profile Image
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(profileUrl),
                  backgroundColor: DefaultColors.profileIconBackground,
                  child: profileUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                // Online Indicator (Mockup)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isOnline ? Colors.green : Colors.white70,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 15),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _formatTime(time),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String timeString) {
    // Simple parser to make the time look cleaner than standard toString()
    try {
      final DateTime date = DateTime.parse(
        timeString,
      ); // Assuming standard ISO string
      final now = DateTime.now();

      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        // Return only time if it's today
        return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
      } else {
        // Return date if older
        return "${date.day}/${date.month}";
      }
    } catch (e) {
      return ""; // Return empty or original string if parsing fails
    }
  }

  Future<bool?> showLogoutConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Log out?", style: TextStyle(color: Colors.white)),
          content: const Text(
            "You will be signed out and redirected to the login screen.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Log out",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}
