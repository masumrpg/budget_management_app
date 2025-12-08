import 'package:budget_management_app/providers/year_provider.dart';
import 'package:budget_management_app/screens/main_layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_management_app/l10n/app_localizations.dart';

class YearSelectionScreen extends StatefulWidget {
  const YearSelectionScreen({super.key});

  @override
  State<YearSelectionScreen> createState() => _YearSelectionScreenState();
}

class _YearSelectionScreenState extends State<YearSelectionScreen> {
  final TextEditingController _yearController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set tahun saat ini sebagai default
    _yearController.text = DateTime.now().year.toString();
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectBudgetYear),
        automaticallyImplyLeading: false, // Disable back button
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 64,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.selectBudgetYearTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.selectBudgetYearSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _yearController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.budgetYearLabel,
                          hintText: AppLocalizations.of(context)!.budgetYearHint,
                          prefixIcon: Icon(Icons.numbers),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterYear;
                          }

                          final year = int.tryParse(value);
                          if (year == null) {
                            return AppLocalizations.of(context)!.pleaseEnterValidYear;
                          }

                          final currentYear = DateTime.now().year;
                          if (year < 1970 || year > currentYear + 10) {
                            return AppLocalizations.of(context)!.pleaseEnterValidYear;
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final year = int.parse(_yearController.text);
                            Provider.of<YearProvider>(context, listen: false)
                                .setCurrentYear(year);

                            // Navigate back to main layout after setting year
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const MainLayoutScreen(),
                              ),
                            );
                          }
                        },
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.continueToApp,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}