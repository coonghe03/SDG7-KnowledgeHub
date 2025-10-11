import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sdg7_app/core/api_client.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});
  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class ChatMessage {
  final String role; // 'user' | 'bot'
  final String text;
  ChatMessage(this.role, this.text);
}

class _ChatbotPageState extends State<ChatbotPage> {
  final _controller = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<ChatMessage> _messages = [
    ChatMessage('bot', 'Hi! I’m your SDG 7 helper. Ask me about solar, wind, hydro, energy tips, quizzes, or rewards.')
  ];
  bool _typing = false;
  List<Map<String, String>> _suggestions = const [
    {'label': 'What is SDG 7?', 'q': 'What is SDG 7?'},
    {'label': 'Solar basics', 'q': 'Explain solar basics'},
    {'label': 'Energy tips', 'q': 'Give me energy conservation tips'},
    {'label': 'Rewards rule', 'q': 'How do I earn coins and rewards?'}
  ];

  Future<void> _send(String text) async {
    final q = text.trim();
    if (q.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage('user', q));
      _typing = true;
    });
    _controller.clear();

    try {
      final res = await ApiClient.askChatbot(q);
      final answer = (res['answer'] ?? '').toString();
      final sugg = (res['suggestions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      setState(() {
        _messages.add(ChatMessage('bot', answer));
        _suggestions = sugg
            .map((e) => {'label': (e['label'] ?? '').toString(), 'route': (e['route'] ?? '').toString()})
            .toList()
            .cast<Map<String, String>>();
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage('bot', 'Sorry, I had an error: $e'));
      });
    } finally {
      setState(() => _typing = false);
      await Future.delayed(const Duration(milliseconds: 50));
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: Column(
        children: [
          // Suggestions bar
          if (_suggestions.isNotEmpty)
            SizedBox(
              height: 46,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final s = _suggestions[i];
                  // If suggestion has route -> navigate, else send as question
                  final label = s['label'] ?? '';
                  final route = s['route'];
                  return ActionChip(
                    label: Text(label),
                    onPressed: () {
                      if (route != null && route.isNotEmpty) {
                        context.go(route);
                      } else if (s['q'] != null) {
                        _send(s['q']!);
                      }
                    },
                  );
                },
              ),
            ),
          const Divider(height: 1),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_typing ? 1 : 0),
              itemBuilder: (_, i) {
                if (_typing && i == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('…typing'),
                    ),
                  );
                }
                final m = _messages[i];
                final isUser = m.role == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 320),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(m.text),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Input
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _send,
                      decoration: const InputDecoration(
                        hintText: 'Ask about SDG 7 (e.g., “solar basics”)',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _send(_controller.text),
                    icon: const Icon(Icons.send),
                    label: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
