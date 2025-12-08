import 'package:budget_management_app/models/budget_item.dart';
import 'package:budget_management_app/providers/budget_provider.dart';
import 'package:budget_management_app/providers/year_provider.dart';
import 'package:budget_management_app/utils/thousands_formatter.dart';
import 'package:flutter/material.dart';

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
                  Icons.add_circle_outline,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.addNewBudgetItem,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.fillInDetails,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _yearlyBudgetController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.yearlyBudgetLabel,
                          hintText: '0',
                          prefixText: 'Rp ',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(
                            Icons.monetization_on_outlined,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsFormatter()],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterPlannedAmount;
                          }
                          final cleanValue = value.replaceAll('.', '');
                          if (double.tryParse(cleanValue) == null) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterValidNumber;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _frequencyController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(
                            context,
                          )!.frequencyLabel,
                          hintText: '1-12',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          prefixIcon: const Icon(Icons.repeat),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [ThousandsFormatter()],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterFrequency;
                          }
                          final freq = int.tryParse(value);
                          if (freq == null || freq < 1 || freq > 12) {
                            return AppLocalizations.of(
                              context,
                            )!.pleaseEnterValidFrequency;
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),

                if (_currentFrequency > 0) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 18,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.selectActiveMonths,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: List.generate(12, (index) {
                        return ChoiceChip(
                          label: Text(_getMonthNames(context)[index]),
                          selected: _selectedMonths.contains(index),
                          showCheckmark: false,
                          labelStyle: TextStyle(
                            color: _selectedMonths.contains(index)
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            fontWeight: _selectedMonths.contains(index)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          selectedColor: Theme.of(context).colorScheme.primary,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: _selectedMonths.contains(index)
                                  ? Colors.transparent
                                  : Colors.grey.shade300,
                            ),
                          ),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                if (_selectedMonths.length < _currentFrequency) {
                                  _selectedMonths.add(index);
                                } else {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        AppLocalizations.of(context)!.maxMonthsSelection(_currentFrequency),
                                      ),
                                      behavior: SnackBarBehavior.floating,
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
                      padding: const EdgeInsets.only(top: 8.0, left: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.selectExactlyMonths(_currentFrequency),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
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
          onPressed: _saveItem,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: Text(AppLocalizations.of(context)!.saveItem),
        ),
      ],
    );
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      if (_selectedMonths.length != _currentFrequency) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.selectExactlyMonths(_currentFrequency)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }

      final cleanBudgetValue = _yearlyBudgetController.text.replaceAll('.', '');
      final budgetAmount = double.parse(cleanBudgetValue);

      final newItem = BudgetItem(
        id: const Uuid().v4(),
        itemName: _itemNameController.text,
        picName: _picNameController.text,
        yearlyBudget: budgetAmount,
        frequency: _currentFrequency,
        activeMonths: _selectedMonths.toList()..sort(),
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
