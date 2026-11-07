import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

class CompletedScreen extends StatelessWidget {
  const CompletedScreen({super.key});
  @override
  Widget build(BuildContext context) => Consumer<TaskProvider>(builder: (context, p, _) => Scaffold(
    appBar: AppBar(title: const Text('Tugas Selesai')),
    body: p.completedTasks.isEmpty ? const Center(child: Text('Belum ada tugas yang diselesaikan.'))
      : ListView.builder(padding: const EdgeInsets.all(16), itemCount: p.completedTasks.length, itemBuilder: (_, i) => TaskCard(task: p.completedTasks[i])),
  ));
}
