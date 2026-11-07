import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_todo_model.dart';

class ApiService {
  static const _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<ApiTodoModel>> fetchReferenceTasks() async {
    final response = await http.get(Uri.parse('$_baseUrl/todos?_limit=8'))
        .timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data API (${response.statusCode})');
    }
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => ApiTodoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
