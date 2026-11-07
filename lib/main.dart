
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'providers/task_provider.dart';
import 'repositories/task_repository.dart';
import 'services/api_service.dart';
import 'services/supabase_service.dart';
import 'screens/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi format tanggal Indonesia
  await initializeDateFormatting('id_ID', null);

  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabasePublishableKey =
      String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');

  final configured =
      supabaseUrl.isNotEmpty && supabasePublishableKey.isNotEmpty;

  if (configured) {
    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
  }

  runApp(TaskMateApp(databaseConfigured: configured));
}

class TaskMateApp extends StatelessWidget {
  const TaskMateApp({
    super.key,
    required this.databaseConfigured,
  });

  final bool databaseConfigured;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider(
        repository: TaskRepository(
          apiService: ApiService(),
          supabaseService: SupabaseService(
            enabled: databaseConfigured,
          ),
        ),
      )..loadTasks(),
      child: MaterialApp(
        title: 'TaskMate',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF536DFE),
          ),
          scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF7F8FC),
            surfaceTintColor: Colors.transparent,
            centerTitle: false,
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        home: MainNavigation(
          databaseConfigured: databaseConfigured,
        ),
      ),
    );
  }
}
