import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/widgets/dialogs/update_amount_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BudgetTable extends StatelessWidget {
  final List<BudgetItem> budgetItems;

  const BudgetTable({super.key, required this.budgetItems});

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      // If amount is 10 Million or more
      return 'Rp ${(amount / 1000000).toStringAsFixed(0)} Jt';
    } else {
      final currencyFormat = NumberFormat.currency(
        locale: 'id_ID', // Use id_ID for dot separator
        symbol: 'Rp ',
        decimalDigits: 0, // No decimal digits for cleaner look
      );
      return currencyFormat.format(amount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 2000,
      fixedLeftColumns: 2,
      columns: [
        const DataColumn2(label: Text('Item Name'), size: ColumnSize.L),
        const DataColumn2(label: Text('PIC')),
        const DataColumn2(label: Text('Pagu'), numeric: true),
        ...List.generate(
          12,
          (index) =>
              DataColumn2(label: Text(_monthNames[index]), numeric: true),
        ),
        const DataColumn2(label: Text('Sisa'), numeric: true),
        const DataColumn2(label: Text('Actions')),
      ],
      rows: budgetItems.map((item) {
        return DataRow(
          cells: [
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(item.itemName),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(item.picName),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(_formatAmount(item.yearlyBudget)),
              ),
            ),
            ...List.generate(12, (monthIndex) {
              return DataCell(
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildMonthCell(context, item, monthIndex),
                ),
                onTap: () {
                  if (item.activeMonths.contains(monthIndex)) {
                    showDialog(
                      context: context,
                      builder: (context) => UpdateAmountDialog(
                        item: item,
                        monthIndex: monthIndex,
                      ),
                    );
                  }
                },
              );
            }),
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(_formatAmount(item.remaining)),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _showDeleteConfirmation(context, item),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildMonthCell(
    BuildContext context,
    BudgetItem item,
    int monthIndex,
  ) {
    final bool isActive = item.activeMonths.contains(monthIndex);
    final double amount = item.monthlyWithdrawals[monthIndex] ?? 0;
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID', // Use id_ID for dot separator
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    Color? cellColor;
    Widget cellContent;

    if (!isActive) {
      cellColor = colorScheme.surfaceContainerHighest;
      cellContent = const Text('-', textAlign: TextAlign.center);
    } else if (amount > 0) {
      cellColor = Color.alphaBlend(
        colorScheme.primary.withAlpha(51),
        colorScheme.surface,
      );
      cellContent = Text(currencyFormat.format(amount));
    } else {
      cellColor = Color.alphaBlend(
        colorScheme.error.withAlpha(51),
        colorScheme.surface,
      );
      cellContent = const Text('Input', style: TextStyle(color: Colors.red));
    }

    return Container(
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(8), // Rounded corners for cells
      ),
      padding: const EdgeInsets.all(8.0), // Add padding within cells
      child: Center(child: cellContent),
    );
  }

  final List<String> _monthNames = const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  void _showDeleteConfirmation(BuildContext context, BudgetItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "${item.itemName}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Provider.of<BudgetProvider>(
                  context,
                  listen: false,
                ).deleteBudgetItem(item.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
