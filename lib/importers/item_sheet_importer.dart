import 'dart:typed_data';

import '../models/column_mapping.dart';
import '../models/import_config.dart';
import '../models/import_result.dart';
import 'column_matcher.dart';
import 'sheet_parser.dart';

/// Importer for item/product data from CSV/Excel sheets
///
/// Supports fuzzy matching of columns to standard item fields:
/// - Name (required)
/// - HSN Code
/// - Price/Rate (defaultNetPrice)
/// - GST Rate %
/// - Quantity Unit
/// - Stock Qty
/// - Description
class ItemSheetImporter {
  final ImportConfig config;
  final ColumnMatcher _matcher;

  ItemSheetImporter({ImportConfig? config})
      : config = config ?? const ImportConfig(),
        _matcher = ColumnMatcher(config: config);

  /// Field definitions for item data
  static final Map<String, FieldDefinition> _fieldDefinitions = {
    'name': const FieldDefinition(
      fieldName: 'name',
      displayName: 'Name',
      aliases: ['Item Name', 'Product Name', 'Item', 'Product'],
      isRequired: true,
      dataType: FieldDataType.string,
    ),
    'hsnCode': const FieldDefinition(
      fieldName: 'hsnCode',
      displayName: 'HSN Code',
      aliases: ['HSN', 'HSN/SAC', 'SAC Code', 'HSN Code'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
    'defaultNetPrice': const FieldDefinition(
      fieldName: 'defaultNetPrice',
      displayName: 'Price',
      aliases: ['Rate', 'Cost', 'Amount', 'Unit Price', 'Net Price'],
      isRequired: false,
      dataType: FieldDataType.number,
    ),
    'gstRate': const FieldDefinition(
      fieldName: 'gstRate',
      displayName: 'GST Rate %',
      aliases: ['GST', 'Tax Rate', 'GST%', 'Tax%', 'GST Percent'],
      isRequired: false,
      dataType: FieldDataType.number,
    ),
    'qtyUnit': const FieldDefinition(
      fieldName: 'qtyUnit',
      displayName: 'Quantity Unit',
      aliases: ['Qty Unit', 'Unit', 'UOM', 'Measure', 'Quantity'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
    'stockQty': const FieldDefinition(
      fieldName: 'stockQty',
      displayName: 'Stock Qty',
      aliases: ['Stock', 'Quantity', 'Stock Quantity', 'Inventory'],
      isRequired: false,
      dataType: FieldDataType.number,
    ),
    'description': const FieldDefinition(
      fieldName: 'description',
      displayName: 'Description',
      aliases: ['Details', 'Notes', 'Desc', 'Info'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
  };

  /// Import items from a CSV or Excel file
  ///
  /// Returns an ImportResult containing:
  /// - List of ImportedItemData objects
  /// - Column mappings used
  /// - Warnings for skipped/invalid rows
  /// - Metadata about the import
  Future<ImportResult<List<ImportedItemData>>> importItems({
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final startTime = DateTime.now();
    final warnings = <ImportWarning>[];
    final items = <ImportedItemData>[];

    try {
      // Parse the file
      final parsedSheet = await SheetParser.parseFile(
        fileBytes: fileBytes,
        fileName: fileName,
      );

      // Match columns
      final columnMappings = _matcher.matchColumns(
        sheetHeaders: parsedSheet.headers,
        fieldDefinitions: _fieldDefinitions,
      );

      // Extract data from rows
      int successCount = 0;
      int failureCount = 0;

      final maxRows = config.maxRows ?? parsedSheet.totalRows;
      final rowsToProcess =
          parsedSheet.totalRows > maxRows ? maxRows : parsedSheet.totalRows;

      for (int i = 0; i < rowsToProcess; i++) {
        try {
          final itemData = _extractItemData(
            parsedSheet: parsedSheet,
            rowIndex: i,
            columnMappings: columnMappings,
          );

          // Validate required fields
          if (itemData.name.trim().isEmpty) {
            throw ImportException(
              'Item name is required',
              type: ImportExceptionType.invalidData,
            );
          }

          items.add(itemData);
          successCount++;
        } catch (e) {
          failureCount++;

          if (config.skipInvalidRows) {
            warnings.add(ImportWarning(
              message: e.toString(),
              rowIndex: i,
              type: ImportWarningType.invalidData,
            ));
          } else {
            rethrow;
          }
        }
      }

      // Add warnings for low confidence matches
      for (final mapping in columnMappings.values) {
        if (mapping.isLowConfidence) {
          warnings.add(ImportWarning(
            message:
                'Low confidence match for "${mapping.fieldName}": ${mapping.confidenceScore.toStringAsFixed(1)}%',
            columnName: mapping.sheetColumnName,
            type: ImportWarningType.lowConfidenceMatch,
          ));
        }
      }

      final duration = DateTime.now().difference(startTime);

      return ImportResult.success(
        data: items,
        columnMappings: columnMappings,
        warnings: warnings,
        metadata: ImportMetadata(
          totalRows: rowsToProcess,
          successCount: successCount,
          failureCount: failureCount,
          duration: duration,
        ),
      );
    } catch (e) {
      final duration = DateTime.now().difference(startTime);

      return ImportResult.failure(
        errorMessage: e.toString(),
        warnings: warnings,
        metadata: ImportMetadata(
          totalRows: 0,
          successCount: 0,
          failureCount: 0,
          duration: duration,
        ),
      );
    }
  }

  /// Extract item data from a single row
  ImportedItemData _extractItemData({
    required ParsedSheet parsedSheet,
    required int rowIndex,
    required Map<String, ColumnMapping> columnMappings,
  }) {
    String getValue(String fieldName, {String defaultValue = ''}) {
      final mapping = columnMappings[fieldName];
      if (mapping == null) return defaultValue;

      final value = parsedSheet.getCell(rowIndex, mapping.columnIndex);
      return config.trimWhitespace ? value.trim() : value;
    }

    double? getNumericValue(String fieldName) {
      final value = getValue(fieldName);
      if (value.isEmpty) return null;
      return double.tryParse(value.replaceAll(',', ''));
    }

    return ImportedItemData(
      name: getValue('name'),
      hsnCode: getValue('hsnCode'),
      defaultNetPrice: getNumericValue('defaultNetPrice') ?? 0.0,
      gstRate: getNumericValue('gstRate') ?? 0.0,
      qtyUnit: getValue('qtyUnit', defaultValue: 'Nos'),
      stockQty: getNumericValue('stockQty') ?? 0.0,
      description: getValue('description'),
      sourceRowIndex: rowIndex,
    );
  }
}

/// Intermediate data structure for imported item data
///
/// This can be converted to ItemBasicInfoStruct in the consuming application.
/// Kept separate from FlutterFlow-specific code for package independence.
class ImportedItemData {
  final String name;
  final String hsnCode;
  final double defaultNetPrice;
  final double gstRate;
  final String qtyUnit;
  final double stockQty;
  final String description;

  /// The row index this data came from (for error reporting)
  final int sourceRowIndex;

  ImportedItemData({
    required this.name,
    this.hsnCode = '',
    this.defaultNetPrice = 0.0,
    this.gstRate = 0.0,
    this.qtyUnit = 'Nos',
    this.stockQty = 0.0,
    this.description = '',
    required this.sourceRowIndex,
  });

  /// Convert to a Map for JSON serialization or Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'hsnCode': hsnCode,
      'defaultNetPrice': defaultNetPrice,
      'qtyUnit': qtyUnit,
      'description': description,
      'taxRatesConfig': {
        'gstPercent': gstRate,
        'cessPercent': 0.0,
        'grossPercent': gstRate,
      },
      // Custom metadata (not part of ItemBasicInfoStruct)
      'importMetadata': {
        'stockQty': stockQty,
        'sourceRowIndex': sourceRowIndex,
      },
    };
  }

  @override
  String toString() {
    return 'ImportedItemData(name: $name, hsnCode: $hsnCode, '
        'price: $defaultNetPrice, gstRate: $gstRate%, unit: $qtyUnit)';
  }
}
