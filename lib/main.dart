import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/providers/theme_provider.dart';
import 'package:budget_management_app/providers/year_provider.dart';
import 'package:budget_management_app/screens/main_layout_screen.dart';
import 'package:budget_management_app/screens/year_selection_screen.dart';
import 'package:budget_management_app/services/notification_service.dart';
import 'package:budget_management_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/budget_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BudgetItemAdapter());
  await Hive.openBox<BudgetItem>('budgetBox');
  await Hive.openBox('settings'); // Open settings box for year storage
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
        ChangeNotifierProvider(create: (context) => YearProvider()),
      ],
      child: Consumer<YearProvider>(
        builder: (context, yearProvider, child) {
          Widget initialScreen;
          if (yearProvider.isYearSet()) {
            initialScreen = const MainLayoutScreen();
          } else {
            initialScreen = const YearSelectionScreen();
          }

          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                title: 'Budget Management App',
                themeMode: themeProvider.themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                home: initialScreen,
              );
            },
          );
        },
      ),
    );
  }
}
