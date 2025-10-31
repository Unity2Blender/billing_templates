# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

Flutter-based invoice PDF template library for generating professional invoices, bills, and receipts with support for GST compliance, multiple document types, and various business formats. The library generates PDFs entirely client-side using the `pdf` and `printing` packages.

**Key Features:**
- Client-side PDF generation (offline-first, no server dependency)
- 7 distinct invoice templates with varying layouts and styles
- GST-compliant invoice generation (CGST/SGST/IGST/CESS)
- Support for multiple invoice modes (Sales, Proforma, Estimate, Quotation, Credit Note, Debit Note, Delivery Challan, Purchase Order)
- Color theme support for select templates
- Comprehensive demo invoice data covering edge cases
- **NEW:** CSV/Excel sheets importer with fuzzy column matching (items & party contacts)

---

## Package Export Architecture

### Overview

This project is designed as a Flutter package that can be imported via Git URL in other Flutter/FlutterFlow applications. The architecture follows a clear separation of responsibilities:

**Your App's Responsibility:**
- Fetch all invoice data from Firestore (InvoiceStruct with nested structs)
- Fetch seller firm data from Firestore (FirmConfigStruct with nested structs)
- Handle user interactions and business logic
- Store and manage invoice documents

**This Package's Responsibility:**
- Convert FlutterFlow structs to internal models (via adapters)
- Generate PDF documents from invoice data
- Provide multiple professional templates
- Handle printing, sharing, and PDF export

### Public API

The package exposes a minimal, clean API through `lib/billing_templates.dart`:

```dart
import 'package:billing_templates/billing_templates.dart';

// Public exports:
// - InvoiceAdapter (for struct conversion)
// - PDFService (for PDF generation)
// - TemplateRegistry (for template selection)
// - InvoiceThemes (for color customization)
```

**What's NOT exported:**
- Internal models (InvoiceData, ItemSaleInfo, BusinessDetails, etc.)
- Template implementations (accessed via TemplateRegistry only)
- Demo data and UI screens
- Internal utilities and helpers

### Data Flow

```
FlutterFlow App (Firestore)
    ↓ (fetch complete data)
InvoiceStruct + FirmConfigStruct
    ↓ (pure conversion, no I/O)
InvoiceAdapter.fromFlutterFlowStruct()
    ↓
InvoiceData (internal model)
    ↓
PDFService.generatePDF()
    ↓ (template + theme)
PDF Bytes (Uint8List)
    ↓ (print/share/save)
User's device
```

### Adapter System

Adapters provide one-way conversion from FlutterFlow structs to internal models:

**Main Adapter:**
- `InvoiceAdapter` - Orchestrates conversion of complete invoice

**Sub-Adapters (used internally):**
- `BusinessAdapter` - Converts BusinessDetailsStruct
- `ItemAdapter` - Converts ItemSaleInfoStruct + ItemBasicInfoStruct
- `BillSummaryAdapter` - Converts BillSummaryResultsStruct
- `BankingAdapter` - Converts BankingDetailsStruct

**Key Characteristics:**
- Pure, synchronous functions (no async/await except for PDF generation)
- No Firestore interaction (no document fetching)
- DocumentReferences are ignored (treated as metadata)
- Null-safe with sensible defaults
- One-way conversion only (structs → models, not bidirectional)

**Detailed Documentation:**
See `lib/adapters/AdapterReadme.md` for comprehensive field mappings, usage examples, and integration patterns.

### DocumentReferences Handling

The FlutterFlow structs contain many DocumentReference fields for database relationships. The adapter system **ignores these completely**:

**Ignored References:**
- `invoice.invoiceRef` - Self-reference
- `invoice.sellerFirm` - Seller DocumentReference (you pass actual FirmConfigStruct instead)
- `invoice.referenceInvoiceRef` - Related invoice reference
- `firm.firmRef` - Firm self-reference
- `businessDetails.partyRef` - Party reference
- `item.itemRef` - Item reference
- `item.byFirms` - Array of firm references
- All `customFieldValues[].fieldRef` - Custom field schema references

**Why they're ignored:**
- PDF generation doesn't need database relationships
- All required data should already be denormalized in the structs
- Your app handles fetching and populating nested structs
- Keeps adapter logic simple and free of side effects

### Custom Fields Strategy

FlutterFlow structs include custom field support via `CustomFieldStruct` (see `references/structTypes/custom_field_struct.dart`):
- `fieldRef`: DocumentReference to field schema (ignored by adapters)
- `nameLabel`: Display name for the custom field
- `formWidgetType`: Input type (text, number, date, etc.)
- `defaultValueStr`: Default value
- `isBusiness`: `true` for business-level custom fields, `false` for item-level
- `partyRef`: Optional DocumentReference for party-specific fields

**Current State (v2.0+):**
- ✅ Custom field struct schema documented and implemented
- ✅ Custom fields **fully supported** in all templates
- ✅ Adapters extract and process custom field values
- ✅ Complete rendering logic implemented
- ✅ 12 comprehensive demo invoices for testing

**Implementation Details:**

1. **Item-Level Custom Fields** (`isBusiness: false`)
   - Rendered inline within item name column (below item name)
   - Examples: Warranty period, Color, Batch number, Serial number, HUID
   - Displayed as compact text: "Field1: Value1 • Field2: Value2"
   - Font size: 7-8pt, grey color for differentiation
   - All templates support item custom fields

2. **Business-Level Custom Fields** (`isBusiness: true`)
   - Rendered in "Additional Details" section after standard fields
   - Examples: Vendor code, Credit limit, IEC Code, ISO Certification
   - Displayed in bordered container for visual grouping
   - Format: "Field Name: Field Value" (one per line)
   - All templates support business custom fields

3. **Party-Specific Fields**
   - Different buyers can have different custom fields
   - Filtered by `partyRef` during adapter conversion
   - Only matching fields displayed for each party
   - Seller fields always use firm's fields (no party filtering)

**Field Types Supported:**
- **text** - Single-line string (e.g., "Warranty: 2 Years")
- **number** - Numeric with 2 decimal places (e.g., "Weight: 24.50")
- **date** - DD-MM-YYYY format (e.g., "Expiry: 31-12-2025")
- **boolean** - Yes/No display (e.g., "Certified: Yes")
- **select** - Single selection dropdown (e.g., "Color: Blue")
- **multiselect** - Comma-separated values (e.g., "Features: WiFi, Bluetooth, GPS")

**Backward Compatibility:**
- 100% backward compatible with existing invoices
- Empty `customFields` lists default to `[]`
- Templates conditionally render custom fields sections
- No breaking changes to public API

### Integration Pattern

**Recommended Integration Flow:**

1. **Setup (once):**
   ```dart
   // Add to pubspec.yaml
   dependencies:
     billing_templates:
       git:
         url: https://github.com/Unity2Blender/billing_templates.git
         ref: v1.0.0
   ```

2. **Fetch Data (your app):**
   ```dart
   // Fetch invoice with all nested data
   final invoiceDoc = await firestore.collection('invoices').doc(id).get();
   final invoice = InvoiceStruct.fromMap(invoiceDoc.data()!);

   // Fetch firm with all nested data
   final firmDoc = await firestore.collection('firms').doc(firmId).get();
   final firm = FirmConfigStruct.fromMap(firmDoc.data()!);
   ```

3. **Convert (adapter):**
   ```dart
   final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
     invoice: invoice,
     sellerFirm: firm,
   );
   ```

4. **Generate PDF (service):**
   ```dart
   await PDFService().printInvoice(
     invoice: invoiceData,
     templateId: 'mbbook_modern',
     colorTheme: InvoiceThemes.lightBlue,
   );
   ```

### Versioning Strategy

**Git Tags:**
- Use semantic versioning (v1.0.0, v1.1.0, v2.0.0)
- Breaking changes: Increment major version
- New features: Increment minor version
- Bug fixes: Increment patch version

**Dependency Specification:**
```yaml
# Production: Pin to specific version
billing_templates:
  git:
    url: https://github.com/Unity2Blender/billing_templates.git
    ref: v1.0.0

# Development: Use branch for latest
billing_templates:
  git:
    url: https://github.com/Unity2Blender/billing_templates.git
    ref: main
```

### Testing Strategy

**Package Testing:**
- Unit tests for adapters (struct → model conversion)
- Integration tests for PDF generation
- Visual regression tests for templates

**Consumer App Testing:**
- Fetch real invoice data from your Firestore
- Test adapter conversion with various invoice types
- Verify PDF output matches expectations
- Test across different templates and themes

### Error Handling

**Adapter Errors:**
- Null/missing fields → Default values (empty strings, 0.0)
- Invalid enum values → Fallback to defaults
- Malformed structs → May throw exceptions (validate before passing)

**PDF Generation Errors:**
- Template not found → Exception with list of valid IDs
- Font loading failure → Falls back to default PDF fonts
- Image loading failure (logo/signature) → Continues without image

**Recommendation:** Wrap adapter and PDF generation calls in try-catch blocks in your app.

### Migration Guide

If you have existing invoice generation code:

**Before (hypothetical old approach):**
```dart
// Old: Tightly coupled with Firestore
final pdf = await generateInvoicePDF(invoiceRef: docRef);
```

**After (with this package):**
```dart
// New: Separation of concerns
// 1. Your app: Fetch data
final invoice = await fetchInvoiceData(invoiceId);
final firm = await fetchFirmData(firmId);

// 2. Package: Convert & generate
final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
  invoice: invoice,
  sellerFirm: firm,
);
final pdf = await PDFService().generatePDF(
  invoice: invoiceData,
  templateId: selectedTemplate,
);
```

### Performance Considerations

**Adapter Conversion:**
- Synchronous, fast (typically <1ms)
- No I/O operations
- Safe to call in build methods if memoized

**PDF Generation:**
- Async, takes 100-500ms depending on complexity
- Font loading happens once (cached)
- Image loading from URLs can add latency
- Consider showing loading indicator

**Optimization Tips:**
- Cache converted InvoiceData if generating multiple times
- Pre-load fonts on app startup
- Use local image assets instead of URLs for logos

---

## Sheets Importer Module

**NEW in v2.1:** Import items/products and party contacts from CSV/Excel files with intelligent fuzzy column matching.

### Overview

The Sheets Importer provides a robust solution for bulk importing data from spreadsheets:
- **Fuzzy Column Matching** - Automatically matches column headers even with typos or variations
- **CSV & Excel Support** - Handles both .csv and .xlsx/.xls files
- **Configurable Thresholds** - Adjust matching confidence levels
- **Error Handling** - Skip invalid rows or fail fast
- **Type-Safe Output** - Returns structured data ready for Firestore upload

### Architecture

```
CSV/Excel File (Uint8List)
    ↓ (parse)
ParsedSheet (headers + rows)
    ↓ (fuzzy match)
ColumnMapping (field → column index)
    ↓ (extract & validate)
ImportedItemData[] / ImportedPartyData[]
    ↓ (your app)
Firestore Upload
```

### Public API

```dart
import 'package:billing_templates/billing_templates.dart';

final service = SheetsImporterService();

// Import items
final result = await service.importItems(
  fileBytes: csvBytes,
  fileName: 'products.csv',
);

// Import parties
final result = await service.importParties(
  fileBytes: excelBytes,
  fileName: 'customers.xlsx',
);
```

### Supported Fields

**Items/Products:**
- **Name*** (required) - Item/Product name
- **HSN Code** - HSN/SAC code for GST
- **Price** - Default net price (aliases: Rate, Cost, Amount)
- **GST Rate %** - GST percentage (0, 5, 12, 18, 28)
- **Quantity Unit** - Unit of measurement (aliases: Qty Unit, UOM)
- **Stock Qty** - Current stock quantity
- **Description** - Item description/details

**Party/Business Contacts:**
- **Business Name*** (required) - Company/Firm name
- **Phone** - Contact phone number
- **Email** - Email address
- **GSTIN** - GST identification number
- **PAN** - PAN card number
- **State** - State name
- **District** - District/City name
- **Address** - Full business address

### Fuzzy Matching Examples

The importer intelligently matches column variations:

| Sheet Column | Matched Field | Confidence |
|--------------|---------------|------------|
| "Product Nam" | name | 92% |
| "Rate" | defaultNetPrice | 85% |
| "Tax %" | gstRate | 88% |
| "UOM" | qtyUnit | 75% |
| "Company" | businessName | 90% |
| "Contact Number" | phone | 85% |

### Configuration Options

```dart
// Strict matching (high confidence only)
final result = await service.importItems(
  fileBytes: bytes,
  fileName: 'products.csv',
  config: ImportConfig.strict, // 85% minimum match score
);

// Lenient matching (accept lower confidence)
final result = await service.importItems(
  fileBytes: bytes,
  fileName: 'messy_data.csv',
  config: ImportConfig.lenient, // 60% minimum, skip invalid rows
);

// Custom configuration
final result = await service.importItems(
  fileBytes: bytes,
  fileName: 'products.csv',
  config: ImportConfig(
    minimumMatchScore: 75.0,
    skipInvalidRows: true,
    maxRows: 1000,
    trimWhitespace: true,
  ),
);
```

### Error Handling & Warnings

```dart
final result = await service.importItems(
  fileBytes: bytes,
  fileName: 'products.csv',
);

if (result.isSuccess) {
  print('✓ Imported ${result.data!.length} items');

  // Check for warnings
  if (result.hasWarnings) {
    for (final warning in result.warnings) {
      print('⚠ ${warning.message} at row ${warning.rowIndex}');
    }
  }

  // View column mappings
  result.columnMappings!.forEach((field, mapping) {
    print('${mapping.fieldName}: "${mapping.sheetColumnName}" '
          '(${mapping.confidenceScore.toStringAsFixed(1)}%)');
  });

} else {
  print('✗ Import failed: ${result.errorMessage}');
}
```

### Integration Pattern

**Step 1: Import from sheet**
```dart
final result = await SheetsImporterService().importItems(
  fileBytes: fileBytes,
  fileName: fileName,
);
```

**Step 2: Convert to Firestore-compatible maps**
```dart
final items = result.data!.map((item) => item.toMap()).toList();
```

**Step 3: Upload to Firestore (in your app)**
```dart
for (final itemMap in items) {
  await FirebaseFirestore.instance
    .collection('billing')
    .doc(firmId)
    .collection('items')
    .add(itemMap);
}
```

### Data Output Format

**ImportedItemData:**
```dart
{
  'name': 'Wireless Mouse',
  'hsnCode': '8471',
  'defaultNetPrice': 899.0,
  'qtyUnit': 'Nos',
  'description': 'Ergonomic wireless mouse',
  'taxRatesConfig': {
    'gstPercent': 18.0,
    'cessPercent': 0.0,
    'grossPercent': 18.0,
  },
  'importMetadata': {
    'stockQty': 45.0,
    'sourceRowIndex': 0,
  }
}
```

**ImportedPartyData:**
```dart
{
  'businessName': 'Tech Solutions Pvt Ltd',
  'phone': '9876543210',
  'email': 'contact@techsolutions.com',
  'gstin': '27AABCT1234F1Z5',
  'pan': 'AABCT1234F',
  'state': 'Maharashtra',
  'district': 'Mumbai',
  'businessAddress': '123 Park Street, Andheri West',
  'isCustomer': true,
  'isVendor': false,
  'customFieldValues': [],
  'importMetadata': {
    'sourceRowIndex': 0,
  }
}
```

### Sample Files

Sample CSV/XLSX files available in `examples/sample_imports/`:
- `sample_items.csv` - 10 electronics items (clean data)
- `sample_items_with_typos.csv` - 10 stationery items (fuzzy matching test)
- `sample_parties.csv` - 10 business contacts

See `examples/sample_imports/README.md` for detailed usage examples.

### Important Notes

**Firestore Upload:**
- The importer does NOT upload to Firestore automatically
- Your app is responsible for Firestore operations
- Use `.toMap()` to get Firestore-compatible data

**Data Validation:**
- Only required fields are validated (name for items, businessName for parties)
- Optional fields default to empty strings or 0.0
- Invalid rows can be skipped or cause import failure (configurable)

**Column Matching:**
- Each sheet column is matched at most once (greedy algorithm)
- Highest confidence matches are assigned first
- Missing optional columns are allowed (will use default values)
- Missing required columns cause import failure (unless `allowPartialImport: true`)

**Performance:**
- CSV parsing: ~1ms per 100 rows
- Excel parsing: ~5ms per 100 rows
- Fuzzy matching: ~10ms for 10 columns × 10 headers
- Total: 100-500ms for typical files (10-100 rows)

### Dependencies

The Sheets Importer uses:
- `csv: ^6.0.0` - CSV parsing
- `excel: ^4.0.3` - Excel file support
- `fuzzywuzzy: ^1.1.6` - Fuzzy string matching (Levenshtein distance)

---

## Development Commands

### Running the Application
```bash
# Run on Chrome (recommended for development/testing)
flutter run -d chrome --web-renderer html

# Run on mobile
flutter run

# Clean and rebuild
flutter clean && flutter pub get && flutter run
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Code Analysis
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format .
```

### Build Commands
```bash
# Build for web
flutter build web --web-renderer html

# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

---

## Architecture Overview

### Core Template System

The project uses an abstract `InvoiceTemplate` base class that all templates must implement:

**Location:** `lib/templates/invoice_template_base.dart`

Key methods:
- `Future<pw.Document> generatePDF()` - Generates the PDF document
- `Widget buildPreview()` - Flutter widget preview
- `Widget buildThumbnail()` - Template selection UI thumbnail

### Template Registry Pattern

**Location:** `lib/services/template_registry.dart`

Centralized registry for all templates using a Map-based lookup system:
```dart
static final Map<String, InvoiceTemplate> _templates = {
  'modern_elite': ModernEliteTemplate(),
  'mbbook_stylish': MBBookStylishTemplate(),
  // ... other templates
};
```

Access templates via `TemplateRegistry.getTemplate(id)` or `TemplateRegistry.getAllTemplates()`.

### Data Flow Architecture

```
InvoiceData (models/invoice_data.dart)
    ↓
Template Selection (services/template_registry.dart)
    ↓
PDF Generation (templates/*_template.dart)
    ↓
Preview/Download (screens/invoice_preview_screen.dart)
```

### Invoice Data Model

**Location:** `lib/models/invoice_data.dart`

Core data structure containing:
- Invoice metadata (number, mode, dates)
- Business details (seller/buyer)
- Line items with tax calculations
- Bill summary and payment info
- Optional banking details

**Important:** The model supports both intra-state (CGST+SGST) and inter-state (IGST) transactions via the `isIntraState` computed property.

---

## Template Schemas

The codebase implements 3 distinct template schema categories:

### 1. Tally Schema
Templates: `MBBookTallyTemplate`, `TallyProfessionalTemplate`

**Characteristics:**
- Traditional GST-compliant layout
- Detailed tax breakdowns (separate CGST/SGST/IGST columns)
- Two-column notes/terms layout
- Comprehensive business details
- Best for: B2B invoices, formal documentation

**GST Summary by HSN:**
Both Tally templates include a dedicated GST summary table grouped by HSN code, showing:
- HSN/SAC codes
- Taxable amounts per HSN
- Tax rates and amounts
- Total GST collected

This is a unique feature of Tally templates for GST compliance reporting.

### 2. Modern Schema
Templates: `ModernEliteTemplate`, `MBBookStylishTemplate`, `MBBookModernTemplate`

**Characteristics:**
- Clean, minimalist design
- Color theme support (7 pre-defined themes)
- Single tax column (GST%)
- Simplified footer with combined notes/terms
- Best for: Modern businesses, service providers

**Color Themes:**
Modern templates support theme customization via `InvoiceThemes.all`:
- Default, Light Blue, Green, Purple, Orange, Red, Teal
- Each theme defines `primaryColor`, `secondaryColor`, `accentColor`
- Color theme selection available in preview screen (removed from home screen dialog)

### 3. Compact/Thermal Schema
Templates: `A5CompactTemplate`, `ThermalTheme2Template`

**Characteristics:**
- Space-optimized layout (A5 or thermal printer width)
- Minimal borders and padding
- Essential information only
- Best for: Retail, POS systems, quick bills

---

## Demo Invoice System

**Location:** `lib/data/demo_invoices.dart` (2400+ lines)

Comprehensive demo data covering:

### Invoice Categories
1. **Basic Demos** - Simple retail and service invoices
2. **GST Testing** - Multi-rate GST, CESS, export, intra/inter-state scenarios
3. **Document Types** - Estimates, Purchase Orders, Credit/Debit Notes, Delivery Challans
4. **Thermal/POS** - Restaurant bills, grocery receipts
5. **Edge Cases** - Stress tests (15+ items), partial payments, minimal data
6. **Notes & Terms Testing** - 12 dedicated test invoices for validating notes/terms layouts across all schema types
7. **Custom Fields Testing** - 12 comprehensive demos covering all field types and use cases

Access via: `DemoInvoices.getAllSamples()` or specific methods like `DemoInvoices.getSampleInvoice3()`

### Demo Metadata System

**Location:** `lib/models/demo_invoice_metadata.dart`, `lib/utils/demo_helpers.dart`

Enhanced demo invoice organization with:
- Categorization (7 categories: Basic, GST Testing, Document Types, Thermal/POS, Edge Cases, Notes & Terms, Custom Fields)
- Template recommendations per invoice type
- Quick info labels for UI display
- Helper methods for filtering and grouping
- 12 custom fields demos covering all field types and edge cases

---

## UI Navigation Flow

```
HomeScreen (screens/home_screen.dart)
  ├─ Demo Invoice Selector (categorized, responsive)
  └─ Template Grid (1-4 columns based on screen size)
      └─ Template Card (with screenshot preview)
          └─ [Tap] → InvoicePreviewScreen
              ├─ PDF Preview Widget
              ├─ Color Theme Selector (palette icon, if supported)
              ├─ Download Button
              ├─ Print Button
              └─ Share Button
```

**Responsive Design:**
- Mobile (<600px): 1 column, dropdown selector
- Tablet (600-1200px): 2 columns, expansion tile selector
- Desktop (>1200px): 4 columns, expansion tile selector

---

## GST Tax Calculation Logic

### Intra-State vs Inter-State

```dart
// In InvoiceData model
bool get isIntraState =>
  sellerDetails.state.isNotEmpty &&
  buyerDetails.state.isNotEmpty &&
  sellerDetails.state == buyerDetails.state;
```

**Intra-State:** Same state → CGST + SGST (split equally)
**Inter-State:** Different states → IGST only

### Line Item Tax Fields

In `ItemSaleInfo` (models/item_sale_info.dart):
- `taxableValue` - Base amount after discount
- `csgst` - Combined SGST+CGST for intra-state (or SGST alone in some contexts)
- `igst` - IGST for inter-state
- `cessAmt` - Compensation cess (luxury goods, vehicles)
- `grossTaxCharged` - Total tax rate (%)
- `lineTotal` - Final amount including all taxes

---

## Template Recommendations

**Location:** `lib/utils/demo_helpers.dart:isTemplateRecommended()`

Logic for recommending templates based on invoice characteristics:

- **A5 Compact** → Retail bills, walk-in customers, low item count
- **Tally Templates** → B2B, high-value invoices, detailed tax reporting
- **Modern Templates** → Service invoices, proformas, modern businesses
- **Thermal** → Restaurant/POS, high item count (compact layout)

---

## PDF Generation Pipeline

### Font Loading
Custom fonts must be loaded before PDF generation. The codebase expects Helvetica fonts but uses default PDF fonts if not available.

**Note:** Font loading is handled per-template. Check individual template implementations for font setup.

### PDF Page Format
- Default: A4 (PdfPageFormat.a4)
- A5 template: A5 format
- Thermal: Custom width (typically 80mm)

### Common PDF Building Patterns

**Table Structure:**
```dart
pw.Table(
  border: pw.TableBorder.all(),
  children: [
    pw.TableRow(children: [...]), // Header
    ...items.map((item) => pw.TableRow(children: [...])),
  ],
)
```

**Multi-page Support:**
Use `pw.MultiPage` for invoices that may span multiple pages (automatically handles headers/footers).

---

## Important File Locations

### Models
- `lib/models/invoice_data.dart` - Main invoice data structure
- `lib/models/invoice_enums.dart` - InvoiceMode, PaymentMode enums (with "Inv" suffix)
- `lib/models/business_details.dart` - Business/customer information with custom fields
- `lib/models/item_sale_info.dart` - Line item with tax calculations and custom fields
- `lib/models/bill_summary.dart` - Invoice totals and summary (totalTaxableValue, totalGst, etc.)
- `lib/models/custom_field_value.dart` - Custom field value model with type-specific formatting

### Adapters
- `lib/adapters/invoice_adapter.dart` - Main orchestrator for invoice conversion
- `lib/adapters/business_adapter.dart` - Business/party details conversion
- `lib/adapters/item_adapter.dart` - Line item conversion with tax handling
- `lib/adapters/bill_summary_adapter.dart` - Invoice totals conversion
- `lib/adapters/banking_adapter.dart` - Banking details conversion
- `lib/adapters/AdapterReadme.md` - Comprehensive adapter documentation

### Templates
All templates in `lib/templates/`:
- `invoice_template_base.dart` - Abstract base class
- `mbbook_tally_template.dart` - Traditional GST template with HSN summary
- `tally_professional_template.dart` - Professional Tally variant
- `mbbook_modern_template.dart` - Modern minimalist
- `mbbook_stylish_template.dart` - Stylish with color themes
- `modern_elite_template.dart` - Premium modern design
- `a5_compact_template.dart` - A5 format for retail
- `thermal_theme2_template.dart` - Thermal printer format

### Utilities
- `lib/utils/currency_formatter.dart` - Indian currency formatting (₹)
- `lib/utils/invoice_colors.dart` - Color theme definitions
- `lib/utils/pdf_font_helpers.dart` - PDF font loading utilities
- `lib/utils/demo_helpers.dart` - Demo invoice organization and filtering

### Services
- `lib/services/template_registry.dart` - Template lookup and management
- `lib/services/pdf_service.dart` - PDF generation and export utilities
- `lib/services/sheets_importer_service.dart` - Public API for CSV/Excel import

### Importers (Sheets Importer Module)
- `lib/importers/column_matcher.dart` - Fuzzy column matching logic
- `lib/importers/sheet_parser.dart` - CSV/Excel file parsing
- `lib/importers/item_sheet_importer.dart` - Item/product import logic
- `lib/importers/party_sheet_importer.dart` - Party/contact import logic
- `lib/models/import_result.dart` - Import result wrapper and metadata
- `lib/models/import_config.dart` - Import configuration options
- `lib/models/column_mapping.dart` - Column mapping metadata

### Screens
- `lib/screens/home_screen.dart` - Main template gallery (620 lines, responsive)
- `lib/screens/invoice_preview_screen.dart` - PDF preview with actions

### Reference Documentation
- `references/README/Flutter Inv Gen.md` - Comprehensive implementation guide (2100+ lines)
- `references/README/Testing.md` - Testing workflow for Chrome preview (1200+ lines)
- `references/templateScreenshots/` - Template preview images
- `references/structTypes/custom_field_struct.dart` - FlutterFlow CustomFieldStruct definition

### Planning & Roadmap
- `TODO-CustomFields.md` - Custom fields implementation plan (Phases 1-3 complete, Phase 4 pending)

### Sample Data
- `examples/sample_imports/sample_items.csv` - Sample items for import testing
- `examples/sample_imports/sample_items_with_typos.csv` - Fuzzy matching test data
- `examples/sample_imports/sample_parties.csv` - Sample party contacts
- `examples/sample_imports/README.md` - Import usage examples and documentation

---

## Common Development Tasks

### Adding a New Template

1. Create new template file in `lib/templates/` extending `InvoiceTemplate`
2. Implement required methods: `generatePDF()`, `buildPreview()`, `buildThumbnail()`
3. Define template metadata: `id`, `name`, `description`, `screenshotPath`
4. Add to `TemplateRegistry._templates` map
5. Add screenshot to `references/templateScreenshots/`
6. Test with various demo invoices

### Adding a New Demo Invoice

1. Add static method in `DemoInvoices` class (lib/data/demo_invoices.dart)
2. Create `DemoInvoiceMetadata` entry in `lib/models/demo_invoice_metadata.dart`
3. Register in `DemoHelpers.getAllDemoMetadata()` (lib/utils/demo_helpers.dart)
4. Assign to appropriate `DemoCategory`
5. Test across all templates

### Modifying Tax Calculations

Tax logic is distributed:
- **Demo Data:** Pre-calculated in `demo_invoices.dart`
- **Templates:** Display logic only (read from `ItemSaleInfo` and `BillSummary`)

To modify tax calculations, update the demo invoice generation methods to recalculate:
- `taxableValue` = subtotal - discount
- GST = taxableValue × (rate / 100)
- `lineTotal` = taxableValue + GST + CESS

### Adding Color Themes

1. Define new theme in `InvoiceThemes` class (lib/utils/invoice_colors.dart)
2. Add to `InvoiceThemes.all` list
3. Theme-supporting templates will automatically pick it up

---

## Testing Strategy

### Visual Testing
Run on Chrome for rapid visual feedback:
```bash
flutter run -d chrome --web-renderer html
```

Navigate through:
1. All demo invoice categories
2. Each template with various invoice types
3. Color theme variations (Modern templates)
4. Edge cases (many items, minimal data, long text)

### Specific Test Cases

**GST Compliance:**
- `DemoInvoices.getIntraStateDetailed()` - CGST+SGST
- `DemoInvoices.getInterStateIgst()` - IGST only
- `DemoInvoices.getCessHeavyGoods()` - CESS on luxury items
- `DemoInvoices.getMultiGstRatesInvoice()` - Multiple GST rates (5%, 12%, 18%, 28%)

**Layout Stress Tests:**
- `DemoInvoices.getStressTestManyItems()` - 15 items with long names/descriptions
- `DemoInvoices.getPartialPaymentScenario()` - Balance due calculations
- `DemoInvoices.getMinimalDataInvoice()` - Sparse data handling

**Notes & Terms Testing:**
- `DemoInvoices.getTallySchemaWithBoth()` - Both notes and terms
- `DemoInvoices.getModernSchemaWithNotes()` - Notes only
- `DemoInvoices.getA5ThermalSchemaWithTerms()` - Terms only in compact layout

### Unit Tests
Currently minimal. Widget tests exist in `test/widget_test.dart` but need expansion.

**Recommended test coverage:**
- Currency formatting (`currency_formatter.dart`)
- Template registry lookup
- Demo invoice data validation
- PDF generation (snapshot testing)

---

## Known Constraints & Conventions

### Currency Format
All amounts use Indian currency formatting:
- Symbol: ₹ (Rupee)
- Format: ₹1,23,456.78 (Indian numbering with lakhs/crores)

### HSN/SAC Codes
HSN (Harmonized System of Nomenclature) codes are product classification codes used for GST. Templates display these in item tables when available.

### Date Formatting
No standardized date formatting utility. Templates use various formats:
- Tally: DD-MM-YYYY
- Modern: MMM DD, YYYY
- Consider creating a shared utility if consistency is needed

### State Names
Full state names used (not codes). GST state codes (01-37) are not currently handled but may be needed for formal compliance.

### PDF Font Handling
Templates assume fonts are available but should gracefully handle font loading failures. Default PDF fonts (Helvetica) work without external font files.

---

## Gotchas & Pitfalls

### Template ID Case Sensitivity
Template IDs in `TemplateRegistry` are lowercase with underscores (e.g., `mbbook_tally`). UI display names use proper casing. Keep these distinct.

### InvoiceData Immutability
`InvoiceData` and related models don't have copyWith methods. To modify, create new instances. Consider adding copyWith for better ergonomics.

### CGST Field Handling
In `ItemSaleInfo`, the `csgst` field represents:
- Combined CGST+SGST amount for intra-state transactions
- Value is 0 for inter-state transactions (where `igst` is used instead)
- Templates that need separate CGST/SGST display split the value equally (csgst/2 each)
- Your app should pre-calculate the combined amount before passing to adapters

**Important:** The adapter does NOT split CGST/SGST - it passes through the combined value. Templates handle display splitting if needed.

### Footer Element Handling (Notes, Terms, Signatures)

**Critical:** Templates must carefully handle THREE distinct footer elements:
1. **Notes** (`invoice.notesFooter` - String)
2. **Terms & Conditions** (`invoice.paymentTerms` - List<String>)
3. **Signature Section** (static, seller business name)

**Requirements:**
- Templates MUST check BOTH `notesFooter` and `paymentTerms` fields
- Support all 4 scenarios: both/notes-only/terms-only/neither
- Never confuse labels (don't label `notesFooter` as "Terms & Conditions")
- Maintain proper spacing between sections when both are present

**Schema-Specific Patterns:**

**Tally Schema** (mbbook_tally, tally_professional):
- Two-column footer: Left = Notes/Terms, Right = Signature
- Stack notes and terms vertically if both present
- Show bullet points for payment terms list items

**Modern Schema** (mbbook_stylish, modern_elite, mbbook_modern):
- Single-column approach on left side
- Styled container with both sections combined
- Right side: Pricing summary + signature

**Compact/Thermal Schema** (a5_compact, thermal_theme2):
- Space-constrained layout
- Compact vertical stacking of all elements
- Minimal padding and smaller fonts

**Testing:**
Use the 12 dedicated test invoices in `DemoInvoices.getNotesAndTermsTestingInvoices()`:
- 4 Tally schema tests (notes/terms/both/neither)
- 4 Modern schema tests
- 4 A5/Thermal schema tests

**Common Mistakes:**
- ❌ Only checking `notesFooter`, ignoring `paymentTerms`
- ❌ Showing placeholder text when terms are populated
- ❌ Labeling notes as "Terms & Conditions"
- ❌ Not handling the "both present" scenario
- ✅ Always check both fields with proper conditional logic

### Screenshot Paths
Template screenshots must exist in `references/templateScreenshots/` and match the filename pattern in `screenshotPath`. Missing screenshots show a placeholder icon.

### Color Theme Applicability
Not all templates support color themes. Check `supportsColorThemes` property before showing theme selector. Currently only Modern templates support themes.

### Responsive Grid Column Count
`HomeScreen` calculates columns based on screen width:
- Mobile: 1 column
- Tablet: 2 columns
- Desktop: 4 columns

If templates are added/removed, adjust `childAspectRatio` for optimal card proportions.

### Demo Invoice Category Assignment
Each demo must be assigned to exactly one `DemoCategory`. The category determines where it appears in the UI and which templates are recommended.

---

## Git Workflow

### Automatic Commit & Push Rule

**IMPORTANT:** After successfully implementing a plan or completing a significant task, you MUST:
1. Stage all relevant changes with `git add`
2. Create a concise commit message following conventional commits format
3. Push changes to remote with `git push`

This ensures work is never lost and maintains a clear commit history.

### When Committing Changes

**Template Changes:**
1. Ensure corresponding screenshots are updated in `references/templateScreenshots/`
2. Update `TemplateRegistry` mappings if template IDs change
3. Test with all demo invoices (especially edge cases)
4. Verify backward compatibility if templates are removed/renamed

**Adapter Changes:**
1. Update corresponding internal models if fields change
2. Update field mapping documentation in adapter files and `AdapterReadme.md`
3. Run unit tests if available (or add new tests)
4. Update CLAUDE.md if public API changes

**Model Changes:**
1. Update all affected adapters
2. Update all templates that use the changed models
3. Update demo invoice data if field structure changes
4. Run comprehensive testing across all templates

### Commit Message Format
Follow conventional commits format:
- `feat:` - New features
- `fix:` - Bug fixes
- `refactor:` - Code refactoring
- `docs:` - Documentation updates
- `test:` - Test updates
- `chore:` - Build/tooling changes

---

## External Dependencies

**Core PDF Generation:**
- `pdf: ^3.11.1` - PDF document creation
- `printing: ^5.13.2` - PDF preview, print, share functionality

**File Handling:**
- `path_provider: ^2.1.4` - Device storage access

**Utilities:**
- `intl: ^0.19.0` - Internationalization (date/number formatting)
- `http: ^1.2.2` - Network requests (for logo/signature loading)
- `google_fonts: ^6.2.1` - Optional custom fonts

**Development:**
- `flutter_lints: ^5.0.0` - Linting rules

No backend dependencies - fully client-side operation.

---

## Performance Considerations

### PDF Generation Speed
- Simple invoices: <100ms
- Complex invoices (15+ items): 200-500ms
- Thermal templates: Fastest (minimal layout)
- Tally templates: Slowest (GST summary tables)

### Image Loading
Logo and signature images loaded from URLs can slow rendering. Consider:
- Caching images locally
- Compressing images before embedding
- Using placeholders for missing images

### Large Item Counts
Templates handle pagination differently:
- `pw.MultiPage` - Automatic pagination
- `pw.Page` - Single page (items may overflow)

Test with `DemoInvoices.getStressTestManyItems()` (15 items) to verify multi-page handling.

---

## Recent Changes (v1.0)

### Adapter Refinements
- **BillSummary fields** aligned with FlutterFlow struct naming:
  - `subtotal` → `totalTaxableValue`
  - `totalTax` → `totalGst`
  - `grandTotal` → `totalLineItemsAfterTaxes`
  - `balance` → `dueBalancePayable`
  - Removed `roundOff` field (not in source struct)

- **InvoiceMode enum** updated with "Inv" suffix for all values:
  - `sales` → `salesInv`, `proforma` → `proformaInv`, etc.

### UX Improvements
- Color theme selection moved from home screen to preview screen
- Default color theme changed to `lightBlue`
- Simplified template preview flow (direct navigation)

### Documentation
- Added comprehensive `lib/adapters/AdapterReadme.md`
- Updated CLAUDE.md with latest field mappings
- Removed outdated README.md (replaced by CLAUDE.md)

---

## Recent Enhancements (v2.0+)

### Custom Fields Support - ✅ IMPLEMENTED

**Status:** Fully implemented and tested (Phases 1-3 complete, Phase 4 visual testing pending)

**Features Delivered:**
- ✅ Item-level custom fields rendered inline within item name column
- ✅ Business-level custom fields in "Additional Details" section
- ✅ Party-specific custom fields (different fields per customer)
- ✅ Inline rendering strategy optimized for all templates
- ✅ Support for 6 field types: text, number, date, boolean, select, multi-select
- ✅ Type-specific formatting (dates as DD-MM-YYYY, booleans as Yes/No, etc.)
- ✅ 12 comprehensive demo invoices for testing all scenarios
- ✅ 100% backward compatible with existing invoices
- ⏳ Visual regression testing pending (Phase 4)

**Demo Invoices Available:**
1. Basic item fields (1-2 fields, simple use case)
2. Multiple item fields (5 fields, all types - jewellery)
3. Mixed items (some with/without custom fields - pharma)
4. Edge case (long names, Unicode, special chars)
5. Seller business fields only (export business)
6. Buyer business fields only (B2B customer)
7. Both seller & buyer fields
8. All 6 field types showcase
9. Combined item + business fields
10. Fields with notes + terms (layout conflict test)
11. A5/Thermal stress test (space-constrained)
12. Zero custom fields (backward compatibility)

**Technical Implementation:**
- Model: `lib/models/custom_field_value.dart`
- Adapters: `ItemAdapter`, `BusinessAdapter` with field extraction
- Templates: All 7 templates support both item and business custom fields
- Demo Data: `lib/data/demo_invoices.dart` (12 new methods)
- Metadata: `lib/utils/demo_helpers.dart` (DemoCategory.customFieldsTesting)

See `lib/adapters/AdapterReadme.md` for complete custom fields documentation.

## Future Enhancement Ideas

### Potential v3.0 Features

Based on reference documentation analysis:

1. **Cloud Generation Fallback** - Hybrid approach for complex templates
2. **Template Marketplace** - User-uploadable custom templates
3. **Interactive PDF Forms** - Editable fields in generated PDFs
4. **Email Delivery Integration** - Direct invoice sending
5. **Multi-language Support** - i18n for invoice text
6. **QR Code Generation** - Payment QR codes in footer
7. **Digital Signatures** - Cryptographic invoice signing
8. **Batch Generation** - Multiple invoices in single operation
9. **Template Preview Caching** - Pre-generate thumbnails for faster gallery loading
10. **Custom Font Support** - User-uploadable brand fonts
11. **Adapter Unit Tests** - Comprehensive test coverage for all adapters

Refer to `references/README/Flutter Inv Gen.md` sections on "Comparison with Cloud Generation" and "Hybrid Approach" for architectural guidance.
