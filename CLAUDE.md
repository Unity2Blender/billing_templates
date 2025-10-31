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

FlutterFlow structs include `customFieldValues` lists that contain:
- `fieldRef`: DocumentReference to field schema (ignored)
- Field values (could be rendered in future template versions)

**Current Handling:**
- Custom field refs are ignored
- Custom field values are not rendered in standard templates
- Future templates may add support for rendering custom field values

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
     colorTheme: InvoiceThemes.blue,
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
- Default, Blue, Green, Purple, Orange, Red, Teal
- Each theme defines `primaryColor`, `secondaryColor`, `accentColor`

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

Access via: `DemoInvoices.getAllSamples()` or specific methods like `DemoInvoices.getSampleInvoice3()`

### Demo Metadata System

**Location:** `lib/models/demo_invoice_metadata.dart`, `lib/utils/demo_helpers.dart`

Enhanced demo invoice organization with:
- Categorization (6 categories: Basic, GST Testing, Document Types, Thermal/POS, Edge Cases, Notes & Terms)
- Template recommendations per invoice type
- Quick info labels for UI display
- Helper methods for filtering and grouping

---

## UI Navigation Flow

```
HomeScreen (screens/home_screen.dart)
  ├─ Demo Invoice Selector (categorized, responsive)
  └─ Template Grid (1-4 columns based on screen size)
      └─ Template Card (with screenshot preview)
          └─ [Tap] → Color Theme Dialog (if supported)
              └─ InvoicePreviewScreen
                  ├─ PDF Preview Widget
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
- `lib/models/invoice_enums.dart` - InvoiceMode, PaymentMode enums
- `lib/models/business_details.dart` - Business/customer information
- `lib/models/item_sale_info.dart` - Line item with tax calculations
- `lib/models/bill_summary.dart` - Invoice totals and summary

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

### Screens
- `lib/screens/home_screen.dart` - Main template gallery (620 lines, responsive)
- `lib/screens/invoice_preview_screen.dart` - PDF preview with actions

### Reference Documentation
- `references/README/Flutter Inv Gen.md` - Comprehensive implementation guide (2100+ lines)
- `references/README/Testing.md` - Testing workflow for Chrome preview (1200+ lines)
- `references/templateScreenshots/` - Template preview images

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

### CGST Field Overloading
In `ItemSaleInfo`, the `csgst` field represents:
- Combined CGST+SGST for intra-state transactions in some templates
- Just CGST in others (with separate `sgst` field implied)

This inconsistency exists across demo data. When adding new templates, verify the expected tax field interpretation.

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

## Git Workflow Notes

Current git status shows:
- Modified template files (switched from default to stylish/modern variants)
- Deleted `mbbook_default_template.dart` (replaced by newer templates)
- New `mbbook_stylish_template.dart` added
- Screenshot updates in progress

When committing template changes:
1. Ensure corresponding screenshots are updated
2. Update `TemplateRegistry` mappings
3. Test with all demo invoices
4. Verify backward compatibility if templates are removed

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

## Future Enhancement Ideas

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

Refer to `references/README/Flutter Inv Gen.md` sections on "Comparison with Cloud Generation" and "Hybrid Approach" for architectural guidance.
