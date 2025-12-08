import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

class ReportDetailScreen extends StatefulWidget {
  final int selectedYear;

  const ReportDetailScreen({
    super.key,
    required this.selectedYear,
  });

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  String _formatAmount(double amount) {
    if (amount >= 1000000000) { // 1 miliar
      return 'Rp ${(amount / 1000000000).toStringAsFixed(1)} M';
    } else if (amount >= 1000000) { // 1 juta
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)} Jt';
    } else if (amount >= 1000) { // 1 ribu
      return 'Rp ${(amount / 1000).toStringAsFixed(0)} Rb';
    } else {
      final formatter = NumberFormat('#,##0', 'id_ID');
      return 'Rp ${formatter.format(amount)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.reportTitle(widget.selectedYear)),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<BudgetProvider>(
          builder: (context, budgetProvider, child) {
            final itemsForYear = budgetProvider.getItemsForYear(widget.selectedYear);

            if (itemsForYear.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 64,
                      color: Theme.of(context).disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noBudgetDataForYear,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Calculate totals
            double totalBudget = 0;
            double totalUsed = 0;
            double totalRemaining = 0;

            for (final item in itemsForYear) {
              totalBudget += item.yearlyBudget;
              totalUsed += item.totalUsed;
              totalRemaining += item.remaining;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Report Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(
                          context,
                        )!.budgetReportTitle(widget.selectedYear),
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildSummaryCard(
                            AppLocalizations.of(context)!.totalBudget,
                            _formatAmount(totalBudget),
                            Icons.account_balance_wallet,
                            Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          _buildSummaryCard(
                            AppLocalizations.of(context)!.totalUsed,
                            _formatAmount(totalUsed),
                            Icons.trending_up,
                            Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(width: 12),
                          _buildSummaryCard(
                            AppLocalizations.of(context)!.remaining,
                            _formatAmount(totalRemaining),
                            Icons.savings,
                            Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Detailed Table (Expanded to take remaining space)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.grey.shade200),
                      child: DataTable2(
                        columnSpacing: 16,
                        horizontalMargin: 16,
                        minWidth: 800,
                        headingRowHeight: 56,
                        dataRowHeight: 60,
                        headingRowColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.5),
                        ),
                        columns: [
                          DataColumn2(
                            label: Text(
                              AppLocalizations.of(context)!.itemName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            size: ColumnSize.L,
                          ),
                          DataColumn2(
                            label: Text(
                              AppLocalizations.of(context)!.picName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          DataColumn2(
                            label: Text(
                              AppLocalizations.of(context)!.pagu,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text(
                              AppLocalizations.of(context)!.actualAmount,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text(
                              AppLocalizations.of(context)!.remaining,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            numeric: true,
                          ),
                          DataColumn2(
                            label: Text(
                              AppLocalizations.of(context)!.usagePercentage,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: itemsForYear.map((item) {
                          final usagePercent = item.yearlyBudget > 0
                              ? (item.totalUsed / item.yearlyBudget)
                              : 0.0;

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  item.itemName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(Text(item.picName)),
                              DataCell(Text(_formatAmount(item.yearlyBudget))),
                              DataCell(Text(_formatAmount(item.totalUsed))),
                              DataCell(
                                Text(
                                  _formatAmount(item.remaining),
                                  style: TextStyle(
                                    color: item.remaining < 0
                                        ? Theme.of(context).colorScheme.error
                                        : Colors
                                              .green, // Visual indicator for positive remaining
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: usagePercent.clamp(0.0, 1.0),
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                item.remaining < 0
                                                    ? Theme.of(
                                                        context,
                                                      ).colorScheme.error
                                                    : Theme.of(
                                                        context,
                                                      ).colorScheme.secondary,
                                              ),
                                          minHeight: 6,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 45,
                                      child: Text(
                                        '${item.usagePercentage.toStringAsFixed(1)}%',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Bottom Summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.overallUsage,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          totalBudget > 0
                              ? '${((totalUsed / totalBudget) * 100).toStringAsFixed(1)}%'
                              : '0%',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}