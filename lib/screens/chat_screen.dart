import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:project001/theme/app_theme.dart';
import 'package:project001/providers/auth_provider.dart';
import 'package:project001/services/chatbot_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Guest users see login prompt
    if (!auth.isAuthenticated) {
      return const _GuestPrompt();
    }

    final schoolCode = auth.userProfile?['schoolCode'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  const Text(
                    '💬 Chat',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (schoolCode.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        schoolCode,
                        style: const TextStyle(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: '🏫 School Chat'),
                  Tab(text: '🤖 FAQ Bot'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _SchoolChatTab(schoolCode: schoolCode, auth: auth),
                  const _FaqBotTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Guest Prompt ──────────────────────────────────────────────────────────────

class _GuestPrompt extends StatelessWidget {
  const _GuestPrompt();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.messageCircle,
                    size: 60,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Login to access Chat',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Chat with your school and get\nanswers to disaster FAQs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to profile tab (index 4)
                      // Using a simple Navigator push to profile
                    },
                    child: const Text('Login / Register'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── School Chat Tab ───────────────────────────────────────────────────────────

class _SchoolChatTab extends StatefulWidget {
  final String schoolCode;
  final AuthProvider auth;

  const _SchoolChatTab({required this.schoolCode, required this.auth});

  @override
  State<_SchoolChatTab> createState() => _SchoolChatTabState();
}

class _SchoolChatTabState extends State<_SchoolChatTab> {
  final TextEditingController _messageCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageCtrl.text.trim();
    if (text.isEmpty || widget.schoolCode.isEmpty) return;

    setState(() => _isSending = true);
    _messageCtrl.clear();

    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(widget.schoolCode)
          .collection('channel')
          .add({
        'senderId': widget.auth.user!.uid,
        'senderName': widget.auth.userProfile?['name'] ?? 'User',
        'senderRole': widget.auth.userProfile?['role'] ?? 'student',
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Scroll to bottom after sending
      await Future.delayed(const Duration(milliseconds: 200));
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message'), backgroundColor: AppTheme.alertRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.schoolCode.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Join a school to access school chat.\nGo to Profile and register with a school code.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Messages List
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('messages')
                .doc(widget.schoolCode)
                .collection('channel')
                .orderBy('timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.messageSquare,
                          size: 48, color: Colors.grey.withValues(alpha: 0.4)),
                      const SizedBox(height: 16),
                      const Text(
                        'No messages yet.\nBe the first to say something!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              final docs = snapshot.data!.docs;
              return ListView.builder(
                controller: _scrollCtrl,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>;
                  final isMe = data['senderId'] == widget.auth.user?.uid;
                  return _MessageBubble(data: data, isMe: isMe);
                },
              );
            },
          ),
        ),

        // Message Input
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppTheme.borderLight)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageCtrl,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _isSending ? null : _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isSending ? Colors.grey : AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: _isSending
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(LucideIcons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isMe;

  const _MessageBubble({required this.data, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final isAdmin = data['senderRole'] == 'admin';
    final time = data['timestamp'] != null
        ? _formatTime((data['timestamp'] as Timestamp).toDate())
        : '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Row(
                children: [
                  Text(
                    data['senderName'] ?? 'User',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isAdmin ? AppTheme.alertRed : AppTheme.textSecondary,
                    ),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.alertRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ADMIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          Row(
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMe)
                Text(time,
                    style: const TextStyle(
                        fontSize: 10, color: AppTheme.textSecondary)),
              if (isMe) const SizedBox(width: 6),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? AppTheme.primaryBlue : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    border: isMe
                        ? null
                        : Border.all(color: AppTheme.borderLight),
                  ),
                  child: Text(
                    data['text'] ?? '',
                    style: TextStyle(
                      color: isMe ? Colors.white : AppTheme.textPrimary,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
              if (!isMe) const SizedBox(width: 6),
              if (!isMe)
                Text(time,
                    style: const TextStyle(
                        fontSize: 10, color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day) {
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    }
    return '${dt.day}/${dt.month}';
  }
}

// ─── FAQ Bot Tab ───────────────────────────────────────────────────────────────

class _FaqBotTab extends StatefulWidget {
  const _FaqBotTab();

  @override
  State<_FaqBotTab> createState() => _FaqBotTabState();
}

class _FaqBotTabState extends State<_FaqBotTab> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  final List<Map<String, String>> _chatHistory = [];
  bool _showSuggestions = true;

  void _askQuestion(String question) {
    final results = ChatbotService.search(question);
    setState(() {
      _chatHistory.add({'type': 'user', 'text': question});
      _showSuggestions = false;
      for (final result in results) {
        _chatHistory.add({'type': 'bot', 'text': '**${result['q']}**\n\n${result['a']}' });
      }
    });
    _searchCtrl.clear();

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bot Header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Text('🤖', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Disaster FAQ Bot',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary)),
                    Text('Offline · Works without internet',
                        style:
                            TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.safeGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('ONLINE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        // Chat history / Suggestions
        Expanded(
          child: _showSuggestions && _chatHistory.isEmpty
              ? _buildSuggestions()
              : ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _chatHistory.length,
                  itemBuilder: (context, index) {
                    final msg = _chatHistory[index];
                    final isUser = msg['type'] == 'user';
                    return _BotMessage(text: msg['text']!, isUser: isUser);
                  },
                ),
        ),

        // Input
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppTheme.borderLight)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Koi sawaal poochho...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(LucideIcons.search,
                        size: 18, color: AppTheme.textSecondary),
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isNotEmpty) _askQuestion(val.trim());
                  },
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_searchCtrl.text.trim().isNotEmpty) {
                    _askQuestion(_searchCtrl.text.trim());
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(LucideIcons.send,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    final suggestions = ChatbotService.getSuggestions();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '👋 Namaste! Koi sawaal poochho disaster safety ke baare mein.',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          const Text(
            'Suggested Questions:',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
                fontSize: 13),
          ),
          const SizedBox(height: 12),
          ...suggestions.map((s) => GestureDetector(
                onTap: () => _askQuestion(s),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.borderLight),
                  ),
                  child: Row(
                    children: [
                      const Text('💬', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(s,
                            style: const TextStyle(
                                color: AppTheme.textPrimary, fontSize: 14)),
                      ),
                      const Icon(LucideIcons.chevronRight,
                          size: 16, color: AppTheme.textSecondary),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class _BotMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const _BotMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              margin: const EdgeInsets.only(right: 8, top: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Text('🤖', style: TextStyle(fontSize: 14)),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryBlue : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                border: isUser ? null : Border.all(color: AppTheme.borderLight),
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isUser ? Colors.white : AppTheme.textPrimary,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
