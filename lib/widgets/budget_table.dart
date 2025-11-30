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
    if (amount >= 1000000000) { // 1 miliar
      // If amount is 1 Billion or more
      return 'Rp ${(amount / 1000000000).toStringAsFixed(0)} M';
    } else if (amount >= 1000000) { // 1 juta
      // If amount is 1 Million or more
      return 'Rp ${(amount / 1000000).toStringAsFixed(0)} Jt';
    } else if (amount >= 1000) { // 1 ribu
      // If amount is 1 Thousand or more
      return 'Rp ${(amount / 1000).toStringAsFixed(0)} Rb';
    } else {
      final formatter = NumberFormat('#,##0', 'id_ID');
      return 'Rp ${formatter.format(amount)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 2000,
      fixedLeftColumns: 2,
      headingRowHeight: 50,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1.0,
          ),
        ),
      ),
      headingRowDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      columns: [
        const DataColumn2(
          label: Text(
            'Item Name',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          size: ColumnSize.L,
        ),
        const DataColumn2(
          label: Text(
            'PIC',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn2(
          label: Text(
            'Pagu',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          numeric: true,
        ),
        ...List.generate(
          12,
          (index) => DataColumn2(
            label: Text(
              _monthNames[index],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            numeric: true,
          ),
        ),
        DataColumn2(
          label: Text(
            'Sisa',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          numeric: true,
        ),
        const DataColumn2(
          label: Text(
            'Actions',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
      rows: budgetItems.map((item) {
        return DataRow(
          color: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
              }
              return null;
            },
          ),
          cells: [
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  item.itemName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  item.picName,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  _formatAmount(item.yearlyBudget),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
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
                child: Text(
                  _formatAmount(item.remaining),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: item.remaining < 0
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            DataCell(
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Tooltip(
                      message: 'Edit Item',
                      child: IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          // Edit functionality can be added here if needed
                        },
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        splashRadius: 20,
                      ),
                    ),
                    Tooltip(
                      message: 'Delete Item',
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _showDeleteConfirmation(context, item),
                        color: Theme.of(context).colorScheme.error,
                        splashRadius: 20,
                      ),
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
      cellContent = Text(_formatAmount(amount));
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
