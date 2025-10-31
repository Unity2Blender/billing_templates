/// Configuration for sheet import behavior
///
/// Controls fuzzy matching thresholds, data validation, and error handling.
class ImportConfig {
  /// Minimum similarity score (0-100) for a column match to be accepted
  ///
  /// Default: 70.0
  /// - Higher values = stricter matching (fewer false positives)
  /// - Lower values = more lenient matching (more potential matches)
  final double minimumMatchScore;

  /// Whether to skip rows with invalid data instead of failing the entire import
  ///
  /// Default: true
  /// - true: Skip invalid rows, collect warnings
  /// - false: Fail entire import on first invalid row
  final bool skipInvalidRows;

  /// Maximum number of rows to process (for large files)
  ///
  /// Default: null (no limit)
  final int? maxRows;

  /// Whether to trim whitespace from all string values
  ///
  /// Default: true
  final bool trimWhitespace;

  /// Whether to allow partial imports (some required columns missing)
  ///
  /// Default: false
  /// - false: All required columns must be matched
  /// - true: Import with partial data (may result in incomplete records)
  final bool allowPartialImport;

  /// Custom column aliases for fuzzy matching
  ///
  /// Example: {"Price": ["Rate", "Cost", "Amount"]}
  /// This helps match common variations of column names.
  final Map<String, List<String>> customAliases;

  const ImportConfig({
    this.minimumMatchScore = 70.0,
    this.skipInvalidRows = true,
    this.maxRows,
    this.trimWhitespace = true,
    this.allowPartialImport = false,
    this.customAliases = const {},
  });

  /// Default strict configuration (high confidence matches only)
  static const ImportConfig strict = ImportConfig(
    minimumMatchScore: 85.0,
    skipInvalidRows: false,
    allowPartialImport: false,
  );

  /// Default lenient configuration (accepts lower confidence matches)
  static const ImportConfig lenient = ImportConfig(
    minimumMatchScore: 60.0,
    skipInvalidRows: true,
    allowPartialImport: true,
  );

  ImportConfig copyWith({
    double? minimumMatchScore,
    bool? skipInvalidRows,
    int? maxRows,
    bool? trimWhitespace,
    bool? allowPartialImport,
    Map<String, List<String>>? customAliases,
  }) {
    return ImportConfig(
      minimumMatchScore: minimumMatchScore ?? this.minimumMatchScore,
      skipInvalidRows: skipInvalidRows ?? this.skipInvalidRows,
      maxRows: maxRows ?? this.maxRows,
      trimWhitespace: trimWhitespace ?? this.trimWhitespace,
      allowPartialImport: allowPartialImport ?? this.allowPartialImport,
      customAliases: customAliases ?? this.customAliases,
    );
  }
}
