import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/utils/thousands_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

class EditItemDialog extends StatefulWidget {
  final BudgetItem item;

  const EditItemDialog({
    super.key,
    required this.item,
  });

  @override
  EditItemDialogState createState() => EditItemDialogState();
}

class EditItemDialogState extends State<EditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _itemNameController;
  late final TextEditingController _picNameController;
  late final TextEditingController _yearlyBudgetController;

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(text: widget.item.itemName);
    _picNameController = TextEditingController(text: widget.item.picName);
    // Format the yearly budget with thousand separators
    final formatter = NumberFormat('#,###', 'id_ID');
    final formattedValue = formatter.format(widget.item.yearlyBudget).replaceAll(',', '.');
    _yearlyBudgetController = TextEditingController(
      text: formattedValue,
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _picNameController.dispose();
    _yearlyBudgetController.dispose();
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
                  Icons.edit_note,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.editBudgetItem,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.updateItemDetails,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.itemName,
                    hintText: AppLocalizations.of(context)!.enterItemName,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.shopping_bag_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterItemName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _picNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.picLabel,
                    hintText: AppLocalizations.of(context)!.enterPicName,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterPicName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _yearlyBudgetController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.yearlyBudgetLabel,
                    hintText: AppLocalizations.of(context)!.enterAmountHint,
                    prefixText: 'Rp ',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [ThousandsFormatter(), FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterPlannedAmount;
                    }
                    // Remove formatting characters before validation
                    final cleanValue = value.replaceAll('.', '');
                    if (double.tryParse(cleanValue) == null) {
                      return AppLocalizations.of(context)!.pleaseEnterValidNumber;
                    }

                    final budget = double.parse(cleanValue);
                    final formatter = NumberFormat('#,##0', 'id_ID');

                    // Check if the budget is less than the total used amount
                    if (budget < widget.item.totalUsed) {
                      final formattedUsed = formatter.format(widget.item.totalUsed).replaceAll(',', '.');
                      return AppLocalizations.of(context)!.budgetLessThanUsed('Rp $formattedUsed');
                    }
                    return null;
                  },
                ),
              ],
            ),
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
          onPressed: _updateItem,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(AppLocalizations.of(context)!.updateItem),
        ),
      ],
    );
  }

  void _updateItem() {
    if (_formKey.currentState!.validate()) {
      // Remove formatting characters before parsing
      final cleanBudgetValue = _yearlyBudgetController.text.replaceAll('.', '');
      final budgetAmount = double.parse(cleanBudgetValue);

      final updatedItem = BudgetItem(
        id: widget.item.id,
        itemName: _itemNameController.text,
        picName: _picNameController.text,
        yearlyBudget: budgetAmount,
        frequency: widget.item.frequency,
        activeMonths: widget.item.activeMonths,
        year: widget.item.year ?? DateTime.now().year, // Use current year if item year is null
        createdAt: widget.item.createdAt,
        lastUpdated: DateTime.now(),
        notes: widget.item.notes,
      );

      // Preserve the existing monthly withdrawals
      updatedItem.monthlyWithdrawals.addAll(widget.item.monthlyWithdrawals);

      Provider.of<BudgetProvider>(
        context,
        listen: false,
      ).updateBudgetItem(updatedItem);

      Navigator.of(context).pop();
    }
  }
}