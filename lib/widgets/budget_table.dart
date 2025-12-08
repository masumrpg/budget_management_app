import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/widgets/dialogs/update_amount_dialog.dart';
import 'package:budget_management_app/widgets/dialogs/edit_item_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

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
        DataColumn2(
          label: Text(
            AppLocalizations.of(context)!.itemName,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          size: ColumnSize.L,
        ),
        DataColumn2(
          label: Text(
            AppLocalizations.of(context)!.picName,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        DataColumn2(
          label: Text(
            AppLocalizations.of(context)!.pagu,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          numeric: true,
        ),
        ...List.generate(
          12,
          (index) => DataColumn2(
            label: Text(
              _getMonthName(context, index),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            numeric: true,
          ),
        ),
        DataColumn2(
          label: Text(
            AppLocalizations.of(context)!.sisa,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          numeric: true,
        ),
        DataColumn2(
          label: Text(
            AppLocalizations.of(context)!.actions,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
      rows: budgetItems.map((item) {
        return DataRow(
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
                      message: AppLocalizations.of(context)!.editItem,
                      child: IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditItemDialog(item: item),
                          );
                        },
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        splashRadius: 20,
                      ),
                    ),
                    Tooltip(
                      message: AppLocalizations.of(context)!.deleteItem,
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
      cellContent = Text(AppLocalizations.of(context)!.input, style: TextStyle(color: Colors.red));
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

  String _getMonthName(BuildContext context, int index) {
    final months = [
      AppLocalizations.of(context)!.january,
      AppLocalizations.of(context)!.february,
      AppLocalizations.of(context)!.march,
      AppLocalizations.of(context)!.april,
      AppLocalizations.of(context)!.may,
      AppLocalizations.of(context)!.june,
      AppLocalizations.of(context)!.july,
      AppLocalizations.of(context)!.august,
      AppLocalizations.of(context)!.september,
      AppLocalizations.of(context)!.october,
      AppLocalizations.of(context)!.november,
      AppLocalizations.of(context)!.december,
    ];
    return months[index];
  }

  void _showDeleteConfirmation(BuildContext context, BudgetItem item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDelete),
          content: Text(AppLocalizations.of(context)!.deleteConfirmationMessage(item.itemName)),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.delete),
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
