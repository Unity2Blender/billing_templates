import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import '../utils/currency_formatter.dart';
import '../utils/pdf_font_helpers.dart';
import 'invoice_template_base.dart';

class MBBookTallyTemplate extends InvoiceTemplate {
  @override
  String get id => 'mbbook_tally';

  @override
  String get name => 'MBBook Tally';

  @override
  String get description => 'Tally-style invoice with detailed GST breakdown';

  @override
  String get screenshotPath =>
      'references/templateScreenshots/MBBook_Tally.jpg';

  @override
  bool get supportsColorThemes => false;

  @override
  Future<pw.Document> generatePDF({
    required InvoiceData invoice,
    colorTheme,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(25),
        build: (context) => [
          _buildHeader(invoice),
          pw.SizedBox(height: 15),
          _buildInvoiceInfo(invoice),
          pw.SizedBox(height: 15),
          _buildParties(invoice),
          pw.SizedBox(height: 15),
          _buildItemsTable(invoice),
          pw.SizedBox(height: 15),
          _buildTotals(invoice),
          if (invoice.notesFooter.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            _buildNotes(invoice),
          ],
        ],
        footer: (context) => _buildFooter(invoice),
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoiceData invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 2),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            invoice.sellerDetails.businessName.toUpperCase(),
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            invoice.sellerDetails.businessAddress,
            style: const pw.TextStyle(fontSize: 10),
            textAlign: pw.TextAlign.center,
          ),
          pw.Text(
            'Phone: ${invoice.sellerDetails.phone}',
            style: const pw.TextStyle(fontSize: 10),
            textAlign: pw.TextAlign.center,
          ),
          if (invoice.sellerDetails.gstin.isNotEmpty)
            pw.Text(
              'GSTIN: ${invoice.sellerDetails.gstin}',
              style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              textAlign: pw.TextAlign.center,
            ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceInfo(InvoiceData invoice) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                invoice.invoiceMode.displayName.toUpperCase(),
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'No: ${invoice.fullInvoiceNumber}',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'Date: ${dateFormat.format(invoice.issueDate)}',
                style: const pw.TextStyle(fontSize: 10),
              ),
              if (invoice.dueDate != null)
                pw.Text(
                  'Due Date: ${dateFormat.format(invoice.dueDate!)}',
                  style: const pw.TextStyle(fontSize: 10),
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
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Buyer Details',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  invoice.buyerDetails.businessName,
                  style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  invoice.buyerDetails.businessAddress,
                  style: const pw.TextStyle(fontSize: 9),
                ),
                pw.Text(
                  'Phone: ${invoice.buyerDetails.phone}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
                pw.Text(
                  'State: ${invoice.buyerDetails.state}',
                  style: const pw.TextStyle(fontSize: 9),
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
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Payment Mode',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  invoice.paymentMode.displayName,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildItemsTable(InvoiceData invoice) {
    final showHSN = PDFFontHelpers.hasHSNCodes(invoice.lineItems);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black),
      columnWidths: showHSN
          ? {
              0: const pw.FlexColumnWidth(0.8),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.2),
              4: const pw.FlexColumnWidth(1.2),
              5: const pw.FlexColumnWidth(1.5),
            }
          : {
              0: const pw.FlexColumnWidth(0.8),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(1.2),
              4: const pw.FlexColumnWidth(1.5),
            },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableCell('Sr.', isHeader: true),
            _buildTableCell('Particulars', isHeader: true),
            if (showHSN) _buildTableCell('HSN', isHeader: true),
            _buildTableCell('Qty', isHeader: true),
            _buildTableCell('Rate', isHeader: true),
            _buildTableCell('Amount', isHeader: true),
          ],
        ),
        // Items
        ...invoice.lineItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return pw.TableRow(
            children: [
              _buildTableCell('${index + 1}'),
              _buildTableCell(item.item.name),
              if (showHSN) _buildTableCell(item.item.hsnCode),
              _buildTableCell('${item.qtyOnBill} ${item.item.qtyUnit}'),
              _buildTableCellRupee(item.partyNetPrice),
              _buildTableCellRupee(item.lineTotal),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 9 : 8,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  pw.Widget _buildTableCellRupee(double amount) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: PDFFontHelpers.regularRupeeAmount(
        amount,
        fontSize: 8,
        color: PdfColors.grey800,
      ),
    );
  }

  pw.Widget _buildTotals(InvoiceData invoice) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left side - Amount in words
        pw.Expanded(
          flex: 2,
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Amount in Words:',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                pw.Text(
                  CurrencyFormatter.toWords(invoice.billSummary.totalLineItemsAfterTaxes),
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 10),
        // Right side - GST breakdown
        pw.Expanded(
          flex: 1,
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.black),
            ),
            child: pw.Column(
              children: [
                _buildTotalRow('Taxable Value', invoice.billSummary.totalTaxableValue),
                if (invoice.isIntraState) ...[
                  _buildTotalRow('CGST', invoice.billSummary.totalGst / 2),
                  _buildTotalRow('SGST', invoice.billSummary.totalGst / 2),
                ] else ...[
                  _buildTotalRow('IGST', invoice.billSummary.totalGst),
                ],
                pw.Container(
                  padding: const pw.EdgeInsets.all(8),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.black, width: 2),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total Amount',
                        style: pw.TextStyle(
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      PDFFontHelpers.boldRupeeAmount(
                        invoice.billSummary.totalLineItemsAfterTaxes,
                        fontSize: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTotalRow(String label, double amount) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: const pw.TextStyle(fontSize: 9),
          ),
          PDFFontHelpers.regularRupeeAmount(amount, fontSize: 9),
        ],
      ),
    );
  }

  pw.Widget _buildNotes(InvoiceData invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Notes:',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            invoice.notesFooter,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(InvoiceData invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Terms & Conditions Apply',
            style: const pw.TextStyle(fontSize: 8),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'For ${invoice.sellerDetails.businessName}',
                style: const pw.TextStyle(fontSize: 9),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Authorized Signatory',
                style: const pw.TextStyle(fontSize: 8),
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
      child: Text('MBBook Tally Template\nUse PDF preview to see the full design'),
    );
  }
}
