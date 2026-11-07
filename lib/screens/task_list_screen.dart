import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, p, _) => Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas')),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskFormScreen())), child: const Icon(Icons.add)),
      body: p.isLoading ? const Center(child: CircularProgressIndicator())
        : p.error != null ? Center(child: Padding(padding: const EdgeInsets.all(20), child: Text('Terjadi kesalahan: ${p.error}')))
        : p.tasks.isEmpty ? const Center(child: Text('Belum ada tugas.'))
        : LayoutBuilder(builder: (context, c) {
          if (c.maxWidth >= 750) {
            return GridView.builder(padding: const EdgeInsets.all(20), gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 420, mainAxisExtent: 125, crossAxisSpacing: 12, mainAxisSpacing: 12), itemCount: p.tasks.length, itemBuilder: (_, i) => TaskCard(task: p.tasks[i]));
          }
          return ListView.builder(padding: const EdgeInsets.all(16), itemCount: p.tasks.length, itemBuilder: (_, i) => TaskCard(task: p.tasks[i]));
        }),
    ));
  }
}
