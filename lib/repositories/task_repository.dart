import '../models/api_todo_model.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
import '../services/supabase_service.dart';

class TaskRepository {
  TaskRepository({required this.apiService, required this.supabaseService});
  final ApiService apiService;
  final SupabaseService supabaseService;

  Future<List<TaskModel>> getTasks() => supabaseService.getTasks();
  Future<TaskModel> addTask(TaskModel task) => supabaseService.createTask(task);
  Future<TaskModel> editTask(TaskModel task) => supabaseService.updateTask(task);
  Future<void> removeTask(int id) => supabaseService.deleteTask(id);
  Future<List<ApiTodoModel>> getApiReferences() => apiService.fetchReferenceTasks();
}
