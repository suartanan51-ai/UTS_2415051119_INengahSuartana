class TaskModel {
  const TaskModel({
    this.id,
    required this.title,
    required this.description,
    required this.course,
    required this.dueDate,
    this.priority = 'Sedang',
    this.isCompleted = false,
    this.createdAt,
  });

  final int? id;
  final String title;
  final String description;
  final String course;
  final DateTime dueDate;
  final String priority;
  final bool isCompleted;
  final DateTime? createdAt;

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'] as int?,
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString() ?? '',
        course: json['course']?.toString() ?? 'Umum',
        dueDate: DateTime.tryParse(json['due_date']?.toString() ?? '') ?? DateTime.now(),
        priority: json['priority']?.toString() ?? 'Sedang',
        isCompleted: json['is_completed'] == true,
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      );

  Map<String, dynamic> toInsertJson() => {
        'title': title,
        'description': description,
        'course': course,
        'due_date': dueDate.toIso8601String(),
        'priority': priority,
        'is_completed': isCompleted,
      };

  TaskModel copyWith({
    int? id,
    String? title,
    String? description,
    String? course,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
  }) => TaskModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        course: course ?? this.course,
        dueDate: dueDate ?? this.dueDate,
        priority: priority ?? this.priority,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt,
      );
}
