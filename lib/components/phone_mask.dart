import 'package:flutter/services.dart';
import 'package:project_evydhence/components/generic_masks.dart';
import 'package:project_evydhence/components/keep_only_digits.dart';

/// [PhoneMask]
///
/// Implementação da classe [GenericMask] para mascarar telefones e celulares
///
/// exemplos:
/// - 1140028922 -> (11)4402-8922
/// - 15988776655 -> (15)98877-6655
class PhoneMask extends GenericMask {
  //Realiza a validação se o telefone possui 3 dígitos no DDD ou 2
  PhoneMask()
      : super(RegExp(
            r'(^\([0-9]{2}\)[9]?[1-9]{1}[0-9]{3}-[0-9]{4}$)|(^\([0-9]{3}\)[9]?[1-9]{1}[0-9]{3}-[0-9]{4}$)'));

  // Revisar, pois no Paylod está passando o ddd e telefone errado

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final phone = newValue.text;
    final phoneSplittedByClosingParenthesis = phone.split(')');

    // para validar se o [phone] tem prefixo 9, é preciso ignorar a parte do DDD
    // e pegar a parte dos digitos
    // se o DDD estiver preenchido, teremos algo assim:
    // ['(xx', '9xxxx-xxxx'], o index 1 é o objetivo
    // se o DDD não estiver preenchido, é preciso retornar uma string vazia para
    // evitar [RangeError] (o index 1 não existiria)
    String digits = '';
    if (newValue.text.contains('(')) {
      digits = phoneSplittedByClosingParenthesis.length > 1
          ? phoneSplittedByClosingParenthesis[1]
          : '';
    } else {
      digits = newValue.text.substring(2);
    }

    final hasNinePrefix = digits.startsWith('9');
    final hasZeroPrefix =
        phoneSplittedByClosingParenthesis[0].startsWith('0') ||
            phoneSplittedByClosingParenthesis[0].startsWith('(0');
    int zeroPrefix = hasZeroPrefix ? 1 : 0;
    int posClosingParenthesis = hasZeroPrefix ? 3 : 2;
    int posDash = (hasNinePrefix ? 7 : 6) + zeroPrefix;

    final phoneMaxLength =
        hasNinePrefix ? '(xx)9xxxx-xxxx'.length : '(xx)xxxx-xxxx'.length;

    final symbolsPositioning = <String, List<int>>{
      '(': [0],
      ')': [posClosingParenthesis],
      '-': [posDash],
    };

    int qtdPhoneMaxLength() {
      return hasZeroPrefix ? phoneMaxLength + 1 : phoneMaxLength;
    }

    return super.mask(
      oldValue,
      newValue,
      condition: phone.length <= qtdPhoneMaxLength(),
      symbolsPositioning: symbolsPositioning,
    );
  }

  @override
  String format(String source) {
    final digits = keepOnlyDigits(source);
    final isFixo = digits.length == 10;
    final isCellphone = digits.length >= 11;
    int startZero = digits.startsWith('0') ? 1 : 0;

    if (!isFixo && !isCellphone) return source;
    final digitsList = digits.split('');
    digitsList.insert(0, '(');
    digitsList.insert(3 + startZero, ')');
    //Insere um - no array, começando de trás para frente, visto que tanto celular quando telefone fixo possuem 4 dígitos finais
    digitsList.insert(digitsList.length - 4, '-');
    return digitsList.join('');
  }

  String retornarSomenteDDD(String telefone) {
    final phone = keepOnlyDigits(telefone);
    final ddd =
        phone.startsWith('0') ? phone.substring(0, 3) : phone.substring(0, 2);
    return ddd;
  }

  String retornarSomenteNumero(String telefone) {
    final phone = keepOnlyDigits(telefone);
    final numero =
        phone.startsWith('0') ? phone.substring(3) : phone.substring(2);
    return numero;
  }
}
