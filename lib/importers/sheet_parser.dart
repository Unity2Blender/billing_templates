import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';

import 'column_matcher.dart';

/// Utility for parsing CSV and Excel files into row data
class SheetParser {
  /// Parse a file into a list of rows (each row is a list of cell values)
  ///
  /// Supports:
  /// - CSV files (.csv)
  /// - Excel files (.xlsx, .xls)
  ///
  /// Returns a tuple of (headers, data rows)
  static Future<ParsedSheet> parseFile({
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final extension = _getFileExtension(fileName).toLowerCase();

    switch (extension) {
      case 'csv':
        return _parseCsv(fileBytes);
      case 'xlsx':
      case 'xls':
        return _parseExcel(fileBytes);
      default:
        throw ImportException(
          'Unsupported file format: $extension. Supported formats: CSV, XLSX, XLS',
          type: ImportExceptionType.invalidFileFormat,
        );
    }
  }

  /// Parse CSV file
  static ParsedSheet _parseCsv(Uint8List fileBytes) {
    try {
      final csvString = String.fromCharCodes(fileBytes);

      // Configure CSV parser with explicit eol (end of line) character
      // This ensures newlines are treated as row separators, not field content
      // Note: shouldParseNumbers=false keeps all values as strings for consistent validation
      final rows = const CsvToListConverter(
        eol: '\n',
        shouldParseNumbers: false,
      ).convert(csvString);

      if (rows.isEmpty) {
        throw ImportException(
          'CSV file is empty',
          type: ImportExceptionType.emptyFile,
        );
      }

      // First row is headers
      final headers =
          rows.first.map((cell) => cell?.toString() ?? '').toList();

      // Remaining rows are data
      final dataRows = rows.skip(1).map((row) {
        return row.map((cell) => cell?.toString() ?? '').toList();
      }).toList();

      return ParsedSheet(
        headers: headers,
        rows: dataRows,
        totalRows: dataRows.length,
      );
    } catch (e) {
      if (e is ImportException) rethrow;
      throw ImportException(
        'Failed to parse CSV file: $e',
        type: ImportExceptionType.parseError,
      );
    }
  }

  /// Parse Excel file
  static ParsedSheet _parseExcel(Uint8List fileBytes) {
    try {
      final excel = Excel.decodeBytes(fileBytes);

      // Get the first sheet
      if (excel.sheets.isEmpty) {
        throw ImportException(
          'Excel file contains no sheets',
          type: ImportExceptionType.emptyFile,
        );
      }

      final sheetName = excel.sheets.keys.first;
      final sheet = excel.sheets[sheetName];

      if (sheet == null || sheet.rows.isEmpty) {
        throw ImportException(
          'Excel sheet is empty',
          type: ImportExceptionType.emptyFile,
        );
      }

      // First row is headers
      final headerRow = sheet.rows.first;
      final headers = headerRow
          .map((cell) => cell?.value?.toString() ?? '')
          .toList();

      // Remaining rows are data
      final dataRows = sheet.rows.skip(1).map((row) {
        return row.map((cell) => cell?.value?.toString() ?? '').toList();
      }).toList();

      return ParsedSheet(
        headers: headers,
        rows: dataRows,
        totalRows: dataRows.length,
      );
    } catch (e) {
      if (e is ImportException) rethrow;
      throw ImportException(
        'Failed to parse Excel file: $e',
        type: ImportExceptionType.parseError,
      );
    }
  }

  /// Get file extension from filename
  static String _getFileExtension(String fileName) {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last : '';
  }
}

/// Parsed sheet data with headers and rows
class ParsedSheet {
  final List<String> headers;
  final List<List<String>> rows;
  final int totalRows;

  ParsedSheet({
    required this.headers,
    required this.rows,
    required this.totalRows,
  });

  /// Get a specific cell value by row and column index
  String getCell(int rowIndex, int columnIndex) {
    if (rowIndex < 0 || rowIndex >= rows.length) return '';
    if (columnIndex < 0 || columnIndex >= rows[rowIndex].length) return '';
    return rows[rowIndex][columnIndex];
  }

  /// Get all values for a specific column
  List<String> getColumn(int columnIndex) {
    return rows.map((row) {
      if (columnIndex < 0 || columnIndex >= row.length) return '';
      return row[columnIndex];
    }).toList();
  }
}
