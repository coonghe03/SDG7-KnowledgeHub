import 'package:flutter/material.dart';
import 'package:sdg7_app/core/api_client.dart';
import 'package:sdg7_app/core/user_config.dart';
import 'quiz_models.dart';

class QuizzesPage extends StatefulWidget {
  const QuizzesPage({super.key});
  @override
  State<QuizzesPage> createState() => _QuizzesPageState();
}

class _QuizzesPageState extends State<QuizzesPage> {
  final topics = const ['solar', 'wind'];
  String topic = 'solar';
  List<QuizQuestion> qs = [];
  List<int?> answers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final data = await ApiClient.getQuiz(topic);
    final list = (data['questions'] as List)
        .map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
        .toList();
    setState(() {
      qs = list;
      answers = List<int?>.filled(qs.length, null);
      loading = false;
    });
  }

  Future<void> _submit() async {
    // ensure all answered
    if (answers.any((a) => a == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions')),
      );
      return;
    }
    final res = await ApiClient.submitQuiz(
      userId: UserConfig.userId,
      topic: topic,
      answers: answers.cast<int>(),
    );
    final score = res['scorePct'];
    final coins = res['coinsEarned'];
    final passed = res['passed'] == true;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Result'),
        content: Text('Score: $score%\nPassed: ${passed ? "Yes" : "No"}\nCoins earned: $coins'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Quiz'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: topic,
              items: topics.map((t) => DropdownMenuItem(value: t, child: Text(t.toUpperCase()))).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() => topic = v);
                _load();
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: qs.length + 1,
              itemBuilder: (context, i) {
                if (i == qs.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.check),
                      label: const Text('Submit Quiz'),
                    ),
                  );
                }
                final q = qs[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q${i + 1}. ${q.q}', style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        ...List.generate(q.options.length, (idx) {
                          return RadioListTile<int>(
                            value: idx,
                            groupValue: answers[i],
                            onChanged: (v) => setState(() => answers[i] = v),
                            title: Text(q.options[idx]),
                          );
                        })
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
