import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  final _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  String _formattedRemaining = '';

  @override
  void initState() {
    super.initState();
    _amountController.text =
        widget.item.monthlyWithdrawals[widget.monthIndex]?.toString() ?? '';

    // Initialize the remaining budget display
    _updateRemainingDisplay(double.tryParse(_amountController.text) ?? 0);

    // Add listener to update remaining budget when amount changes
    _amountController.addListener(_onAmountChanged);
  }

  void _onAmountChanged() {
    final currentAmount = double.tryParse(_amountController.text) ?? 0;
    _updateRemainingDisplay(currentAmount);
  }

  void _updateRemainingDisplay(double currentInputAmount) {
    final previousAmount = widget.item.monthlyWithdrawals[widget.monthIndex] ?? 0;
    final difference = currentInputAmount - previousAmount;
    final newRemaining = widget.item.yearlyBudget - (widget.item.totalUsed + difference);

    setState(() {
      final formatter = NumberFormat('#,##0', 'id_ID');
      _formattedRemaining = 'Rp ${formatter.format(newRemaining)}';
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
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Update Amount for ${widget.item.itemName}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Month: ${_monthNames[widget.monthIndex]}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining Budget',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formattedRemaining,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'Enter amount...',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final inputAmount = double.tryParse(value) ?? 0;
                  _updateRemainingDisplay(inputAmount);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }

                  final inputAmount = double.parse(value);
                  final newRemaining = widget.item.yearlyBudget - (widget.item.totalUsed + (inputAmount - (widget.item.monthlyWithdrawals[widget.monthIndex] ?? 0)));
                  if (newRemaining < 0) {
                    return 'Amount exceeds remaining budget';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _updateAmount,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _updateAmount() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text);

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
