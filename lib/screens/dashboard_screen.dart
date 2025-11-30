import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/providers/theme_provider.dart';
import 'package:budget_management_app/services/export_service.dart';
import 'package:budget_management_app/services/notification_service.dart';
import 'package:budget_management_app/widgets/budget_table.dart';
import 'package:budget_management_app/widgets/dialogs/add_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Management 2025'),
        elevation: 1,
        actions: [
          Container(
            width: 250,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search items or PIC...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onChanged: (value) {
                Provider.of<BudgetProvider>(
                  context,
                  listen: false,
                ).setSearchQuery(value);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              NotificationService.showNotification(
                'Test Notification',
                'This is a test notification.',
              );
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () async {
              final budgetProvider = Provider.of<BudgetProvider>(
                context,
                listen: false,
              );
              final messenger = ScaffoldMessenger.of(context);
              final path = await ExportService.exportToExcel(
                budgetProvider.items,
              );
              if (!mounted) return;
              if (path != null) {
                messenger.showSnackBar(
                  SnackBar(content: Text('Exported to $path')),
                );
              }
            },
            tooltip: 'Export to Excel',
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.themeMode == ThemeMode.dark
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
                ),
                onPressed: () {
                  themeProvider.toggleTheme(themeProvider.themeMode != ThemeMode.dark);
                },
                tooltip: themeProvider.themeMode == ThemeMode.dark
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<BudgetProvider>(
          builder: (context, budgetProvider, child) {
            if (budgetProvider.filteredItems.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.sentiment_dissatisfied_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No items found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Try adjusting your search',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5,
                ),
              ),
              child: BudgetTable(budgetItems: budgetProvider.filteredItems),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddItemDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
