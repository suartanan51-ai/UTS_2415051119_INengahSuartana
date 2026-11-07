# Dokumentasi Arsitektur TaskMate

TaskMate menggunakan arsitektur terpisah agar kode mudah dikelola.

- models: menyimpan model data.
- providers: mengelola state aplikasi.
- repositories: mengatur akses data.
- services: menangani API dan Supabase.
- screens: menyimpan halaman aplikasi.
- widgets: menyimpan reusable widgets.

Pengelolaan state menggunakan Provider dan ChangeNotifier.
