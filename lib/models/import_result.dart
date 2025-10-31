import 'column_mapping.dart';

/// Result wrapper for sheet import operations
///
/// Generic result type that can hold success data or error information.
class ImportResult<T> {
  /// Whether the import was successful
  final bool isSuccess;

  /// The imported data (only present if isSuccess == true)
  final T? data;

  /// Error message (only present if isSuccess == false)
  final String? errorMessage;

  /// Column mappings used during import
  final Map<String, ColumnMapping>? columnMappings;

  /// Non-fatal warnings collected during import
  ///
  /// Examples:
  /// - Skipped rows due to invalid data
  /// - Low confidence column matches
  /// - Data type coercion warnings
  final List<ImportWarning> warnings;

  /// Metadata about the import operation
  final ImportMetadata metadata;

  ImportResult.success({
    required this.data,
    required this.columnMappings,
    this.warnings = const [],
    ImportMetadata? metadata,
  })  : isSuccess = true,
        errorMessage = null,
        metadata = metadata ?? ImportMetadata();

  ImportResult.failure({
    required this.errorMessage,
    this.warnings = const [],
    this.columnMappings,
    ImportMetadata? metadata,
  })  : isSuccess = false,
        data = null,
        metadata = metadata ?? ImportMetadata();

  /// Whether there are any warnings
  bool get hasWarnings => warnings.isNotEmpty;

  /// Number of successful imports
  int get successCount => metadata.successCount;

  /// Number of failed/skipped rows
  int get failureCount => metadata.failureCount;
}

/// Warning information for non-fatal issues during import
class ImportWarning {
  final String message;
  final int? rowIndex;
  final String? columnName;
  final ImportWarningType type;

  ImportWarning({
    required this.message,
    this.rowIndex,
    this.columnName,
    required this.type,
  });

  @override
  String toString() {
    final location =
        rowIndex != null ? ' (row ${rowIndex! + 1})' : '';
    final column = columnName != null ? ' [$columnName]' : '';
    return '${type.name.toUpperCase()}$location$column: $message';
  }
}

enum ImportWarningType {
  lowConfidenceMatch,
  invalidData,
  missingOptionalField,
  dataTypeCoercion,
  duplicateRow,
  other,
}

/// Metadata about the import operation
class ImportMetadata {
  final int totalRows;
  final int successCount;
  final int failureCount;
  final DateTime importedAt;
  final Duration duration;

  ImportMetadata({
    this.totalRows = 0,
    this.successCount = 0,
    this.failureCount = 0,
    DateTime? importedAt,
    Duration? duration,
  })  : importedAt = importedAt ?? DateTime.now(),
        duration = duration ?? Duration.zero;

  double get successRate =>
      totalRows > 0 ? (successCount / totalRows) * 100 : 0.0;

  @override
  String toString() {
    return 'ImportMetadata(total: $totalRows, success: $successCount, '
        'failed: $failureCount, rate: ${successRate.toStringAsFixed(1)}%)';
  }
}
