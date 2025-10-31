import 'package:fuzzywuzzy/fuzzywuzzy.dart';

import '../models/column_mapping.dart';
import '../models/import_config.dart';

/// Fuzzy column matching utility for sheet imports
///
/// Uses Levenshtein distance-based fuzzy matching to map sheet column headers
/// to predefined field names. Implements a greedy best-match algorithm where
/// each sheet column can only be matched once.
class ColumnMatcher {
  final ImportConfig config;

  ColumnMatcher({ImportConfig? config})
      : config = config ?? const ImportConfig();

  /// Match sheet headers to predefined field definitions
  ///
  /// Returns a map of fieldName -> ColumnMapping for all matched columns.
  /// Throws an exception if required fields are missing and allowPartialImport is false.
  Map<String, ColumnMapping> matchColumns({
    required List<String> sheetHeaders,
    required Map<String, FieldDefinition> fieldDefinitions,
  }) {
    final mappings = <String, ColumnMapping>{};
    final usedIndices = <int>{};

    // Normalize headers (trim, lowercase for comparison)
    final normalizedHeaders = sheetHeaders
        .asMap()
        .map((index, header) => MapEntry(index, _normalizeString(header)));

    // Calculate all match scores
    final scores = <_MatchScore>[];
    for (final fieldEntry in fieldDefinitions.entries) {
      final fieldName = fieldEntry.key;
      final fieldDef = fieldEntry.value;

      // Check all possible variations (field name + aliases)
      final variations = [fieldDef.displayName, ...fieldDef.aliases];

      for (final variation in variations) {
        final normalizedVariation = _normalizeString(variation);

        for (final headerEntry in normalizedHeaders.entries) {
          final index = headerEntry.key;
          final normalizedHeader = headerEntry.value;

          // Calculate similarity score using fuzzywuzzy
          final score = ratio(normalizedVariation, normalizedHeader).toDouble();

          if (score >= config.minimumMatchScore) {
            scores.add(_MatchScore(
              fieldName: fieldName,
              fieldDisplayName: fieldDef.displayName,
              sheetColumnName: sheetHeaders[index],
              columnIndex: index,
              score: score,
              isRequired: fieldDef.isRequired,
            ));
          }
        }
      }
    }

    // Sort by score (descending) for greedy matching
    scores.sort((a, b) => b.score.compareTo(a.score));

    // Greedy assignment: assign highest scores first
    for (final matchScore in scores) {
      // Skip if this field is already mapped
      if (mappings.containsKey(matchScore.fieldName)) continue;

      // Skip if this column index is already used
      if (usedIndices.contains(matchScore.columnIndex)) continue;

      // Assign mapping
      mappings[matchScore.fieldName] = ColumnMapping(
        fieldName: matchScore.fieldName,
        sheetColumnName: matchScore.sheetColumnName,
        columnIndex: matchScore.columnIndex,
        confidenceScore: matchScore.score,
        isRequired: matchScore.isRequired,
      );

      usedIndices.add(matchScore.columnIndex);
    }

    // Check for missing required fields
    final missingRequired = fieldDefinitions.entries
        .where((entry) =>
            entry.value.isRequired && !mappings.containsKey(entry.key))
        .map((entry) => entry.value.displayName)
        .toList();

    if (missingRequired.isNotEmpty && !config.allowPartialImport) {
      throw ImportException(
        'Missing required columns: ${missingRequired.join(", ")}',
        type: ImportExceptionType.missingRequiredColumns,
        details: {
          'missingColumns': missingRequired,
          'availableHeaders': sheetHeaders,
        },
      );
    }

    return mappings;
  }

  /// Normalize a string for comparison
  ///
  /// - Lowercase
  /// - Trim whitespace
  /// - Remove special characters
  /// - Collapse multiple spaces
  String _normalizeString(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}

/// Definition of a field that can be matched in the sheet
class FieldDefinition {
  /// Internal field name (e.g., "defaultNetPrice")
  final String fieldName;

  /// Display name for the field (e.g., "Price")
  final String displayName;

  /// List of alternative names/aliases for fuzzy matching
  ///
  /// Example: ["Rate", "Cost", "Amount"] for "Price"
  final List<String> aliases;

  /// Whether this field is required for successful import
  final bool isRequired;

  /// Data type for validation (optional)
  final FieldDataType dataType;

  const FieldDefinition({
    required this.fieldName,
    required this.displayName,
    this.aliases = const [],
    this.isRequired = false,
    this.dataType = FieldDataType.string,
  });
}

enum FieldDataType {
  string,
  number,
  integer,
  boolean,
  date,
}

/// Internal class for storing match scores during greedy assignment
class _MatchScore {
  final String fieldName;
  final String fieldDisplayName;
  final String sheetColumnName;
  final int columnIndex;
  final double score;
  final bool isRequired;

  _MatchScore({
    required this.fieldName,
    required this.fieldDisplayName,
    required this.sheetColumnName,
    required this.columnIndex,
    required this.score,
    required this.isRequired,
  });
}

/// Custom exception for import errors
class ImportException implements Exception {
  final String message;
  final ImportExceptionType type;
  final Map<String, dynamic>? details;

  ImportException(
    this.message, {
    required this.type,
    this.details,
  });

  @override
  String toString() => 'ImportException: $message';
}

enum ImportExceptionType {
  missingRequiredColumns,
  invalidFileFormat,
  emptyFile,
  invalidData,
  parseError,
}
