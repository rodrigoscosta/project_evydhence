import 'package:flutter/services.dart';

class TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Adiciona automaticamente os ':' no local correto
    if (text.length == 2 && !text.contains(':')) {
      return TextEditingValue(
        text: '$text:',
        selection: const TextSelection.collapsed(offset: 3),
      );
    }
    return newValue;
  }
}
