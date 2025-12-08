import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/providers/year_provider.dart';
import 'package:budget_management_app/screens/report_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

class YearSelectionReportScreen extends StatefulWidget {
  const YearSelectionReportScreen({super.key});

  @override
  State<YearSelectionReportScreen> createState() => _YearSelectionReportScreenState();
}

class _YearSelectionReportScreenState extends State<YearSelectionReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectYearForReport),
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Consumer2<BudgetProvider, YearProvider>(
          builder: (context, budgetProvider, yearProvider, child) {
            // Get all unique years from budget items
            final allYears = <int>{};
            for (final item in budgetProvider.items) {
              if (item.year != null) {
                allYears.add(item.year!);
              }
            }

            // Convert to list and sort in descending order
            final sortedYears = allYears.toList()..sort((a, b) => b.compareTo(a));

            if (sortedYears.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.report_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noBudgetData,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.addBudgetItemsFirst,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: sortedYears.length,
              itemBuilder: (context, index) {
                final year = sortedYears[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month),
                    title: Text(
                      AppLocalizations.of(context)!.reportForYear(year),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ReportDetailScreen(selectedYear: year),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}