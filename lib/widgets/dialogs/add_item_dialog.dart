import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/providers/year_provider.dart';
import 'package:budget_management_app/utils/thousands_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

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
          Text(
            AppLocalizations.of(context)!.addNewBudgetItem,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context)!.fillInDetails,
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
                    labelText: AppLocalizations.of(context)!.itemName,
                    hintText: AppLocalizations.of(context)!.enterItemName,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterItemName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _picNameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.picLabel,
                    hintText: AppLocalizations.of(context)!.enterPicName,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterPicName;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _yearlyBudgetController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.yearlyBudgetLabel,
                    hintText: AppLocalizations.of(context)!.enterAmountHint,
                    prefixText: 'Rp ',
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
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
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _frequencyController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.frequencyLabel,
                    hintText: AppLocalizations.of(context)!.frequencyHint,
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
                      return AppLocalizations.of(context)!.pleaseEnterFrequency;
                    }
                    final freq = int.tryParse(value);
                    if (freq == null || freq < 1 || freq > 12) {
                      return AppLocalizations.of(context)!.pleaseEnterValidFrequency;
                    }
                    return null;
                  },
                ),
                if (_currentFrequency > 0) ...[
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.selectActiveMonths,
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
                          label: Text(_getMonthNames(context)[index]),
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
                                        AppLocalizations.of(context)!.maxMonthsSelection(_currentFrequency),
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
                        AppLocalizations.of(context)!.selectExactlyMonths(_currentFrequency),
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
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        FilledButton(
          onPressed: _saveItem,
          child: Text(AppLocalizations.of(context)!.saveItem),
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
            content: Text(AppLocalizations.of(context)!.selectExactlyMonths(_currentFrequency)),
          ),
        );
        return;
      }

      // Remove formatting characters before parsing
      final cleanBudgetValue = _yearlyBudgetController.text.replaceAll('.', '');
      final budgetAmount = double.parse(cleanBudgetValue);

      final newItem = BudgetItem(
        id: const Uuid().v4(),
        itemName: _itemNameController.text,
        picName: _picNameController.text,
        yearlyBudget: budgetAmount,
        frequency: _currentFrequency,
        activeMonths: _selectedMonths.toList()
          ..sort(), // Ensure sorted for consistency
        year: Provider.of<YearProvider>(context, listen: false).currentYear ?? DateTime.now().year,
      );

      Provider.of<BudgetProvider>(
        context,
        listen: false,
      ).addBudgetItem(newItem);
      Navigator.of(context).pop();
    }
  }
}
