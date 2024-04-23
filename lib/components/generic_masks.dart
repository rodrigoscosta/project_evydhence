import 'package:flutter/services.dart';
import 'package:project_evydhence/components/keep_only_digits.dart';

/// [GenericMask]
///
/// Classe abstrata que herda de [TextInputFormatter] e isola a lógica comum
/// para lidar com máscaras de input, como mascarar valores, desmascarar e
/// validar via [RegExp].
abstract class GenericMask extends TextInputFormatter {
  /// [_validationRegExp] é uma [RegExp] para validar valores mascarados
  ///
  /// é um atributo privado e só pode ser acessado via getter
  final RegExp _validationRegExp;

  GenericMask(this._validationRegExp);

  /// Getter do campo privado [_validationRegExp]
  RegExp get validationRegExp => _validationRegExp;

  /// Remove tudo de [value] que não for um digito
  String unmask(String value) => keepOnlyDigits(value);

  /// Mascara [TextEditingValue] se baseando nos valores de [symbolsPositioning]
  ///
  /// se [condition] for `false` então retorna o [oldValue] sem mudanças
  TextEditingValue mask(
    TextEditingValue oldValue,
    TextEditingValue newValue, {
    required bool condition,
    required Map<String, List<int>> symbolsPositioning,
  }) {
    if (!condition) {
      return oldValue;
    }

    final digits = unmask(newValue.text).split('');
    final masked = List<String>.empty(growable: true);

    digits.asMap().forEach((digitIndex, digit) {
      symbolsPositioning.forEach((symbol, positions) {
        if (positions.contains(digitIndex)) {
          masked.add(symbol);
        }
      });
      masked.add(digit);
    });

    return newValue.copyWith(
      text: masked.join(''),
      selection: TextSelection.fromPosition(
        TextPosition(offset: masked.length),
      ),
    );
  }

  String format(String source) => throw UnimplementedError();
}
