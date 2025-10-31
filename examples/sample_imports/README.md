# Sample Import Files

This directory contains sample CSV and Excel files for testing the Sheets Importer functionality.

## Files

### Items/Products Import

1. **sample_items.csv** - Clean, well-formatted items
   - Contains 10 electronics items
   - All columns properly named and formatted
   - Good for testing perfect matches

2. **sample_items_with_typos.csv** - Items with typos in column headers
   - Contains 10 stationery items
   - Column names have typos: "Product Nam", "Rate", "Tax %", "UOM", "Stocks"
   - Good for testing fuzzy matching capabilities

### Party/Contact Import

1. **sample_parties.csv** - Business contacts
   - Contains 10 sample businesses
   - All standard fields included
   - Various states and cities across India

## Usage Examples

### Importing Items

```dart
import 'package:billing_templates/billing_templates.dart';
import 'dart:io';

Future<void> importItemsExample() async {
  // Read the CSV file
  final file = File('examples/sample_imports/sample_items.csv');
  final fileBytes = await file.readAsBytes();

  // Import using the service
  final service = SheetsImporterService();
  final result = await service.importItems(
    fileBytes: fileBytes,
    fileName: 'sample_items.csv',
  );

  if (result.isSuccess) {
    print('✓ Successfully imported ${result.data!.length} items');

    // Show column mappings
    print('\nColumn Mappings:');
    result.columnMappings!.forEach((field, mapping) {
      print('  ${mapping.fieldName}: "${mapping.sheetColumnName}" '
            '(confidence: ${mapping.confidenceScore.toStringAsFixed(1)}%)');
    });

    // Display items
    print('\nImported Items:');
    for (final item in result.data!) {
      print('  - ${item.name} | ₹${item.defaultNetPrice} | GST: ${item.gstRate}%');
    }

    // Show warnings if any
    if (result.hasWarnings) {
      print('\nWarnings:');
      for (final warning in result.warnings) {
        print('  ⚠ $warning');
      }
    }
  } else {
    print('✗ Import failed: ${result.errorMessage}');
  }
}
```

### Testing Fuzzy Matching

```dart
Future<void> testFuzzyMatching() async {
  final file = File('examples/sample_imports/sample_items_with_typos.csv');
  final fileBytes = await file.readAsBytes();

  final service = SheetsImporterService();
  final result = await service.importItems(
    fileBytes: fileBytes,
    fileName: 'sample_items_with_typos.csv',
    config: ImportConfig(
      minimumMatchScore: 65.0, // More lenient for typos
    ),
  );

  if (result.isSuccess) {
    print('✓ Fuzzy matching succeeded!');
    print('Matched columns despite typos:');
    result.columnMappings!.forEach((field, mapping) {
      if (mapping.confidenceScore < 90) {
        print('  "${mapping.sheetColumnName}" → ${mapping.fieldName} '
              '(${mapping.confidenceScore.toStringAsFixed(1)}%)');
      }
    });
  }
}
```

### Importing Parties

```dart
Future<void> importPartiesExample() async {
  final file = File('examples/sample_imports/sample_parties.csv');
  final fileBytes = await file.readAsBytes();

  final service = SheetsImporterService();
  final result = await service.importParties(
    fileBytes: fileBytes,
    fileName: 'sample_parties.csv',
  );

  if (result.isSuccess) {
    print('✓ Successfully imported ${result.data!.length} parties');

    for (final party in result.data!) {
      print('  - ${party.businessName}');
      print('    Phone: ${party.phone}, Email: ${party.email}');
      print('    GSTIN: ${party.gstin}, State: ${party.state}');
    }
  }
}
```

## Field Mappings

### Items Schema

| Field Name | Required | Aliases |
|------------|----------|---------|
| Name | Yes | Item Name, Product Name, Item, Product |
| HSN Code | No | HSN, HSN/SAC, SAC Code |
| Price | No | Rate, Cost, Amount, Unit Price, Net Price |
| GST Rate % | No | GST, Tax Rate, GST%, Tax%, GST Percent |
| Quantity Unit | No | Qty Unit, Unit, UOM, Measure, Quantity |
| Stock Qty | No | Stock, Quantity, Stock Quantity, Inventory |
| Description | No | Details, Notes, Desc, Info |

### Parties Schema

| Field Name | Required | Aliases |
|------------|----------|---------|
| Business Name | Yes | Company, Firm Name, Party Name, Customer Name, Name |
| Phone | No | Mobile, Contact, Phone Number, Mobile Number |
| Email | No | Email Address, Email ID, Mail |
| GSTIN | No | GST Number, GST No, GSTIN Number, GST |
| PAN | No | PAN Number, PAN Card, PAN No |
| State | No | State Name, State/UT |
| District | No | City, District Name |
| Address | No | Business Address, Full Address, Location, Street |

## Expected Output

When using these sample files with default configuration:

- **sample_items.csv**: All columns should match with 95-100% confidence
- **sample_items_with_typos.csv**: All columns should match with 70-95% confidence (demonstrating fuzzy matching)
- **sample_parties.csv**: All columns should match with 95-100% confidence

## Testing Strategies

1. **Perfect Match Test**: Use `sample_items.csv` with strict config (85% threshold)
2. **Fuzzy Match Test**: Use `sample_items_with_typos.csv` with lenient config (65% threshold)
3. **Missing Columns Test**: Remove optional columns and verify partial import
4. **Invalid Data Test**: Modify values (e.g., text in price field) and check error handling
5. **Large File Test**: Duplicate rows 100 times and test performance
