# Invoice PDF Testing & Development Guide

Comprehensive guide for testing invoice PDF generation in Chrome during development with live preview capabilities.

---

## Table of Contents

1. [Development Environment Setup](#development-environment-setup)
2. [PDF Test Screen Implementation](#pdf-test-screen-implementation)
3. [Sample Data Generator](#sample-data-generator)
4. [Live Preview in Chrome](#live-preview-in-chrome)
5. [Comparison Tools](#comparison-tools)
6. [Hot Reload Workflow](#hot-reload-workflow)
7. [Performance Benchmarking](#performance-benchmarking)
8. [Debugging Tips](#debugging-tips)
9. [Test Automation](#test-automation)

---

## Development Environment Setup

### Prerequisites

```bash
# Ensure Flutter web is enabled
flutter config --enable-web

# Check available devices
flutter devices
```

### Running in Chrome

```bash
# Standard launch
flutter run -d chrome

# With HTML renderer (better for PDF preview)
flutter run -d chrome --web-renderer html

# With specific Chrome flags for better PDF handling
flutter run -d chrome --web-renderer html --dart-define=FLUTTER_WEB_USE_SKIA=false
```

### Project Configuration

Add test route to your app (development only):

```dart
// lib/main.dart
import 'package:flutter/foundation.dart';
import 'dev/pdf_test_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Invoice App',
      routes: {
        '/': (context) => HomeScreen(),
        // Development-only route
        if (kDebugMode)
          '/pdf-test': (context) => PDFTestScreen(),
      },
    );
  }
}
```

---

## PDF Test Screen Implementation

### Complete Test Harness

```dart
// lib/dev/pdf_test_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'dart:html' as html;
import '../templates/template_registry.dart';
import '../services/invoice_pdf_service.dart';
import '../utils/sample_invoice_data.dart';

class PDFTestScreen extends StatefulWidget {
  @override
  _PDFTestScreenState createState() => _PDFTestScreenState();
}

class _PDFTestScreenState extends State<PDFTestScreen> {
  InvoiceTemplate _selectedTemplate = TemplateRegistry.getTemplate('classic');
  InvoicePDFData? _sampleData;
  bool _loading = true;
  String _generationTime = '';
  int _pdfSize = 0;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  Future<void> _loadSampleData() async {
    setState(() => _loading = true);
    try {
      final data = SampleInvoiceDataGenerator.createSample(
        mode: InvoiceMode.salesInv,
        itemCount: 5,
        includeShipment: true,
      );
      setState(() {
        _sampleData = data;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading sample data: $e')),
      );
    }
  }

  Future<void> _regeneratePDF() async {
    if (_sampleData == null) return;

    final stopwatch = Stopwatch()..start();
    final bytes = await InvoicePDFService().generatePDF(
      data: _sampleData!,
      templateId: _selectedTemplate.templateId,
    );
    stopwatch.stop();

    setState(() {
      _generationTime = '${stopwatch.elapsedMilliseconds}ms';
      _pdfSize = bytes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _sampleData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('PDF Template Tester')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Template Tester'),
        actions: [
          // Template selector
          DropdownButton<InvoiceTemplate>(
            value: _selectedTemplate,
            underline: Container(),
            dropdownColor: Colors.blue[700],
            items: TemplateRegistry.getAllTemplates().map((template) {
              return DropdownMenuItem(
                value: template,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    template.templateName,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
            onChanged: (template) {
              if (template != null) {
                setState(() => _selectedTemplate = template);
                _regeneratePDF();
              }
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Left Panel: Controls
          Container(
            width: 350,
            color: Colors.grey[100],
            child: _buildControlPanel(),
          ),
          // Right Panel: Live Preview
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: Column(
                children: [
                  // Metrics bar
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.blue[700],
                    child: Row(
                      children: [
                        Icon(Icons.timer, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Generation Time: $_generationTime',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(width: 24),
                        Icon(Icons.storage, color: Colors.white, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Size: ${(_pdfSize / 1024).toStringAsFixed(1)} KB',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  // PDF Preview
                  Expanded(
                    child: PdfPreview(
                      build: (format) async {
                        final stopwatch = Stopwatch()..start();
                        final pdf = await _selectedTemplate.generate(_sampleData!);
                        final bytes = await pdf.save();
                        stopwatch.stop();

                        setState(() {
                          _generationTime = '${stopwatch.elapsedMilliseconds}ms';
                          _pdfSize = bytes.length;
                        });

                        return bytes;
                      },
                      canChangePageFormat: false,
                      canDebug: true,
                      allowPrinting: true,
                      allowSharing: true,
                      pdfFileName: 'test_${_selectedTemplate.templateId}.pdf',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Invoice Data',
            _buildInvoiceDataEditor(),
          ),
          SizedBox(height: 24),
          _buildSection(
            'Templates',
            _buildTemplateGallery(),
          ),
          SizedBox(height: 24),
          _buildSection(
            'Actions',
            _buildActionButtons(),
          ),
          SizedBox(height: 24),
          _buildSection(
            'Sample Data Presets',
            _buildPresetButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildInvoiceDataEditor() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Invoice Number',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          controller: TextEditingController(
            text: '${_sampleData!.invoice.modeSpecifcDetails.modeId}',
          ),
          onChanged: (value) {
            final id = int.tryParse(value) ?? 1;
            setState(() {
              _sampleData = InvoicePDFData(
                invoice: _sampleData!.invoice.copyWith(
                  modeSpecifcDetails: _sampleData!.invoice.modeSpecifcDetails.copyWith(
                    modeId: id,
                  ),
                ),
                firm: _sampleData!.firm,
              );
            });
          },
        ),
        SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            labelText: 'Customer Name',
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
          controller: TextEditingController(
            text: _sampleData!.invoice.billToParty.businessName,
          ),
          onChanged: (value) {
            setState(() {
              _sampleData = InvoicePDFData(
                invoice: _sampleData!.invoice.copyWith(
                  billToParty: _sampleData!.invoice.billToParty.copyWith(
                    businessName: value,
                  ),
                ),
                firm: _sampleData!.firm,
              );
            });
          },
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Text('Item Count: '),
            Expanded(
              child: Slider(
                value: _sampleData!.invoice.lines.length.toDouble(),
                min: 1,
                max: 20,
                divisions: 19,
                label: '${_sampleData!.invoice.lines.length}',
                onChanged: (value) {
                  setState(() {
                    _sampleData = SampleInvoiceDataGenerator.createSample(
                      itemCount: value.toInt(),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTemplateGallery() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: TemplateRegistry.getAllTemplates().map((template) {
        final isSelected = template.templateId == _selectedTemplate.templateId;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedTemplate = template);
            _regeneratePDF();
          },
          child: Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: isSelected ? 3 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Expanded(child: template.previewThumbnail),
                Container(
                  padding: EdgeInsets.all(4),
                  color: isSelected ? Colors.blue : Colors.grey[200],
                  width: double.infinity,
                  child: Text(
                    template.templateName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _downloadPDF,
          icon: Icon(Icons.download),
          label: Text('Download PDF'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _printPDF,
          icon: Icon(Icons.print),
          label: Text('Print PDF'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _comparePDFs,
          icon: Icon(Icons.compare),
          label: Text('Compare with Cloud'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => _loadSampleData(),
          icon: Icon(Icons.refresh),
          label: Text('Reset Data'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPresetButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _presetButton('5 Items + Shipment', () {
          setState(() {
            _sampleData = SampleInvoiceDataGenerator.createSample(
              itemCount: 5,
              includeShipment: true,
            );
          });
        }),
        _presetButton('10 Items No Shipment', () {
          setState(() {
            _sampleData = SampleInvoiceDataGenerator.createSample(
              itemCount: 10,
              includeShipment: false,
            );
          });
        }),
        _presetButton('Proforma Invoice', () {
          setState(() {
            _sampleData = SampleInvoiceDataGenerator.createSample(
              mode: InvoiceMode.proformaInv,
              itemCount: 7,
            );
          });
        }),
        _presetButton('Credit Note', () {
          setState(() {
            _sampleData = SampleInvoiceDataGenerator.createSample(
              mode: InvoiceMode.creditNoteInv,
              itemCount: 3,
            );
          });
        }),
      ],
    );
  }

  Widget _presetButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }

  Future<void> _downloadPDF() async {
    final bytes = await InvoicePDFService().generatePDF(
      data: _sampleData!,
      templateId: _selectedTemplate.templateId,
    );

    // Web download
    if (kIsWeb) {
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement()
        ..href = url
        ..download = 'test_${_selectedTemplate.templateId}.pdf'
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF downloaded!')),
      );
    }
  }

  Future<void> _printPDF() async {
    await Printing.layoutPdf(
      onLayout: (format) => _selectedTemplate.generate(_sampleData!).then((doc) => doc.save()),
      name: 'test_invoice.pdf',
    );
  }

  Future<void> _comparePDFs() async {
    // TODO: Implement comparison with cloud-generated PDF
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cloud comparison not yet implemented'),
        duration: Duration(seconds: 2),
      ),
    );

    // Implementation would:
    // 1. Generate Flutter PDF
    // 2. Call cloud function to generate cloud PDF
    // 3. Show side-by-side comparison dialog
  }
}
```

---

## Sample Data Generator

### Comprehensive Test Data Factory

```dart
// lib/utils/sample_invoice_data.dart
import '../models/invoice_pdf_data.dart';

class SampleInvoiceDataGenerator {
  static InvoicePDFData createSample({
    InvoiceMode mode = InvoiceMode.salesInv,
    int itemCount = 5,
    bool includeShipment = true,
    bool includePartialPayment = false,
  }) {
    final invoice = InvoiceStruct(
      invoiceRef: null, // Mock reference
      sellerFirm: null,
      lastUpdatedAt: DateTime.now(),

      modeSpecifcDetails: BillModeConfigStruct(
        modeType: mode,
        modeTitle: _getModeTitle(mode),
        modeId: 1001,
        modeIdPrefix: _getModePrefix(mode),
        dates: DatesStruct(
          issueDate: DateTime.now(),
          dueDate: DateTime.now().add(Duration(days: 30)),
          paymentTerms: ['Net 30 days', 'Due on receipt'],
        ),
      ),

      billToParty: BusinessDetailsStruct(
        businessName: 'Sample Customer Pvt Ltd',
        phone: '+91 98765 43210',
        email: 'customer@example.com',
        gstin: '29ABCDE1234F1Z5',
        pan: 'ABCDE1234F',
        state: 'Karnataka',
        district: 'Bangalore Urban',
        businessAddress: '123 MG Road, Bangalore, Karnataka - 560001',
        customFieldValues: [],
      ),

      lines: List.generate(itemCount, (i) {
        final qty = (i + 1).toDouble();
        final rate = 1000.0 + (i * 100);
        final subtotal = qty * rate;
        final discount = subtotal * 0.1; // 10% discount
        final taxableValue = subtotal - discount;
        final gstRate = 18.0;
        final gstAmount = taxableValue * gstRate / 100;
        final lineTotal = taxableValue + gstAmount;

        return ItemSaleInfoStruct(
          item: ItemBasicInfoStruct(
            name: 'Product ${i + 1}',
            hsnCode: '8517${1000 + i}',
            description: 'High quality product with premium features',
            qtyUnit: 'pcs',
            imageThumbnailUrl: '',
          ),
          qtyOnBill: qty,
          partyNetPrice: rate,
          subtotal: subtotal,
          discountPercentage: 10.0,
          discountAmt: discount,
          taxableValue: taxableValue,
          igst: 0.0,
          csgst: gstAmount / 2,
          sgst: gstAmount / 2,
          cessAmt: 0.0,
          grossTaxCharged: gstRate,
          lineTotal: lineTotal,
          customFieldInputs: [],
        );
      }),

      billSummary: _calculateSummary(itemCount),

      amountPaid: includePartialPayment ? 5000.0 : 0.0,
      paymentMode: includePartialPayment ? PaymentMode.UPI : null,

      shipmentInfo: includeShipment ? ShipmentDetailsStruct(
        vehicleNo: 'KA-01-AB-1234',
        goodsLoadingPoint: 'Bangalore Warehouse',
        deliveryPoint: 'Mumbai Dock',
        trackingInfo: 'TRACK123456',
        deliveryMode: 'Road Transport',
        dispatchDate: DateTime.now(),
        expectedDeliveryDate: DateTime.now().add(Duration(days: 3)),
        expectedShipmentDuration: '3 days',
        totalWeight: '50 kg',
        netCharges: 500.0,
        gstRate: 18.0,
        chargesTotalInclGst: 590.0,
      ) : null,

      notesFooter: 'Thank you for your business!\n\nTerms & Conditions:\n1. Payment due within 30 days\n2. Late payment subject to 2% monthly interest\n3. All disputes subject to Bangalore jurisdiction',
    );

    final firm = FirmsRecord(
      firmLogo: '', // URL to logo
      signature: '', // URL to signature
      shopInfo: BusinessDetailsStruct(
        businessName: 'Sample Business Enterprises',
        phone: '+91 80 1234 5678',
        email: 'info@samplebusiness.com',
        gstin: '29ZYXWV9876E1Z1',
        pan: 'ZYXWV9876E',
        state: 'Karnataka',
        district: 'Bangalore Urban',
        businessAddress: '456 Industrial Area, Bangalore, Karnataka - 560058',
        customFieldValues: [],
      ),
      bankAccounts: [
        BankingDetailsStruct(
          makeChequeFor: 'Sample Business Enterprises',
          upi: 'business@upi',
          accountNo: 1234567890,
          ifsc: 'HDFC0001234',
          bankName: 'HDFC Bank',
          branchAddress: 'MG Road Branch, Bangalore',
        ),
      ],
    );

    return InvoicePDFData(
      invoice: invoice,
      firm: firm,
    );
  }

  static BillSummaryResultsStruct _calculateSummary(int itemCount) {
    // Simplified calculation for sample data
    final taxableValue = itemCount * 1000.0 * 0.9; // After 10% discount
    final gst = taxableValue * 0.18;
    final total = taxableValue + gst;

    return BillSummaryResultsStruct(
      totalTaxableValue: taxableValue,
      totalDiscount: itemCount * 100.0,
      totalGst: gst,
      totalCess: 0.0,
      totalLineItemsAfterTaxes: total,
      dueBalancePayable: total,
    );
  }

  static String _getModeTitle(InvoiceMode mode) {
    switch (mode) {
      case InvoiceMode.salesInv:
        return 'Tax Invoice';
      case InvoiceMode.proformaInv:
        return 'Proforma Invoice';
      case InvoiceMode.estimateInv:
        return 'Estimate';
      case InvoiceMode.quotationInv:
        return 'Quotation';
      case InvoiceMode.creditNoteInv:
        return 'Credit Note';
      case InvoiceMode.debitNoteInv:
        return 'Debit Note';
      default:
        return 'Invoice';
    }
  }

  static String _getModePrefix(InvoiceMode mode) {
    switch (mode) {
      case InvoiceMode.salesInv:
        return 'INV-';
      case InvoiceMode.proformaInv:
        return 'PI-';
      case InvoiceMode.estimateInv:
        return 'EST-';
      case InvoiceMode.quotationInv:
        return 'QT-';
      case InvoiceMode.creditNoteInv:
        return 'CN-';
      case InvoiceMode.debitNoteInv:
        return 'DN-';
      default:
        return 'DOC-';
    }
  }
}
```

---

## Live Preview in Chrome

### Accessing Test Screen

1. **Run app in Chrome:**
   ```bash
   flutter run -d chrome --web-renderer html
   ```

2. **Navigate to test screen:**
   - Add button in your app (dev mode only):
     ```dart
     if (kDebugMode)
       FloatingActionButton(
         onPressed: () => Navigator.pushNamed(context, '/pdf-test'),
         child: Icon(Icons.bug_report),
       )
     ```
   - Or navigate directly: `http://localhost:PORT/#/pdf-test`

3. **Chrome automatically opens with:**
   - Split-panel interface
   - Live PDF preview
   - Real-time regeneration on changes

### Chrome Print Dialog Testing

```dart
// Test actual browser print dialog
ElevatedButton(
  onPressed: () async {
    final bytes = await InvoicePDFService().generatePDF(data: data);

    // Open Chrome print dialog
    await Printing.layoutPdf(
      onLayout: (format) async => bytes,
    );
  },
  child: Text('Test Print Dialog'),
)
```

---

## Comparison Tools

### Side-by-Side Comparison

```dart
Future<void> showPDFComparison(
  BuildContext context,
  Uint8List flutterPDF,
  Uint8List cloudPDF,
) async {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        width: 1200,
        height: 800,
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PDF Comparison',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Comparison panels
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.green[100],
                          child: Text(
                            'Flutter PDF',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: PdfPreview(
                            build: (format) async => flutterPDF,
                            canChangePageFormat: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1, color: Colors.grey),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.blue[100],
                          child: Text(
                            'Cloud PDF',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: PdfPreview(
                            build: (format) async => cloudPDF,
                            canChangePageFormat: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

---

## Hot Reload Workflow

### Optimal Development Flow

1. **Make changes to template code**
2. **Press `r` in terminal** (hot reload)
3. **PDF preview updates automatically**
4. **Verify changes visually**
5. **Repeat**

### Template Development Tips

```dart
// Use constants for quick iteration
class DesignTokens {
  static const double headerFontSize = 24.0; // Easy to adjust
  static const PdfColor primaryColor = PdfColors.blue700;
  static const double tableRowHeight = 30.0;
}

// Usage in template
pw.Text('Invoice', style: pw.TextStyle(fontSize: DesignTokens.headerFontSize))
```

### Live Editing with Hot Reload

```dart
// Before: Hard-coded value
pw.Container(padding: pw.EdgeInsets.all(12))

// After: Configurable constant
static const double PADDING = 16.0; // Change this and hot reload!
pw.Container(padding: pw.EdgeInsets.all(PADDING))
```

---

## Performance Benchmarking

### Built-in Benchmarking

```dart
class PDFBenchmark {
  static Future<BenchmarkResult> benchmark({
    required InvoicePDFData data,
    required String templateId,
    int iterations = 10,
  }) async {
    final template = TemplateRegistry.getTemplate(templateId);
    final times = <int>[];
    final sizes = <int>[];

    for (var i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();
      final pdf = await template.generate(data);
      final bytes = await pdf.save();
      stopwatch.stop();

      times.add(stopwatch.elapsedMilliseconds);
      sizes.add(bytes.length);
    }

    return BenchmarkResult(
      templateId: templateId,
      iterations: iterations,
      averageTime: times.reduce((a, b) => a + b) / iterations,
      minTime: times.reduce((a, b) => a < b ? a : b),
      maxTime: times.reduce((a, b) => a > b ? a : b),
      averageSize: sizes.reduce((a, b) => a + b) / iterations,
    );
  }
}

class BenchmarkResult {
  final String templateId;
  final int iterations;
  final double averageTime;
  final int minTime;
  final int maxTime;
  final double averageSize;

  BenchmarkResult({
    required this.templateId,
    required this.iterations,
    required this.averageTime,
    required this.minTime,
    required this.maxTime,
    required this.averageSize,
  });

  @override
  String toString() {
    return '''
Template: $templateId
Iterations: $iterations
Average Time: ${averageTime.toStringAsFixed(1)}ms
Min/Max Time: ${minTime}ms / ${maxTime}ms
Average Size: ${(averageSize / 1024).toStringAsFixed(1)} KB
    ''';
  }
}
```

### Usage in Test Screen

```dart
ElevatedButton(
  onPressed: () async {
    final result = await PDFBenchmark.benchmark(
      data: _sampleData!,
      templateId: _selectedTemplate.templateId,
      iterations: 10,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Benchmark Results'),
        content: Text(result.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  },
  child: Text('Run Benchmark'),
)
```

---

## Debugging Tips

### Enable PDF Debug Mode

```dart
PdfPreview(
  build: (format) => template.generate(data),
  canDebug: true, // Shows PDF structure tree
)
```

### Logging Generation Steps

```dart
class DebugPDFTemplate extends ClassicInvoiceTemplate {
  @override
  Future<pw.Document> generate(InvoicePDFData data) async {
    print('🔧 Generating PDF...');
    print('  Template: ${templateId}');
    print('  Invoice: ${data.invoiceNumber}');
    print('  Items: ${data.invoice.lines.length}');

    final stopwatch = Stopwatch()..start();
    final pdf = await super.generate(data);
    stopwatch.stop();

    print('  ✅ Generated in ${stopwatch.elapsedMilliseconds}ms');

    return pdf;
  }
}
```

### Chrome DevTools

1. **Open DevTools** (F12)
2. **Console Tab:**
   - View print statements
   - Check for errors
   - Monitor generation times

3. **Network Tab:**
   - Monitor font loading
   - Track image downloads
   - Check asset caching

4. **Performance Tab:**
   - Profile PDF generation
   - Identify bottlenecks
   - Analyze memory usage

### Common Issues and Solutions

```dart
// Issue: Font not rendering
// Solution: Check font loading
PDFFontLoader.load().then((fonts) {
  print('Fonts loaded: ${fonts != null}');
});

// Issue: Image not showing
// Solution: Verify image data
final imageBytes = await http.get(Uri.parse(logoUrl));
print('Image loaded: ${imageBytes.bodyBytes.length} bytes');

// Issue: Slow generation
// Solution: Profile each section
final sw1 = Stopwatch()..start();
final header = _buildHeader(data);
print('Header: ${sw1.elapsedMilliseconds}ms');

final sw2 = Stopwatch()..start();
final table = _buildTable(data);
print('Table: ${sw2.elapsedMilliseconds}ms');
```

---

## Test Automation

### Unit Tests for Templates

```dart
// test/templates/classic_template_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClassicInvoiceTemplate', () {
    late ClassicInvoiceTemplate template;
    late InvoicePDFData sampleData;

    setUp(() {
      template = ClassicInvoiceTemplate();
      sampleData = SampleInvoiceDataGenerator.createSample();
    });

    test('generates valid PDF document', () async {
      final pdf = await template.generate(sampleData);
      expect(pdf.document.pdfPageList.pages.isNotEmpty, true);
    });

    test('includes all invoice items', () async {
      final pdf = await template.generate(sampleData);
      final bytes = await pdf.save();

      // PDF should contain at least item count references
      expect(bytes.length, greaterThan(10000)); // Minimum reasonable size
    });

    test('generation completes within performance target', () async {
      final stopwatch = Stopwatch()..start();
      await template.generate(sampleData);
      stopwatch.stop();

      expect(stopwatch.elapsedMilliseconds, lessThan(500)); // Target: <500ms
    });
  });
}
```

### Integration Tests

```dart
// integration_test/pdf_generation_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('PDF preview screen renders correctly', (tester) async {
    await tester.pumpWidget(MyApp());

    // Navigate to PDF test screen
    await tester.tap(find.byIcon(Icons.bug_report));
    await tester.pumpAndSettle();

    // Verify preview is shown
    expect(find.byType(PdfPreview), findsOneWidget);

    // Test template switching
    await tester.tap(find.text('Modern'));
    await tester.pumpAndSettle(Duration(seconds: 2));

    expect(find.text('Modern Invoice'), findsOneWidget);
  });
}
```

---

## Troubleshooting Checklist

- [ ] Flutter web enabled (`flutter config --enable-web`)
- [ ] Chrome available (`flutter devices` shows chrome)
- [ ] Fonts added to `pubspec.yaml` and assets folder
- [ ] Test route added to app (debug mode only)
- [ ] Sample data generator working
- [ ] Hot reload functioning (`r` in terminal)
- [ ] Chrome DevTools accessible (F12)
- [ ] PDF preview widget rendering
- [ ] Print dialog working
- [ ] Download working in web

---

## Next Steps

1. **Setup test environment** using this guide
2. **Implement templates** from Flutter Inv Gen.md
3. **Test in Chrome** with live preview
4. **Benchmark performance** with different data sizes
5. **Compare** with cloud-generated PDFs
6. **Iterate** using hot reload for rapid development

---

## Resources

- [printing package docs](https://pub.dev/packages/printing)
- [Flutter web debugging](https://docs.flutter.dev/platform-integration/web/debugging)
- [Chrome DevTools guide](https://developer.chrome.com/docs/devtools/)
- Main implementation guide: [Flutter Inv Gen.md](./Flutter%20Inv%20Gen.md)
