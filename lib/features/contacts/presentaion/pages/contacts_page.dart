import 'dart:ui';
import 'package:chatapp/core/show_error.dart';
import 'package:chatapp/features/chat/presentaion/pages/chat_page.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_bloc.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_event.dart';
import 'package:chatapp/features/contacts/presentaion/bloc/contacts_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContactsBloc>(context).add(FetchContacts());
  }

  @override
  Widget build(BuildContext context) {
    // Define modern dark colors
    final cardColor = const Color(0xFF1E1E1E).withValues(alpha: 0.7);

    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows background to stretch behind AppBar
      backgroundColor: Colors.black, // Fallback color
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Contacts",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withValues(alpha: 0.2)),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.person_add_alt_1, color: Colors.white),
              onPressed: () => _showAddContactDialog(context),
            ),
          ),
        ],
      ),
      body: BlocListener<ContactsBloc, ContactsState>(
        listener: (context, state) async {
          final contactsBloc = BlocProvider.of<ContactsBloc>(context);

          if (state is ConversationReady) {
            var res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  conversationId: state.conversationId,
                  participantName: state.contactName,
                  participantProfileUrl: state.contactProfileUrl,
                ),
              ),
            );
            if (res == null) {
              contactsBloc.add(FetchContacts());
            }
          }
        },
        child: BlocBuilder<ContactsBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactsLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (state is ContactsLoaded) {
              if (state.contacts.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  110,
                  16,
                  20,
                ), // Top padding accounts for AppBar
                physics: const BouncingScrollPhysics(),
                itemCount: state.contacts.length,
                itemBuilder: (context, index) {
                  final contact = state.contacts[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 7),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: .08),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          BlocProvider.of<ContactsBloc>(context).add(
                            CheckOrCreateConversation(
                              contact.id,
                              contact.username,
                              contact.profileUrl,
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Avatar with gradient border
                              Container(
                                padding: const EdgeInsets.all(2),

                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.black,
                                  backgroundImage: NetworkImage(
                                    contact.profileUrl,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Text Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      contact.username,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      contact.email,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: .5,
                                        ),
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),

                              // Action Button
                              IconButton(
                                onPressed: () {
                                  // TODO: Implement delete logic
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
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white.withValues(alpha: .6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is ContactsError) {
              showErrorPopup(
                context: context,
                errorName: "CONTACTS FAILED",
                errorType: "External-error",
                errorText: state.error,
                errorIcon: Icons.warning_amber_rounded,
              );
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Failed to load contacts",
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.perm_contact_calendar_outlined,
            size: 80,
            color: Colors.white.withValues(alpha: .2),
          ),
          const SizedBox(height: 20),
          Text(
            "No contacts yet",
            style: TextStyle(
              color: Colors.white.withValues(alpha: .5),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => _showAddContactDialog(context),
            child: const Text("Add your first contact"),
          ),
        ],
      ),
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final emailController = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) => Container(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim1.value),
          child: AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'Add Contact',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter contact email...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final email = emailController.text.trim();
                  if (email.isNotEmpty) {
                    BlocProvider.of<ContactsBloc>(
                      context,
                    ).add(AddContact(email));
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: const Text("Add", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }
}
