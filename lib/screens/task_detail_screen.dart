import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import 'task_form_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMMM yyyy', 'id_ID').format(task.dueDate);
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas'), actions: [
        IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)))),
        IconButton(icon: const Icon(Icons.delete_outline), onPressed: () async {
          final confirm = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
            title: const Text('Hapus tugas?'), content: const Text('Data tugas ini akan dihapus dari database.'),
            actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus'))]));
          if (confirm == true && task.id != null && context.mounted) {
            try { await context.read<TaskProvider>().deleteTask(task.id!); if (context.mounted) Navigator.pop(context); }
            catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e'))); }
          }
        }),
      ]),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        Text(task.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        _InfoTile(icon: Icons.menu_book_outlined, label: 'Mata Kuliah', value: task.course),
        _InfoTile(icon: Icons.calendar_month_outlined, label: 'Tenggat', value: date),
        _InfoTile(icon: Icons.flag_outlined, label: 'Prioritas', value: task.priority),
        _InfoTile(icon: Icons.check_circle_outline, label: 'Status', value: task.isCompleted ? 'Selesai' : 'Belum selesai'),
        const SizedBox(height: 16),
        const Text('Deskripsi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(task.description.isEmpty ? 'Tidak ada deskripsi.' : task.description),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: () async {
          try { await context.read<TaskProvider>().toggleCompleted(task); if (context.mounted) Navigator.pop(context); }
          catch (e) { if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal mengubah status: $e'))); }
        }, icon: const Icon(Icons.check), label: Text(task.isCompleted ? 'Tandai Belum Selesai' : 'Tandai Selesai')),
      ]),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.icon, required this.label, required this.value});
  final IconData icon; final String label; final String value;
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(leading: Icon(icon), title: Text(label), subtitle: Text(value)));
}
