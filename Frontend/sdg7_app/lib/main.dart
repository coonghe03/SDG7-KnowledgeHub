// lib/main.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/api_client.dart';
import 'core/app_theme.dart';

import 'features/videos/videos_page.dart';
import 'features/articles_news/articles_page.dart';
import 'features/quizzes/quizzes_page.dart';
import 'features/rewards/rewards_page.dart';
import 'features/billing/bill_upload_page.dart';
import 'features/chatbot/chatbot_page.dart';

void main() {
  runApp(const SDG7App());
}

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

class SDG7App extends StatelessWidget {
  const SDG7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SDG7 Knowledge Hub',
      routerConfig: _router,
      theme: AppTheme.light, // use the shared theme
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <(String, String, IconData)>[
      ('/videos', 'Educational Videos', Icons.play_circle_outline),
      ('/articles', 'Articles & Daily News', Icons.article_outlined),
      ('/quizzes', 'Interactive Quizzes', Icons.quiz_outlined),
      ('/chatbot', 'Chatbot Support', Icons.smart_toy_outlined),
      ('/rewards', 'Rewards & Coins', Icons.workspace_premium_outlined),
      ('/billing', 'Upload Electricity Bill', Icons.upload_file),
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
              final msg = ok ? 'API OK ✅' : 'API not reachable ❌';
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final (route, label, icon) = items[i];
          return InkWell(
            onTap: () => context.go(route),
            borderRadius: BorderRadius.circular(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 38),
                    const SizedBox(height: 12),
                    Text(label, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
