import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/providers/theme_provider.dart';
import 'package:budget_management_app/providers/year_provider.dart';
import 'package:budget_management_app/screens/year_selection_report_screen.dart';
import 'package:budget_management_app/screens/year_selection_screen.dart';
import 'package:budget_management_app/services/export_service.dart';
import 'package:budget_management_app/services/notification_service.dart';
import 'package:budget_management_app/widgets/budget_table.dart';
import 'package:budget_management_app/widgets/dialogs/add_item_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:budget_management_app/l10n/app_localizations.dart';

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
        title: Consumer<YearProvider>(
          builder: (context, yearProvider, child) {
            return Text(AppLocalizations.of(context)!.budgetManagementTitle(yearProvider.currentYear ?? DateTime.now().year));
          },
        ),
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
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchHint,
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
                AppLocalizations.of(context)!.notificationTitle,
                AppLocalizations.of(context)!.notificationBody,
              );
            },
            tooltip: AppLocalizations.of(context)!.notificationsTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () async {
              final budgetProvider = Provider.of<BudgetProvider>(
                context,
                listen: false,
              );
              final messenger = ScaffoldMessenger.of(context);
              final localizations = AppLocalizations.of(context)!;
              final path = await ExportService.exportToExcel(
                budgetProvider.items,
              );
              if (!mounted) return;
              if (path != null) {
                messenger.showSnackBar(
                  SnackBar(content: Text(localizations.exportSuccess(path))),
                );
              }
            },
            tooltip: AppLocalizations.of(context)!.exportTooltip,
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
                  ? AppLocalizations.of(context)!.switchToLightMode
                  : AppLocalizations.of(context)!.switchToDarkMode,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () {
              // Navigate to year selection screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const YearSelectionScreen(),
                ),
              );
            },
            tooltip: AppLocalizations.of(context)!.changeYearTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: () {
              // Navigate to report selection screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const YearSelectionReportScreen(),
                ),
              );
            },
            tooltip: AppLocalizations.of(context)!.viewReportsTooltip,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Consumer2<BudgetProvider, YearProvider>(
          builder: (context, budgetProvider, yearProvider, child) {
            final itemsForCurrentYear = budgetProvider.getItemsForYear(
              yearProvider.currentYear ?? DateTime.now().year,
            );
            final filteredItems = itemsForCurrentYear.where((item) {
              if (budgetProvider.searchQuery.isEmpty) {
                return true;
              }
              return item.itemName.toLowerCase().contains(budgetProvider.searchQuery.toLowerCase()) ||
                  item.picName.toLowerCase().contains(budgetProvider.searchQuery.toLowerCase());
            }).toList();

            if (filteredItems.isEmpty) {
              return Center(
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
                      AppLocalizations.of(context)!.noItemsFound(yearProvider.currentYear ?? DateTime.now().year),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.tryAddingItems,
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
              child: BudgetTable(budgetItems: filteredItems),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_budget_item_fab', // Unique hero tag to prevent conflicts
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddItemDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addItem),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
