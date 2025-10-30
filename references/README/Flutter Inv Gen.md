# Flutter Invoice PDF Generation Guide

## Overview

Client-side invoice PDF generation using the `printing` package with Helvetica fonts, designed to work offline and provide instant previews across Flutter platforms (Mobile, Web, Desktop).

**Key Benefits:**
- **Offline-First**: Generate PDFs without network dependency
- **Instant Preview**: Real-time rendering before print/save/share
- **Type-Safe**: Leverage Dart's type system with InvoiceStruct
- **Cross-Platform**: Single codebase for iOS, Android, Web, Desktop
- **Cost-Effective**: No per-invoice generation costs

---

## Table of Contents

1. [Architecture](#architecture)
2. [Setup & Dependencies](#setup--dependencies)
3. [Invoice Data Model](#invoice-data-model)
4. [Template System](#template-system)
5. [Classic Template Implementation](#classic-template-implementation)
6. [Modern Template Implementation](#modern-template-implementation)
7. [Minimal Template Implementation](#minimal-template-implementation)
8. [Font Management](#font-management)
9. [Styling Components](#styling-components)
10. [PDF Service Integration](#pdf-service-integration)
11. [Platform-Specific Considerations](#platform-specific-considerations)
12. [Performance Optimization](#performance-optimization)
13. [Comparison with Cloud Generation](#comparison-with-cloud-generation)
14. [Migration Strategy](#migration-strategy)
15. [Troubleshooting](#troubleshooting)

---

## Architecture

### Design Philosophy

**Offline-First Approach:**
```
InvoiceStruct → Template Selector → Data Mapper → PDF Builder → Preview/Print/Save
```

**Key Components:**
1. **Data Layer**: InvoiceStruct and related records from Firestore
2. **Template Layer**: Pluggable template system (Classic/Modern/Minimal)
3. **Rendering Layer**: `printing` package with Helvetica fonts
4. **Output Layer**: Preview, print, save, share capabilities

### Generation Flow

```dart
// High-level flow
final invoiceData = await fetchInvoiceData(invoiceId);
final template = ClassicInvoiceTemplate();
final pdfDocument = await template.generate(invoiceData);
final bytes = await pdfDocument.save();
// → Preview, Print, Share, or Save
```

---

## Setup & Dependencies

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter

  # PDF Generation
  printing: ^5.12.0
  pdf: ^3.10.7

  # File handling
  path_provider: ^2.1.1
  share_plus: ^7.2.1

  # Image handling (for logos)
  http: ^1.1.0
  flutter_cache_manager: ^3.3.1

dev_dependencies:
  flutter_test:
    sdk: flutter
```

### Font Assets

Download Helvetica font family and add to your project:

```yaml
flutter:
  fonts:
    - family: Helvetica
      fonts:
        - asset: assets/fonts/Helvetica.ttf
        - asset: assets/fonts/Helvetica-Bold.ttf
          weight: 700
        - asset: assets/fonts/Helvetica-Oblique.ttf
          style: italic
        - asset: assets/fonts/Helvetica-BoldOblique.ttf
          weight: 700
          style: italic
```

**Font Files Location:**
```
assets/
└── fonts/
    ├── Helvetica.ttf
    ├── Helvetica-Bold.ttf
    ├── Helvetica-Oblique.ttf
    └── Helvetica-BoldOblique.ttf
```

### Project Structure

```
lib/
├── services/
│   ├── invoice_pdf_service.dart       # Main service
│   └── pdf_font_loader.dart           # Font management
├── templates/
│   ├── invoice_template_base.dart     # Base template interface
│   ├── classic_invoice_template.dart  # GST-compliant traditional
│   ├── modern_invoice_template.dart   # Clean minimalist
│   └── minimal_invoice_template.dart  # Lightweight essential
├── widgets/
│   └── pdf_preview_screen.dart        # Preview UI
└── utils/
    ├── pdf_styles.dart                 # Reusable styling
    ├── invoice_data_mapper.dart        # Data transformation
    └── currency_formatter.dart         # Number formatting
```

---

## Invoice Data Model

### Core Data Structures

The Flutter PDF generator uses the same data structures defined in `record-definitions/billing-struct-definitions/`:

#### InvoiceStruct
Main invoice container with:
- `modeSpecifcDetails: BillModeConfigStruct` - Invoice type, number, dates
- `billToParty: BusinessDetailsStruct` - Customer details
- `lines: List<ItemSaleInfoStruct>` - Line items with tax calculations
- `billSummary: BillSummaryResultsStruct` - Totals and summaries
- `shipmentInfo: ShipmentDetailsStruct` - Delivery information
- `notesFooter: String` - Custom notes

#### FirmsRecord
Seller firm details:
- `firmLogo: String` - Logo URL
- `signature: String` - Signature image URL
- `shopInfo: BusinessDetailsStruct` - Business details
- `bankAccounts: List<BankingDetailsStruct>` - Payment information

### Data Container

```dart
// lib/models/invoice_pdf_data.dart
class InvoicePDFData {
  final InvoiceStruct invoice;
  final FirmsRecord firm;

  InvoicePDFData({
    required this.invoice,
    required this.firm,
  });

  // Convenience getters
  String get invoiceNumber =>
      '${invoice.modeSpecifcDetails.modeIdPrefix}${invoice.modeSpecifcDetails.modeId}';

  bool get isIntraState =>
      invoice.billToParty.state == firm.shopInfo.state;

  bool get hasShipment =>
      invoice.shipmentInfo != null;
}
```

---

## Template System

### Base Template Interface

```dart
// lib/templates/invoice_template_base.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

abstract class InvoiceTemplate {
  /// Generate PDF document from invoice data
  Future<pw.Document> generate(InvoicePDFData data);

  /// Unique template identifier
  String get templateId;

  /// Display name for template
  String get templateName;

  /// Template description
  String get description;

  /// Preview thumbnail widget (for template selector UI)
  Widget get previewThumbnail;
}
```

### Template Registry

```dart
// lib/services/template_registry.dart
class TemplateRegistry {
  static final Map<String, InvoiceTemplate> _templates = {
    'classic': ClassicInvoiceTemplate(),
    'modern': ModernInvoiceTemplate(),
    'minimal': MinimalInvoiceTemplate(),
  };

  static InvoiceTemplate getTemplate(String id) {
    return _templates[id] ?? ClassicInvoiceTemplate();
  }

  static List<InvoiceTemplate> getAllTemplates() {
    return _templates.values.toList();
  }
}
```

---

## Classic Template Implementation

Traditional GST-compliant invoice format with comprehensive details.

### Features
- Complete firm and party details
- GST/IGST tax breakdown
- Payment terms and bank details
- Signature space
- Professional layout

### Implementation

```dart
// lib/templates/classic_invoice_template.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../services/pdf_font_loader.dart';
import '../utils/pdf_styles.dart';
import '../utils/currency_formatter.dart';

class ClassicInvoiceTemplate implements InvoiceTemplate {
  @override
  String get templateId => 'classic';

  @override
  String get templateName => 'Classic Invoice';

  @override
  String get description => 'Traditional GST-compliant business format';

  @override
  Widget get previewThumbnail {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.blue[50],
            padding: EdgeInsets.all(8),
            child: Text('INVOICE', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Center(child: Icon(Icons.receipt_long))),
        ],
      ),
    );
  }

  @override
  Future<pw.Document> generate(InvoicePDFData data) async {
    final pdf = pw.Document();
    final fonts = await PDFFontLoader.load();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(InvoiceStyles.pageMargin),
        theme: pw.ThemeData.withFont(
          base: fonts.regular,
          bold: fonts.bold,
          italic: fonts.italic,
          boldItalic: fonts.boldItalic,
        ),
        build: (context) => [
          _buildHeader(data, fonts),
          pw.SizedBox(height: 20),
          _buildPartyDetails(data),
          pw.SizedBox(height: 20),
          _buildInvoiceInfo(data),
          pw.SizedBox(height: 20),
          _buildItemsTable(data),
          pw.SizedBox(height: 20),
          _buildSummary(data),
          pw.SizedBox(height: 20),
          _buildPaymentInfo(data),
          if (data.hasShipment) ...[
            pw.SizedBox(height: 20),
            _buildShipmentInfo(data),
          ],
          if (data.invoice.notesFooter.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            _buildNotes(data),
          ],
        ],
        footer: (context) => _buildFooter(data),
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoicePDFData data, PDFFonts fonts) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Firm details
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (data.firm.firmLogo.isNotEmpty)
                pw.Container(
                  width: 80,
                  height: 80,
                  margin: pw.EdgeInsets.only(bottom: 10),
                  child: pw.Text('[LOGO]'), // Load actual logo in production
                ),
              pw.Text(
                data.firm.shopInfo.businessName.toUpperCase(),
                style: InvoiceStyles.firmName,
              ),
              pw.SizedBox(height: 4),
              pw.Text(data.firm.shopInfo.businessAddress, style: InvoiceStyles.bodyText),
              pw.Text('Phone: ${data.firm.shopInfo.phone}', style: InvoiceStyles.bodyText),
              pw.Text('Email: ${data.firm.shopInfo.email}', style: InvoiceStyles.bodyText),
              if (data.firm.shopInfo.gstin.isNotEmpty)
                pw.Text('GSTIN: ${data.firm.shopInfo.gstin}', style: InvoiceStyles.bodyTextBold),
            ],
          ),
        ),
        // Invoice title and number
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                border: pw.Border.all(color: PdfColors.blue300),
              ),
              child: pw.Text(
                data.invoice.modeSpecifcDetails.modeTitle.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              data.invoiceNumber,
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPartyDetails(InvoicePDFData data) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Bill To
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('BILL TO', style: InvoiceStyles.sectionHeader),
                pw.SizedBox(height: 8),
                pw.Text(
                  data.invoice.billToParty.businessName,
                  style: InvoiceStyles.bodyTextBold,
                ),
                pw.Text(data.invoice.billToParty.businessAddress, style: InvoiceStyles.bodyText),
                if (data.invoice.billToParty.phone.isNotEmpty)
                  pw.Text('Phone: ${data.invoice.billToParty.phone}', style: InvoiceStyles.bodyText),
                if (data.invoice.billToParty.gstin.isNotEmpty)
                  pw.Text('GSTIN: ${data.invoice.billToParty.gstin}', style: InvoiceStyles.bodyTextBold),
                if (data.invoice.billToParty.state.isNotEmpty)
                  pw.Text('State: ${data.invoice.billToParty.state}', style: InvoiceStyles.bodyText),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 16),
        // Invoice dates and details
        pw.Expanded(
          child: pw.Container(
            padding: pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('INVOICE DETAILS', style: InvoiceStyles.sectionHeader),
                pw.SizedBox(height: 8),
                _buildDetailRow('Invoice Date', _formatDate(data.invoice.modeSpecifcDetails.dates.issueDate)),
                if (data.invoice.modeSpecifcDetails.dates.dueDate != null)
                  _buildDetailRow('Due Date', _formatDate(data.invoice.modeSpecifcDetails.dates.dueDate!)),
                if (data.invoice.modeSpecifcDetails.dates.paymentTerms.isNotEmpty)
                  _buildDetailRow('Payment Terms', data.invoice.modeSpecifcDetails.dates.paymentTerms.first),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildInvoiceInfo(InvoicePDFData data) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Invoice Mode: ${data.invoice.modeSpecifcDetails.modeType.toString().split('.').last}',
            style: InvoiceStyles.bodyText,
          ),
          if (data.invoice.paymentMode != null)
            pw.Text(
              'Payment Mode: ${data.invoice.paymentMode.toString().split('.').last}',
              style: InvoiceStyles.bodyText,
            ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable(InvoicePDFData data) {
    final headers = [
      '#',
      'Item Description',
      'HSN',
      'Qty',
      'Rate',
      'Disc%',
      'Taxable',
      data.isIntraState ? 'CGST' : 'IGST',
      if (data.isIntraState) 'SGST',
      'Amount',
    ];

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: pw.FixedColumnWidth(30),
      },
      children: [
        // Header
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.blue100),
          children: headers.map((h) => _tableHeader(h)).toList(),
        ),
        // Items
        ...data.invoice.lines.asMap().entries.map((entry) {
          final index = entry.key;
          final line = entry.value;

          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: index % 2 == 0 ? PdfColors.white : PdfColors.grey50,
            ),
            children: [
              _tableCell('${index + 1}'),
              _tableCell('${line.item.name}\n${line.item.description}', align: pw.TextAlign.left),
              _tableCell(line.item.hsnCode),
              _tableCell('${line.qtyOnBill} ${line.item.qtyUnit}'),
              _tableCell(formatCurrency(line.partyNetPrice)),
              _tableCell('${line.discountPercentage}%'),
              _tableCell(formatCurrency(line.taxableValue)),
              _tableCell(formatCurrency(data.isIntraState ? line.csgst : line.igst)),
              if (data.isIntraState)
                _tableCell(formatCurrency(line.csgst)),
              _tableCell(formatCurrency(line.lineTotal), bold: true),
            ],
          );
        }).toList(),
      ],
    );
  }

  pw.Widget _buildSummary(InvoicePDFData data) {
    final summary = data.invoice.billSummary;

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 280,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          padding: pw.EdgeInsets.all(12),
          child: pw.Column(
            children: [
              _summaryRow('Subtotal', summary.totalTaxableValue),
              if (summary.totalDiscount > 0)
                _summaryRow('Total Discount', -summary.totalDiscount),
              _summaryRow('Total GST', summary.totalGst),
              if (summary.totalCess > 0)
                _summaryRow('Total Cess', summary.totalCess),
              pw.Divider(thickness: 2),
              _summaryRow(
                'GRAND TOTAL',
                summary.totalLineItemsAfterTaxes,
                bold: true,
                fontSize: 14,
              ),
              if (data.invoice.amountPaid > 0) ...[
                pw.Divider(),
                _summaryRow('Amount Paid', -data.invoice.amountPaid),
                _summaryRow(
                  'Balance Due',
                  summary.dueBalancePayable,
                  bold: true,
                  color: PdfColors.red700,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPaymentInfo(InvoicePDFData data) {
    if (data.firm.bankAccounts.isEmpty) return pw.SizedBox();

    final bank = data.firm.bankAccounts.first;

    return pw.Container(
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(4),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('BANK DETAILS', style: InvoiceStyles.sectionHeader),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Bank Name', bank.bankName),
                    _buildDetailRow('Account No', bank.accountNo.toString()),
                    _buildDetailRow('IFSC Code', bank.ifsc),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Account Holder', bank.makeChequeFor),
                    if (bank.upi.isNotEmpty)
                      _buildDetailRow('UPI ID', bank.upi),
                    _buildDetailRow('Branch', bank.branchAddress),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildShipmentInfo(InvoicePDFData data) {
    final shipment = data.invoice.shipmentInfo!;

    return pw.Container(
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('SHIPMENT DETAILS', style: InvoiceStyles.sectionHeader),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (shipment.vehicleNo.isNotEmpty)
                      _buildDetailRow('Vehicle No', shipment.vehicleNo),
                    if (shipment.goodsLoadingPoint.isNotEmpty)
                      _buildDetailRow('Loading Point', shipment.goodsLoadingPoint),
                    if (shipment.deliveryPoint.isNotEmpty)
                      _buildDetailRow('Delivery Point', shipment.deliveryPoint),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (shipment.dispatchDate != null)
                      _buildDetailRow('Dispatch Date', _formatDate(shipment.dispatchDate!)),
                    if (shipment.expectedDeliveryDate != null)
                      _buildDetailRow('Expected Delivery', _formatDate(shipment.expectedDeliveryDate!)),
                    if (shipment.totalWeight.isNotEmpty)
                      _buildDetailRow('Weight', shipment.totalWeight),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildNotes(InvoicePDFData data) {
    return pw.Container(
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('NOTES', style: InvoiceStyles.sectionHeader),
          pw.SizedBox(height: 8),
          pw.Text(data.invoice.notesFooter, style: InvoiceStyles.bodyText),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(InvoicePDFData data) {
    return pw.Container(
      padding: pw.EdgeInsets.only(top: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Generated on ${_formatDate(DateTime.now())}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
          if (data.firm.signature.isNotEmpty)
            pw.Container(
              child: pw.Column(
                children: [
                  pw.Text('Authorized Signatory', style: InvoiceStyles.bodyText),
                  pw.SizedBox(height: 30), // Space for signature
                  pw.Divider(thickness: 1),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper widgets
  pw.Widget _tableHeader(String text) {
    return pw.Container(
      padding: pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _tableCell(String text, {bool bold = false, pw.TextAlign align = pw.TextAlign.center}) {
    return pw.Container(
      padding: pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: align,
      ),
    );
  }

  pw.Widget _summaryRow(String label, double amount, {bool bold = false, double fontSize = 10, PdfColor? color}) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color,
            ),
          ),
          pw.Text(
            formatCurrency(amount),
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text('$label: ', style: InvoiceStyles.bodyTextBold),
          pw.Expanded(child: pw.Text(value, style: InvoiceStyles.bodyText)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
```

---

## Modern Template Implementation

Clean, minimalist design with focus on readability and white space.

### Features
- Minimalist aesthetic
- Prominent invoice number
- Clean table layout
- Subtle borders and colors
- Modern typography

### Implementation

```dart
// lib/templates/modern_invoice_template.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../services/pdf_font_loader.dart';
import '../utils/pdf_styles.dart';
import '../utils/currency_formatter.dart';

class ModernInvoiceTemplate implements InvoiceTemplate {
  @override
  String get templateId => 'modern';

  @override
  String get templateName => 'Modern Invoice';

  @override
  String get description => 'Clean, minimalist design with focus on readability';

  @override
  Widget get previewThumbnail {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('INVOICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                Text('#001', style: TextStyle(fontSize: 8)),
              ],
            ),
          ),
          Divider(height: 1),
          Expanded(child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.article_outlined, size: 32),
          )),
        ],
      ),
    );
  }

  @override
  Future<pw.Document> generate(InvoicePDFData data) async {
    final pdf = pw.Document();
    final fonts = await PDFFontLoader.load();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(30),
        theme: pw.ThemeData.withFont(
          base: fonts.regular,
          bold: fonts.bold,
        ),
        build: (context) => [
          _buildHeader(data),
          pw.SizedBox(height: 30),
          _buildParties(data),
          pw.SizedBox(height: 30),
          _buildItems(data),
          pw.SizedBox(height: 30),
          _buildSummary(data),
          if (data.invoice.notesFooter.isNotEmpty) ...[
            pw.SizedBox(height: 30),
            _buildNotes(data),
          ],
        ],
        footer: (context) => _buildFooter(data, context),
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoicePDFData data) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Firm info (minimal)
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              data.firm.shopInfo.businessName,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey800,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              data.firm.shopInfo.email,
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
            pw.Text(
              data.firm.shopInfo.phone,
              style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
            ),
          ],
        ),
        // Invoice number (prominent)
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'INVOICE',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey900,
                letterSpacing: 1.5,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Container(
              padding: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey900,
              ),
              child: pw.Text(
                data.invoiceNumber,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              _formatDate(data.invoice.modeSpecifcDetails.dates.issueDate),
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildParties(InvoicePDFData data) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Bill To
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'BILL TO',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey600,
                  letterSpacing: 1,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                data.invoice.billToParty.businessName,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                data.invoice.billToParty.businessAddress,
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
              ),
              if (data.invoice.billToParty.gstin.isNotEmpty)
                pw.Text(
                  'GSTIN: ${data.invoice.billToParty.gstin}',
                  style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
                ),
            ],
          ),
        ),
        pw.SizedBox(width: 40),
        // Due date
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            if (data.invoice.modeSpecifcDetails.dates.dueDate != null)
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'DUE DATE',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.grey600,
                      letterSpacing: 1,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    _formatDate(data.invoice.modeSpecifcDetails.dates.dueDate!),
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildItems(InvoicePDFData data) {
    return pw.Column(
      children: [
        // Header
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey900, width: 2),
            ),
          ),
          padding: pw.EdgeInsets.symmetric(vertical: 8),
          child: pw.Row(
            children: [
              pw.Expanded(flex: 3, child: _headerText('ITEM')),
              pw.Expanded(flex: 1, child: _headerText('QTY', align: pw.TextAlign.center)),
              pw.Expanded(flex: 1, child: _headerText('RATE', align: pw.TextAlign.right)),
              pw.Expanded(flex: 1, child: _headerText('TAX', align: pw.TextAlign.right)),
              pw.Expanded(flex: 1, child: _headerText('AMOUNT', align: pw.TextAlign.right)),
            ],
          ),
        ),
        // Items
        ...data.invoice.lines.map((line) => pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border(
              bottom: pw.BorderSide(color: PdfColors.grey200, width: 0.5),
            ),
          ),
          padding: pw.EdgeInsets.symmetric(vertical: 12),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(line.item.name, style: pw.TextStyle(fontSize: 10)),
                    if (line.item.description.isNotEmpty)
                      pw.Text(
                        line.item.description,
                        style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
                      ),
                  ],
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  '${line.qtyOnBill} ${line.item.qtyUnit}',
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  formatCurrency(line.partyNetPrice),
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  '${line.grossTaxCharged.toStringAsFixed(1)}%',
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Text(
                  formatCurrency(line.lineTotal),
                  style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  pw.Widget _buildSummary(InvoicePDFData data) {
    final summary = data.invoice.billSummary;

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Container(
          width: 250,
          child: pw.Column(
            children: [
              _summaryRow('Subtotal', summary.totalTaxableValue),
              if (summary.totalDiscount > 0)
                _summaryRow('Discount', -summary.totalDiscount),
              _summaryRow('Tax', summary.totalGst + summary.totalCess),
              pw.Container(
                margin: pw.EdgeInsets.symmetric(vertical: 8),
                padding: pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey900,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'TOTAL',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.Text(
                      formatCurrency(summary.totalLineItemsAfterTaxes),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (data.invoice.amountPaid > 0) ...[
                _summaryRow('Paid', -data.invoice.amountPaid),
                _summaryRow('Balance Due', summary.dueBalancePayable, bold: true),
              ],
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildNotes(InvoicePDFData data) {
    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'NOTES',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.grey600,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            data.invoice.notesFooter,
            style: pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(InvoicePDFData data, pw.Context context) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
        ),
      ),
      padding: pw.EdgeInsets.only(top: 16),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
          pw.Text(
            data.firm.shopInfo.businessName,
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }

  // Helper widgets
  pw.Widget _headerText(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey700,
        letterSpacing: 0.5,
      ),
      textAlign: align,
    );
  }

  pw.Widget _summaryRow(String label, double amount, {bool bold = false}) {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: PdfColors.grey700,
            ),
          ),
          pw.Text(
            formatCurrency(amount),
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
```

---

## Minimal Template Implementation

Lightweight, essential-information-only template for simple invoices.

### Features
- Bare minimum layout
- Fastest generation time
- Smallest file size
- Simple table without borders
- Basic styling

### Implementation

```dart
// lib/templates/minimal_invoice_template.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../services/pdf_font_loader.dart';
import '../utils/currency_formatter.dart';

class MinimalInvoiceTemplate implements InvoiceTemplate {
  @override
  String get templateId => 'minimal';

  @override
  String get templateName => 'Minimal Invoice';

  @override
  String get description => 'Lightweight, essential-information-only template';

  @override
  Widget get previewThumbnail {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Invoice', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Divider(),
          Expanded(child: Icon(Icons.list_alt, size: 32)),
        ],
      ),
    );
  }

  @override
  Future<pw.Document> generate(InvoicePDFData data) async {
    final pdf = pw.Document();
    final fonts = await PDFFontLoader.load();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(base: fonts.regular, bold: fonts.bold),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(data),
            pw.SizedBox(height: 20),
            _buildParties(data),
            pw.SizedBox(height: 20),
            _buildItems(data),
            pw.SizedBox(height: 20),
            _buildTotal(data),
          ],
        ),
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoicePDFData data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'INVOICE',
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          data.invoiceNumber,
          style: pw.TextStyle(fontSize: 14),
        ),
        pw.Text(
          _formatDate(data.invoice.modeSpecifcDetails.dates.issueDate),
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  pw.Widget _buildParties(InvoicePDFData data) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // From
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('From:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text(data.firm.shopInfo.businessName, style: pw.TextStyle(fontSize: 10)),
              pw.Text(data.firm.shopInfo.phone, style: pw.TextStyle(fontSize: 9)),
            ],
          ),
        ),
        // To
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('To:', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text(data.invoice.billToParty.businessName, style: pw.TextStyle(fontSize: 10)),
              pw.Text(data.invoice.billToParty.phone, style: pw.TextStyle(fontSize: 9)),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildItems(InvoicePDFData data) {
    return pw.Column(
      children: [
        // Header
        pw.Row(
          children: [
            pw.Expanded(flex: 3, child: pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10))),
            pw.Expanded(flex: 1, child: pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10), textAlign: pw.TextAlign.right)),
            pw.Expanded(flex: 1, child: pw.Text('Rate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10), textAlign: pw.TextAlign.right)),
            pw.Expanded(flex: 1, child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10), textAlign: pw.TextAlign.right)),
          ],
        ),
        pw.Divider(),
        // Items
        ...data.invoice.lines.map((line) => pw.Padding(
          padding: pw.EdgeInsets.symmetric(vertical: 4),
          child: pw.Row(
            children: [
              pw.Expanded(flex: 3, child: pw.Text(line.item.name, style: pw.TextStyle(fontSize: 9))),
              pw.Expanded(flex: 1, child: pw.Text('${line.qtyOnBill}', style: pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.right)),
              pw.Expanded(flex: 1, child: pw.Text(formatCurrency(line.partyNetPrice), style: pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.right)),
              pw.Expanded(flex: 1, child: pw.Text(formatCurrency(line.lineTotal), style: pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.right)),
            ],
          ),
        )).toList(),
      ],
    );
  }

  pw.Widget _buildTotal(InvoicePDFData data) {
    return pw.Column(
      children: [
        pw.Divider(thickness: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text('TOTAL: ', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.Text(
              formatCurrency(data.invoice.billSummary.totalLineItemsAfterTaxes),
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        if (data.invoice.billSummary.dueBalancePayable > 0)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text('Balance Due: ', style: pw.TextStyle(fontSize: 12)),
              pw.Text(
                formatCurrency(data.invoice.billSummary.dueBalancePayable),
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
```

---

## Font Management

### Font Loader Service

```dart
// lib/services/pdf_font_loader.dart
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFFonts {
  final pw.Font regular;
  final pw.Font bold;
  final pw.Font italic;
  final pw.Font boldItalic;

  PDFFonts({
    required this.regular,
    required this.bold,
    required this.italic,
    required this.boldItalic,
  });
}

class PDFFontLoader {
  static PDFFonts? _cached;

  static Future<PDFFonts> load() async {
    if (_cached != null) return _cached!;

    final regular = await rootBundle.load("assets/fonts/Helvetica.ttf");
    final bold = await rootBundle.load("assets/fonts/Helvetica-Bold.ttf");
    final italic = await rootBundle.load("assets/fonts/Helvetica-Oblique.ttf");
    final boldItalic = await rootBundle.load("assets/fonts/Helvetica-BoldOblique.ttf");

    _cached = PDFFonts(
      regular: pw.Font.ttf(regular),
      bold: pw.Font.ttf(bold),
      italic: pw.Font.ttf(italic),
      boldItalic: pw.Font.ttf(boldItalic),
    );

    return _cached!;
  }

  static void clearCache() {
    _cached = null;
  }
}
```

---

## Styling Components

### Reusable Styles

```dart
// lib/utils/pdf_styles.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceStyles {
  // Page layout
  static const double pageMargin = 20; // mm
  static const PdfPageFormat pageFormat = PdfPageFormat.a4;

  // Typography
  static final pw.TextStyle firmName = pw.TextStyle(
    fontSize: 14,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.grey900,
  );

  static final pw.TextStyle sectionHeader = pw.TextStyle(
    fontSize: 11,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.grey700,
    letterSpacing: 0.5,
  );

  static final pw.TextStyle bodyText = pw.TextStyle(
    fontSize: 9,
    color: PdfColors.grey800,
  );

  static final pw.TextStyle bodyTextBold = pw.TextStyle(
    fontSize: 9,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.grey800,
  );

  static final pw.TextStyle caption = pw.TextStyle(
    fontSize: 8,
    color: PdfColors.grey600,
  );

  // Colors
  static const PdfColor primaryColor = PdfColors.blue700;
  static const PdfColor accentColor = PdfColors.blue50;
  static const PdfColor borderColor = PdfColors.grey400;
  static const PdfColor backgroundColor = PdfColors.grey50;

  // Decorations
  static pw.BoxDecoration tableCellBorder = pw.BoxDecoration(
    border: pw.Border.all(color: borderColor, width: 0.5),
  );

  static pw.BoxDecoration tableHeaderDecoration = pw.BoxDecoration(
    color: accentColor,
    border: pw.Border.all(color: borderColor),
  );

  static pw.BoxDecoration sectionBoxDecoration = pw.BoxDecoration(
    border: pw.Border.all(color: borderColor),
    borderRadius: pw.BorderRadius.circular(4),
  );
}
```

### Currency Formatter

```dart
// lib/utils/currency_formatter.dart
String formatCurrency(double amount, {String symbol = '₹'}) {
  final isNegative = amount < 0;
  final absAmount = amount.abs();

  final formatted = absAmount.toStringAsFixed(2);
  final parts = formatted.split('.');
  final intPart = parts[0];
  final decPart = parts[1];

  // Indian number formatting (lakhs/crores)
  String formattedInt;
  if (intPart.length > 3) {
    final lastThree = intPart.substring(intPart.length - 3);
    final remaining = intPart.substring(0, intPart.length - 3);

    final regEx = RegExp(r'(\d)(?=(\d{2})+$)');
    formattedInt = remaining.replaceAllMapped(regEx, (match) => '${match.group(1)},');
    formattedInt = '$formattedInt,$lastThree';
  } else {
    formattedInt = intPart;
  }

  final result = '$symbol$formattedInt.$decPart';
  return isNegative ? '-$result' : result;
}
```

---

## PDF Service Integration

### Main Service

```dart
// lib/services/invoice_pdf_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import '../templates/template_registry.dart';
import '../widgets/pdf_preview_screen.dart';

class InvoicePDFService {
  static final InvoicePDFService _instance = InvoicePDFService._internal();
  factory InvoicePDFService() => _instance;
  InvoicePDFService._internal();

  /// Show PDF preview screen
  Future<void> previewInvoice({
    required BuildContext context,
    required InvoicePDFData data,
    String templateId = 'classic',
  }) async {
    final template = TemplateRegistry.getTemplate(templateId);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFPreviewScreen(
          invoiceData: data,
          template: template,
        ),
      ),
    );
  }

  /// Generate PDF bytes
  Future<Uint8List> generatePDF({
    required InvoicePDFData data,
    String templateId = 'classic',
  }) async {
    final template = TemplateRegistry.getTemplate(templateId);
    final pdfDocument = await template.generate(data);
    return await pdfDocument.save();
  }

  /// Save PDF to device
  Future<File> savePDF({
    required InvoicePDFData data,
    String templateId = 'classic',
    String? customFileName,
  }) async {
    final bytes = await generatePDF(data: data, templateId: templateId);

    final directory = await getApplicationDocumentsDirectory();
    final fileName = customFileName ?? '${data.invoiceNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf';
    final file = File('${directory.path}/$fileName');

    await file.writeAsBytes(bytes);
    return file;
  }

  /// Share PDF
  Future<void> sharePDF({
    required InvoicePDFData data,
    String templateId = 'classic',
    String? subject,
  }) async {
    final file = await savePDF(data: data, templateId: templateId);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: subject ?? 'Invoice ${data.invoiceNumber}',
    );
  }

  /// Print PDF
  Future<void> printPDF({
    required InvoicePDFData data,
    String templateId = 'classic',
  }) async {
    final template = TemplateRegistry.getTemplate(templateId);

    await Printing.layoutPdf(
      onLayout: (format) => template.generate(data).then((doc) => doc.save()),
      name: '${data.invoiceNumber}.pdf',
    );
  }

  /// Fetch invoice data from Firestore
  Future<InvoicePDFData> fetchInvoiceData(String invoiceId) async {
    // TODO: Implement Firestore queries
    // final invoiceDoc = await FirebaseFirestore.instance
    //     .collection('billing')
    //     .doc(userId)
    //     .collection('invoices')
    //     .doc(invoiceId)
    //     .get();
    //
    // final invoiceStruct = InvoiceStruct.fromMap(invoiceDoc.data()!);
    //
    // final firmDoc = await invoiceStruct.sellerFirm.get();
    // final firmRecord = FirmsRecord.fromMap(firmDoc.data()!);
    //
    // return InvoicePDFData(
    //   invoice: invoiceStruct,
    //   firm: firmRecord,
    // );

    throw UnimplementedError('Fetch invoice data from Firestore');
  }
}
```

### Preview Screen Widget

```dart
// lib/widgets/pdf_preview_screen.dart
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class PDFPreviewScreen extends StatelessWidget {
  final InvoicePDFData invoiceData;
  final InvoiceTemplate template;

  const PDFPreviewScreen({
    Key? key,
    required this.invoiceData,
    required this.template,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Preview'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            tooltip: 'Share PDF',
            onPressed: () => _sharePDF(context),
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => template.generate(invoiceData).then((doc) => doc.save()),
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: true,
        allowSharing: true,
        pdfFileName: '${invoiceData.invoiceNumber}.pdf',
      ),
    );
  }

  Future<void> _sharePDF(BuildContext context) async {
    await InvoicePDFService().sharePDF(
      data: invoiceData,
      templateId: template.templateId,
    );
  }
}
```

---

## Platform-Specific Considerations

### Web Platform

```dart
import 'dart:html' as html;

Future<void> downloadPDFWeb(Uint8List bytes, String fileName) async {
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement()
    ..href = url
    ..download = fileName
    ..click();
  html.Url.revokeObjectUrl(url);
}
```

### Mobile Platform

```dart
import 'package:open_file/open_file.dart';

Future<void> openPDFMobile(File file) async {
  await OpenFile.open(file.path);
}
```

### Desktop Platform

```dart
Future<void> printPDFDesktop(Uint8List bytes) async {
  await Printing.layoutPdf(
    onLayout: (format) async => bytes,
    name: 'invoice.pdf',
  );
}
```

---

## Performance Optimization

### Caching Strategy

```dart
class PDFCache {
  static final Map<String, Uint8List> _cache = {};
  static const int maxCacheSize = 10; // PDFs

  static Future<Uint8List> getOrGenerate(
    String cacheKey,
    Future<Uint8List> Function() generator,
  ) async {
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    final bytes = await generator();

    // Evict oldest if cache full
    if (_cache.length >= maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }

    _cache[cacheKey] = bytes;
    return bytes;
  }

  static void clear() => _cache.clear();

  static void remove(String key) => _cache.remove(key);
}

// Usage
final bytes = await PDFCache.getOrGenerate(
  'invoice_${invoiceId}_${templateId}',
  () => InvoicePDFService().generatePDF(data: data, templateId: templateId),
);
```

### Image Optimization

```dart
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;

Future<pw.ImageProvider> loadOptimizedImage(String url) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;

  // Compress if too large
  if (bytes.length > 500 * 1024) { // 500KB threshold
    final compressed = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 800,
      minHeight: 600,
      quality: 85,
    );
    return pw.MemoryImage(Uint8List.fromList(compressed));
  }

  return pw.MemoryImage(bytes);
}
```

### Background Generation

```dart
import 'dart:isolate';

Future<Uint8List> generatePDFInBackground(InvoicePDFData data) async {
  final receivePort = ReceivePort();

  await Isolate.spawn(
    _generatePDFIsolate,
    [receivePort.sendPort, data],
  );

  return await receivePort.first as Uint8List;
}

void _generatePDFIsolate(List<dynamic> args) async {
  final sendPort = args[0] as SendPort;
  final data = args[1] as InvoicePDFData;

  final template = ClassicInvoiceTemplate();
  final pdf = await template.generate(data);
  final bytes = await pdf.save();

  sendPort.send(bytes);
}
```

---

## Comparison with Cloud Generation

| Feature | Flutter (Client-Side) | Cloud (Server-Side) |
|---------|----------------------|---------------------|
| **Generation Speed** | <100ms | 2-5 seconds (cold start) |
| **Offline Support** | ✅ Yes | ❌ No |
| **Preview Quality** | ✅ Native, high-quality | ⚠️ Requires separate call |
| **Cost per Invoice** | Free | $0.01-0.05 |
| **Template Updates** | App update required | Instant (template upload) |
| **App Size Impact** | +2-5MB | None |
| **Platform Support** | iOS, Android, Web, Desktop | Universal |
| **Customization** | Per-user (local prefs) | Global/per-tenant |
| **Maintenance** | Client-side code | Server infrastructure |

### When to Use Flutter

- Instant preview is critical
- Offline functionality needed
- High volume of invoices
- Cost-sensitive scenarios
- User-specific customization

### When to Use Cloud

- Template marketplace
- Non-developer template editing
- Email delivery integration
- Consistent cross-platform output
- Template A/B testing

### Hybrid Approach

```dart
class HybridPDFService {
  Future<Uint8List> generatePDF({
    required InvoicePDFData data,
    bool preferCloud = false,
  }) async {
    if (preferCloud && await _isOnline()) {
      try {
        return await _generateCloudPDF(data);
      } catch (e) {
        debugPrint('Cloud generation failed, falling back to Flutter: $e');
      }
    }

    // Default: Flutter generation
    return await InvoicePDFService().generatePDF(data: data);
  }

  Future<bool> _isOnline() async {
    // Check connectivity
    return true;
  }

  Future<Uint8List> _generateCloudPDF(InvoicePDFData data) async {
    // Call Cloud Function
    throw UnimplementedError();
  }
}
```

---

## Migration Strategy

### Phase 1: Parallel Implementation (Weeks 1-2)

```dart
// Feature flag for gradual rollout
class FeatureFlags {
  static bool get useFlutterPDF => true; // Toggle via remote config
}

// Usage
if (FeatureFlags.useFlutterPDF) {
  await InvoicePDFService().previewInvoice(context: context, data: data);
} else {
  await CloudPDFService().generateAndPreview(data);
}
```

### Phase 2: A/B Testing (Weeks 3-4)

```dart
// Track metrics
class PDFAnalytics {
  static void trackGeneration({
    required String method, // 'flutter' or 'cloud'
    required Duration duration,
    required int fileSizeBytes,
    bool success = true,
  }) {
    // Firebase Analytics
  }
}
```

### Phase 3: Full Migration (Week 5+)

- Monitor crash rates and errors
- Compare user feedback
- Gradually increase Flutter usage percentage
- Keep cloud as fallback for 1-2 months

---

## Troubleshooting

### Common Issues

#### 1. Fonts Not Rendering

**Problem:** Text appears as boxes or default system font

**Solution:**
```dart
// Ensure fonts are loaded before generation
final fonts = await PDFFontLoader.load();

// Apply theme correctly
theme: pw.ThemeData.withFont(
  base: fonts.regular,
  bold: fonts.bold,
)
```

#### 2. Images Not Displaying

**Problem:** Logo or signature not showing

**Solution:**
```dart
// Load image from network with error handling
Future<pw.ImageProvider?> loadImage(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    }
  } catch (e) {
    debugPrint('Failed to load image: $e');
  }
  return null;
}

// Use with null check
if (logoImage != null) {
  pw.Image(logoImage, width: 80, height: 80)
}
```

#### 3. Table Overflow

**Problem:** Table doesn't fit on page

**Solution:**
```dart
// Use TableHelper for auto-pagination
pw.TableHelper.fromTextArray(
  context: context,
  data: tableData,
  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
  cellAlignment: pw.Alignment.centerLeft,
  cellPadding: pw.EdgeInsets.all(5),
)
```

#### 4. PDF Too Large

**Problem:** File size exceeds limits

**Solution:**
```dart
// Compress images before embedding
final compressed = await FlutterImageCompress.compressWithList(
  imageBytes,
  quality: 85,
  minWidth: 800,
);

// Remove unnecessary data
final optimizedData = data.copyWith(
  invoice: data.invoice.copyWith(
    // Remove base64 images if using URLs
  ),
);
```

#### 5. Slow Generation

**Problem:** PDF takes >1 second to generate

**Solution:**
```dart
// Use isolates for complex PDFs
Future<Uint8List> generateFast(InvoicePDFData data) async {
  return await compute(_generatePDF, data);
}

static Future<Uint8List> _generatePDF(InvoicePDFData data) async {
  final template = ClassicInvoiceTemplate();
  final pdf = await template.generate(data);
  return await pdf.save();
}
```

---

## Next Steps

1. **Setup**: Install dependencies and configure fonts
2. **Implementation**: Choose and implement template(s)
3. **Testing**: Use Testing.md guide for Chrome preview setup
4. **Integration**: Connect to Firestore data sources
5. **Deployment**: Gradual rollout with feature flags

For testing and development workflow, see **[Testing.md](./Testing.md)**.

For server-side generation, see **[Cloud Invoice Gen.md](./Cloud%20Invoice%20Gen.md)**.

---

## Resources

- [printing package documentation](https://pub.dev/packages/printing)
- [pdf package documentation](https://pub.dev/packages/pdf)
- [Flutter PDF examples](https://github.com/DavBfr/dart_pdf/tree/master/printing/example)
- Helvetica font: [Download from authorized source]

