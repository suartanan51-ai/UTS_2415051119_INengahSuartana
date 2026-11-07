# TaskMate – Aplikasi Manajemen Tugas Mahasiswa

## 1. Deskripsi Proyek

TaskMate merupakan aplikasi mobile berbasis Flutter yang dirancang untuk membantu mahasiswa mengelola tugas perkuliahan. Aplikasi ini memungkinkan pengguna menambahkan, melihat, mengubah, menghapus, dan menandai tugas yang telah selesai.

Aplikasi ini dikembangkan sebagai proyek Ujian Tengah Semester (UTS) mata kuliah Pemrograman Mobile dengan menerapkan konsep pemrograman Dart, Flutter, REST API, database Supabase, serta pengelolaan state menggunakan Provider.

## 2. Identitas Pengembang

- **Nama:** I Nengah Suartana
- **NIM:** 2415051119
- **Kelas:** PTI 5A
- **Program Studi:** Pendidikan Teknik Informatika
- **Universitas:** Universitas Pendidikan Ganesha

## 3. Tujuan Aplikasi

Tujuan pengembangan TaskMate adalah:
- Membantu mahasiswa mengelola tugas perkuliahan.
- Memudahkan pencatatan judul dan deskripsi tugas.
- Membantu pengguna mengatur mata kuliah, tenggat waktu, dan prioritas.
- Memantau tugas yang sudah selesai maupun belum selesai.
- Menerapkan konsep pengembangan aplikasi mobile menggunakan Flutter.

## 4. Fitur Aplikasi

1. **Dashboard:** Menampilkan ringkasan informasi tugas.
2. **Daftar Tugas:** Menampilkan seluruh tugas yang tersimpan.
3. **Detail Tugas:** Menampilkan informasi lengkap suatu tugas.
4. **Tambah Tugas:** Menambahkan tugas baru melalui formulir.
5. **Edit Tugas:** Mengubah informasi tugas.
6. **Hapus Tugas:** Menghapus tugas dari database.
7. **Tugas Selesai:** Menampilkan tugas yang telah diselesaikan.
8. **Profil:** Menampilkan informasi pengembang.
9. **REST API:** Mengambil data contoh dari layanan JSONPlaceholder.
10. **Responsive Layout:** Menyesuaikan tampilan berdasarkan ukuran layar.

## 5. Teknologi yang Digunakan

- Flutter
- Dart
- Provider
- Supabase
- PostgreSQL
- REST API
- JSON
- Git dan GitHub

## 6. REST API

Aplikasi menggunakan REST API dari JSONPlaceholder untuk mengambil data contoh tugas.

Endpoint:

`https://jsonplaceholder.typicode.com/todos?_limit=8`

Metode HTTP yang digunakan:
- GET: Mengambil data tugas dari API.

Data JSON kemudian diproses menggunakan model Dart dan ditampilkan pada aplikasi.

## 7. Database dan Backend

Aplikasi menggunakan Supabase sebagai backend dan PostgreSQL sebagai database.

Tabel utama yang digunakan adalah `tasks`, dengan beberapa kolom:
- `id`
- `title`
- `description`
- `course`
- `due_date`
- `priority`
- `is_completed`
- `created_at`

Operasi database:
- Create: Menambahkan tugas.
- Read: Menampilkan tugas.
- Update: Mengubah data tugas.
- Delete: Menghapus tugas.

## 8. Pengelolaan State

Aplikasi menggunakan Provider dan ChangeNotifier untuk mengelola state.

Pengelolaan state digunakan untuk:
- Menyimpan daftar tugas.
- Memperbarui data setelah operasi CRUD.
- Mengatur status loading.
- Menangani kesalahan ketika proses pengambilan atau penyimpanan data berlangsung.

## 9. Struktur Folder

```text
lib/
├── main.dart
├── models/
├── providers/
├── repositories/
├── screens/
├── services/
└── widgets/

supabase/
test/
android/
ios/
web/
```

## 10. Cara Menjalankan Aplikasi

1. Pastikan Flutter dan Dart sudah terpasang.
2. Clone repository GitHub.
3. Buka folder proyek menggunakan Visual Studio Code atau Android Studio.
4. Jalankan perintah:

```bash
flutter pub get
```

5. Atur konfigurasi Supabase menggunakan URL dan Publishable Key dari proyek Supabase milik sendiri.
6. Jalankan aplikasi menggunakan:

```bash
flutter run --dart-define=SUPABASE_URL=URL_SUPABASE --dart-define=SUPABASE_PUBLISHABLE_KEY=PUBLISHABLE_KEY
```

Ganti nilai URL dan Publishable Key dengan konfigurasi proyek Supabase yang sesuai.

## 11. Cara Build APK

Jalankan perintah:

```bash
flutter build apk --release
```

Hasil APK tersedia pada:

```text
build/app/outputs/flutter-apk/app-release.apk
```

## 12. Repository GitHub

Repository proyek:

https://github.com/suartanan51-ai/UTS_2415051119_INengahSuartana

---

**TaskMate – Aplikasi Manajemen Tugas Mahasiswa**

Dikembangkan oleh I Nengah Suartana  
Pendidikan Teknik Informatika  
Universitas Pendidikan Ganesha