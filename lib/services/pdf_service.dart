import 'dart:typed_data';
import 'package:printing/printing.dart';
import '../models/invoice_data.dart';
import '../utils/invoice_colors.dart';
import '../utils/pdf_font_helpers.dart';
import 'template_registry.dart';

class PDFService {
  static final PDFService _instance = PDFService._internal();
  factory PDFService() => _instance;
  PDFService._internal();

  /// Generate PDF bytes for an invoice
  Future<Uint8List> generatePDF({
    required InvoiceData invoice,
    required String templateId,
    InvoiceColorTheme? colorTheme,
  }) async {
    // Load fonts to support ₹ symbol and Unicode characters
    await PDFFontHelpers.loadFonts();

    final template = TemplateRegistry.getTemplate(templateId);
    final pdfDocument = await template.generatePDF(
      invoice: invoice,
      colorTheme: colorTheme,
    );
    return await pdfDocument.save();
  }

  /// Preview and print invoice
  Future<void> printInvoice({
    required InvoiceData invoice,
    required String templateId,
    InvoiceColorTheme? colorTheme,
  }) async {
    await Printing.layoutPdf(
      onLayout: (format) => generatePDF(
        invoice: invoice,
        templateId: templateId,
        colorTheme: colorTheme,
      ),
      name: '${invoice.fullInvoiceNumber}.pdf',
    );
  }

  /// Share PDF
  Future<void> sharePDF({
    required InvoiceData invoice,
    required String templateId,
    InvoiceColorTheme? colorTheme,
  }) async {
    final bytes = await generatePDF(
      invoice: invoice,
      templateId: templateId,
      colorTheme: colorTheme,
    );
    await Printing.sharePdf(
      bytes: bytes,
      filename: '${invoice.fullInvoiceNumber}.pdf',
    );
  }
}
