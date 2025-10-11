class Article {
  final String id;
  final String title;
  final String summary;
  final String url;
  final String source;
  final String publishedAt;

  Article({
    required this.id,
    required this.title,
    required this.summary,
    required this.url,
    required this.source,
    required this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> j) => Article(
        id: j['id'] ?? '',
        title: j['title'] ?? '',
        summary: j['summary'] ?? '',
        url: j['url'] ?? '',
        source: j['source'] ?? '',
        publishedAt: j['publishedAt'] ?? '',
      );
}
