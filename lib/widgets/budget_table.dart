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

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 2000,
      fixedLeftColumns: 2,
      columns: [
        const DataColumn2(label: Text('Item Name'), size: ColumnSize.L, fixedWidth: 200),
        const DataColumn2(label: Text('PIC'), fixedWidth: 100),
        const DataColumn2(label: Text('Pagu'), numeric: true),
        ...List.generate(12, (index) => DataColumn2(label: Text(months[index]), numeric: true)),
        const DataColumn2(label: Text('Sisa'), numeric: true),
        const DataColumn2(label: Text('Actions')),
      ],
      rows: budgetItems.map((item) {
        return DataRow(cells: [
          DataCell(Text(item.itemName)),
          DataCell(Text(item.picName)),
          DataCell(Text(currencyFormat.format(item.yearlyBudget))),
          ...List.generate(12, (monthIndex) {
            return DataCell(
              _buildMonthCell(context, item, monthIndex),
              onTap: () {
                if (item.activeMonths.contains(monthIndex)) {
                  showDialog(
                    context: context,
                    builder: (context) => UpdateAmountDialog(item: item, monthIndex: monthIndex),
                  );
                }
              },
            );
          }),
          DataCell(Text(currencyFormat.format(item.remaining))),
          DataCell(Row(
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteConfirmation(context, item),
              ),
            ],
          )),
        ]);
      }).toList(),
    );
  }

  Widget _buildMonthCell(BuildContext context, BudgetItem item, int monthIndex) {
    final bool isActive = item.activeMonths.contains(monthIndex);
    final double amount = item.monthlyWithdrawals[monthIndex] ?? 0;
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    Color? cellColor;
    Widget cellContent;

    if (!isActive) {
      cellColor = Colors.grey.withAlpha(51);
      cellContent = const Text('-', textAlign: TextAlign.center);
    } else if (amount > 0) {
      cellColor = Colors.green.withAlpha(51);
      cellContent = Text(currencyFormat.format(amount));
    } else {
      cellColor = Colors.red.withAlpha(51);
      cellContent = const Text('Input', style: TextStyle(color: Colors.red));
    }

    return Container(
      color: cellColor,
      child: Center(child: cellContent),
    );
  }

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
                Provider.of<BudgetProvider>(context, listen: false)
                    .deleteBudgetItem(item.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
