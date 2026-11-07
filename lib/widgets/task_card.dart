import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../screens/task_detail_screen.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});
  final TaskModel task;
  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy').format(task.dueDate);
    return Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      leading: CircleAvatar(child: Icon(task.isCompleted ? Icons.check : Icons.assignment_outlined)),
      title: Text(task.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${task.course} • $date\nPrioritas: ${task.priority}', maxLines: 2),
      isThreeLine: true,
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task))),
    ));
  }
}
