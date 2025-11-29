import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateAmountDialog extends StatefulWidget {
  final BudgetItem item;
  final int monthIndex;

  const UpdateAmountDialog({super.key, required this.item, required this.monthIndex});

  @override
  _UpdateAmountDialogState createState() => _UpdateAmountDialogState();
}

class _UpdateAmountDialogState extends State<UpdateAmountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.text = widget.item.monthlyWithdrawals[widget.monthIndex]?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Amount for ${widget.item.itemName}'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(labelText: 'Amount'),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
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

      Provider.of<BudgetProvider>(context, listen: false).updateBudgetItem(updatedItem);
      Navigator.of(context).pop();
    }
  }
}
