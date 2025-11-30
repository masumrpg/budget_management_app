import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/providers/theme_provider.dart';
import 'package:budget_management_app/screens/dashboard_screen.dart';
import 'package:budget_management_app/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/budget_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BudgetItemAdapter());
  await Hive.openBox<BudgetItem>('budgetBox');
  await NotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BudgetProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Budget Management App',
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme(
                brightness: Brightness.light,
                primary: Color(0xFF2196F3),
                onPrimary: Colors.white,
                secondary: Color(0xFF4CAF50),
                onSecondary: Colors.white,
                error: Color(0xFFF44336),
                onError: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: const ColorScheme(
                brightness: Brightness.dark,
                primary: Color(0xFF64B5F6),
                onPrimary: Colors.black,
                secondary: Color(0xFF81C784),
                onSecondary: Colors.black,
                error: Color(0xFFEF5350),
                onError: Colors.black,
                surface: Color(0xFF1E1E1E),
                onSurface: Colors.white,
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: const DashboardScreen(),
          );
        },
      ),
    );
  }
}
