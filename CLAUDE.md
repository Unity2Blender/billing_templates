# CLAUDE.md

Project guidance for Claude Code when working with this Flutter invoice PDF template library. Use /flutter-architect agent for architecture guidance.

---

## Project Overview

**Flutter-based invoice PDF template library** for professional invoices with GST compliance and offline-first PDF generation.

**Key Features:**
- 7 distinct invoice templates (Tally/Modern/Compact schemas)
- Client-side PDF generation (no server dependency)
- GST-compliant (CGST/SGST/IGST/CESS)
- Multiple invoice modes (Sales, Proforma, Estimate, Quotation, Credit/Debit Note, Delivery Challan, Purchase Order)
- Color theme support (Modern templates)
- CSV/Excel sheets importer with fuzzy column matching
- Custom fields support (item-level & business-level)

---

## Architecture

### Package Export (Git URL Import)

**Your App:** Fetch Firestore data (InvoiceStruct + FirmConfigStruct) → **This Package:** Convert structs to models → Generate PDF → Export/Print/Share

**Public API** (`lib/billing_templates.dart`):
- `InvoiceAdapter` - Struct conversion
- `PDFService` - PDF generation
- `TemplateRegistry` - Template selection
- `InvoiceThemes` - Color customization
- `SheetsImporterService` - CSV/Excel import

**Not Exported:** Internal models, template implementations, demo data, utilities

### Adapter System

**One-way conversion:** FlutterFlow structs → Internal models

| Adapter | Purpose |
|---------|---------|
| `InvoiceAdapter` | Main orchestrator |
| `BusinessAdapter` | BusinessDetailsStruct conversion |
| `ItemAdapter` | ItemSaleInfoStruct + ItemBasicInfoStruct |
| `BillSummaryAdapter` | BillSummaryResultsStruct |
| `BankingAdapter` | BankingDetailsStruct |

**Characteristics:**
- Pure synchronous functions (no Firestore I/O)
- DocumentReferences ignored (metadata only)
- Null-safe with defaults
- See `lib/adapters/AdapterReadme.md` for field mappings

### Template System

**Base Class:** `InvoiceTemplate` (lib/templates/invoice_template_base.dart)
- `generatePDF()` - PDF document generation
- `buildPreview()` - Flutter widget preview
- `buildThumbnail()` - Template selector UI

**Registry:** `TemplateRegistry` - Map-based template lookup
- `getTemplate(id)` - Get template instance
- `getAllTemplates()` - Get all template objects
- `getAllTemplateIds()` - Get all template IDs (alphabetically sorted)
- `hasTemplate(id)` - Check if template exists

**3 Schema Types:**

| Schema | Templates | Characteristics | Best For |
|--------|-----------|-----------------|----------|
| **Tally** | mbbook_tally, tally_professional | GST-compliant, detailed tax breakdowns, HSN summary | B2B, formal documentation |
| **Modern** | modern_elite, mbbook_stylish, mbbook_modern | Minimalist, color themes, single tax column | Modern businesses, services |
| **Compact** | a5_compact, thermal_theme2 | Space-optimized, minimal borders | Retail, POS, quick bills |

---

## Data Models

**Core Models** (lib/models/):
- `invoice_data.dart` - Main invoice structure, `isIntraState` computed property
- `invoice_enums.dart` - InvoiceMode, PaymentMode (with "Inv" suffix)
- `business_details.dart` - Business/customer info + custom fields
- `item_sale_info.dart` - Line items + tax calculations + custom fields
- `bill_summary.dart` - Invoice totals (`totalTaxableValue`, `totalGst`, `totalLineItemsAfterTaxes`, `dueBalancePayable`)
- `custom_field_value.dart` - Custom field with type-specific formatting

**GST Tax Logic:**
- **Intra-State:** Same state → CGST + SGST (split equally)
- **Inter-State:** Different states → IGST only
- `csgst` field = Combined CGST+SGST amount (templates split for display)

---

## Custom Fields (v2.0+) ✅ IMPLEMENTED

**Status:** 85% Complete (Core implementation done, visual testing pending)

**Quick Reference:**
- **Item-Level:** Inline below item name (7-8pt font, grey color)
- **Business-Level:** "Additional Details" bordered section
- **Supported Types:** text, number (2 decimals), date (DD-MM-YYYY), boolean (Yes/No), select, multiselect
- **Party-Specific:** Different buyers can have different custom fields (filtered by `partyRef`)
- **Testing:** 12 demo invoices in `DemoInvoices.getCustomFieldsTestingInvoices()`

**Full Documentation:**
- **Implementation Status:** `READMEs/Custom fields support/CUSTOM_FIELDS_STATUS.md`
- **Developer Guide:** `READMEs/Custom fields support/IMPLEMENTATION_GUIDE_CustomFields.md`
- **Complete Specification:** `READMEs/Custom fields support/TODO-CustomFields.md`

---

## Sheets Importer (v2.1+) ✅ IMPLEMENTED

Import items/products and party contacts from CSV/Excel with fuzzy column matching.

**Quick Start:**
```dart
import 'package:billing_templates/billing_templates.dart';

final service = SheetsImporterService();
final result = await service.importItems(
  fileBytes: csvBytes,
  fileName: 'products.csv',
  config: ImportConfig.standard, // or .strict, .lenient
);
```

**Key Features:**
- **Fuzzy Matching:** Handles typos (e.g., "Product Nam" → name 92%, "UOM" → qtyUnit 75%)
- **Dual Import:** Items (Name*, HSN, Price, GST%, Qty Unit, Stock, Desc) | Parties (Name*, Phone, Email, GSTIN, PAN, State, District, Address)
- **Output:** `ImportedItemData[]` / `ImportedPartyData[]` with `.toMap()` for Firestore upload

### CSV Injection Security (v2.2+) ✅

**OWASP-Compliant Protection** against formula injection (`=`, `+`, `-`, `@`, `|`, tab, CR). Sanitization is **enabled by default** (recommended). Opt-out with `ImportConfig(sanitizeInput: false)` for trusted sources only.

**Warnings:** Sanitized cells generate `ImportWarningType.sanitizedFormulaInjection` warnings.

**Full Documentation:**
- **Implementation Guide:** `READMEs/XLSX importer/Importer-STATUS.md`
- **Sample Files:** `examples/sample_imports/README.md`
- **Security Details:** `examples/sample_imports/README_SECURITY.md`
- **Testing:** `test/security/csv_injection_test.dart`

---

## Integration Pattern

**1. Setup (pubspec.yaml):**
```yaml
billing_templates:
  git:
    url: https://github.com/Unity2Blender/billing_templates.git
    ref: v1.0.0  # or 'main' for latest
```

**2. Fetch Data (your app):**
```dart
final invoice = InvoiceStruct.fromMap(await firestore.collection('invoices').doc(id).get().data()!);
final firm = FirmConfigStruct.fromMap(await firestore.collection('firms').doc(firmId).get().data()!);
```

**3. Convert:**
```dart
final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
  invoice: invoice,
  sellerFirm: firm,
);
```

**4. Generate PDF:**
```dart
await PDFService().printInvoice(
  invoice: invoiceData,
  templateId: 'mbbook_modern',
  colorTheme: InvoiceThemes.lightBlue,
);
```

---

## Demo Invoices

**Location:** `lib/data/demo_invoices.dart` (2400+ lines)

**Categories:**
1. Basic Demos
2. GST Testing (multi-rate, CESS, intra/inter-state)
3. Document Types (Estimates, POs, Credit/Debit Notes)
4. Thermal/POS
5. Edge Cases (15+ items, minimal data)
6. Notes & Terms Testing (12 invoices)
7. Custom Fields Testing (12 invoices)

**Access:** `DemoInvoices.getAllSamples()` or `DemoInvoices.getSampleInvoice3()`

**Metadata:** `DemoHelpers.getAllDemoMetadata()` - categorization, template recommendations

---

## Development Commands

```bash
# Run on Chrome (recommended)
flutter run -d chrome --web-renderer html

# Test
flutter test
flutter test --coverage

# Analyze
flutter analyze
dart format .

# Build
flutter build web --web-renderer html
flutter build apk
flutter build ios
```

---

## File Reference

### Models
| File | Purpose |
|------|---------|
| `lib/models/invoice_data.dart` | Main invoice structure |
| `lib/models/invoice_enums.dart` | InvoiceMode, PaymentMode enums |
| `lib/models/business_details.dart` | Business info + custom fields |
| `lib/models/item_sale_info.dart` | Line items + tax + custom fields |
| `lib/models/bill_summary.dart` | Invoice totals |
| `lib/models/custom_field_value.dart` | Custom field values |

### Adapters
| File | Purpose |
|------|---------|
| `lib/adapters/invoice_adapter.dart` | Main orchestrator |
| `lib/adapters/business_adapter.dart` | Business details conversion |
| `lib/adapters/item_adapter.dart` | Item conversion + tax |
| `lib/adapters/bill_summary_adapter.dart` | Totals conversion |
| `lib/adapters/banking_adapter.dart` | Banking details |
| `lib/adapters/AdapterReadme.md` | **Comprehensive documentation** |

### Templates
All in `lib/templates/`:
- `invoice_template_base.dart` - Abstract base
- `mbbook_tally_template.dart` - Tally schema + HSN summary
- `tally_professional_template.dart` - Tally variant
- `mbbook_modern_template.dart` - Modern minimalist
- `mbbook_stylish_template.dart` - Modern + color themes
- `modern_elite_template.dart` - Premium modern
- `a5_compact_template.dart` - A5 retail format
- `thermal_theme2_template.dart` - Thermal printer

### Services & Utilities
| File | Purpose |
|------|---------|
| `lib/services/template_registry.dart` | Template lookup |
| `lib/services/pdf_service.dart` | PDF generation/export |
| `lib/services/sheets_importer_service.dart` | CSV/Excel import API |
| `lib/utils/currency_formatter.dart` | Indian currency (₹1,23,456.78) |
| `lib/utils/invoice_colors.dart` | Color theme definitions |
| `lib/utils/demo_helpers.dart` | Demo organization/filtering |
| `lib/utils/csv_sanitizer.dart` | OWASP CSV injection protection |

### Importers
| File | Purpose |
|------|---------|
| `lib/importers/column_matcher.dart` | Fuzzy column matching |
| `lib/importers/sheet_parser.dart` | CSV/Excel parsing |
| `lib/importers/item_sheet_importer.dart` | Item import logic |
| `lib/importers/party_sheet_importer.dart` | Party import logic |
| `lib/models/import_result.dart` | Import result wrapper |
| `lib/models/import_config.dart` | Import configuration |

### Screens & References
| File | Purpose |
|------|---------|
| `lib/screens/home_screen.dart` | Template gallery (responsive) |
| `lib/screens/invoice_preview_screen.dart` | PDF preview + actions |
| `references/README/Flutter Inv Gen.md` | Implementation guide (2100+ lines) |
| `references/templateScreenshots/` | Template preview images |
| `references/structTypes/custom_field_struct.dart` | FlutterFlow CustomFieldStruct |

### Documentation
| File | Purpose |
|------|---------|
| `READMEs/Custom fields support/CUSTOM_FIELDS_STATUS.md` | Implementation progress tracker |
| `READMEs/Custom fields support/IMPLEMENTATION_GUIDE_CustomFields.md` | Developer coding guide |
| `READMEs/Custom fields support/TODO-CustomFields.md` | Complete specification |
| `READMEs/XLSX importer/Importer-STATUS.md` | Importer architecture & API reference |
| `examples/sample_imports/README.md` | Sample files usage guide |
| `examples/sample_imports/README_SECURITY.md` | CSV injection security guide |

---

## Common Tasks

### Add New Template
1. Create file in `lib/templates/` extending `InvoiceTemplate`
2. Implement: `generatePDF()`, `buildPreview()`, `buildThumbnail()`
3. Add to `TemplateRegistry._templates` map
4. Add screenshot to `references/templateScreenshots/`
5. Test with demo invoices

### Add New Demo Invoice
1. Add method in `DemoInvoices` class
2. Create `DemoInvoiceMetadata` entry
3. Register in `DemoHelpers.getAllDemoMetadata()`
4. Assign to `DemoCategory`

### Add Color Theme
1. Define in `InvoiceThemes` class (lib/utils/invoice_colors.dart)
2. Add to `InvoiceThemes.all` list

---

## Testing Strategy

**Visual Testing (Chrome):**
```bash
flutter run -d chrome --web-renderer html
```
- Test all demo categories
- Verify each template with various invoice types
- Check color themes, edge cases, multi-page handling

**Key Test Cases:**
- GST: `getIntraStateDetailed()`, `getInterStateIgst()`, `getCessHeavyGoods()`, `getMultiGstRatesInvoice()`
- Layout: `getStressTestManyItems()`, `getPartialPaymentScenario()`, `getMinimalDataInvoice()`
- Footer: `getNotesAndTermsTestingInvoices()` (12 invoices)
- Custom Fields: `getCustomFieldsTestingInvoices()` (12 invoices)

**Security Testing:**
```bash
# Run CSV injection security tests
flutter test test/security/csv_injection_test.dart

# Run all tests
flutter test

# Test with sample attack files
# Import: examples/sample_imports/sample_*_injection_attack.csv
```

---

## Critical Conventions & Gotchas

### Footer Element Handling ⚠️

**Templates MUST handle 3 distinct elements:**
1. **Notes** (`invoice.notesFooter` - String)
2. **Terms** (`invoice.paymentTerms` - List<String>)
3. **Signature** (seller business name)

**Requirements:**
- Check BOTH `notesFooter` AND `paymentTerms` fields
- Support all 4 scenarios: both/notes-only/terms-only/neither
- Never confuse labels (don't label `notesFooter` as "Terms & Conditions")
- Proper spacing between sections

**Schema Patterns:**
- **Tally:** Two-column footer (Notes/Terms left, Signature right)
- **Modern:** Single-column left (combined), Pricing+Signature right
- **Compact:** Vertical stacking, minimal padding

**Test:** Use `DemoInvoices.getNotesAndTermsTestingInvoices()` (12 invoices)

### CGST Field Handling

`ItemSaleInfo.csgst` = Combined CGST+SGST amount (not split)
- Intra-state: Full combined amount
- Inter-state: 0 (IGST used instead)
- Templates split for display: `csgst/2` each for CGST and SGST

### DocumentReferences

**All ignored by adapters:**
- `invoice.invoiceRef`, `invoice.sellerFirm`, `invoice.referenceInvoiceRef`
- `businessDetails.partyRef`, `item.itemRef`, `customFieldValues[].fieldRef`
- Your app denormalizes nested data before conversion

### Other Gotchas

- **Template IDs:** Lowercase with underscores (e.g., `mbbook_tally`)
- **Currency:** Indian format (₹1,23,456.78)
- **InvoiceMode enum:** All values have "Inv" suffix (`salesInv`, `proformaInv`)
- **No copyWith methods:** Create new instances to modify
- **Screenshots:** Must exist in `references/templateScreenshots/` matching `screenshotPath`
- **Color themes:** Only Modern templates support themes (check `supportsColorThemes`)
- **Responsive grid:** Mobile 1 col, Tablet 2 col, Desktop 4 col

---

## Git Workflow

### Automatic Commit & Push Rule ⚠️

**IMPORTANT:** After completing significant tasks, MUST:
1. `git add` relevant changes
2. Create concise commit message (conventional commits format)
3. `git push` to remote

### When Committing

**Template Changes:**
- Update screenshots in `references/templateScreenshots/`
- Update `TemplateRegistry` if IDs change
- Test with all demo invoices

**Adapter Changes:**
- Update models if fields change
- Update `AdapterReadme.md` documentation
- Update CLAUDE.md if public API changes

**Model Changes:**
- Update all affected adapters and templates
- Update demo invoice data
- Run comprehensive testing

### Commit Message Format
- `feat:` New features
- `fix:` Bug fixes
- `refactor:` Code refactoring
- `docs:` Documentation updates
- `test:` Test updates
- `chore:` Build/tooling changes

---

## Dependencies

**Core:**
- `pdf: ^3.11.1` - PDF creation
- `printing: ^5.13.2` - Preview/print/share
- `path_provider: ^2.1.4` - Storage access

**Importers:**
- `csv: ^6.0.0` - CSV parsing
- `excel: ^4.0.3` - Excel support
- `fuzzywuzzy: ^1.1.6` - Fuzzy matching

**Utilities:**
- `intl: ^0.19.0` - Date/number formatting
- `http: ^1.2.2` - Image loading
- `google_fonts: ^6.2.1` - Custom fonts

**Dev:**
- `flutter_lints: ^5.0.0` - Linting

---

## Future Enhancements (v3.0 Ideas)

1. Cloud generation fallback
2. Template marketplace
3. Interactive PDF forms
4. Email delivery integration
5. Multi-language support (i18n)
6. QR code generation
7. Digital signatures
8. Batch generation
9. Template preview caching
10. Custom font support
11. Adapter unit tests

See `references/README/Flutter Inv Gen.md` for architectural guidance.
