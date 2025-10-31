/// Represents the mapping between a sheet column and a predefined field
///
/// Used to store the result of fuzzy column matching, including the
/// matched column index, confidence score, and metadata.
class ColumnMapping {
  /// The predefined field name (e.g., "name", "hsnCode", "defaultNetPrice")
  final String fieldName;

  /// The header name found in the sheet
  final String sheetColumnName;

  /// The 0-based index of the matched column in the sheet
  final int columnIndex;

  /// Confidence score of the match (0.0 to 100.0)
  ///
  /// - 100: Perfect match
  /// - 70-99: Good match (fuzzy)
  /// - Below 70: Low confidence (may need manual review)
  final double confidenceScore;

  /// Whether this field is required for successful import
  final bool isRequired;

  ColumnMapping({
    required this.fieldName,
    required this.sheetColumnName,
    required this.columnIndex,
    required this.confidenceScore,
    required this.isRequired,
  });

  /// Whether this is a high confidence match (>= 80%)
  bool get isHighConfidence => confidenceScore >= 80.0;

  /// Whether this is a medium confidence match (70-79%)
  bool get isMediumConfidence =>
      confidenceScore >= 70.0 && confidenceScore < 80.0;

  /// Whether this is a low confidence match (< 70%)
  bool get isLowConfidence => confidenceScore < 70.0;

  @override
  String toString() {
    return 'ColumnMapping(field: $fieldName, sheet: "$sheetColumnName", '
        'index: $columnIndex, confidence: ${confidenceScore.toStringAsFixed(1)}%)';
  }

  Map<String, dynamic> toJson() => {
        'fieldName': fieldName,
        'sheetColumnName': sheetColumnName,
        'columnIndex': columnIndex,
        'confidenceScore': confidenceScore,
        'isRequired': isRequired,
      };
}
