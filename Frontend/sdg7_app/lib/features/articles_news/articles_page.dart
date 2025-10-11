import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sdg7_app/core/api_client.dart';
import 'article.dart';

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});
  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final _controller = TextEditingController();
  late Future<List<Article>> _future;

  Future<List<Article>> _load({String q = ''}) async {
    final rows = await ApiClient.getArticles(q: q);
    return rows.map((e) => Article.fromJson(e)).toList();
  }

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  void _search() {
    final q = _controller.text.trim();
    setState(() => _future = _load(q: q));
  }

  Future<void> _refresh() async {
    setState(() => _future = _load(q: _controller.text.trim()));
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Articles & Daily News')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Search (solar, wind, tips...)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _search,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Article>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Couldn’t load articles.\nPlease check your connection and try again.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final data = snap.data ?? [];
                if (data.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No articles found.\nTry a different search or check again later.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: data.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final a = data[i];
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(width: 0.5),
                        ),
                        title: Text(a.title),
                        subtitle: Text('${a.source} • ${a.publishedAt}\n${a.summary}'),
                        isThreeLine: true,
                        trailing: const Icon(Icons.open_in_new),
                        onTap: () async {
                          final uri = Uri.parse(a.url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          } else {
                            await launchUrl(uri);
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
