import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_model.dart';

class SupabaseService {
  SupabaseService({required this.enabled});
  final bool enabled;

  SupabaseClient get _client => Supabase.instance.client;

  void _checkConfiguration() {
    if (!enabled) {
      throw Exception('Supabase belum dikonfigurasi. Ikuti langkah pada README.md.');
    }
  }

  Future<List<TaskModel>> getTasks() async {
    _checkConfiguration();
    final rows = await _client.from('tasks').select().order('due_date');
    return rows.map((row) => TaskModel.fromJson(row)).toList();
  }

  Future<TaskModel> createTask(TaskModel task) async {
    _checkConfiguration();
    final row = await _client.from('tasks').insert(task.toInsertJson()).select().single();
    return TaskModel.fromJson(row);
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    _checkConfiguration();
    if (task.id == null) throw Exception('ID tugas tidak ditemukan.');
    final row = await _client.from('tasks')
        .update(task.toInsertJson()).eq('id', task.id!).select().single();
    return TaskModel.fromJson(row);
  }

  Future<void> deleteTask(int id) async {
    _checkConfiguration();
    await _client.from('tasks').delete().eq('id', id);
  }
}
