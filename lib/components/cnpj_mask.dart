import 'package:flutter/services.dart';
import 'package:project_evydhence/components/generic_masks.dart';
import 'package:project_evydhence/components/keep_only_digits.dart';

/// [CnpjMask]
///
/// Implementação da classe [GenericMask] para mascarar CNPJ
///
/// exemplo:
/// - 12345678000190 -> 12.345.678/0001-90
class CnpjMask extends GenericMask {
  CnpjMask()
      : super(
          RegExp(
            r'^([0-9]{2})\.([0-9]{3})\.([0-9]{3})\/([0-9]{4})-([0-9]{2})$',
          ),
        );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final cnpjLength = newValue.text.length;
    const maxLength = 'xx.xxx.xxx/xxxx-xx'.length;

    final symbolsPositioning = <String, List<int>>{
      '.': [2, 5],
      '/': [8],
      '-': [12],
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
    if (digits.length != 14) return '';
    final digitsList = digits.split('');
    digitsList.insert(2, '.');
    digitsList.insert(6, '.');
    digitsList.insert(10, '/');
    digitsList.insert(15, '-');
    return digitsList.join('');
  }
}
