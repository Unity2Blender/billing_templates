import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import '../utils/invoice_colors.dart';
import '../utils/currency_formatter.dart';
import '../utils/pdf_font_helpers.dart';
import 'invoice_template_base.dart';

class MBBookDefaultTemplate extends InvoiceTemplate {
  @override
  String get id => 'mbbook_default';

  @override
  String get name => 'MBBook Default';

  @override
  String get description => 'Professional classic invoice layout';

  @override
  String get screenshotPath =>
      'references/templateScreenshots/MBBook_Default.jpg';

  @override
  Future<pw.Document> generatePDF({
    required InvoiceData invoice,
    InvoiceColorTheme? colorTheme,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(25),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader(invoice),
            pw.SizedBox(height: 12),
            _buildInvoiceDetails(invoice),
            pw.SizedBox(height: 16),
            _buildPartyDetails(invoice),
            pw.SizedBox(height: 16),
            _buildItemsTable(invoice),
            pw.SizedBox(height: 16),
            _buildSummary(invoice),
            if (invoice.notesFooter.isNotEmpty) ...[
              pw.SizedBox(height: 16),
              _buildTermsAndConditions(invoice),
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
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 2),
        ),
      ),
      padding: const pw.EdgeInsets.only(bottom: 8),
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
              if (invoice.invoicePrefix.isNotEmpty)
                pw.Text(
                  'ORIGINAL FOR RECIPIENT',
                  style: const pw.TextStyle(fontSize: 8),
                ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInvoiceDetails(InvoiceData invoice) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey600),
      ),
      child: pw.Row(
        children: [
          // Seller details
          pw.Expanded(
            child: pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  right: pw.BorderSide(color: PdfColors.grey600),
                ),
              ),
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
                  pw.SizedBox(height: 4),
                  if (invoice.sellerDetails.businessAddress.isNotEmpty)
                    pw.Text(
                      invoice.sellerDetails.state,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  if (invoice.sellerDetails.phone.isNotEmpty)
                    pw.Text(
                      'Mobile: ${invoice.sellerDetails.phone}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                  if (invoice.sellerDetails.pan.isNotEmpty)
                    pw.Text(
                      'PAN Number: ${invoice.sellerDetails.pan}',
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                ],
              ),
            ),
          ),
          // Invoice meta
          pw.Container(
            width: 200,
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Invoice No.:', invoice.fullInvoiceNumber),
                pw.SizedBox(height: 2),
                _buildInfoRow(
                  'Invoice Date:',
                  DateFormat('dd/MM/yyyy').format(invoice.issueDate),
                ),
                if (invoice.dueDate != null) ...[
                  pw.SizedBox(height: 2),
                  _buildInfoRow(
                    'Due Date:',
                    DateFormat('dd/MM/yyyy').format(invoice.dueDate!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildPartyDetails(InvoiceData invoice) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey600),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'BILL TO',
            style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            invoice.buyerDetails.businessName.toUpperCase(),
            style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
          if (invoice.buyerDetails.phone.isNotEmpty)
            pw.Text(
              'Mobile: ${invoice.buyerDetails.phone}',
              style: const pw.TextStyle(fontSize: 9),
            ),
          if (invoice.buyerDetails.pan.isNotEmpty)
            pw.Text(
              'PAN Number: ${invoice.buyerDetails.pan}',
              style: const pw.TextStyle(fontSize: 9),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildItemsTable(InvoiceData invoice) {
    final showHSN = PDFFontHelpers.hasHSNCodes(invoice.lineItems);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey600),
      columnWidths: showHSN
          ? {
              0: const pw.FixedColumnWidth(30),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FixedColumnWidth(50),
              3: const pw.FixedColumnWidth(60),
              4: const pw.FixedColumnWidth(70),
              5: const pw.FixedColumnWidth(60),
              6: const pw.FixedColumnWidth(70),
            }
          : {
              0: const pw.FixedColumnWidth(30),
              1: const pw.FlexColumnWidth(3),
              2: const pw.FixedColumnWidth(60),
              3: const pw.FixedColumnWidth(80),
              4: const pw.FixedColumnWidth(60),
              5: const pw.FixedColumnWidth(80),
            },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _headerCell('S.NO.'),
            _headerCell('ITEMS'),
            if (showHSN) _headerCell('HSN'),
            _headerCell('QTY.'),
            _headerCell('RATE'),
            _headerCell('TAX'),
            _headerCell('AMOUNT'),
          ],
        ),
        // Item rows
        ...invoice.lineItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return pw.TableRow(
            children: [
              _itemCell('${index + 1}', align: pw.TextAlign.center),
              _itemCell(item.item.name),
              if (showHSN) _itemCell(item.item.hsnCode, align: pw.TextAlign.center),
              _itemCell(
                '${item.qtyOnBill.toStringAsFixed(0)} ${item.item.qtyUnit}',
                align: pw.TextAlign.right,
              ),
              _itemCellRupee(item.partyNetPrice, align: pw.TextAlign.right),
              _itemCell(
                '${(invoice.isIntraState ? item.csgst * 2 : item.igst).toStringAsFixed(2)}\n(${item.grossTaxCharged.toStringAsFixed(1)}%)',
                align: pw.TextAlign.right,
              ),
              _itemCellRupee(item.lineTotal, align: pw.TextAlign.right),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildSummary(InvoiceData invoice) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Terms column
        pw.Expanded(
          child: pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey600),
            ),
            padding: const pw.EdgeInsets.all(8),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'TERMS AND CONDITIONS',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 4),
                if (invoice.notesFooter.isNotEmpty)
                  ...invoice.notesFooter.split('\n').map(
                        (line) => pw.Text(
                          line,
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ),
              ],
            ),
          ),
        ),
        pw.SizedBox(width: 8),
        // Summary column
        pw.Container(
          width: 200,
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey600),
          ),
          child: pw.Column(
            children: [
              _summaryRow('SUBTOTAL', invoice.billSummary.totalTaxableValue),
              _summaryDivider(),
              _summaryRow('Taxable Amount', invoice.billSummary.totalTaxableValue),
              if (invoice.isIntraState) ...[
                _summaryRow(
                  'CGST @${(invoice.lineItems.first.grossTaxCharged / 2).toStringAsFixed(1)}%',
                  invoice.billSummary.totalGst / 2,
                ),
                _summaryRow(
                  'SGST @${(invoice.lineItems.first.grossTaxCharged / 2).toStringAsFixed(1)}%',
                  invoice.billSummary.totalGst / 2,
                ),
              ] else
                _summaryRow(
                  'IGST @${invoice.lineItems.first.grossTaxCharged.toStringAsFixed(1)}%',
                  invoice.billSummary.totalGst,
                ),
              _summaryDivider(),
              _summaryRow(
                'Total Amount',
                invoice.billSummary.totalLineItemsAfterTaxes,
                bold: true,
              ),
              _summaryDivider(),
              _summaryRow('Received Amount', invoice.amountPaid),
              pw.Container(
                padding: const pw.EdgeInsets.all(6),
                color: PdfColors.white,
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Total Amount (in words)',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      CurrencyFormatter.toWords(
                          invoice.billSummary.dueBalancePayable),
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTermsAndConditions(InvoiceData invoice) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey600),
      ),
      padding: const pw.EdgeInsets.all(8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Terms and Conditions',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          ...invoice.notesFooter.split('\n').map(
                (line) => pw.Text(line, style: const pw.TextStyle(fontSize: 8)),
              ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(InvoiceData invoice) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 16),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.end,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(height: 40, width: 120),
              pw.Divider(thickness: 1, color: PdfColors.black),
              pw.Text(
                'AUTHORISED SIGNATORY FOR',
                style: const pw.TextStyle(fontSize: 8),
              ),
              pw.Text(
                invoice.sellerDetails.businessName,
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _headerCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _itemCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 8),
        textAlign: align,
      ),
    );
  }

  pw.Widget _itemCellRupee(double amount, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: PDFFontHelpers.regularRupeeAmount(
        amount,
        fontSize: 8,
        color: PdfColors.grey800,
        align: align,
      ),
    );
  }

  pw.Widget _summaryRow(String label, double amount, {bool bold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          if (bold)
            PDFFontHelpers.boldRupeeAmount(amount, fontSize: 8)
          else
            PDFFontHelpers.regularRupeeAmount(amount, fontSize: 8),
        ],
      ),
    );
  }

  pw.Widget _summaryDivider() {
    return pw.Divider(color: PdfColors.grey600, height: 1);
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
          Text(
            invoice.invoiceMode.displayName.toUpperCase(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            invoice.sellerDetails.businessName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
