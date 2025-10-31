# Sample Import Files

This directory contains sample CSV and Excel files for testing the Sheets Importer functionality.

## Files Overview

**Total:** 10 CSV files organized by test category

### Test Cases by Category

#### 1. Basic/Standard Tests (3 files)

**sample_items.csv** - ✅ Clean, well-formatted items
- **Rows:** 10 electronics items
- **Columns:** All 7 columns (Name, HSN, Price, GST%, Unit, Stock, Description)
- **Purpose:** Test perfect column matches (95-100% confidence)
- **Use case:** Baseline test, validate core functionality

**sample_items_with_typos.csv** - 🔤 Fuzzy matching test
- **Rows:** 10 stationery items
- **Columns:** All 7 columns with typos ("Product Nam", "Rate", "Tax %", "UOM", "Stocks")
- **Purpose:** Test fuzzy matching algorithm (70-95% confidence)
- **Use case:** Verify typo tolerance, alias matching

**sample_parties.csv** - 👥 Business contacts
- **Rows:** 10 businesses across India
- **Columns:** All 8 fields (Name, Phone, Email, GSTIN, PAN, State, District, Address)
- **Purpose:** Test party import with complete data
- **Use case:** Standard party import validation

---

#### 2. Edge Cases (4 files)

**sample_items_minimal.csv** - 🔹 Required fields only
- **Rows:** 5 items
- **Columns:** Name only (1 column)
- **Purpose:** Test default value assignment for optional fields
- **Use case:** Verify minimal data import succeeds
- **Expected:** All items imported with default values (qtyUnit="Nos", price=0.0, etc.)

**sample_items_missing_columns.csv** - 📊 Partial schema
- **Rows:** 8 office supplies
- **Columns:** Name, Price, GST Rate% (3 columns - missing HSN, Unit, Stock, Description)
- **Purpose:** Test import with some optional columns absent
- **Use case:** Verify partial import works, defaults applied
- **Expected:** All items imported, missing fields use defaults

**sample_items_special_chars.csv** - 🌐 Unicode & special characters
- **Rows:** 10 items
- **Columns:** All 7 columns
- **Purpose:** Test handling of emojis, Hindi/Tamil text, accented characters
- **Use case:** International data, multilingual support
- **Data includes:**
  - Emojis: "Laptop 💻"
  - Hindi: "नोटबुक हिंदी"
  - Tamil: "புத்தகம் தமிழ்"
  - Special chars: "()", "-", "₹"
  - Accented: "Café", "Naïve"

**sample_parties_edge_cases.csv** - ⚠️ Problematic party data
- **Rows:** 12 parties (8 valid, 4 with edge cases)
- **Columns:** All 8 fields
- **Purpose:** Test validation and error handling for party imports
- **Edge cases included:**
  - Missing optional fields (phone, email)
  - Invalid GSTIN format
  - Lowercase PAN (should be uppercase)
  - State name typo
  - International party (non-Indian address)
  - Very long business name (100+ chars)

---

#### 3. Data Quality (1 file)

**sample_items_mixed_quality.csv** - ⚡ Valid + Invalid rows
- **Rows:** 15 items (13 valid, 2 invalid)
- **Columns:** All 7 columns
- **Purpose:** Test error handling with mixed data quality
- **Use case:** Verify skipInvalidRows works, lenient validation
- **Invalid rows (rejected):**
  - Row 3: Empty name (required field missing)
  - Row 12: Missing name (empty string)
- **Data quality issues (accepted with defaults):**
  - Row 7: Text in price field ("not-a-number") → defaults to 0.0
  - Row 10: Negative GST rate (-5%) → accepted as-is
  - Row 15: Invalid HSN (special chars only: "@#$%") → accepted as-is
- **Expected:** 13 rows imported, 2 skipped with warnings (lenient validation)

---

#### 4. Performance Test (1 file)

**sample_items_large.csv** - 🚀 Large dataset
- **Rows:** 50 items
- **Columns:** All 7 columns
- **Purpose:** Test import performance with many rows
- **Use case:** Verify speed, memory usage, UI rendering
- **Data includes:** Electronics, furniture, stationery, office supplies
- **Expected performance:** <500ms import time

---

#### 5. Tax Testing (1 file)

**sample_items_all_gst_rates.csv** - 💰 All GST rates
- **Rows:** 10 items (2 per GST rate)
- **Columns:** All 7 columns
- **Purpose:** Test taxRatesConfig generation for all valid GST rates
- **Use case:** Verify GST% → taxRatesConfig conversion
- **GST rates covered:**
  - 0% - Books, Educational materials
  - 5% - Coffee, Tea
  - 12% - Frozen foods, Ayurvedic medicines
  - 18% - Electronics, Cosmetics
  - 28% - Luxury items, Automobiles

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

### Basic/Standard Tests
- **sample_items.csv**: All 7 columns match with 95-100% confidence, 10 items imported
- **sample_items_with_typos.csv**: All columns match with 70-95% confidence (fuzzy matching)
- **sample_parties.csv**: All 8 fields match with 95-100% confidence, 10 parties imported

### Edge Cases
- **sample_items_minimal.csv**: 1 column matched (name), 5 items with default values
- **sample_items_missing_columns.csv**: 3 columns matched, 8 items with partial data + defaults
- **sample_items_special_chars.csv**: All 7 columns matched, Unicode preserved correctly
- **sample_parties_edge_cases.csv**: 8 valid parties imported, 4 with warnings (not failures)

### Data Quality
- **sample_items_mixed_quality.csv**: 13 items imported, 2 skipped with warnings (lenient validation)

### Performance
- **sample_items_large.csv**: All 50 items imported in <500ms

### Tax Testing
- **sample_items_all_gst_rates.csv**: All 10 items with correct taxRatesConfig (0-28% GST)

## Testing Strategies by Category

### 1. Baseline Testing
**File:** `sample_items.csv`
**Config:** Strict (85% threshold)
**Expected:** All columns matched, 100% success rate
**Purpose:** Validate core functionality works

### 2. Fuzzy Matching Testing
**File:** `sample_items_with_typos.csv`
**Config:** Lenient (65% threshold)
**Expected:** All columns matched despite typos, 70-95% confidence
**Purpose:** Verify algorithm handles real-world messy data

### 3. Minimal Data Testing
**File:** `sample_items_minimal.csv`
**Config:** Default (70% threshold)
**Expected:** 5 items imported with defaults applied
**Purpose:** Test that only required fields are truly required

### 4. Partial Schema Testing
**File:** `sample_items_missing_columns.csv`
**Config:** Default
**Expected:** 8 items imported, missing columns use defaults
**Purpose:** Verify partial imports work gracefully

### 5. Unicode & Special Characters Testing
**File:** `sample_items_special_chars.csv`
**Config:** Default
**Expected:** All 10 items imported, special chars preserved
**Purpose:** Validate international/multilingual support

### 6. Data Quality Testing
**File:** `sample_items_mixed_quality.csv`
**Config:** `skipInvalidRows: true` (default)
**Expected:** 13 valid items imported, 2 warnings for rows with empty names
**Purpose:** Test error handling, lenient validation, and warning system
**Note:** Only empty required fields (name) cause rejection. Data quality issues (invalid numbers, special chars) are handled gracefully with defaults.

### 7. Performance Testing
**File:** `sample_items_large.csv`
**Config:** Default
**Expected:** 50 items imported in <500ms
**Purpose:** Benchmark performance with larger datasets

### 8. Tax Configuration Testing
**File:** `sample_items_all_gst_rates.csv`
**Config:** Default
**Expected:** All items with correct taxRatesConfig structure
**Purpose:** Verify GST rate conversion logic

### 9. Party Validation Testing
**File:** `sample_parties_edge_cases.csv`
**Config:** Default
**Expected:** 8 valid parties, 4 with data quality warnings
**Purpose:** Test party-specific validation rules

### 10. Comprehensive Workflow Test
**Files:** All 10 files in sequence
**Purpose:** Full regression testing
**Steps:**
1. Import all 10 files sequentially
2. Verify total imported: 5+8+10+10+10+50+8+10+10+12 = 133 items/parties
3. Check warnings displayed correctly
4. Verify UI responsive with all data sizes
5. Confirm no memory leaks or performance degradation
