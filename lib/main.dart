import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
import 'dart:io' show Platform, File, Directory;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    // On Windows, store data in the executable's directory (Portable mode)
    final executableDir = File(Platform.resolvedExecutable).parent;
    final logPath = '${executableDir.path}\\data';

    // Ensure the directory exists
    Directory(logPath).createSync(recursive: true);

    Hive.init(logPath);
  } else {
    // Default initialization for other platforms
    await Hive.initFlutter();
  }

  Hive.registerAdapter(BudgetItemAdapter());
  await Hive.openBox<BudgetItem>('budgetBox');
  await Hive.openBox('settings'); // Open settings box for year storage
  await NotificationService.init();

  // Check and schedule notifications
  await _checkAndScheduleNotifications();

  runApp(const MyApp());
}

Future<void> _checkAndScheduleNotifications() async {
  final box = Hive.box<BudgetItem>('budgetBox');
  final now = DateTime.now();
  // Get next month (handle December -> January rollover)
  final nextMonth = now.month == 12 ? 1 : now.month + 1;

  bool hasNextMonthItems = false;

  // Check if any item has the next month in its activeMonths
  for (var item in box.values) {
    if (item.activeMonths.contains(nextMonth)) {
      hasNextMonthItems = true;
      break;
    }
  }

  if (hasNextMonthItems) {
    // Schedule 5 times a day: 09:00, 12:00, 15:00, 18:00, 21:00
    final times = [9, 12, 15, 18, 21];
    for (int i = 0; i < times.length; i++) {
      await NotificationService.scheduleDailyNotification(
        id: 100 + i,
        title: 'Budget Input Reminder',
        body: 'Don\'t forget to prepare your budget for next month!',
        hour: times[i],
        minute: 0,
      );
    }

    // TEST MODE: 1-minute interval notification
    // Verify by uncommenting/running this
    await NotificationService.scheduleEveryMinuteTest(
      id: 999,
      title: 'Test Notification',
      body: 'This is a test notification running every minute.',
    );
  } else {
    // Optionally cancel if no longer relevant, but for now we just don't schedule new ones
    // NotificationService.cancelAll();
  }
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
                scaffoldMessengerKey: NotificationService.messengerKey,
                onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
                themeMode: themeProvider.themeMode,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                home: initialScreen,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('id'), // Force Indonesian first as requested
                  Locale('en'),
                ],
                locale: const Locale('id'), // Explicitly set to Indonesian
              );
            },
          );
        },
      ),
    );
  }
}
