import 'package:flutter/services.dart';
import 'package:project_evydhence/components/generic_masks.dart';
import 'package:project_evydhence/components/keep_only_digits.dart';

/// [CpfMask]
///
/// Implementação da classe [GenericMask] para mascarar CPF
///
/// exemplo:
/// - 12345678901 -> 123.456.789-01
class CpfMask extends GenericMask {
  CpfMask() : super(RegExp(r'^([0-9]{3})\.([0-9]{3})\.([0-9]{3})-([0-9]{2})$'));

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final cpfLength = newValue.text.length;
    const maxLength = 'xxx.xxx.xxx-xx'.length;

    final symbolsPositioning = <String, List<int>>{
      '.': [3, 6],
      '-': [9],
    };

    return super.mask(
      oldValue,
      newValue,
      condition: cpfLength <= maxLength,
      symbolsPositioning: symbolsPositioning,
    );
  }

  @override
  String format(String source) {
    final digits = keepOnlyDigits(source);
    if (digits.length != 11) return '';
    final digitsList = digits.split('').toList();
    digitsList.insert(3, '.');
    digitsList.insert(7, '.');
    digitsList.insert(11, '-');
    return digitsList.join('');
  }
}
