import 'package:flutter/services.dart';
import 'package:project_evydhence/components/generic_masks.dart';
import 'package:project_evydhence/components/keep_only_digits.dart';

/// [CepMask]
///
/// Implementação da classe [GenericMask] para mascarar CEP
///
/// exemplo:
/// - 12345678 -> 12.345-678
class CepMask extends GenericMask {
  CepMask() : super(RegExp(r'^([0-9]{2})\.([0-9]{3})-([0-9]{3})$'));

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final cnpjLength = newValue.text.length;
    const maxLength = 'xx.xxx-xxx'.length;

    final symbolsPositioning = <String, List<int>>{
      '.': [2],
      '-': [5],
    };

    return super.mask(
      oldValue,
      newValue,
      condition: cnpjLength <= maxLength,
      symbolsPositioning: symbolsPositioning,
    );
  }

  @override
  String format(String source) {
    final digits = keepOnlyDigits(source);
    if (digits.length != 8) return '';
    final digitsList = digits.split('').toList();
    digitsList.insert(2, '.');
    digitsList.insert(6, '-');
    return digitsList.join('');
  }
}
