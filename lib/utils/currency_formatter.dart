class CurrencyFormatter {
  static String format(double amount, {String symbol = '₹'}) {
    final isNegative = amount < 0;
    final absAmount = amount.abs();

    final formatted = absAmount.toStringAsFixed(2);
    final parts = formatted.split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    // Indian number formatting (lakhs/crores)
    String formattedInt;
    if (intPart.length > 3) {
      final lastThree = intPart.substring(intPart.length - 3);
      final remaining = intPart.substring(0, intPart.length - 3);

      final regEx = RegExp(r'(\d)(?=(\d{2})+$)');
      formattedInt =
          remaining.replaceAllMapped(regEx, (match) => '${match.group(1)},');
      formattedInt = '$formattedInt,$lastThree';
    } else {
      formattedInt = intPart;
    }

    final result = '$symbol $formattedInt.$decPart';
    return isNegative ? '-$result' : result;
  }

  static String formatCompact(double amount, {String symbol = '₹'}) {
    if (amount >= 10000000) {
      // Crores
      return '$symbol ${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      // Lakhs
      return '$symbol ${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      // Thousands
      return '$symbol ${(amount / 1000).toStringAsFixed(2)} K';
    } else {
      return format(amount, symbol: symbol);
    }
  }

  static String toWords(double amount) {
    if (amount == 0) return 'Zero Rupees';

    final rupees = amount.floor();
    final paise = ((amount - rupees) * 100).round();

    String result = '${_convertNumberToWords(rupees)} Rupees';
    if (paise > 0) {
      result = '$result and ${_convertNumberToWords(paise)} Paise';
    }

    return result;
  }

  static String _convertNumberToWords(int number) {
    if (number == 0) return 'Zero';

    final ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    final tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    if (number < 20) {
      return ones[number];
    } else if (number < 100) {
      final base = tens[number ~/ 10];
      return number % 10 != 0 ? '$base ${ones[number % 10]}' : base;
    } else if (number < 1000) {
      final base = '${ones[number ~/ 100]} Hundred';
      return number % 100 != 0
          ? '$base ${_convertNumberToWords(number % 100)}'
          : base;
    } else if (number < 100000) {
      final base = '${_convertNumberToWords(number ~/ 1000)} Thousand';
      return number % 1000 != 0
          ? '$base ${_convertNumberToWords(number % 1000)}'
          : base;
    } else if (number < 10000000) {
      final base = '${_convertNumberToWords(number ~/ 100000)} Lakh';
      return number % 100000 != 0
          ? '$base ${_convertNumberToWords(number % 100000)}'
          : base;
    } else {
      final base = '${_convertNumberToWords(number ~/ 10000000)} Crore';
      return number % 10000000 != 0
          ? '$base ${_convertNumberToWords(number % 10000000)}'
          : base;
    }
  }
}
