// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Core
import 'core/app_theme.dart';
import 'core/api_client.dart';

// Features
import 'features/videos/videos_page.dart';
import 'features/articles_news/articles_page.dart';
import 'features/quizzes/quizzes_page.dart';
import 'features/chatbot/chatbot_page.dart';
import 'features/rewards/rewards_page.dart';
import 'features/billing/bill_upload_page.dart';

void main() {
  runApp(const SDG7App());
}

// ------------------------------------------------------------
// Router setup
// ------------------------------------------------------------
final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomePage()),
    GoRoute(path: '/videos', builder: (_, __) => const VideosPage()),
    GoRoute(path: '/articles', builder: (_, __) => const ArticlesPage()),
    GoRoute(path: '/quizzes', builder: (_, __) => const QuizzesPage()),
    GoRoute(path: '/chatbot', builder: (_, __) => const ChatbotPage()),
    GoRoute(path: '/rewards', builder: (_, __) => const RewardsPage()),
    GoRoute(path: '/billing', builder: (_, __) => const BillUploadPage()),
  ],
);

// ------------------------------------------------------------
// Root widget
// ------------------------------------------------------------
class SDG7App extends StatelessWidget {
  const SDG7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SDG7 Knowledge Hub',
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light, // unified theme from core/app_theme.dart
    );
  }
}

// ------------------------------------------------------------
// Home page with quick links & health check
// ------------------------------------------------------------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('/videos', Icons.play_circle_outline, 'Educational Videos'),
      ('/articles', Icons.article_outlined, 'Articles & Daily News'),
      ('/quizzes', Icons.quiz_outlined, 'Interactive Quizzes'),
      ('/chatbot', Icons.chat_bubble_outline, 'Chatbot Support'),
      ('/rewards', Icons.card_giftcard_outlined, 'Rewards & Coins'),
      ('/billing', Icons.upload_file_outlined, 'Upload Electricity Bill'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('SDG7 – Knowledge Hub'),
        actions: [
          IconButton(
            tooltip: 'Check API',
            icon: const Icon(Icons.wifi_tethering),
            onPressed: () async {
              final ok = await ApiClient.health();
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ok ? '✅ API Connected' : '❌ API not reachable'),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (route, icon, label) = items[i];
          return Card(
            child: ListTile(
              leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
              title: Text(label),
              // ✅ Use push() so Android Back navigates properly
              onTap: () => context.push(route),
            ),
          );
        },
      ),
    );
  }
}
