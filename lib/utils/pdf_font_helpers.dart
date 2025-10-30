import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'currency_formatter.dart';

/// Font helper utilities for PDF generation with rupee symbol support
class PDFFontHelpers {
  static pw.Font? _regularFont;
  static pw.Font? _boldFont;

  /// Load Poppins fonts for PDF (call this once before generating PDFs)
  static Future<void> loadFonts() async {
    if (_regularFont == null || _boldFont == null) {
      try {
        // Load Poppins Regular from assets
        final regularData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
        _regularFont = pw.Font.ttf(regularData);

        // Load Poppins Bold from assets
        final boldData = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
        _boldFont = pw.Font.ttf(boldData);
      } catch (e) {
        // Fallback to default fonts if loading fails
        print('Warning: Failed to load Poppins fonts from assets: $e');
        print('Make sure font files exist in assets/fonts/ directory');
      }
    }
  }

  /// Get regular font (returns null if not loaded, allowing fallback)
  static pw.Font? get regularFont => _regularFont;

  /// Get bold font (returns null if not loaded, allowing fallback)
  static pw.Font? get boldFont => _boldFont;

  /// Create TextStyle with regular font
  static pw.TextStyle regularStyle({
    double fontSize = 10,
    PdfColor color = PdfColors.grey800,
  }) {
    return pw.TextStyle(
      font: _regularFont,
      fontSize: fontSize,
      color: color,
    );
  }

  /// Create TextStyle with bold font
  static pw.TextStyle boldStyle({
    double fontSize = 10,
    PdfColor color = PdfColors.grey800,
  }) {
    return pw.TextStyle(
      font: _boldFont,
      fontSize: fontSize,
      color: color,
      fontWeight: pw.FontWeight.bold,
    );
  }

  /// Build text widget with regular font and rupee amount
  static pw.Widget regularRupeeAmount(
    double amount, {
    double fontSize = 10,
    PdfColor color = PdfColors.grey800,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Text(
      CurrencyFormatter.format(amount),
      style: regularStyle(fontSize: fontSize, color: color),
      textAlign: align,
    );
  }

  /// Build text widget with bold font and rupee amount
  static pw.Widget boldRupeeAmount(
    double amount, {
    double fontSize = 10,
    PdfColor color = PdfColors.grey800,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Text(
      CurrencyFormatter.format(amount),
      style: boldStyle(fontSize: fontSize, color: color),
      textAlign: align,
    );
  }

  /// Build text widget with regular font (for general text with rupee support)
  static pw.Widget regularText(
    String text, {
    double fontSize = 10,
    PdfColor color = PdfColors.grey800,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Text(
      text,
      style: regularStyle(fontSize: fontSize, color: color),
      textAlign: align,
    );
  }

  /// Build text widget with bold font (for general text with rupee support)
  static pw.Widget boldText(
    String text, {
    double fontSize = 10,
    PdfColor color = PdfColors.grey800,
    pw.TextAlign align = pw.TextAlign.left,
  }) {
    return pw.Text(
      text,
      style: boldStyle(fontSize: fontSize, color: color),
      textAlign: align,
    );
  }

  /// Check if any items have HSN code (for conditional HSN column visibility)
  static bool hasHSNCodes(List items) {
    for (final item in items) {
      try {
        // For ItemSaleInfo objects
        final hsnCode = (item as dynamic).item.hsnCode;
        if (hsnCode != null && hsnCode.toString().trim().isNotEmpty) {
          return true;
        }
      } catch (e) {
        // Continue checking other items
      }
    }
    return false;
  }
}
