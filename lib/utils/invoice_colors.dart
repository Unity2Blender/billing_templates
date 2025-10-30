import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

class InvoiceColorTheme {
  final String name;
  final Color primaryColor;
  final Color accentColor;
  final Color textColor;
  final Color backgroundColor;
  final PdfColor pdfPrimaryColor;
  final PdfColor pdfAccentColor;
  final PdfColor pdfTextColor;
  final PdfColor pdfBackgroundColor;

  const InvoiceColorTheme({
    required this.name,
    required this.primaryColor,
    required this.accentColor,
    required this.textColor,
    required this.backgroundColor,
    required this.pdfPrimaryColor,
    required this.pdfAccentColor,
    required this.pdfTextColor,
    required this.pdfBackgroundColor,
  });

  static PdfColor _toPdfColor(Color color) {
    return PdfColor(color.r, color.g, color.b);
  }

  static InvoiceColorTheme fromColor(String name, Color primary) {
    final r = (primary.r * 255.0).round() & 0xff;
    final g = (primary.g * 255.0).round() & 0xff;
    final b = (primary.b * 255.0).round() & 0xff;
    final accent = Color.fromARGB(
      26, // 10% opacity = 26/255
      r,
      g,
      b,
    );
    return InvoiceColorTheme(
      name: name,
      primaryColor: primary,
      accentColor: accent,
      textColor: Colors.grey[900]!,
      backgroundColor: Colors.white,
      pdfPrimaryColor: _toPdfColor(primary),
      pdfAccentColor: _toPdfColor(accent),
      pdfTextColor: PdfColors.grey900,
      pdfBackgroundColor: PdfColors.white,
    );
  }
}

class InvoiceThemes {
  static final purple = InvoiceColorTheme(
    name: 'Purple',
    primaryColor: const Color(0xFF9C89E0),
    accentColor: const Color(0xFFE8E2F7),
    textColor: Colors.grey[900]!,
    backgroundColor: Colors.white,
    pdfPrimaryColor: const PdfColor.fromInt(0xFF9C89E0),
    pdfAccentColor: const PdfColor.fromInt(0xFFE8E2F7),
    pdfTextColor: PdfColors.grey900,
    pdfBackgroundColor: PdfColors.white,
  );

  static final teal = InvoiceColorTheme(
    name: 'Teal',
    primaryColor: const Color(0xFF80CBC4),
    accentColor: const Color(0xFFE0F2F1),
    textColor: Colors.grey[900]!,
    backgroundColor: Colors.white,
    pdfPrimaryColor: const PdfColor.fromInt(0xFF80CBC4),
    pdfAccentColor: const PdfColor.fromInt(0xFFE0F2F1),
    pdfTextColor: PdfColors.grey900,
    pdfBackgroundColor: PdfColors.white,
  );

  static final grey = InvoiceColorTheme(
    name: 'Grey',
    primaryColor: const Color(0xFFBDBDBD),
    accentColor: const Color(0xFFF5F5F5),
    textColor: Colors.grey[900]!,
    backgroundColor: Colors.white,
    pdfPrimaryColor: const PdfColor.fromInt(0xFFBDBDBD),
    pdfAccentColor: const PdfColor.fromInt(0xFFF5F5F5),
    pdfTextColor: PdfColors.grey900,
    pdfBackgroundColor: PdfColors.white,
  );

  static final warmGrey = InvoiceColorTheme(
    name: 'Warm Grey',
    primaryColor: const Color(0xFFA1887F),
    accentColor: const Color(0xFFEFEBE9),
    textColor: Colors.grey[900]!,
    backgroundColor: Colors.white,
    pdfPrimaryColor: const PdfColor.fromInt(0xFFA1887F),
    pdfAccentColor: const PdfColor.fromInt(0xFFEFEBE9),
    pdfTextColor: PdfColors.grey900,
    pdfBackgroundColor: PdfColors.white,
  );

  static final beige = InvoiceColorTheme(
    name: 'Beige',
    primaryColor: const Color(0xFFD7CCC8),
    accentColor: const Color(0xFFFBE9E7),
    textColor: Colors.grey[900]!,
    backgroundColor: Colors.white,
    pdfPrimaryColor: const PdfColor.fromInt(0xFFD7CCC8),
    pdfAccentColor: const PdfColor.fromInt(0xFFFBE9E7),
    pdfTextColor: PdfColors.grey900,
    pdfBackgroundColor: PdfColors.white,
  );

  static final lightBlue = InvoiceColorTheme(
    name: 'Light Blue',
    primaryColor: const Color(0xFF90CAF9),
    accentColor: const Color(0xFFE3F2FD),
    textColor: Colors.grey[900]!,
    backgroundColor: Colors.white,
    pdfPrimaryColor: const PdfColor.fromInt(0xFF90CAF9),
    pdfAccentColor: const PdfColor.fromInt(0xFFE3F2FD),
    pdfTextColor: PdfColors.grey900,
    pdfBackgroundColor: PdfColors.white,
  );

  static final cyan = InvoiceColorTheme(
    name: 'Cyan',
    primaryColor: const Color(0xFF81D4FA),
    accentColor: const Color(0xFFE1F5FE),
    textColor: Colors.grey[900]!,
    backgroundColor: Colors.white,
    pdfPrimaryColor: const PdfColor.fromInt(0xFF81D4FA),
    pdfAccentColor: const PdfColor.fromInt(0xFFE1F5FE),
    pdfTextColor: PdfColors.grey900,
    pdfBackgroundColor: PdfColors.white,
  );

  static final default$ = InvoiceColorTheme(
    name: 'Default',
    primaryColor: Colors.blue[700]!,
    accentColor: Colors.blue[50]!,
    textColor: Colors.grey[900]!,
    backgroundColor: Colors.white,
    pdfPrimaryColor: PdfColors.blue700,
    pdfAccentColor: PdfColors.blue50,
    pdfTextColor: PdfColors.grey900,
    pdfBackgroundColor: PdfColors.white,
  );

  static List<InvoiceColorTheme> get all => [
        purple,
        teal,
        grey,
        warmGrey,
        beige,
        lightBlue,
        cyan,
        default$,
      ];
}
