
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
  bool _isSaving = false;

  String? _error;
  String? _apiError;
  String? _operationError;

  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<TaskModel> get activeTasks =>
      _tasks.where((task) => !task.isCompleted).toList();

  List<ApiTodoModel> get apiReferences =>
      List.unmodifiable(_apiReferences);

  bool get isLoading => _isLoading;
  bool get isApiLoading => _isApiLoading;
  bool get isSaving => _isSaving;

  String? get error => _error;
  String? get apiError => _apiError;
  String? get operationError => _operationError;

  Future<void> loadTasks() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await repository.getTasks();
    } catch (e) {
      _error = 'Gagal memuat tugas. Periksa koneksi dan coba lagi.';
      debugPrint('Load tasks error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadApiReferences() async {
    if (_isApiLoading) return;

    _isApiLoading = true;
    _apiError = null;
    notifyListeners();

    try {
      _apiReferences = await repository.getApiReferences();
    } catch (e) {
      _apiError = 'Gagal mengambil data API. Silakan coba lagi.';
      debugPrint('API error: $e');
    } finally {
      _isApiLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask(TaskModel task) async {
    return _performOperation(() async {
      final created = await repository.addTask(task);
      _tasks = [..._tasks, created];
    });
  }

  Future<bool> updateTask(TaskModel task) async {
    return _performOperation(() async {
      final updated = await repository.editTask(task);

      _tasks = _tasks
          .map((item) => item.id == updated.id ? updated : item)
          .toList();
    });
  }

  Future<bool> deleteTask(int id) async {
    return _performOperation(() async {
      await repository.removeTask(id);

      _tasks = _tasks.where((task) => task.id != id).toList();
    });
  }

  Future<bool> toggleCompleted(TaskModel task) {
    return updateTask(
      task.copyWith(isCompleted: !task.isCompleted),
    );
  }

  Future<bool> _performOperation(
    Future<void> Function() operation,
  ) async {
    if (_isSaving) return false;

    _isSaving = true;
    _operationError = null;
    notifyListeners();

    try {
      await operation();
      return true;
    } catch (e) {
      _operationError = 'Operasi gagal. Silakan coba kembali.';
      debugPrint('Task operation error: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
