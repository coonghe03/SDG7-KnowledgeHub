import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const SDG7App());
}

class SDG7App extends StatelessWidget {
  const SDG7App({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomePage()),
        GoRoute(path: '/videos', builder: (_, __) => const PlaceholderPage(title: 'Videos')),
        GoRoute(path: '/articles', builder: (_, __) => const PlaceholderPage(title: 'Articles & News')),
        GoRoute(path: '/quizzes', builder: (_, __) => const PlaceholderPage(title: 'Quizzes')),
        GoRoute(path: '/chatbot', builder: (_, __) => const PlaceholderPage(title: 'Chatbot')),
        GoRoute(path: '/rewards', builder: (_, __) => const PlaceholderPage(title: 'Rewards')),
        GoRoute(path: '/billing', builder: (_, __) => const PlaceholderPage(title: 'Bill Upload')),
      ],
    );

    return MaterialApp.router(
      title: 'SDG7 Knowledge Hub',
      routerConfig: router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0BA360)),
        useMaterial3: true,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('/videos', 'Educational Videos'),
      ('/articles', 'Articles & Daily News'),
      ('/quizzes', 'Interactive Quizzes'),
      ('/chatbot', 'Chatbot Support'),
      ('/rewards', 'Rewards & Coins'),
      ('/billing', 'Upload Electricity Bill'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('SDG7 – Knowledge Hub')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (route, label) = items[i];
          return ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed(route),
            child: Align(alignment: Alignment.centerLeft, child: Text(label)),
          );
        },
      ),
    );
  }
}

class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title – coming soon')),
    );
  }
}
