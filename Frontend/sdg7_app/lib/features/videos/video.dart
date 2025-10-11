// lib/features/videos/video.dart
class Video {
  final String id;
  final String title;
  final String url;

  Video({required this.id, required this.title, required this.url});

  factory Video.fromJson(Map<String, dynamic> j) =>
      Video(id: j['id'] ?? '', title: j['title'] ?? '', url: j['url'] ?? '');
}
