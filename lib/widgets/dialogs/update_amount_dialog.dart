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
      title: Text('Update Amount for ${widget.item.itemName}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Month: ${_monthNames[widget.monthIndex]}'),
            const SizedBox(height: 8),
            Text('Remaining budget: $_formattedRemaining'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: 'Rp ',
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
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          // Use FilledButton for a modern look
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
