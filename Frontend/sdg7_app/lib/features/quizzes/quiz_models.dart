class QuizQuestion {
  final String q;
  final List<String> options;
  QuizQuestion({required this.q, required this.options});

  factory QuizQuestion.fromJson(Map<String, dynamic> j) =>
      QuizQuestion(q: j['q'] ?? '', options: (j['options'] as List).cast<String>());
}
