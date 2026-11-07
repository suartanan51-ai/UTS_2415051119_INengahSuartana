
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({
    super.key,
    this.task,
  });

  final TaskModel? task;

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _course;
  late final TextEditingController _description;

  DateTime _dueDate = DateTime.now().add(
    const Duration(days: 7),
  );

  String _priority = 'Sedang';
  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final task = widget.task;

    _title = TextEditingController(
      text: task?.title ?? '',
    );

    _course = TextEditingController(
      text: task?.course ?? '',
    );

    _description = TextEditingController(
      text: task?.description ?? '',
    );

    if (task != null) {
      _dueDate = task.dueDate;
      _priority = task.priority;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _course.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final task = TaskModel(
      id: widget.task?.id,
      title: _title.text.trim(),
      course: _course.text.trim(),
      description: _description.text.trim(),
      dueDate: _dueDate,
      priority: _priority,
      isCompleted: widget.task?.isCompleted ?? false,
    );

    try {
      final provider = context.read<TaskProvider>();

      if (widget.task == null) {
        await provider.addTask(task);
      } else {
        await provider.updateTask(task);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.task == null
                ? 'Tugas berhasil ditambahkan.'
                : 'Tugas berhasil diperbarui.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan tugas: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.task != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          editing ? 'Edit Tugas' : 'Tambah Tugas',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Nama tugas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama tugas wajib diisi.';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _course,
              decoration: const InputDecoration(
                labelText: 'Mata kuliah',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.menu_book),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Mata kuliah wajib diisi.';
                }
                return null;
              },
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _description,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(
                labelText: 'Prioritas',
                border: OutlineInputBorder(),
              ),
              items: ['Rendah', 'Sedang', 'Tinggi']
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value ?? 'Sedang';
                });
              },
            ),

            const SizedBox(height: 14),

            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );

                if (picked != null) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
              icon: const Icon(Icons.calendar_month),
              label: Text(
                'Tenggat: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
              ),
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const CircularProgressIndicator()
                  : Text(
                      editing
                          ? 'Simpan Perubahan'
                          : 'Simpan Tugas',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
