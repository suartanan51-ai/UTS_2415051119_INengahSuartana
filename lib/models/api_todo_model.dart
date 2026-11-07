class ApiTodoModel {
  const ApiTodoModel({required this.id, required this.title, required this.completed});
  final int id;
  final String title;
  final bool completed;

  factory ApiTodoModel.fromJson(Map<String, dynamic> json) => ApiTodoModel(
    id: json['id'] as int,
    title: json['title']?.toString() ?? '',
    completed: json['completed'] == true,
  );
}
