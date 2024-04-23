String keepOnlyDigits(String source) {
  final onlyDigitsRegExp = RegExp(r'\D');
  return source.replaceAll(onlyDigitsRegExp, '');
}