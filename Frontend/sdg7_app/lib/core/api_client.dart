// lib/core/api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiClient {
  static String get _base => ApiConfig.baseUrl;

  static Future<bool> health() async {
    final res = await http.get(Uri.parse('$_base/health'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return data['ok'] == true;
    }
    return false;
  }

  static Future<List<Map<String, dynamic>>> getVideos() async {
    final res = await http.get(Uri.parse('$_base/videos'));
    if (res.statusCode != 200) {
      throw Exception('Videos fetch failed: ${res.statusCode}');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

    static Future<List<Map<String, dynamic>>> getArticles({String q = ''}) async {
    final url = q.isEmpty ? '$_base/articles' : '$_base/articles?q=${Uri.encodeQueryComponent(q)}';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('Articles fetch failed: ${res.statusCode}');
    }
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.cast<Map<String, dynamic>>();
  }

    static Future<Map<String, dynamic>> getQuiz(String topic) async {
    final res = await http.get(Uri.parse('$_base/quizzes/$topic'));
    if (res.statusCode != 200) {
      throw Exception('Quiz fetch failed: ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> submitQuiz({
    required String userId,
    required String topic,
    required List<int> answers,
  }) async {
    final res = await http.post(
      Uri.parse('$_base/quizzes/submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'topic': topic, 'answers': answers}),
    );
    if (res.statusCode != 200) {
      throw Exception('Quiz submit failed: ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> getRewardsBalance(String userId) async {
    final res = await http.get(Uri.parse('$_base/rewards/balance/$userId'));
    if (res.statusCode != 200) {
      throw Exception('Balance fetch failed: ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> uploadBill({
    required String userId,
    required String filename,
    List<int>? bytes,     // for web
    String? filePath,     // for mobile/desktop
  }) async {
    final uri = Uri.parse('$_base/billing/upload');
    final req = http.MultipartRequest('POST', uri)
      ..fields['userId'] = userId;

    if (bytes != null) {
      req.files.add(http.MultipartFile.fromBytes('billPhoto', bytes, filename: filename));
    } else if (filePath != null) {
      req.files.add(await http.MultipartFile.fromPath('billPhoto', filePath));
    } else {
      throw Exception('No file provided');
    }

    final streamed = await req.send();
    final res = await http.Response.fromStream(streamed);
    if (res.statusCode != 200) {
      throw Exception('Bill upload failed: ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

    static Future<Map<String, dynamic>> askChatbot(String question) async {
    final res = await http.post(
      Uri.parse('$_base/chatbot/ask'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': question}),
    );
    if (res.statusCode != 200) {
      throw Exception('Chatbot error: ${res.statusCode}');
    }
    return jsonDecode(res.body) as Map<String, dynamic>;
  }


}
