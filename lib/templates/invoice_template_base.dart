import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/invoice_data.dart';
import '../utils/invoice_colors.dart';

/// Base class for all invoice templates
abstract class InvoiceTemplate {
  /// Unique identifier for this template
  String get id;

  /// Display name for the template
  String get name;

  /// Description of the template
  String get description;

  /// Screenshot path for preview
  String get screenshotPath;

  /// Whether this template supports color themes
  bool get supportsColorThemes => false;

  /// Default color theme for this template
  InvoiceColorTheme get defaultColorTheme => InvoiceThemes.default$;

  /// Generate a PDF document from invoice data
  Future<pw.Document> generatePDF({
    required InvoiceData invoice,
    InvoiceColorTheme? colorTheme,
  });

  /// Build a Flutter widget preview of the invoice
  Widget buildPreview({
    required InvoiceData invoice,
    InvoiceColorTheme? colorTheme,
  });

  /// Get thumbnail widget for template selection UI
  Widget buildThumbnail() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(screenshotPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

/// Helper class for common PDF styling
class PDFStyles {
  static const double pageMargin = 20.0;
  static const PdfPageFormat pageFormat = PdfPageFormat.a4;

  static pw.TextStyle heading(PdfColor color) => pw.TextStyle(
        fontSize: 24,
        fontWeight: pw.FontWeight.bold,
        color: color,
      );

  static pw.TextStyle subheading(PdfColor color) => pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
        color: color,
      );

  static const pw.TextStyle body = pw.TextStyle(
    fontSize: 10,
    color: PdfColors.grey800,
  );

  static const pw.TextStyle bodyBold = pw.TextStyle(
    fontSize: 10,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.grey800,
  );

  static const pw.TextStyle small = pw.TextStyle(
    fontSize: 8,
    color: PdfColors.grey600,
  );

  static const pw.TextStyle smallBold = pw.TextStyle(
    fontSize: 8,
    fontWeight: pw.FontWeight.bold,
    color: PdfColors.grey600,
  );

  static pw.TextStyle tableHeader(PdfColor backgroundColor) => pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey900,
      );

  static pw.TextStyle get tableCell => const pw.TextStyle(
        fontSize: 9,
        color: PdfColors.grey800,
      );
}

/// Helper class for common Flutter preview styling
class PreviewStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle body = TextStyle(
    fontSize: 12,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle small = TextStyle(
    fontSize: 10,
    color: Colors.grey,
  );

  static const TextStyle smallBold = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );
}
