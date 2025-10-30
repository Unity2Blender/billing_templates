import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import '../utils/currency_formatter.dart';
import '../utils/pdf_font_helpers.dart';
import 'invoice_template_base.dart';

class TallyProfessionalTemplate extends InvoiceTemplate {
  @override
  String get id => 'tally_professional';

  @override
  String get name => 'Tally Professional';

  @override
  String get description => 'Professional tally-style invoice with detailed breakdown';

  @override
  String get screenshotPath =>
      'references/templateScreenshots/Tally_Professional.jpg';

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
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _buildHeader(invoice),
          pw.SizedBox(height: 12),
          _buildParties(invoice),
          pw.SizedBox(height: 12),
          _buildItemsTable(invoice),
          pw.SizedBox(height: 12),
          _buildTotalsSection(invoice),
          if (invoice.notesFooter.isNotEmpty) ...[
            pw.SizedBox(height: 10),
            _buildNotes(invoice),
          ],
        ],
        footer: (context) => _buildFooter(invoice, context),
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoiceData invoice) {
    final dateFormat = DateFormat('dd-MMM-yyyy');
    return pw.Container(
      child: pw.Column(
        children: [
          // Top border
          pw.Container(
            height: 3,
            color: PdfColors.black,
          ),
          pw.SizedBox(height: 10),
          // Company name and invoice type
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      invoice.sellerDetails.businessName.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      invoice.sellerDetails.businessAddress,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.Text(
                      'Ph: ${invoice.sellerDetails.phone}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    if (invoice.sellerDetails.gstin.isNotEmpty)
                      pw.Text(
                        'GSTIN: ${invoice.sellerDetails.gstin}',
                        style: pw.TextStyle(
                          fontSize: 9,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black, width: 2),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      invoice.invoiceMode.displayName.toUpperCase(),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      invoice.fullInvoiceNumber,
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      dateFormat.format(invoice.issueDate),
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            height: 2,
            color: PdfColors.black,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildParties(InvoiceData invoice) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1.5),
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  right: pw.BorderSide(color: PdfColors.black, width: 1.5),
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    child: pw.Text(
                      ' DETAILS OF RECEIVER (Billed to)',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    invoice.buyerDetails.businessName,
                    style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    invoice.buyerDetails.businessAddress,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                  pw.Text(
                    'Phone: ${invoice.buyerDetails.phone}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                  if (invoice.buyerDetails.gstin.isNotEmpty)
                    pw.Text(
                      'GSTIN: ${invoice.buyerDetails.gstin}',
                      style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                    ),
                  pw.Text(
                    'State: ${invoice.buyerDetails.state}',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ],
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    decoration: const pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    child: pw.Text(
                      ' INVOICE DETAILS',
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  _buildInfoRow('Payment Mode', invoice.paymentMode.displayName),
                  if (invoice.dueDate != null)
                    _buildInfoRow(
                      'Due Date',
                      DateFormat('dd-MMM-yyyy').format(invoice.dueDate!),
                    ),
                  _buildInfoRow(
                    'Place of Supply',
                    invoice.buyerDetails.state,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.Text(
            '$label: ',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 8),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable(InvoiceData invoice) {
    final showHSN = PDFFontHelpers.hasHSNCodes(invoice.lineItems);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.black, width: 1.5),
      columnWidths: showHSN
          ? {
              0: const pw.FlexColumnWidth(0.6),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(1.2),
              5: const pw.FlexColumnWidth(1.2),
              6: const pw.FlexColumnWidth(1.5),
            }
          : {
              0: const pw.FlexColumnWidth(0.6),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1.2),
              4: const pw.FlexColumnWidth(1.2),
              5: const pw.FlexColumnWidth(1.5),
            },
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            _buildTableHeaderCell('#'),
            _buildTableHeaderCell('Description of Goods'),
            if (showHSN) _buildTableHeaderCell('HSN/SAC'),
            _buildTableHeaderCell('Qty'),
            _buildTableHeaderCell('Rate'),
            _buildTableHeaderCell('Per'),
            _buildTableHeaderCell('Amount'),
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
              _buildTableCell(item.qtyOnBill.toStringAsFixed(2)),
              _buildTableCellRupee(item.partyNetPrice),
              _buildTableCell(item.item.qtyUnit),
              _buildTableCellRupee(item.lineTotal),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildTableHeaderCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isAmount = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 7),
        textAlign: isAmount ? pw.TextAlign.right : pw.TextAlign.left,
      ),
    );
  }

  pw.Widget _buildTableCellRupee(double amount) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: PDFFontHelpers.regularRupeeAmount(
        amount,
        fontSize: 7,
        color: PdfColors.grey800,
        align: pw.TextAlign.right,
      ),
    );
  }

  pw.Widget _buildTotalsSection(InvoiceData invoice) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1.5),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Left - Amount in words
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  right: pw.BorderSide(color: PdfColors.black, width: 1.5),
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Amount Chargeable (in words)',
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    CurrencyFormatter.toWords(invoice.billSummary.totalLineItemsAfterTaxes)
                        .toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'E. & O.E.',
                    style: const pw.TextStyle(fontSize: 7),
                  ),
                ],
              ),
            ),
          ),
          // Right - Tax breakdown
          pw.Expanded(
            flex: 1,
            child: pw.Column(
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey300,
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.black, width: 1.5),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total',
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      PDFFontHelpers.boldRupeeAmount(
                        invoice.billSummary.totalTaxableValue,
                        fontSize: 8,
                      ),
                    ],
                  ),
                ),
                if (invoice.isIntraState) ...[
                  _buildTaxRow('CGST', invoice.billSummary.totalGst / 2),
                  _buildTaxRow('SGST', invoice.billSummary.totalGst / 2),
                ] else ...[
                  _buildTaxRow('IGST', invoice.billSummary.totalGst),
                ],
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: const pw.BoxDecoration(
                    color: PdfColors.grey400,
                    border: pw.Border(
                      top: pw.BorderSide(color: PdfColors.black, width: 2),
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Total Amt.',
                        style: pw.TextStyle(
                          fontSize: 9,
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
        ],
      ),
    );
  }

  pw.Widget _buildTaxRow(String label, double amount) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
            style: const pw.TextStyle(fontSize: 8),
          ),
          PDFFontHelpers.regularRupeeAmount(amount, fontSize: 8),
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
            'Terms & Conditions',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            invoice.notesFooter,
            style: const pw.TextStyle(fontSize: 7),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(InvoiceData invoice, pw.Context context) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'for ${invoice.sellerDetails.businessName}',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.SizedBox(height: 25),
              pw.Text(
                'Authorized Signatory',
                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
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
      child: Text('Tally Professional Template\nUse PDF preview to see the full design'),
    );
  }
}
