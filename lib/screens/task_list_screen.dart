
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _selectedFilter = 'Semua';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, provider, _) {
        final query = _searchController.text.trim().toLowerCase();

        final filteredTasks = provider.tasks.where((task) {
          final matchesSearch =
              task.title.toLowerCase().contains(query) ||
              task.course.toLowerCase().contains(query);

          final matchesFilter = switch (_selectedFilter) {
            'Aktif' => !task.isCompleted,
            'Selesai' => task.isCompleted,
            _ => true,
          };

          return matchesSearch && matchesFilter;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Daftar Tugas'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TaskFormScreen(),
                ),
              );
            },
            tooltip: 'Tambah tugas',
            child: const Icon(Icons.add),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari nama tugas atau mata kuliah...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'Semua',
                            label: Text('Semua'),
                          ),
                          ButtonSegment(
                            value: 'Aktif',
                            label: Text('Aktif'),
                          ),
                          ButtonSegment(
                            value: 'Selesai',
                            label: Text('Selesai'),
                          ),
                        ],
                        selected: {_selectedFilter},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _selectedFilter = selection.first;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filteredTasks.length} tugas ditemukan',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),

              Expanded(
                child: provider.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : provider.error != null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.cloud_off,
                                    size: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Gagal memuat daftar tugas.',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  FilledButton.icon(
                                    onPressed: provider.loadTasks,
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : filteredTasks.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        query.isNotEmpty
                                            ? Icons.search_off
                                            : Icons.assignment_outlined,
                                        size: 56,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        query.isNotEmpty
                                            ? 'Tugas tidak ditemukan.'
                                            : _selectedFilter == 'Aktif'
                                                ? 'Tidak ada tugas aktif.'
                                                : _selectedFilter == 'Selesai'
                                                    ? 'Belum ada tugas selesai.'
                                                    : 'Belum ada tugas.',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        query.isNotEmpty
                                            ? 'Coba kata kunci lainnya.'
                                            : 'Tambahkan tugas untuk mulai mengelola kegiatan kuliah.',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : LayoutBuilder(
                                builder: (context, constraints) {
                                  if (constraints.maxWidth >= 750) {
                                    return GridView.builder(
                                      padding: const EdgeInsets.all(20),
                                      gridDelegate:
                                          const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 420,
                                        mainAxisExtent: 125,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemCount: filteredTasks.length,
                                      itemBuilder: (_, index) {
                                        return TaskCard(
                                          task: filteredTasks[index],
                                        );
                                      },
                                    );
                                  }

                                  return ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: filteredTasks.length,
                                    itemBuilder: (_, index) {
                                      return TaskCard(
                                        task: filteredTasks[index],
                                      );
                                    },
                                  );
                                },
                              ),
              ),
            ],
          ),
        );
      },
    );
  }
}
