import 'package:flutter/material.dart';
import 'package:project_evydhence/components/generic_masks.dart';
import 'package:project_evydhence/components/keep_only_digits.dart';

class DateMask extends GenericMask {
  DateMask({
    RegExp? validationRegExp,
  }) : super(
          validationRegExp ?? RegExp(r'^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$'),
        );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    const maxLength = '99/99/9999'.length;
    final newLength = newValue.text.length;
    final symbolsPositioning = <String, List<int>>{
      '/': [2, 4],
    };

    return super.mask(
      oldValue,
      newValue,
      condition: newLength <= maxLength,
      symbolsPositioning: symbolsPositioning,
    );
  }

  @override
  String format(String source) {
    final digits = keepOnlyDigits(source);
    if (digits.length != 8) return '';
    final digitsList = digits.split('').toList();
    digitsList.insert(2, '/');
    digitsList.insert(5, '/');
    return digitsList.join('');
  }
}
