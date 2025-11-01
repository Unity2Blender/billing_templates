# PubSpec Import Guide

Complete guide for importing and using the `billing_templates` package as a Git dependency in your FlutterFlow application.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Installation](#installation)
3. [Data Preparation](#data-preparation)
4. [Basic Usage](#basic-usage)
5. [Available Templates](#available-templates)
6. [Color Themes](#color-themes)
7. [Complete Integration Example](#complete-integration-example)
8. [API Reference](#api-reference)
9. [Troubleshooting](#troubleshooting)

---

## Quick Start

### 1. Add to pubspec.yaml

```yaml
dependencies:
  billing_templates:
    git:
      url: https://github.com/Unity2Blender/billing_templates.git
      ref: v1.0.0  # Or use branch: main for latest
```

### 2. Import in your Dart code

```dart
import 'package:billing_templates/billing_templates.dart';
```

### 3. Convert and Generate

```dart
// Your app fetches complete data from Firestore
final invoice = InvoiceStruct.fromMap(invoiceDoc.data()!);
final firm = FirmConfigStruct.fromMap(firmDoc.data()!);

// Adapter converts (pure, synchronous)
final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
  invoice: invoice,
  sellerFirm: firm,
);

// Generate PDF
final pdfBytes = await PDFService().generatePDF(
  invoice: invoiceData,
  templateId: 'mbbook_modern',
);
```

---

## Installation

### Prerequisites

Your FlutterFlow app must already have:
- `cloud_firestore` (for struct definitions)
- Flutter SDK `^3.8.1` or higher

### Adding the Dependency

#### Option 1: Specific Version (Recommended for Production)

```yaml
dependencies:
  billing_templates:
    git:
      url: https://github.com/Unity2Blender/billing_templates.git
      ref: v1.0.0  # Git tag
```

#### Option 2: Latest from Branch (For Development)

```yaml
dependencies:
  billing_templates:
    git:
      url: https://github.com/Unity2Blender/billing_templates.git
      ref: main  # Or your development branch
```

### Install Dependencies

```bash
flutter pub get
```

---

## Data Preparation

**IMPORTANT:** The `billing_templates` package does NOT fetch data from Firestore. Your app is responsible for fetching ALL required data before calling the adapters.

### Required Data Structures

You must fetch and provide:

1. **InvoiceStruct** - Complete invoice with all nested structs populated
2. **FirmConfigStruct** - Seller firm details with business info, logos, and banking

### Fetching Invoice Data

```dart
// Fetch invoice document
final invoiceDoc = await FirebaseFirestore.instance
    .collection('billing')
    .doc(uid)
    .collection('invoices')
    .doc(invoiceId)
    .get();

// Convert to struct (all nested data included)
final invoice = InvoiceStruct.fromMap(invoiceDoc.data()!);
```

### Fetching Firm Data

```dart
// Fetch firm document
final firmDoc = await FirebaseFirestore.instance
    .collection('billing')
    .doc(uid)
    .collection('firms')
    .doc(firmId)
    .get();

// Convert to struct (includes businessDetails, logos, bankAccounts)
final firm = FirmConfigStruct.fromMap(firmDoc.data()!);
```

### What Gets Ignored

The adapter automatically ignores DocumentReferences and metadata fields:
- `invoice.invoiceRef` - DB reference
- `invoice.sellerFirm` - DocumentReference (you pass the actual struct instead)
- `invoice.referenceInvoiceRef` - DB metadata
- All `customFieldValues` refs (only values are used, refs ignored)
- Item refs (`itemRef`, `byFirms`, `partySpecificPrices` refs)
- Business refs (`partyRef`)

---

## Basic Usage

### Step 1: Convert Structs to Internal Model

```dart
import 'package:billing_templates/billing_templates.dart';

final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
  invoice: myInvoiceStruct,      // InvoiceStruct
  sellerFirm: myFirmConfigStruct, // FirmConfigStruct
);
```

### Step 2: Generate PDF

```dart
final pdfBytes = await PDFService().generatePDF(
  invoice: invoiceData,
  templateId: 'mbbook_modern',
  colorTheme: InvoiceThemes.blue,  // Optional, only for supported templates
);
```

### Step 3: Use the PDF

#### Save to File

```dart
final directory = await getApplicationDocumentsDirectory();
final file = File('${directory.path}/invoice_${invoiceData.fullInvoiceNumber}.pdf');
await file.writeAsBytes(pdfBytes);
```

#### Print

```dart
await PDFService().printInvoice(
  invoice: invoiceData,
  templateId: 'mbbook_tally',
);
```

#### Share

```dart
await PDFService().sharePDF(
  invoice: invoiceData,
  templateId: 'modern_elite',
  colorTheme: InvoiceThemes.green,
);
```

---

## Available Templates

### 1. Tally Schema Templates

#### mbbook_tally
- **Best for:** B2B invoices, detailed tax reporting
- **Features:** GST summary by HSN, CGST/SGST/IGST breakdown
- **Page format:** A4
- **Color themes:** Not supported
- **Template ID:** `'mbbook_tally'`

#### tally_professional
- **Best for:** Professional businesses, formal documentation
- **Features:** Similar to mbbook_tally with refined layout
- **Page format:** A4
- **Color themes:** Not supported
- **Template ID:** `'tally_professional'`

### 2. Modern Schema Templates

#### mbbook_modern
- **Best for:** Modern businesses, service providers
- **Features:** Clean minimalist design, single tax column
- **Page format:** A4
- **Color themes:** Supported (7 themes)
- **Template ID:** `'mbbook_modern'`

#### mbbook_stylish
- **Best for:** Creative businesses, modern invoicing
- **Features:** Stylish layout with color theme support
- **Page format:** A4
- **Color themes:** Supported (7 themes)
- **Template ID:** `'mbbook_stylish'`

#### modern_elite
- **Best for:** Premium services, high-value transactions
- **Features:** Premium modern design, professional appearance
- **Page format:** A4
- **Color themes:** Supported (7 themes)
- **Template ID:** `'modern_elite'`

### 3. Compact/Thermal Schema Templates

#### a5_compact
- **Best for:** Retail bills, walk-in customers
- **Features:** Space-optimized A5 layout
- **Page format:** A5
- **Color themes:** Not supported
- **Template ID:** `'a5_compact'`

#### thermal_theme2
- **Best for:** Thermal printers, POS systems
- **Features:** Minimal layout for thermal printing
- **Page format:** Custom (80mm width)
- **Color themes:** Not supported
- **Template ID:** `'thermal_theme2'`

### Listing Templates Programmatically

```dart
// Get all available templates
final templates = TemplateRegistry.getAllTemplates();

for (var template in templates) {
  print('${template.id}: ${template.name}');
  print('Description: ${template.description}');
  print('Supports themes: ${template.supportsColorThemes}');
  print('---');
}

// Get specific template
final template = TemplateRegistry.getTemplate('mbbook_modern');
print('Template: ${template.name}');
```

---

## Color Themes

Modern templates (`mbbook_modern`, `mbbook_stylish`, `modern_elite`) support color customization.

### Available Themes

```dart
// Predefined themes
InvoiceThemes.defaultTheme  // Default colors
InvoiceThemes.blue          // Professional blue
InvoiceThemes.green         // Fresh green
InvoiceThemes.purple        // Creative purple
InvoiceThemes.orange        // Energetic orange
InvoiceThemes.red           // Bold red
InvoiceThemes.teal          // Modern teal

// Get all themes
final allThemes = InvoiceThemes.all;
```

### Using Themes

```dart
// With color theme
final pdfBytes = await PDFService().generatePDF(
  invoice: invoiceData,
  templateId: 'mbbook_stylish',
  colorTheme: InvoiceThemes.purple,
);

// Without color theme (uses default)
final pdfBytes = await PDFService().generatePDF(
  invoice: invoiceData,
  templateId: 'mbbook_tally',  // Doesn't support themes
);
```

### Custom Theme

```dart
// Create custom color theme
final customTheme = InvoiceColorTheme(
  name: 'My Brand',
  primaryColor: PdfColor.fromHex('#1E40AF'),
  secondaryColor: PdfColor.fromHex('#3B82F6'),
  accentColor: PdfColor.fromHex('#60A5FA'),
);

final pdfBytes = await PDFService().generatePDF(
  invoice: invoiceData,
  templateId: 'modern_elite',
  colorTheme: customTheme,
);
```

---

## Complete Integration Example

### Full Flutter Widget Example

```dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:billing_templates/billing_templates.dart';

class InvoicePDFGenerator extends StatefulWidget {
  final String invoiceId;
  final String firmId;

  const InvoicePDFGenerator({
    required this.invoiceId,
    required this.firmId,
  });

  @override
  _InvoicePDFGeneratorState createState() => _InvoicePDFGeneratorState();
}

class _InvoicePDFGeneratorState extends State<InvoicePDFGenerator> {
  String? _selectedTemplate = 'mbbook_modern';
  InvoiceColorTheme? _selectedTheme = InvoiceThemes.blue;
  bool _isLoading = false;

  Future<void> _generateAndPrintInvoice() async {
    setState(() => _isLoading = true);

    try {
      // Step 1: Fetch invoice data
      final invoiceDoc = await FirebaseFirestore.instance
          .collection('billing')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('invoices')
          .doc(widget.invoiceId)
          .get();

      if (!invoiceDoc.exists) {
        throw Exception('Invoice not found');
      }

      final invoice = InvoiceStruct.fromMap(invoiceDoc.data()!);

      // Step 2: Fetch firm data
      final firmDoc = await FirebaseFirestore.instance
          .collection('billing')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('firms')
          .doc(widget.firmId)
          .get();

      if (!firmDoc.exists) {
        throw Exception('Firm not found');
      }

      final firm = FirmConfigStruct.fromMap(firmDoc.data()!);

      // Step 3: Convert using adapter
      final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
        invoice: invoice,
        sellerFirm: firm,
      );

      // Step 4: Check if template supports themes
      final template = TemplateRegistry.getTemplate(_selectedTemplate!);
      final theme = template.supportsColorThemes ? _selectedTheme : null;

      // Step 5: Print invoice
      await PDFService().printInvoice(
        invoice: invoiceData,
        templateId: _selectedTemplate!,
        colorTheme: theme,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice sent to printer')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate Invoice PDF')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Template selector
            DropdownButtonFormField<String>(
              value: _selectedTemplate,
              decoration: InputDecoration(labelText: 'Template'),
              items: TemplateRegistry.getAllTemplates()
                  .map((t) => DropdownMenuItem(
                        value: t.id,
                        child: Text(t.name),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedTemplate = value),
            ),
            SizedBox(height: 16),

            // Theme selector (if template supports it)
            if (TemplateRegistry.getTemplate(_selectedTemplate!)
                .supportsColorThemes)
              DropdownButtonFormField<InvoiceColorTheme>(
                value: _selectedTheme,
                decoration: InputDecoration(labelText: 'Color Theme'),
                items: InvoiceThemes.all
                    .map((t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.name),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTheme = value),
              ),
            SizedBox(height: 32),

            // Generate button
            ElevatedButton(
              onPressed: _isLoading ? null : _generateAndPrintInvoice,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Generate & Print'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## API Reference

### InvoiceAdapter

```dart
class InvoiceAdapter {
  static InvoiceData fromFlutterFlowStruct({
    required dynamic invoice,     // InvoiceStruct
    required dynamic sellerFirm,  // FirmConfigStruct
  })
}
```

**Parameters:**
- `invoice`: Your InvoiceStruct with all nested data populated
- `sellerFirm`: FirmConfigStruct with seller details, logos, and banking

**Returns:** `InvoiceData` (internal model used by templates)

### PDFService

```dart
class PDFService {
  // Generate PDF bytes
  Future<Uint8List> generatePDF({
    required InvoiceData invoice,
    required String templateId,
    InvoiceColorTheme? colorTheme,
  })

  // Preview and print
  Future<void> printInvoice({
    required InvoiceData invoice,
    required String templateId,
    InvoiceColorTheme? colorTheme,
  })

  // Share PDF
  Future<void> sharePDF({
    required InvoiceData invoice,
    required String templateId,
    InvoiceColorTheme? colorTheme,
  })
}
```

### TemplateRegistry

```dart
class TemplateRegistry {
  // Get specific template by ID
  static InvoiceTemplate getTemplate(String id)

  // Get all available templates
  static List<InvoiceTemplate> getAllTemplates()

  // Get all template IDs (alphabetically sorted)
  static List<String> getAllTemplateIds()

  // Check if template exists
  static bool hasTemplate(String id)
}
```

**Example - Getting Template IDs:**

```dart
// Get list of all template IDs
final templateIds = TemplateRegistry.getAllTemplateIds();
// Returns: ['a5_compact', 'mbbook_modern', 'mbbook_stylish',
//           'mbbook_tally', 'modern_elite', 'tally_professional', 'thermal_theme2']

// Use in dropdown/selector
final templates = templateIds.map((id) => DropdownMenuItem(
  value: id,
  child: Text(id),
)).toList();

// Validate template ID
if (TemplateRegistry.hasTemplate('custom_template')) {
  // Template exists
}
```

### InvoiceThemes

```dart
class InvoiceThemes {
  static final InvoiceColorTheme defaultTheme;
  static final InvoiceColorTheme blue;
  static final InvoiceColorTheme green;
  static final InvoiceColorTheme purple;
  static final InvoiceColorTheme orange;
  static final InvoiceColorTheme red;
  static final InvoiceColorTheme teal;

  static final List<InvoiceColorTheme> all;
}
```

---

## Troubleshooting

### Issue: "Type 'InvoiceStruct' is not a subtype of type required"

**Cause:** Struct types aren't properly imported or instantiated.

**Solution:**
```dart
// Make sure you're using fromMap to create structs
final invoice = InvoiceStruct.fromMap(invoiceDoc.data()!);
final firm = FirmConfigStruct.fromMap(firmDoc.data()!);
```

### Issue: "The method 'generatePDF' was called on null"

**Cause:** PDFService instance is null.

**Solution:**
```dart
// Use constructor to get instance
final pdfService = PDFService();
await pdfService.generatePDF(...);
```

### Issue: PDF shows empty/missing data

**Cause:** Nested structs in InvoiceStruct are not populated.

**Solution:**
- Ensure all nested data is fetched from Firestore
- Check that `invoice.billToParty` has data
- Verify `sellerFirm.businessDetails` is populated
- Confirm `invoice.lines` array has items

### Issue: Logos/signatures not appearing

**Cause:** URL fields are empty or invalid.

**Solution:**
```dart
// Ensure firm struct has logo URLs
print('Shop logo: ${firm.shopLogo}');
print('Signature: ${firm.signLogo}');

// URLs should be accessible HTTP/HTTPS URLs
// Firestore Storage URLs work fine
```

### Issue: Banking details not showing

**Cause:** `firmConfig.bankAccounts` is empty.

**Solution:**
```dart
// Ensure at least one bank account exists
if (firm.bankAccounts.isEmpty) {
  print('Warning: No bank accounts found');
}
```

### Issue: "Template 'xxx' not found"

**Cause:** Invalid template ID.

**Solution:**
```dart
// Use exact template IDs from Available Templates section
final validIds = [
  'mbbook_tally',
  'tally_professional',
  'mbbook_modern',
  'mbbook_stylish',
  'modern_elite',
  'a5_compact',
  'thermal_theme2',
];
```

### Issue: Color theme not applying

**Cause:** Template doesn't support color themes.

**Solution:**
```dart
// Check if template supports themes first
final template = TemplateRegistry.getTemplate(templateId);
if (template.supportsColorThemes) {
  // Apply theme
  await PDFService().generatePDF(
    invoice: invoiceData,
    templateId: templateId,
    colorTheme: InvoiceThemes.blue,
  );
} else {
  // Don't pass colorTheme parameter
  await PDFService().generatePDF(
    invoice: invoiceData,
    templateId: templateId,
  );
}
```

### Issue: GST calculation mismatch

**Cause:** Tax amounts in FlutterFlow structs don't match expected values.

**Solution:**
- The adapter does NOT recalculate taxes
- Your app must pre-calculate all tax amounts correctly
- Verify `csgst` field contains combined CGST+SGST for intra-state
- Verify `igst` field is used for inter-state
- Check `grossTaxCharged` contains total tax percentage

### Getting Help

1. Check [CLAUDE.md](./CLAUDE.md) for architecture details
2. Review adapter source code in `lib/adapters/`
3. Check template implementations in `lib/templates/`
4. Open an issue on the GitHub repository

---

## Version History

- **v1.0.0** - Initial release with 7 templates and adapter system

---

## License

See [LICENSE](./LICENSE) file for details.
