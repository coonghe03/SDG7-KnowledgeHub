// lib/features/videos/videos_page.dart
import 'package:flutter/material.dart';
import 'package:sdg7_app/core/api_client.dart';
import 'video.dart';

class VideosPage extends StatelessWidget {
  const VideosPage({super.key});

  Future<List<Video>> _load() async {
    final rows = await ApiClient.getVideos();
    return rows.map((e) => Video.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Educational Videos')),
      body: FutureBuilder<List<Video>>(
        future: _load(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final data = snap.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No videos yet'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final v = data[i];
              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(width: 0.5),
                ),
                title: Text(v.title),
                subtitle: Text(v.url),
                trailing: const Icon(Icons.play_circle_outline),
                onTap: () {
                  // later: open a video player page
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Open: ${v.title}')),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
