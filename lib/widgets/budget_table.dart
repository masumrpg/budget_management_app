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
    if (amount == 0) return '-';
    final formatter = NumberFormat('#,##0', 'id_ID');
    return 'Rp ${formatter.format(amount)}';
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.grey.shade200,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      child: DataTable2(
        columnSpacing: 16,
        horizontalMargin: 16,
        minWidth: 2500,
        fixedLeftColumns: 2,
        headingRowHeight: 56,
        dataRowHeight: 64,
        headingRowColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        columns: [
          DataColumn2(
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.itemName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            size: ColumnSize.L,
            fixedWidth: 200,
          ),
          DataColumn2(
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.picName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            fixedWidth: 150,
          ),
          DataColumn2(
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.pagu,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            numeric: false,
            fixedWidth: 200,
          ),
          ...List.generate(
            12,
            (index) => DataColumn2(
              label: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getMonthName(context, index),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              numeric: false,
              fixedWidth: 110,
            ),
          ),
          DataColumn2(
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.sisa,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            numeric: false,
            fixedWidth: 200,
          ),
          DataColumn2(
            label: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.actions,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            fixedWidth: 100,
          ),
        ],
        rows: budgetItems.map((item) {

          return DataRow2(
            color: WidgetStateProperty.resolveWith<Color?>((states) {
              if (states.contains(WidgetState.hovered)) {
                return Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.04);
              }
              return null; // Transparent so scaffold/container background shows
            }),
            cells: [
              DataCell(
                Container(
                  padding: const EdgeInsets.only(right: 8),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.itemName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.2),
                      child: Text(
                        item.picName.isNotEmpty
                            ? item.picName[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.picName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  _formatAmount(item.yearlyBudget),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              ...List.generate(12, (monthIndex) {
                return DataCell(
                  Align(
                    alignment: Alignment.centerLeft,
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
                _buildRemainingCell(context, item)),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditItemDialog(item: item),
                        );
                      },
                      color: Theme.of(context).colorScheme.primary,
                      tooltip: AppLocalizations.of(context)!.editItem,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () => _showDeleteConfirmation(context, item),
                      color: Theme.of(context).colorScheme.error,
                      tooltip: AppLocalizations.of(context)!.deleteItem,
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRemainingCell(BuildContext context, BudgetItem item) {
    // Check if remaining is effectively 0 (handling floating point precision)
    final bool isExhausted = item.remaining.abs() < 1;

    // Calculate percentage as before
    final double percentage = item.yearlyBudget > 0
        ? (item.remaining / item.yearlyBudget).clamp(0.0, 1.0)
        : 0.0;

    final Color color = (item.remaining < 0 || isExhausted)
        ? Theme.of(context).colorScheme.error
        : percentColors(percentage);

    String displayText;
    if (isExhausted && item.yearlyBudget > 0) {
      displayText = AppLocalizations.of(context)!.budgetExhausted;
    } else {
      displayText = _formatAmount(item.remaining);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayText,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: 13,
          ),
        ),
        if (item.yearlyBudget > 0 && item.remaining >= 1) ...[ // Don't show progress bar if exhausted
          const SizedBox(height: 4),
          SizedBox(
            width: 80,
            height: 4,
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ],
    );
  }

  Color percentColors(double percentage) {
    if (percentage < 0.2) return Colors.red;
    if (percentage < 0.5) return Colors.orange;
    return Colors.green;
  }

  Widget _buildMonthCell(
    BuildContext context,
    BudgetItem item,
    int monthIndex,
  ) {
    final bool isActive = item.activeMonths.contains(monthIndex);
    final double amount = item.monthlyWithdrawals[monthIndex] ?? 0;

    if (!isActive) {
      return Container(
        width: 32,
        height: 6,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(3),
        ),
      );
    }

    if (amount > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(
            context,
          ).colorScheme.primaryContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          _formatAmount(amount),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          textAlign: TextAlign.left,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
          style: BorderStyle.solid,
        ),
      ),
      child: Icon(Icons.add, size: 14, color: Colors.grey.shade400),
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
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
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
