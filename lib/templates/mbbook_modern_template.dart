import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import '../utils/invoice_colors.dart';
import '../utils/pdf_font_helpers.dart';
import 'invoice_template_base.dart';

class MBBookModernTemplate extends InvoiceTemplate {
  @override
  String get id => 'mbbook_modern';

  @override
  String get name => 'MBBook Modern';

  @override
  String get description => 'Modern professional invoice with clean design';

  @override
  String get screenshotPath =>
      'references/templateScreenshots/MBBook_Modern.jpg';

  @override
  bool get supportsColorThemes => true;

  @override
  InvoiceColorTheme get defaultColorTheme => InvoiceThemes.teal;

  @override
  Future<pw.Document> generatePDF({
    required InvoiceData invoice,
    InvoiceColorTheme? colorTheme,
  }) async {
    final theme = colorTheme ?? defaultColorTheme;
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => [
          _buildHeader(invoice, theme),
          pw.SizedBox(height: 20),
          _buildParties(invoice),
          pw.SizedBox(height: 20),
          _buildItemsTable(invoice, theme),
          pw.SizedBox(height: 20),
          _buildBottomSection(invoice, theme),
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoiceData invoice, InvoiceColorTheme theme) {
    final dateFormat = DateFormat('dd MMM yyyy');
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: theme.pdfPrimaryColor,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 50,
                height: 50,
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Center(
                  child: pw.Text(
                    '⊞',
                    style: pw.TextStyle(
                      fontSize: 30,
                      fontWeight: pw.FontWeight.bold,
                      color: theme.pdfPrimaryColor,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                invoice.sellerDetails.businessName,
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.Text(
                invoice.sellerDetails.phone,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
              ),
              pw.Text(
                invoice.sellerDetails.state,
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.white),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                invoice.invoiceMode.displayName.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                invoice.fullInvoiceNumber,
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                'Date: ${dateFormat.format(invoice.issueDate)}',
                style: const pw.TextStyle(fontSize: 11, color: PdfColors.white),
              ),
              if (invoice.dueDate != null)
                pw.Text(
                  'Due: ${dateFormat.format(invoice.dueDate!)}',
                  style: const pw.TextStyle(fontSize: 11, color: PdfColors.white),
                ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildParties(InvoiceData invoice) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'BILL TO',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  invoice.buyerDetails.businessName,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  invoice.buyerDetails.phone,
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  invoice.buyerDetails.state,
                  style: const pw.TextStyle(fontSize: 10),
                ),
                if (invoice.buyerDetails.gstin.isNotEmpty)
                  pw.Text(
                    'GSTIN: ${invoice.buyerDetails.gstin}',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'FROM',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  invoice.sellerDetails.businessName,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  invoice.sellerDetails.phone,
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  invoice.sellerDetails.state,
                  style: const pw.TextStyle(fontSize: 10),
                ),
                if (invoice.sellerDetails.gstin.isNotEmpty)
                  pw.Text(
                    'GSTIN: ${invoice.sellerDetails.gstin}',
                    style: const pw.TextStyle(fontSize: 9),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildItemsTable(InvoiceData invoice, InvoiceColorTheme theme) {
    final showHSN = PDFFontHelpers.hasHSNCodes(invoice.lineItems);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: showHSN
          ? {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(2),
            }
          : {
              0: const pw.FlexColumnWidth(1),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1.5),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(2),
            },
      children: [
        // Header
        pw.TableRow(
          decoration: pw.BoxDecoration(color: theme.pdfPrimaryColor),
          children: [
            _buildTableCell('#', isHeader: true, isWhite: true),
            _buildTableCell('Item', isHeader: true, isWhite: true),
            if (showHSN) _buildTableCell('HSN', isHeader: true, isWhite: true),
            _buildTableCell('Qty', isHeader: true, isWhite: true),
            _buildTableCell('Rate', isHeader: true, isWhite: true),
            _buildTableCell('Amount', isHeader: true, isWhite: true),
          ],
        ),
        // Items
        ...invoice.lineItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return pw.TableRow(
            decoration: pw.BoxDecoration(
              color: index.isEven ? PdfColors.grey100 : PdfColors.white,
            ),
            children: [
              _buildTableCell('${index + 1}'),
              _buildTableCell(item.item.name),
              if (showHSN) _buildTableCell(item.item.hsnCode),
              _buildTableCell(item.qtyOnBill.toString()),
              _buildTableCellRupee(item.partyNetPrice),
              _buildTableCellRupee(item.lineTotal),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false, bool isWhite = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isWhite ? PdfColors.white : PdfColors.black,
        ),
      ),
    );
  }

  pw.Widget _buildTableCellRupee(double amount) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: PDFFontHelpers.regularRupeeAmount(
        amount,
        fontSize: 9,
        color: PdfColors.black,
      ),
    );
  }

  pw.Widget _buildBottomSection(InvoiceData invoice, InvoiceColorTheme theme) {
    final hasNotes = invoice.notesFooter.isNotEmpty;
    final hasTerms = invoice.paymentTerms.isNotEmpty;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left side - Notes and/or Terms & Conditions
        if (hasNotes || hasTerms)
          pw.Expanded(
            flex: 1,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey100,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Notes section
                  if (hasNotes) ...[
                    pw.Text(
                      'Notes',
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      invoice.notesFooter,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    if (hasTerms) pw.SizedBox(height: 8),
                  ],
                  // Terms & Conditions section
                  if (hasTerms) ...[
                    pw.Text(
                      'Terms & Conditions',
                      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 4),
                    ...invoice.paymentTerms.map((term) => pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 2),
                          child: pw.Text(
                            '• $term',
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                        )),
                  ],
                ],
              ),
            ),
          ),
        if (hasNotes || hasTerms) pw.SizedBox(width: 20),
        // Right side - Summary + Signature
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _buildSummary(invoice, theme),
              pw.SizedBox(height: 20),
              _buildFooter(invoice, theme),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSummary(InvoiceData invoice, InvoiceColorTheme theme) {
    return pw.Container(
      width: 250,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: theme.pdfPrimaryColor, width: 2),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        children: [
          _buildSummaryRow('Subtotal', invoice.billSummary.totalTaxableValue),
          pw.SizedBox(height: 5),
          if (invoice.isIntraState) ...[
            _buildSummaryRow('CGST', invoice.billSummary.totalGst / 2),
            _buildSummaryRow('SGST', invoice.billSummary.totalGst / 2),
          ] else ...[
            _buildSummaryRow('IGST', invoice.billSummary.totalGst),
          ],
          pw.Divider(thickness: 1.5, color: theme.pdfPrimaryColor),
          _buildSummaryRow(
            'TOTAL',
            invoice.billSummary.totalLineItemsAfterTaxes,
            isBold: true,
            color: theme.pdfPrimaryColor,
          ),
          if (invoice.amountPaid > 0) ...[
            pw.SizedBox(height: 5),
            _buildSummaryRow('Paid', invoice.amountPaid),
            _buildSummaryRow(
              'Balance Due',
              invoice.billSummary.totalLineItemsAfterTaxes - invoice.amountPaid,
              isBold: true,
              color: PdfColors.red,
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isBold = false,
    PdfColor? color,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: isBold ? 12 : 10,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
        if (isBold)
          PDFFontHelpers.boldRupeeAmount(
            amount,
            fontSize: 12,
            color: color ?? PdfColors.grey800,
          )
        else
          PDFFontHelpers.regularRupeeAmount(
            amount,
            fontSize: 10,
            color: color ?? PdfColors.grey800,
          ),
      ],
    );
  }

  pw.Widget _buildFooter(InvoiceData invoice, InvoiceColorTheme theme) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(color: theme.pdfPrimaryColor, width: 2),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: theme.pdfPrimaryColor,
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Authorized Signature',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                width: 100,
                height: 1,
                color: PdfColors.grey600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildPreview({
    required InvoiceData invoice,
    colorTheme,
  }) {
    return const Center(
      child: Text('MBBook Modern Template\nUse PDF preview to see the full design'),
    );
  }
}
