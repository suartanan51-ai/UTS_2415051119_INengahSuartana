import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.databaseConfigured});
  final bool databaseConfigured;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => context.read<TaskProvider>().loadApiReferences());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(title: const Text('TaskMate', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [IconButton(onPressed: provider.loadTasks, icon: const Icon(Icons.refresh))]),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskFormScreen())),
          icon: const Icon(Icons.add), label: const Text('Tambah Tugas')),
        body: RefreshIndicator(
          onRefresh: () async { await provider.loadTasks(); await provider.loadApiReferences(); },
          child: ListView(padding: const EdgeInsets.all(20), children: [
            Text('Halo, Suartana!', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text('Atur tugas kuliahmu agar lebih terarah.'),
            if (!widget.databaseConfigured) ...[
              const SizedBox(height: 16),
              const Card(child: Padding(padding: EdgeInsets.all(14), child: Text('Supabase belum terhubung. Tambahkan URL dan anon key sesuai panduan README untuk mengaktifkan CRUD database.'))),
            ],
            const SizedBox(height: 20),
            LayoutBuilder(builder: (context, c) {
              final count = c.maxWidth > 600 ? 3 : 2;
              return GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: count, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.65,
                children: [
                  SummaryCard(title: 'Total Tugas', value: '${provider.tasks.length}', icon: Icons.assignment, color: const Color(0xFF536DFE)),
                  SummaryCard(title: 'Belum Selesai', value: '${provider.activeTasks.length}', icon: Icons.pending_actions, color: const Color(0xFFFFA726)),
                  SummaryCard(title: 'Selesai', value: '${provider.completedTasks.length}', icon: Icons.check_circle, color: const Color(0xFF26A69A)),
                ]);
            }),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Tugas Terbaru', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              TextButton(onPressed: () {}, child: const Text('')),
            ]),
            if (provider.isLoading) const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else if (provider.error != null) Card(child: Padding(padding: const EdgeInsets.all(16), child: Text('Gagal memuat tugas: ${provider.error}')))
            else if (provider.tasks.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('Belum ada tugas. Tekan Tambah Tugas untuk memulai.')))
            else ...provider.tasks.take(4).map((task) => TaskCard(task: task)),
            const SizedBox(height: 20),
            Text('Referensi dari REST API', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            if (provider.isApiLoading) const LinearProgressIndicator()
            else if (provider.apiError != null) Text('API tidak dapat diakses: ${provider.apiError}')
            else ...provider.apiReferences.take(4).map((item) => ListTile(
              contentPadding: EdgeInsets.zero, leading: const Icon(Icons.cloud_download_outlined),
              title: Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(item.completed ? 'Status API: selesai' : 'Status API: belum selesai'),
            )),
          ]),
        ),
      );
    });
  }
}
