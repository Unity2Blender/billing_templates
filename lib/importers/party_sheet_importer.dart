import 'dart:typed_data';

import '../models/column_mapping.dart';
import '../models/import_config.dart';
import '../models/import_result.dart';
import 'column_matcher.dart';
import 'sheet_parser.dart';

/// Importer for party/customer/vendor contact data from CSV/Excel sheets
///
/// Supports fuzzy matching of columns to standard business/party fields:
/// - Business Name (required)
/// - Phone
/// - Email
/// - GSTIN
/// - PAN
/// - State
/// - District
/// - Business Address
class PartySheetImporter {
  final ImportConfig config;
  final ColumnMatcher _matcher;

  PartySheetImporter({ImportConfig? config})
      : config = config ?? const ImportConfig(),
        _matcher = ColumnMatcher(config: config);

  /// Field definitions for party/business contact data
  static final Map<String, FieldDefinition> _fieldDefinitions = {
    'businessName': const FieldDefinition(
      fieldName: 'businessName',
      displayName: 'Business Name',
      aliases: ['Company', 'Firm Name', 'Party Name', 'Customer Name', 'Name'],
      isRequired: true,
      dataType: FieldDataType.string,
    ),
    'phone': const FieldDefinition(
      fieldName: 'phone',
      displayName: 'Phone',
      aliases: [
        'Mobile',
        'Contact',
        'Phone Number',
        'Mobile Number',
        'Contact Number'
      ],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
    'email': const FieldDefinition(
      fieldName: 'email',
      displayName: 'Email',
      aliases: ['Email Address', 'Email ID', 'Mail'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
    'gstin': const FieldDefinition(
      fieldName: 'gstin',
      displayName: 'GSTIN',
      aliases: ['GST Number', 'GST No', 'GSTIN Number', 'GST'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
    'pan': const FieldDefinition(
      fieldName: 'pan',
      displayName: 'PAN',
      aliases: ['PAN Number', 'PAN Card', 'PAN No'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
    'state': const FieldDefinition(
      fieldName: 'state',
      displayName: 'State',
      aliases: ['State Name', 'State/UT'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
    'district': const FieldDefinition(
      fieldName: 'district',
      displayName: 'District',
      aliases: ['City', 'District Name'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
    'businessAddress': const FieldDefinition(
      fieldName: 'businessAddress',
      displayName: 'Address',
      aliases: ['Business Address', 'Full Address', 'Location', 'Street'],
      isRequired: false,
      dataType: FieldDataType.string,
    ),
  };

  /// Import party contacts from a CSV or Excel file
  ///
  /// Returns an ImportResult containing:
  /// - List of ImportedPartyData objects
  /// - Column mappings used
  /// - Warnings for skipped/invalid rows
  /// - Metadata about the import
  Future<ImportResult<List<ImportedPartyData>>> importParties({
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    final startTime = DateTime.now();
    final warnings = <ImportWarning>[];
    final parties = <ImportedPartyData>[];

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
          final partyData = _extractPartyData(
            parsedSheet: parsedSheet,
            rowIndex: i,
            columnMappings: columnMappings,
          );

          // Validate required fields
          if (partyData.businessName.trim().isEmpty) {
            throw ImportException(
              'Business name is required',
              type: ImportExceptionType.invalidData,
            );
          }

          parties.add(partyData);
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
        data: parties,
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

  /// Extract party data from a single row
  ImportedPartyData _extractPartyData({
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

    return ImportedPartyData(
      businessName: getValue('businessName'),
      phone: getValue('phone'),
      email: getValue('email'),
      gstin: getValue('gstin'),
      pan: getValue('pan'),
      state: getValue('state'),
      district: getValue('district'),
      businessAddress: getValue('businessAddress'),
      sourceRowIndex: rowIndex,
    );
  }
}

/// Intermediate data structure for imported party/business contact data
///
/// This can be converted to BusinessDetailsStruct in the consuming application.
/// Kept separate from FlutterFlow-specific code for package independence.
class ImportedPartyData {
  final String businessName;
  final String phone;
  final String email;
  final String gstin;
  final String pan;
  final String state;
  final String district;
  final String businessAddress;

  /// The row index this data came from (for error reporting)
  final int sourceRowIndex;

  ImportedPartyData({
    required this.businessName,
    this.phone = '',
    this.email = '',
    this.gstin = '',
    this.pan = '',
    this.state = '',
    this.district = '',
    this.businessAddress = '',
    required this.sourceRowIndex,
  });

  /// Convert to a Map for JSON serialization or Firestore
  Map<String, dynamic> toMap() {
    return {
      'businessName': businessName,
      'phone': phone,
      'email': email,
      'gstin': gstin,
      'pan': pan,
      'state': state,
      'district': district,
      'businessAddress': businessAddress,
      'isCustomer': true, // Default value
      'isVendor': false, // Default value
      'customFieldValues': [], // Empty by default
      // Custom metadata
      'importMetadata': {
        'sourceRowIndex': sourceRowIndex,
      },
    };
  }

  @override
  String toString() {
    return 'ImportedPartyData(name: $businessName, phone: $phone, '
        'email: $email, gstin: $gstin)';
  }
}
