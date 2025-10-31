import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import '../utils/pdf_font_helpers.dart';
import 'invoice_template_base.dart';

class A5CompactTemplate extends InvoiceTemplate {
  @override
  String get id => 'a5_compact';

  @override
  String get name => 'A5 Compact';

  @override
  String get description => 'Compact invoice template optimized for A5 paper';

  @override
  String get screenshotPath => 'references/templateScreenshots/A5_Compact.jpg';

  @override
  bool get supportsColorThemes => false;

  @override
  Future<pw.Document> generatePDF({
    required InvoiceData invoice,
    colorTheme,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(invoice),
            pw.SizedBox(height: 12),
            _buildInvoiceDetails(invoice),
            pw.SizedBox(height: 12),
            _buildItemsTable(invoice),
            pw.SizedBox(height: 10),
            _buildSummary(invoice),
            if (invoice.notesFooter.isNotEmpty || invoice.paymentTerms.isNotEmpty) ...[
              pw.SizedBox(height: 8),
              _buildNotesAndTerms(invoice),
            ],
            pw.Spacer(),
            _buildFooter(invoice),
          ],
        ),
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoiceData invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey300,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  invoice.sellerDetails.businessName,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  invoice.sellerDetails.phone,
                  style: const pw.TextStyle(fontSize: 8),
                ),
                pw.Text(
                  invoice.sellerDetails.state,
                  style: const pw.TextStyle(fontSize: 8),
                ),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                invoice.invoiceMode.displayName,
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                invoice.fullInvoiceNumber,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceDetails(InvoiceData invoice) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Bill To:',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                invoice.buyerDetails.businessName,
                style: const pw.TextStyle(fontSize: 9),
              ),
              pw.Text(
                invoice.buyerDetails.phone,
                style: const pw.TextStyle(fontSize: 7),
              ),
            ],
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Date: ${dateFormat.format(invoice.issueDate)}',
              style: const pw.TextStyle(fontSize: 8),
            ),
            if (invoice.dueDate != null)
              pw.Text(
                'Due: ${dateFormat.format(invoice.dueDate!)}',
                style: const pw.TextStyle(fontSize: 8),
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildItemsTable(InvoiceData invoice) {
    final showHSN = PDFFontHelpers.hasHSNCodes(invoice.lineItems);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      columnWidths: showHSN
          ? {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(1.5),
            }
          : {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.5),
            },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('Item', isHeader: true),
            if (showHSN) _buildTableCell('HSN', isHeader: true),
            _buildTableCell('Qty', isHeader: true),
            _buildTableCell('Rate', isHeader: true),
            _buildTableCell('Amount', isHeader: true),
          ],
        ),
        // Items
        ...invoice.lineItems.map((item) => pw.TableRow(
              children: [
                _buildTableCell(item.item.name),
                if (showHSN) _buildTableCell(item.item.hsnCode),
                _buildTableCell(item.qtyOnBill.toString()),
                _buildTableCellRupee(item.partyNetPrice),
                _buildTableCellRupee(item.lineTotal),
              ],
            )),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 8 : 7,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildTableCellRupee(double amount) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: PDFFontHelpers.regularRupeeAmount(
        amount,
        fontSize: 7,
        color: PdfColors.grey800,
      ),
    );
  }

  pw.Widget _buildSummary(InvoiceData invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 0.5),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        children: [
          _buildSummaryRow('Subtotal', invoice.billSummary.totalTaxableValue),
          if (invoice.isIntraState) ...[
            _buildSummaryRow('CGST', invoice.billSummary.totalGst / 2),
            _buildSummaryRow('SGST', invoice.billSummary.totalGst / 2),
          ] else ...[
            _buildSummaryRow('IGST', invoice.billSummary.totalGst),
          ],
          pw.Divider(thickness: 1),
          _buildSummaryRow(
            'Total',
            invoice.billSummary.totalLineItemsAfterTaxes,
            isBold: true,
          ),
          if (invoice.amountPaid > 0) ...[
            _buildSummaryRow('Paid', invoice.amountPaid),
            _buildSummaryRow(
              'Balance',
              invoice.billSummary.totalLineItemsAfterTaxes - invoice.amountPaid,
              isBold: true,
            ),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildSummaryRow(String label, double amount, {bool isBold = false}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        if (isBold)
          PDFFontHelpers.boldRupeeAmount(amount, fontSize: 8)
        else
          PDFFontHelpers.regularRupeeAmount(amount, fontSize: 8),
      ],
    );
  }

  pw.Widget _buildNotesAndTerms(InvoiceData invoice) {
    final hasNotes = invoice.notesFooter.isNotEmpty;
    final hasTerms = invoice.paymentTerms.isNotEmpty;

    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Notes section
          if (hasNotes) ...[
            pw.Text(
              'Notes:',
              style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              invoice.notesFooter,
              style: const pw.TextStyle(fontSize: 7),
            ),
            if (hasTerms) pw.SizedBox(height: 6),
          ],
          // Terms & Conditions section
          if (hasTerms) ...[
            pw.Text(
              'Terms & Conditions:',
              style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 2),
            ...invoice.paymentTerms.map((term) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 1),
                  child: pw.Text(
                    '• $term',
                    style: const pw.TextStyle(fontSize: 7),
                  ),
                )),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildFooter(InvoiceData invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'Authorized Signature',
              style: const pw.TextStyle(fontSize: 7),
            ),
            pw.SizedBox(height: 15),
            pw.Container(
              width: 80,
              height: 0.5,
              color: PdfColors.grey600,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget buildPreview({
    required InvoiceData invoice,
    colorTheme,
  }) {
    return const Center(
      child: Text('A5 Compact Template\nUse PDF preview to see the full design'),
    );
  }
}
