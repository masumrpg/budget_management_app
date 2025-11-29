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
        actions: [
          SizedBox(
            width: 200,
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                Provider.of<BudgetProvider>(context, listen: false).setSearchQuery(value);
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              NotificationService.showNotification('Test Notification', 'This is a test notification.');
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);
              final path = await ExportService.exportToExcel(budgetProvider.items);
              if (path != null && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Exported to $path')),
                );
              }
            },
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, budgetProvider, child) {
          if (budgetProvider.filteredItems.isEmpty) {
            return const Center(
              child: Text('No items found.'),
            );
          }
          return BudgetTable(budgetItems: budgetProvider.filteredItems);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddItemDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
