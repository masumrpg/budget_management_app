import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddItemDialog extends StatefulWidget {
  const AddItemDialog({super.key});

  @override
  AddItemDialogState createState() => AddItemDialogState();
}

class AddItemDialogState extends State<AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  final _picNameController = TextEditingController();
  final _yearlyBudgetController = TextEditingController();
  final _frequencyController = TextEditingController();

  Set<int> _selectedMonths = {};
  int _currentFrequency = 0;

  final List<String> _monthNames = [
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

  @override
  void initState() {
    super.initState();
    _frequencyController.addListener(_updateFrequency);
  }

  @override
  void dispose() {
    _frequencyController.removeListener(_updateFrequency);
    _itemNameController.dispose();
    _picNameController.dispose();
    _yearlyBudgetController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  void _updateFrequency() {
    final freq = int.tryParse(_frequencyController.text);
    if (freq != null && freq >= 1 && freq <= 12) {
      setState(() {
        _currentFrequency = freq;
        // If selected months exceed new frequency, clear excess
        if (_selectedMonths.length > _currentFrequency) {
          _selectedMonths = _selectedMonths.take(_currentFrequency).toSet();
        }
      });
    } else {
      setState(() {
        _currentFrequency = 0;
        _selectedMonths.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add New Budget Item',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Fill in the details below',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _itemNameController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    hintText: 'Enter item name...',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _picNameController,
                  decoration: InputDecoration(
                    labelText: 'Person in Charge (PIC)',
                    hintText: 'Enter PIC name...',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a PIC name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearlyBudgetController,
                  decoration: InputDecoration(
                    labelText: 'Yearly Budget',
                    hintText: 'Enter amount...',
                    prefixText: 'Rp ',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a yearly budget';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _frequencyController,
                  decoration: InputDecoration(
                    labelText: 'Frequency (times a year)',
                    hintText: 'Enter frequency (1-12)...',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a frequency';
                    }
                    final freq = int.tryParse(value);
                    if (freq == null || freq < 1 || freq > 12) {
                      return 'Please enter a number between 1 and 12';
                    }
                    return null;
                  },
                ),
                if (_currentFrequency > 0) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Select Active Months:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(12, (index) {
                        return ChoiceChip(
                          label: Text(_monthNames[index]),
                          selected: _selectedMonths.contains(index),
                          selectedColor: Theme.of(context).colorScheme.primary,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                if (_selectedMonths.length < _currentFrequency) {
                                  _selectedMonths.add(index);
                                } else {
                                  // Optionally show a message that max selections reached
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'You can only select $_currentFrequency months.',
                                      ),
                                      backgroundColor: Theme.of(context).colorScheme.error,
                                    ),
                                  );
                                }
                              } else {
                                _selectedMonths.remove(index);
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ),
                  if (_selectedMonths.length != _currentFrequency)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Please select exactly $_currentFrequency months.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveItem,
          child: const Text('Save Item'),
        ),
      ],
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      if (_selectedMonths.length != _currentFrequency) {
        // Show an error for month selection
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select exactly $_currentFrequency months.'),
          ),
        );
        return;
      }

      final newItem = BudgetItem(
        id: const Uuid().v4(),
        itemName: _itemNameController.text,
        picName: _picNameController.text,
        yearlyBudget: double.parse(_yearlyBudgetController.text),
        frequency: _currentFrequency,
        activeMonths: _selectedMonths.toList()
          ..sort(), // Ensure sorted for consistency
      );

      Provider.of<BudgetProvider>(
        context,
        listen: false,
      ).addBudgetItem(newItem);
      Navigator.of(context).pop();
    }
  }
}
