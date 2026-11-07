
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

    _title = TextEditingController(text: task?.title ?? '');
    _course = TextEditingController(text: task?.course ?? '');
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && mounted) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _save() async {
    if (_saving) return;

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

      final success = widget.task == null
          ? await provider.addTask(task)
          : await provider.updateTask(task);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.task == null
                  ? 'Tugas berhasil ditambahkan.'
                  : 'Tugas berhasil diperbarui.',
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              provider.operationError ??
                  'Gagal menyimpan tugas. Silakan coba lagi.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Terjadi kesalahan saat menyimpan tugas.',
          ),
          backgroundColor: Colors.red,
        ),
      );

      debugPrint('Save task screen error: $e');
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
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nama tugas',
                hintText: 'Masukkan nama tugas',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.assignment),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama tugas wajib diisi.';
                }

                if (value.trim().length < 3) {
                  return 'Nama tugas minimal 3 karakter.';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _course,
              maxLength: 60,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Mata kuliah',
                hintText: 'Masukkan nama mata kuliah',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.menu_book),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Mata kuliah wajib diisi.';
                }

                if (value.trim().length < 2) {
                  return 'Nama mata kuliah terlalu pendek.';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            TextFormField(
              controller: _description,
              maxLines: 4,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Deskripsi',
                hintText: 'Tambahkan keterangan tugas (opsional)',
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
                prefixIcon: Icon(Icons.flag),
              ),
              items: ['Rendah', 'Sedang', 'Tinggi']
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ),
                  )
                  .toList(),
              onChanged: _saving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() {
                          _priority = value;
                        });
                      }
                    },
            ),

            const SizedBox(height: 14),

            OutlinedButton.icon(
              onPressed: _saving ? null : _selectDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                'Tenggat: ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
              ),
            ),

            const SizedBox(height: 24),

            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
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
