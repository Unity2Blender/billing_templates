import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../utils/invoice_colors.dart';
import '../utils/currency_formatter.dart';
import '../utils/pdf_font_helpers.dart';
import 'invoice_template_base.dart';

class MBBookStylishTemplate extends InvoiceTemplate {
  @override
  String get id => 'mbbook_stylish';

  @override
  String get name => 'MBBook Stylish';

  @override
  String get description => 'Modern and elegant invoice design';

  @override
  String get screenshotPath =>
      'references/templateScreenshots/MBBook_Stylish.jpg';

  @override
  Future<pw.Document> generatePDF({
    required InvoiceData invoice,
    InvoiceColorTheme? colorTheme,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(invoice),
            pw.SizedBox(height: 16),
            _buildSellerInfo(invoice),
            pw.SizedBox(height: 12),
            _buildInvoiceMetadata(invoice),
            pw.SizedBox(height: 16),
            _buildBuyerInfo(invoice),
            pw.SizedBox(height: 16),
            _buildItemsTable(invoice),
            pw.SizedBox(height: 16),
            _buildBottomSection(invoice),
            pw.Spacer(),
            _buildSignature(invoice),
          ],
        ),
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoiceData invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'TAX INVOICE',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey600),
          ),
          child: pw.Text(
            'ORIGINAL FOR RECIPIENT',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSellerInfo(InvoiceData invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          invoice.sellerDetails.businessName,
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        if (invoice.sellerDetails.state.isNotEmpty)
          pw.Text(
            '${invoice.sellerDetails.state},',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
          ),
        if (invoice.sellerDetails.phone.isNotEmpty)
          pw.Text(
            'Mobile: ${invoice.sellerDetails.phone}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
          ),
        if (invoice.sellerDetails.pan.isNotEmpty)
          pw.Text(
            'PAN Number: ${invoice.sellerDetails.pan}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800),
          ),
      ],
    );
  }

  pw.Widget _buildInvoiceMetadata(InvoiceData invoice) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _buildMetadataItem('Invoice No.:', invoice.fullInvoiceNumber),
          _buildMetadataItem(
            'Invoice Date:',
            DateFormat('dd/MM/yyyy').format(invoice.issueDate),
          ),
          if (invoice.dueDate != null)
            _buildMetadataItem(
              'Due Date:',
              DateFormat('dd/MM/yyyy').format(invoice.dueDate!),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildMetadataItem(String label, String value) {
    return pw.Row(
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
        ),
        pw.SizedBox(width: 4),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildBuyerInfo(InvoiceData invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'BILL TO',
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          invoice.buyerDetails.businessName,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (invoice.buyerDetails.phone.isNotEmpty)
          pw.Text(
            'Mobile: ${invoice.buyerDetails.phone}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
          ),
        if (invoice.buyerDetails.pan.isNotEmpty)
          pw.Text(
            'PAN Number: ${invoice.buyerDetails.pan}',
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey800),
          ),
      ],
    );
  }

  pw.Widget _buildItemsTable(InvoiceData invoice) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey800),
      ),
      child: pw.Table(
        border: pw.TableBorder.all(color: PdfColors.grey400),
        columnWidths: {
          0: const pw.FlexColumnWidth(3),
          1: const pw.FlexColumnWidth(1),
          2: const pw.FlexColumnWidth(1.5),
          3: const pw.FlexColumnWidth(1.5),
          4: const pw.FlexColumnWidth(1.5),
        },
        children: [
          // Header
          pw.TableRow(
            children: [
              _buildTableHeader('ITEMS'),
              _buildTableHeader('QTY.'),
              _buildTableHeader('RATE'),
              _buildTableHeader('TAX'),
              _buildTableHeader('AMOUNT'),
            ],
          ),
          // Items
          ...invoice.lineItems.map((item) {
            final taxAmount = invoice.isIntraState
                ? item.csgst * 2
                : item.igst;
            final taxPercent = '(${item.grossTaxCharged.toStringAsFixed(1)}%)';

            return pw.TableRow(
              children: [
                _buildTableCell(item.item.name),
                _buildTableCell(
                  '${item.qtyOnBill.toStringAsFixed(0)} ${item.item.qtyUnit}',
                  align: pw.TextAlign.right,
                ),
                _buildTableCellRupee(item.partyNetPrice, align: pw.TextAlign.right),
                _buildTableCell(
                  '${taxAmount.toStringAsFixed(2)}\n$taxPercent',
                  align: pw.TextAlign.right,
                ),
                _buildTableCellRupee(item.lineTotal, align: pw.TextAlign.right),
              ],
            );
          }),
        ],
      ),
    );
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      color: PdfColors.white,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9),
        textAlign: align,
      ),
    );
  }

  pw.Widget _buildTableCellRupee(double amount, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: PDFFontHelpers.regularRupeeAmount(
        amount,
        fontSize: 9,
        align: align,
      ),
    );
  }

  pw.Widget _buildBottomSection(InvoiceData invoice) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left side - Notes (if present)
        pw.Expanded(
          flex: 3,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (invoice.notesFooter.isNotEmpty) ...[
                pw.Text(
                  'TERMS AND CONDITIONS',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                ...invoice.notesFooter.split('\n').map(
                      (line) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Text(
                          line,
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        // Right side - Summary
        pw.Container(
          width: 200,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildSummaryRow('SUBTOTAL', invoice.billSummary.totalTaxableValue),
              pw.Divider(color: PdfColors.grey800, height: 8),
              _buildSummaryRow('Taxable Amount', invoice.billSummary.totalTaxableValue),
              if (invoice.isIntraState) ...[
                _buildSummaryRow(
                  'CGST @${(invoice.lineItems.first.grossTaxCharged / 2).toStringAsFixed(1)}%',
                  invoice.billSummary.totalGst / 2,
                ),
                _buildSummaryRow(
                  'SGST @${(invoice.lineItems.first.grossTaxCharged / 2).toStringAsFixed(1)}%',
                  invoice.billSummary.totalGst / 2,
                ),
              ] else
                _buildSummaryRow(
                  'IGST @${invoice.lineItems.first.grossTaxCharged.toStringAsFixed(1)}%',
                  invoice.billSummary.totalGst,
                ),
              pw.Divider(color: PdfColors.grey800, height: 8),
              _buildSummaryRow(
                'Total Amount',
                invoice.billSummary.totalLineItemsAfterTaxes,
                bold: true,
                fontSize: 10,
              ),
              pw.SizedBox(height: 8),
              _buildSummaryRow('Received Amount', invoice.amountPaid),
              pw.SizedBox(height: 12),
              pw.Text(
                'Total Amount (in words)',
                style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                CurrencyFormatter.toWords(invoice.billSummary.dueBalancePayable),
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSummaryRow(String label, double amount, {bool bold = false, double fontSize = 9}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: fontSize - 1,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          if (bold)
            PDFFontHelpers.boldRupeeAmount(amount, fontSize: fontSize)
          else
            PDFFontHelpers.regularRupeeAmount(amount, fontSize: fontSize - 1),
        ],
      ),
    );
  }

  pw.Widget _buildSignature(InvoiceData invoice) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Container(height: 40, width: 150),
          pw.Container(
            width: 150,
            height: 1,
            color: PdfColors.grey800,
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'AUTHORISED SIGNATORY FOR',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
          pw.Text(
            invoice.sellerDetails.businessName,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildPreview({
    required InvoiceData invoice,
    InvoiceColorTheme? colorTheme,
  }) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TAX INVOICE',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            invoice.sellerDetails.businessName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            'Total: ${CurrencyFormatter.format(invoice.billSummary.totalLineItemsAfterTaxes)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
