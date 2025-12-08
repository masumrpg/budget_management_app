import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  static const int maxDigits = 15; // Max 15 digits to prevent overflow

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text == '') {
      return const TextEditingValue(text: '');
    }

    // Remove any existing formatting
    String cleanValue = newValue.text.replaceAll('.', '');

    // Validate that input contains only digits
    if (!RegExp(r'^\d*$').hasMatch(cleanValue)) {
      return oldValue;
    }

    // Limit the length to prevent overflow
    if (cleanValue.length > maxDigits) {
      cleanValue = cleanValue.substring(0, maxDigits);
    }

    // Format with thousand separators
    String formattedValue = _formatWithThousandsSeparator(cleanValue);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  String _formatWithThousandsSeparator(String value) {
    if (value.isEmpty) return '';
    
    // Convert to number and format
    int numericValue = int.tryParse(value) ?? 0;
    return NumberFormat('#,###', 'id_ID').format(numericValue).replaceAll(',', '.');
  }
}