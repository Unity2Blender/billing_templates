/// CSV Injection Sanitization Utility
///
/// Provides OWASP-compliant protection against CSV formula injection attacks.
///
/// CSV injection (also known as Formula Injection) occurs when malicious formulas
/// are embedded in CSV/Excel files. When these files are opened in spreadsheet
/// applications like Excel, LibreOffice, or Google Sheets, the formulas can execute
/// arbitrary commands, steal data, or perform other malicious actions.
///
/// ## Attack Vectors
/// Cells starting with the following characters are potentially dangerous:
/// - `=` (equals) - Standard Excel formula
/// - `+` (plus) - Alternative formula prefix
/// - `-` (minus) - Alternative formula prefix
/// - `@` (at) - Excel function prefix
/// - `|` (pipe) - Command separator in some contexts
/// - `\t` (tab) - Field delimiter confusion
/// - `\r` (carriage return) - Line break manipulation
///
/// ## Example Attacks
/// ```csv
/// Item Name,Price
/// =1+1+cmd|'/c calc'!A1,100        // Executes calculator on Windows
/// =HYPERLINK("http://evil.com"),200 // Phishing link
/// @SUM(1+1),300                     // Function execution
/// ```
///
/// ## Sanitization Method
/// This utility prepends a single quote `'` to cells that start with dangerous
/// characters. This causes spreadsheet applications to treat the content as
/// literal text rather than executable formulas.
///
/// Example:
/// - Input: `=SUM(A1:A10)`
/// - Output: `'=SUM(A1:A10)`
///
/// ## Usage
/// ```dart
/// final sanitizer = CsvSanitizer();
/// final safe = sanitizer.sanitizeCell('=malicious formula');
/// // Returns: '=malicious formula
/// ```
///
/// ## References
/// - OWASP: https://owasp.org/www-community/attacks/CSV_Injection
/// - CWE-1236: https://cwe.mitre.org/data/definitions/1236.html
library;

class CsvSanitizer {
  /// Characters that indicate a potential formula injection when found at the
  /// start of a cell value (after trimming left whitespace).
  static const List<String> _dangerousChars = [
    '=', // Standard Excel formula
    '+', // Alternative formula prefix
    '-', // Alternative formula prefix
    '@', // Excel function prefix (e.g., @SUM)
    '|', // Command separator/pipe
    '\t', // Tab character (field delimiter)
    '\r', // Carriage return (line manipulation)
  ];

  /// Sanitizes a cell value to prevent CSV formula injection attacks.
  ///
  /// If the cell value starts with a dangerous character (after trimming left
  /// whitespace), this method prepends a single quote `'` to neutralize the
  /// formula. Spreadsheet applications will treat the content as literal text.
  ///
  /// The original formatting (including leading whitespace) is always preserved
  /// when adding the quote. For example: `'  =1+1'` becomes `'  =1+1` with the
  /// quote prepended but whitespace intact.
  ///
  /// **Parameters:**
  /// - `value`: The cell value to sanitize
  ///
  /// **Returns:**
  /// - Sanitized string with leading `'` if dangerous
  /// - Original string if safe
  /// - Empty string if input is null or empty
  ///
  /// **Examples:**
  /// ```dart
  /// sanitizeCell('=SUM(A1:A10)');           // Returns: '=SUM(A1:A10)
  /// sanitizeCell('Normal text');             // Returns: Normal text
  /// sanitizeCell('  =dangerous');            // Returns: '  =dangerous
  /// sanitizeCell('+cmd|calc');               // Returns: '+cmd|calc
  /// sanitizeCell('@SUM(1+1)');               // Returns: '@SUM(1+1)
  /// sanitizeCell('user+tag@example.com');    // Returns: user+tag@example.com
  /// sanitizeCell('123-456-7890');            // Returns: 123-456-7890
  /// ```
  static String sanitizeCell(String? value) {
    // Handle null or empty values
    if (value == null || value.isEmpty) {
      return '';
    }

    // Check if the first character (after removing only regular spaces) is dangerous
    // We trim only spaces, not tabs/carriage returns, since those are dangerous chars
    String checkValue = value;
    while (checkValue.isNotEmpty && checkValue[0] == ' ') {
      checkValue = checkValue.substring(1);
    }

    // Check if the value starts with a dangerous character
    if (checkValue.isNotEmpty && requiresSanitization(checkValue)) {
      // Prepend single quote to neutralize formula
      // Original whitespace is preserved
      return "'$value";
    }

    return value;
  }

  /// Checks if a cell value requires sanitization.
  ///
  /// Returns `true` if the value starts with any dangerous character that could
  /// trigger formula execution in spreadsheet applications.
  ///
  /// **Parameters:**
  /// - `value`: The cell value to check (should already be trimmed if needed)
  ///
  /// **Returns:**
  /// - `true` if the value starts with a dangerous character
  /// - `false` if the value is safe or empty
  ///
  /// **Examples:**
  /// ```dart
  /// requiresSanitization('=SUM(A1)');     // Returns: true
  /// requiresSanitization('+1+1');         // Returns: true
  /// requiresSanitization('-1+1');         // Returns: true
  /// requiresSanitization('@SUM(1)');      // Returns: true
  /// requiresSanitization('|calc');        // Returns: true
  /// requiresSanitization('Normal text');  // Returns: false
  /// requiresSanitization('user@email.com'); // Returns: false (@ not at start)
  /// requiresSanitization('123-456');      // Returns: false (- not at start)
  /// ```
  static bool requiresSanitization(String value) {
    if (value.isEmpty) return false;

    // Check if the first character matches any dangerous character
    final firstChar = value[0];
    return _dangerousChars.contains(firstChar);
  }

  /// Batch sanitizes multiple cell values.
  ///
  /// Efficiently sanitizes a list of cell values, such as an entire row from
  /// a CSV file.
  ///
  /// **Parameters:**
  /// - `values`: List of cell values to sanitize
  ///
  /// **Returns:**
  /// - List of sanitized strings in the same order
  ///
  /// **Example:**
  /// ```dart
  /// final row = ['=SUM(A1)', 'Normal', '+dangerous'];
  /// final sanitized = sanitizeCells(row);
  /// // Returns: ["'=SUM(A1)", 'Normal', "'+dangerous"]
  /// ```
  static List<String> sanitizeCells(List<String?> values) {
    return values.map((value) => sanitizeCell(value)).toList();
  }

  /// Sanitizes an entire row represented as a map of column names to values.
  ///
  /// Useful for sanitizing parsed CSV rows where columns are already mapped
  /// to their field names.
  ///
  /// **Parameters:**
  /// - `row`: Map of column names to cell values
  ///
  /// **Returns:**
  /// - New map with sanitized values (original keys preserved)
  ///
  /// **Example:**
  /// ```dart
  /// final row = {'name': '=malicious', 'price': '100', 'desc': 'Normal'};
  /// final sanitized = sanitizeRow(row);
  /// // Returns: {'name': "'=malicious", 'price': '100', 'desc': 'Normal'}
  /// ```
  static Map<String, String> sanitizeRow(Map<String, String?> row) {
    return row.map(
      (key, value) => MapEntry(key, sanitizeCell(value)),
    );
  }

  /// Returns statistics about sanitization performed on a list of values.
  ///
  /// Useful for logging and monitoring security events.
  ///
  /// **Parameters:**
  /// - `values`: List of cell values to analyze
  ///
  /// **Returns:**
  /// - Map with statistics:
  ///   - `total`: Total number of values
  ///   - `sanitized`: Number of values that required sanitization
  ///   - `safe`: Number of values that were already safe
  ///   - `empty`: Number of null/empty values
  ///
  /// **Example:**
  /// ```dart
  /// final stats = getSanitizationStats(['=bad', 'good', '', '=bad2']);
  /// // Returns: {total: 4, sanitized: 2, safe: 1, empty: 1}
  /// ```
  static Map<String, int> getSanitizationStats(List<String?> values) {
    int total = values.length;
    int sanitized = 0;
    int safe = 0;
    int empty = 0;

    for (final value in values) {
      if (value == null || value.isEmpty) {
        empty++;
      } else if (requiresSanitization(value.trimLeft())) {
        sanitized++;
      } else {
        safe++;
      }
    }

    return {
      'total': total,
      'sanitized': sanitized,
      'safe': safe,
      'empty': empty,
    };
  }
}
