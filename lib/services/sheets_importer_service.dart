import 'dart:typed_data';

import '../importers/item_sheet_importer.dart';
import '../importers/party_sheet_importer.dart';
import '../models/import_config.dart';
import '../models/import_result.dart';

/// Public API service for importing data from CSV/Excel sheets
///
/// This service provides a clean, high-level interface for importing:
/// - Items/Products (with fuzzy column matching)
/// - Party/Business contacts (customers, vendors)
///
/// Usage:
/// ```dart
/// final service = SheetsImporterService();
///
/// // Import items
/// final result = await service.importItems(
///   fileBytes: fileData,
///   fileName: 'products.csv',
/// );
///
/// if (result.isSuccess) {
///   print('Imported ${result.data!.length} items');
///   for (final item in result.data!) {
///     print(item.name); // Access item data
///   }
/// }
/// ```
///
/// Features:
/// - Fuzzy column name matching (typo-tolerant)
/// - Support for CSV and Excel (.xlsx) files
/// - Configurable matching thresholds
/// - Detailed error reporting and warnings
/// - Skip invalid rows or fail fast
class SheetsImporterService {
  /// Import items/products from a CSV or Excel file
  ///
  /// Supported columns (with fuzzy matching):
  /// - **Name** (required) - Item/Product name
  /// - **HSN Code** - HSN/SAC code for GST
  /// - **Price** - Default net price (aliases: Rate, Cost, Amount)
  /// - **GST Rate %** - GST percentage (0, 5, 12, 18, 28)
  /// - **Quantity Unit** - Unit of measurement (aliases: Qty Unit, UOM)
  /// - **Stock Qty** - Current stock quantity
  /// - **Description** - Item description/details
  ///
  /// Returns:
  /// - `ImportResult<List<ImportedItemData>>` with success/error details
  /// - `result.data` contains the imported items
  /// - `result.warnings` contains non-fatal issues (skipped rows, low confidence matches)
  /// - `result.columnMappings` shows which columns were matched
  ///
  /// Example:
  /// ```dart
  /// final result = await service.importItems(
  ///   fileBytes: csvBytes,
  ///   fileName: 'inventory.csv',
  ///   config: ImportConfig(minimumMatchScore: 75.0),
  /// );
  ///
  /// if (result.isSuccess) {
  ///   for (final item in result.data!) {
  ///     // Convert to your struct format
  ///     final struct = ItemBasicInfoStruct(
  ///       name: item.name,
  ///       hsnCode: item.hsnCode,
  ///       defaultNetPrice: item.defaultNetPrice,
  ///       // ... other fields
  ///     );
  ///     // Upload to Firestore
  ///     await firestore.collection('items').add(struct.toMap());
  ///   }
  /// }
  /// ```
  Future<ImportResult<List<ImportedItemData>>> importItems({
    required Uint8List fileBytes,
    required String fileName,
    ImportConfig? config,
  }) async {
    final importer = ItemSheetImporter(config: config);
    return await importer.importItems(
      fileBytes: fileBytes,
      fileName: fileName,
    );
  }

  /// Import party/business contacts from a CSV or Excel file
  ///
  /// Supported columns (with fuzzy matching):
  /// - **Business Name** (required) - Company/Firm name
  /// - **Phone** - Contact phone number
  /// - **Email** - Email address
  /// - **GSTIN** - GST identification number
  /// - **PAN** - PAN card number
  /// - **State** - State name
  /// - **District** - District/City name
  /// - **Address** - Full business address
  ///
  /// Returns:
  /// - `ImportResult<List<ImportedPartyData>>` with success/error details
  /// - `result.data` contains the imported party contacts
  /// - `result.warnings` contains non-fatal issues
  /// - `result.columnMappings` shows which columns were matched
  ///
  /// Example:
  /// ```dart
  /// final result = await service.importParties(
  ///   fileBytes: excelBytes,
  ///   fileName: 'customers.xlsx',
  /// );
  ///
  /// if (result.isSuccess) {
  ///   for (final party in result.data!) {
  ///     // Convert to your struct format
  ///     final struct = BusinessDetailsStruct(
  ///       businessName: party.businessName,
  ///       phone: party.phone,
  ///       email: party.email,
  ///       // ... other fields
  ///     );
  ///     // Upload to Firestore
  ///     await firestore.collection('parties').add(struct.toMap());
  ///   }
  /// }
  /// ```
  Future<ImportResult<List<ImportedPartyData>>> importParties({
    required Uint8List fileBytes,
    required String fileName,
    ImportConfig? config,
  }) async {
    final importer = PartySheetImporter(config: config);
    return await importer.importParties(
      fileBytes: fileBytes,
      fileName: fileName,
    );
  }

  /// Get a summary of what columns will be matched for items
  ///
  /// Useful for showing a preview before actual import.
  /// Returns the field definitions that will be used for matching.
  Map<String, String> getItemFieldSummary() {
    return {
      'Name': 'Required - Item/Product name',
      'HSN Code': 'Optional - HSN/SAC code for GST',
      'Price': 'Optional - Default net price (aliases: Rate, Cost)',
      'GST Rate %': 'Optional - GST percentage (0, 5, 12, 18, 28)',
      'Quantity Unit': 'Optional - Unit of measurement (aliases: Qty Unit, UOM)',
      'Stock Qty': 'Optional - Current stock quantity',
      'Description': 'Optional - Item description/details',
    };
  }

  /// Get a summary of what columns will be matched for parties
  ///
  /// Useful for showing a preview before actual import.
  /// Returns the field definitions that will be used for matching.
  Map<String, String> getPartyFieldSummary() {
    return {
      'Business Name': 'Required - Company/Firm name',
      'Phone': 'Optional - Contact phone number',
      'Email': 'Optional - Email address',
      'GSTIN': 'Optional - GST identification number',
      'PAN': 'Optional - PAN card number',
      'State': 'Optional - State name',
      'District': 'Optional - District/City name',
      'Address': 'Optional - Full business address',
    };
  }
}
