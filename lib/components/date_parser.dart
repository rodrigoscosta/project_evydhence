bool isUsingDatePattern(String value) =>
    RegExp(r'^(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/](19|20)\d\d$')
        .hasMatch(value);

/// parse 'dd/mm/yyyy hh:ss:mm' to 'yyyy-mm-dd hh:ss:mm'.
String fromDateUsingPatternToFormattedString(
  String dateUsingSinqiaPattern,
) {
  final splittedInDateAndTime = dateUsingSinqiaPattern.split(' ');
  final date = splittedInDateAndTime.first;
  //final time = splittedInDateAndTime.last;

  final splittedDate = date.split('/');
  final day = splittedDate.first;
  final month = splittedDate.elementAt(1);
  final year = splittedDate.elementAt(2);

  final dateString = [year, month, day].join('-');

  return dateString;
}

/// parse 'dd/mm/yyyy hh:ss:mm' to [DateTime].
DateTime fromDateUsingPatternToDateTime(String dateUsingSinqiaPattern) {
  final formattedString =
      fromDateUsingPatternToFormattedString(dateUsingSinqiaPattern);
  return DateTime.parse(formattedString);
}

/// parse [DateTime] to 'dd/mm/yyyy hh:ss:mm'
String fromDateTimeToDateUsingPattern(DateTime dateTime) {
  final day = _leadingZeroInt(dateTime.day);
  final month = _leadingZeroInt(dateTime.month);
  final year = dateTime.year.toString();

  return '$day/$month/$year';
}

/// parse [DateTime] to 'dd/mm/yyyy hh:ss:mm'
String convertePadraoData(DateTime dateTime) {
  final day = _leadingZeroInt(dateTime.day);
  final month = _leadingZeroInt(dateTime.month);
  final year = dateTime.year.toString();

  return '$year-$month-$day';
}

String _leadingZeroInt(int number) => number.toString().padLeft(2, '0');
