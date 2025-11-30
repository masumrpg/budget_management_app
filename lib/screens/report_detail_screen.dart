import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
      return 'Rp ${(amount / 1000000000).toStringAsFixed(0)} M';
    } else if (amount >= 1000000) { // 1 juta
      return 'Rp ${(amount / 1000000).toStringAsFixed(0)} Jt';
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
        title: Text('Report ${widget.selectedYear}'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<BudgetProvider>(
          builder: (context, budgetProvider, child) {
            final itemsForYear = budgetProvider.getItemsForYear(widget.selectedYear);
            
            if (itemsForYear.isEmpty) {
              return const Center(
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
                      'No budget data for this year',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
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
            
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Report Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Budget Report ${widget.selectedYear}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryCard('Total Budget', _formatAmount(totalBudget), Colors.blue),
                            _buildSummaryCard('Total Used', _formatAmount(totalUsed), Colors.orange),
                            _buildSummaryCard('Total Remaining', _formatAmount(totalRemaining), Colors.green),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Detailed Table
                  Card(
                    elevation: 2,
                    child: DataTable(
                      columnSpacing: 16,
                      headingRowColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          return Theme.of(context).colorScheme.surfaceContainerHighest;
                        },
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Item Name',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'PIC',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Pagu',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Used',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Remaining',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Usage %',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                      rows: itemsForYear.map((item) {
                        return DataRow(
                          cells: [
                            DataCell(Text(item.itemName)),
                            DataCell(Text(item.picName)),
                            DataCell(Text(_formatAmount(item.yearlyBudget))),
                            DataCell(Text(_formatAmount(item.totalUsed))),
                            DataCell(
                              Text(
                                _formatAmount(item.remaining),
                                style: TextStyle(
                                  color: item.remaining < 0 
                                    ? Theme.of(context).colorScheme.error 
                                    : Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                '${item.usagePercentage.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Summary Section
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Summary',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          _buildSummaryRow('Total Items:', itemsForYear.length.toString()),
                          _buildSummaryRow('Total Budget:', _formatAmount(totalBudget)),
                          _buildSummaryRow('Total Used:', _formatAmount(totalUsed)),
                          _buildSummaryRow('Total Remaining:', _formatAmount(totalRemaining)),
                          _buildSummaryRow(
                            'Overall Usage:',
                            totalBudget > 0 
                              ? '${((totalUsed / totalBudget) * 100).toStringAsFixed(1)}%' 
                              : '0%',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildSummaryCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}