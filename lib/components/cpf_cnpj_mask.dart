import 'package:flutter/services.dart';
import 'package:project_evydhence/components/cnpj_mask.dart';
import 'package:project_evydhence/components/cpf_mask.dart';
import 'package:project_evydhence/components/generic_masks.dart';

/// [CpfCnpjMask]
///
/// Implementação da classe [GenericMask] para mascarar CPF/CNPJ
///
/// exemplo:
/// - 12345678901 -> 123.456.789-01
/// - 12345678000190 -> 12.345.678/0001-90
class CpfCnpjMask extends GenericMask {
  CpfCnpjMask()
      : super(
          RegExp(
            r'^([0-9]{3})\.([0-9]{3})\.([0-9]{3})-([0-9]{2})|([0-9]{2})\.([0-9]{3})\.([0-9]{3})\/([0-9]{4})-([0-9]{2})$',
          ),
        );

  final _cpfMask = CpfMask();

  final _cnpjMask = CnpjMask();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      cleanInput(newValue.text).length > 11
          ? _cnpjMask.formatEditUpdate(oldValue, newValue)
          : _cpfMask.formatEditUpdate(oldValue, newValue);

  @override
  String format(String source) {
    final String cleanString = cleanInput(source);
    return cleanString.length > 11
        ? _cnpjMask.format(source)
        : _cpfMask.format(source);
  }

  String cleanInput(String text) {
    final cleanInput = text.replaceAll(RegExp(r'[^0-9]'), '');
    return cleanInput;
  }
}
