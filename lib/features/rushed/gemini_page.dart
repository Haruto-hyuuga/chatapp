import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class LocalGeminiChat extends StatefulWidget {
  final String participantName;
  final String participantProfileUrl;
  final bool isAsset;

  const LocalGeminiChat({
    super.key,
    required this.participantName,
    required this.participantProfileUrl,
    this.isAsset = true,
  });

  @override
  State<LocalGeminiChat> createState() => _LocalGeminiChatState();
}

class _LocalGeminiChatState extends State<LocalGeminiChat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final _storage = FlutterSecureStorage();

  // Local temporary storage (RAM only)
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- LOCAL LOGIC & API ---
  void _handleSendMessage() async {
    final prompt = _messageController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": prompt});
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();

    try {
      // Logic for your Backend API
      String token = await _storage.read(key: 'token') ?? '';
      final response = await http.post(
        Uri.parse('https://chatapp-backend-1b8y.onrender.com/gemini'),
        body: jsonEncode({"prompt": prompt}),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      // print("PRINITING RESPONSE;\n ${response.body} \n ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({"role": "model", "content": data['message']});
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          _messages.add({"role": "model", "content": data['error']});
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "model",
          "content": "Failed to connect to Gemini.",
        });
      });
    } finally {
      setState(() => _isTyping = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark console theme
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              backgroundColor: const Color(0x77000000),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: widget.isAsset
                        ? AssetImage(widget.participantProfileUrl)
                              as ImageProvider
                        : NetworkImage(widget.participantProfileUrl),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.participantName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              actions: [
                // CLEAR BUTTON as requested
                IconButton(
                  onPressed: () => setState(() => _messages.clear()),
                  icon: const Icon(Icons.delete_outline, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      top: 100,
                      left: 20,
                      right: 20,
                      bottom: 20,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      return msg['role'] == 'user'
                          ? _buildSentMessage(context, msg['content']!)
                          : _buildReceivedMessage(context, msg['content']!);
                    },
                  ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.only(left: 20, bottom: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Gemini is thinking...",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.participantProfileUrl,
            height: 80,
            opacity: const AlwaysStoppedAnimation(0.5),
          ),
          const SizedBox(height: 16),
          const Text(
            "How can I help you today?",
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Color(0xFF303030),
          borderRadius: BorderRadius.circular(
            20,
          ).copyWith(bottomRight: const Radius.circular(4)),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildReceivedMessage(BuildContext context, String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundImage: AssetImage(widget.participantProfileUrl),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(
                  20,
                ).copyWith(topLeft: const Radius.circular(4)),
              ),
              child: MarkdownBody(
                data: message,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  code: TextStyle(
                    backgroundColor: Colors.black45,
                    color: Colors.blue[200],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF252525),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 15),
            Expanded(
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Enter a prompt here",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _handleSendMessage(),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.send_rounded,
                color: _isTyping ? Colors.blueGrey : Colors.blueAccent,
              ),
              onPressed: _handleSendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
