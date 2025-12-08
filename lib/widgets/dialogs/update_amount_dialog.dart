import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/utils/thousands_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

class UpdateAmountDialog extends StatefulWidget {
  final BudgetItem item;
  final int monthIndex;

  const UpdateAmountDialog({
    super.key,
    required this.item,
    required this.monthIndex,
  });

  @override
  UpdateAmountDialogState createState() => UpdateAmountDialogState();
}

class UpdateAmountDialogState extends State<UpdateAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  List<String> _getMonthNames(BuildContext context) {
    return [
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
  }
  String _formattedRemaining = '';

  @override
  void initState() {
    super.initState();
    final amount = widget.item.monthlyWithdrawals[widget.monthIndex] ?? 0;
    // Format the amount with thousand separators
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedValue = formatter.format(amount).replaceAll(',', '.');
    _amountController.text = formattedValue;

    // Initialize the remaining budget display
    // Remove formatting characters before parsing
    final cleanAmountValue = _amountController.text.replaceAll('.', '');
    _updateRemainingDisplay(double.tryParse(cleanAmountValue) ?? 0);

    // Add listener to update remaining budget when amount changes
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    final currentAmount =
        double.tryParse(_amountController.text.replaceAll('.', '')) ?? 0;
    _updateRemainingDisplay(currentAmount);
  }

  void _updateRemainingDisplay(double currentInputAmount) {
    final previousAmount = widget.item.monthlyWithdrawals[widget.monthIndex] ?? 0;
    final difference = currentInputAmount - previousAmount;
    final newRemaining = widget.item.yearlyBudget - (widget.item.totalUsed + difference);

    setState(() {
      final formatter = NumberFormat('#,###', 'id_ID');
      final formattedValue = formatter.format(newRemaining).replaceAll(',', '.');
      _formattedRemaining = 'Rp $formattedValue';
    });
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      actionsPadding: const EdgeInsets.all(24),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.edit_calendar,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(
                    context,
                  )!.updateAmountFor(widget.item.itemName),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.monthLabel(_getMonthNames(context)[widget.monthIndex]),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.remainingBudget,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formattedRemaining,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: _formattedRemaining.contains('-')
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.amountLabel,
                  hintText: AppLocalizations.of(context)!.enterAmountHint,
                  prefixText: 'Rp ',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [ThousandsFormatter(), FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  // Only need to trigger visual update, logic handles stripping dots inside _onAmountChanged
                  // But wait, _onAmountChanged uses _amountController.text directly.
                  // This callback might be redundant if we have the listener, but harmless.
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.pleaseEnterAmount;
                  }
                  final cleanValue = value.replaceAll('.', '');
                  if (double.tryParse(cleanValue) == null) {
                    return AppLocalizations.of(context)!.pleaseEnterValidNumber;
                  }

                  final inputAmount = double.parse(cleanValue);
                  final newRemaining = widget.item.yearlyBudget - (widget.item.totalUsed + (inputAmount - (widget.item.monthlyWithdrawals[widget.monthIndex] ?? 0)));
                  if (newRemaining < 0) {
                    return AppLocalizations.of(context)!.amountExceedsRemaining;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: _updateAmount,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(AppLocalizations.of(context)!.save),
        ),
      ],
    );
  }

  void _updateAmount() {
    if (_formKey.currentState!.validate()) {
      // Remove formatting characters before parsing
      final cleanAmountValue = _amountController.text.replaceAll('.', '');
      final amount = double.parse(cleanAmountValue);

      final updatedItem = widget.item;
      updatedItem.monthlyWithdrawals[widget.monthIndex] = amount;

      Provider.of<BudgetProvider>(
        context,
        listen: false,
      ).updateBudgetItem(updatedItem);
      Navigator.of(context).pop();
    }
  }
}
