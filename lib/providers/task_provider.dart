import 'package:flutter/foundation.dart';
import '../models/api_todo_model.dart';
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider({required this.repository});
  final TaskRepository repository;

  List<TaskModel> _tasks = [];
  List<ApiTodoModel> _apiReferences = [];
  bool _isLoading = false;
  bool _isApiLoading = false;
  String? _error;
  String? _apiError;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<TaskModel> get completedTasks => _tasks.where((t) => t.isCompleted).toList();
  List<TaskModel> get activeTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<ApiTodoModel> get apiReferences => List.unmodifiable(_apiReferences);
  bool get isLoading => _isLoading;
  bool get isApiLoading => _isApiLoading;
  String? get error => _error;
  String? get apiError => _apiError;

  Future<void> loadTasks() async {
    _isLoading = true; _error = null; notifyListeners();
    try { _tasks = await repository.getTasks(); }
    catch (e) { _error = e.toString(); }
    finally { _isLoading = false; notifyListeners(); }
  }

  Future<void> loadApiReferences() async {
    _isApiLoading = true; _apiError = null; notifyListeners();
    try { _apiReferences = await repository.getApiReferences(); }
    catch (e) { _apiError = e.toString(); }
    finally { _isApiLoading = false; notifyListeners(); }
  }

  Future<void> addTask(TaskModel task) async {
    final created = await repository.addTask(task);
    _tasks = [..._tasks, created]; notifyListeners();
  }

  Future<void> updateTask(TaskModel task) async {
    final updated = await repository.editTask(task);
    _tasks = _tasks.map((t) => t.id == updated.id ? updated : t).toList();
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await repository.removeTask(id);
    _tasks = _tasks.where((t) => t.id != id).toList(); notifyListeners();
  }

  Future<void> toggleCompleted(TaskModel task) => updateTask(task.copyWith(isCompleted: !task.isCompleted));
}
