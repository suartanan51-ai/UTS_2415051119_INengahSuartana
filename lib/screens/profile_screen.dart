import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Profil')),
    body: ListView(padding: const EdgeInsets.all(24), children: [
      const CircleAvatar(radius: 46, child: Icon(Icons.person, size: 48)),
      const SizedBox(height: 16),
      Text('I Nengah Suartana', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      const Text('2415051119', textAlign: TextAlign.center),
      const SizedBox(height: 24),
      const Card(child: Column(children: [
        ListTile(leading: Icon(Icons.school_outlined), title: Text('Kelas'), subtitle: Text('PTI 5A')),
        Divider(height: 1),
        ListTile(leading: Icon(Icons.computer_outlined), title: Text('Program Studi'), subtitle: Text('Pendidikan Teknik Informatika')),
        Divider(height: 1),
        ListTile(leading: Icon(Icons.phone_android), title: Text('Aplikasi'), subtitle: Text('TaskMate – Manajemen Tugas Mahasiswa')),
      ])),
    ]),
  );
}
