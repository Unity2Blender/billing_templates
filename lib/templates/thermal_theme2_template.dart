import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import '../models/item_sale_info.dart';
import '../utils/pdf_font_helpers.dart';
import 'invoice_template_base.dart';

class ThermalTheme2Template extends InvoiceTemplate {
  @override
  String get id => 'thermal_theme2';

  @override
  String get name => 'Thermal Receipt';

  @override
  String get description => 'Thermal printer-style compact receipt';

  @override
  String get screenshotPath =>
      'references/templateScreenshots/Thermal_Theme_2.jpg';

  @override
  bool get supportsColorThemes => false;

  @override
  bool get supportsItemCustomFields => true;

  @override
  bool get supportsBusinessCustomFields => true;

  @override
  Future<pw.Document> generatePDF({
    required InvoiceData invoice,
    colorTheme,
  }) async {
    final pdf = pw.Document();

    // Thermal receipt is typically 80mm wide (about 227 points)
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(227, double.infinity),
        margin: const pw.EdgeInsets.all(10),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            _buildHeader(invoice),
            pw.SizedBox(height: 8),
            _buildDivider(),
            pw.SizedBox(height: 8),
            _buildInvoiceInfo(invoice),
            pw.SizedBox(height: 8),
            _buildDivider(),
            pw.SizedBox(height: 8),
            _buildCustomerInfo(invoice),
            pw.SizedBox(height: 8),
            _buildDivider(),
            pw.SizedBox(height: 8),
            _buildItems(invoice),
            pw.SizedBox(height: 8),
            _buildDivider(),
            pw.SizedBox(height: 8),
            _buildTotals(invoice),
            pw.SizedBox(height: 8),
            _buildDivider(isDashed: true),
            pw.SizedBox(height: 8),
            _buildFooter(invoice),
          ],
        ),
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoiceData invoice) {
    return pw.Column(
      children: [
        pw.Text(
          invoice.sellerDetails.businessName.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          invoice.sellerDetails.businessAddress,
          style: const pw.TextStyle(fontSize: 8),
          textAlign: pw.TextAlign.center,
        ),
        pw.Text(
          'Ph: ${invoice.sellerDetails.phone}',
          style: const pw.TextStyle(fontSize: 8),
          textAlign: pw.TextAlign.center,
        ),
        if (invoice.sellerDetails.gstin.isNotEmpty)
          pw.Text(
            'GSTIN: ${invoice.sellerDetails.gstin}',
            style: const pw.TextStyle(fontSize: 8),
            textAlign: pw.TextAlign.center,
          ),

        // Seller custom fields (ultra-compact for thermal)
        if (invoice.sellerDetails.customFields.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          ...invoice.sellerDetails.customFields.map((field) =>
            pw.Text(
              '${field.fieldName}: ${field.displayValue}',
              style: pw.TextStyle(
                fontSize: 7,
                color: PdfColors.grey700,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  pw.Widget _buildInvoiceInfo(InvoiceData invoice) {
    final dateFormat = DateFormat('dd/MM/yyyy hh:mm a');
    return pw.Column(
      children: [
        pw.Text(
          invoice.invoiceMode.displayName.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        _buildInfoLine('Bill No:', invoice.fullInvoiceNumber),
        _buildInfoLine('Date:', dateFormat.format(invoice.issueDate)),
        if (invoice.dueDate != null)
          _buildInfoLine(
            'Due:',
            DateFormat('dd/MM/yyyy').format(invoice.dueDate!),
          ),
      ],
    );
  }

  pw.Widget _buildCustomerInfo(InvoiceData invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'CUSTOMER DETAILS',
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          invoice.buyerDetails.businessName,
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          'Ph: ${invoice.buyerDetails.phone}',
          style: const pw.TextStyle(fontSize: 8),
        ),
        if (invoice.buyerDetails.gstin.isNotEmpty)
          pw.Text(
            'GSTIN: ${invoice.buyerDetails.gstin}',
            style: const pw.TextStyle(fontSize: 8),
          ),

        // Buyer custom fields (ultra-compact for thermal)
        if (invoice.buyerDetails.customFields.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          ...invoice.buyerDetails.customFields.map((field) =>
            pw.Text(
              '${field.fieldName}: ${field.displayValue}',
              style: pw.TextStyle(
                fontSize: 7,
                color: PdfColors.grey700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  pw.Widget _buildInfoLine(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }

  pw.Widget _buildItems(InvoiceData invoice) {
    final showHSN = PDFFontHelpers.hasHSNCodes(invoice.lineItems);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        // Header
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'ITEM',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
            if (showHSN)
              pw.Text(
                'HSN',
                style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
              ),
            pw.Text(
              'QTY',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'RATE',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'AMOUNT',
              style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        ...invoice.lineItems.map((item) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Item name
                pw.Text(
                  item.item.name,
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),

                // Description (if present)
                if (item.item.description.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 1),
                    child: pw.Text(
                      item.item.description,
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),

                // Custom fields (if any)
                if (item.customFields.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 1),
                    child: pw.Text(
                      '(${item.customFields.map((f) => '${f.fieldName}: ${f.displayValue}').join(', ')})',
                      style: pw.TextStyle(
                        fontSize: 7,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),

                pw.SizedBox(height: 2),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      '',
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    if (showHSN)
                      pw.Text(
                        item.item.hsnCode,
                        style: const pw.TextStyle(fontSize: 8),
                      ),
                    pw.Text(
                      '${item.qtyOnBill} ${item.item.qtyUnit}',
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    PDFFontHelpers.regularRupeeAmount(
                      item.partyNetPrice,
                      fontSize: 8,
                    ),
                    PDFFontHelpers.regularRupeeAmount(
                      item.lineTotal,
                      fontSize: 8,
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
              ],
            )),
      ],
    );
  }

  pw.Widget _buildTotals(InvoiceData invoice) {
    return pw.Column(
      children: [
        _buildTotalRow(
          'Subtotal',
          invoice.billSummary.totalTaxableValue,
          isBold: false,
        ),
        if (invoice.isIntraState) ...[
          _buildTotalRow('CGST', invoice.billSummary.totalGst / 2),
          _buildTotalRow('SGST', invoice.billSummary.totalGst / 2),
        ] else ...[
          _buildTotalRow('IGST', invoice.billSummary.totalGst),
        ],
        pw.SizedBox(height: 4),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          decoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'TOTAL',
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              PDFFontHelpers.boldRupeeAmount(
                invoice.billSummary.totalLineItemsAfterTaxes,
                fontSize: 11,
              ),
            ],
          ),
        ),
        if (invoice.amountPaid > 0) ...[
          pw.SizedBox(height: 4),
          _buildTotalRow('Paid', invoice.amountPaid),
          _buildTotalRow(
            'Balance',
            invoice.billSummary.totalLineItemsAfterTaxes - invoice.amountPaid,
            isBold: true,
          ),
        ],
      ],
    );
  }

  pw.Widget _buildTotalRow(String label, double amount, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          if (isBold)
            PDFFontHelpers.boldRupeeAmount(amount, fontSize: 9)
          else
            PDFFontHelpers.regularRupeeAmount(amount, fontSize: 9),
        ],
      ),
    );
  }

  pw.Widget _buildDivider({bool isDashed = false}) {
    if (isDashed) {
      return pw.Container(
        height: 1,
        child: pw.Row(
          children: List.generate(
            30,
            (index) => pw.Expanded(
              child: pw.Container(
                margin: const pw.EdgeInsets.symmetric(horizontal: 1),
                height: 1,
                color: PdfColors.grey600,
              ),
            ),
          ),
        ),
      );
    }
    return pw.Container(
      height: 1,
      color: PdfColors.grey800,
    );
  }

  pw.Widget _buildFooter(InvoiceData invoice) {
    final hasNotes = invoice.notesFooter.isNotEmpty;
    final hasTerms = invoice.paymentTerms.isNotEmpty;

    return pw.Column(
      children: [
        pw.Text(
          'Payment Mode: ${invoice.paymentMode.displayName}',
          style: const pw.TextStyle(fontSize: 8),
          textAlign: pw.TextAlign.center,
        ),
        // Notes section
        if (hasNotes) ...[
          pw.SizedBox(height: 6),
          pw.Text(
            'NOTES',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            invoice.notesFooter,
            style: const pw.TextStyle(fontSize: 7),
            textAlign: pw.TextAlign.center,
          ),
        ],
        // Terms & Conditions section
        if (hasTerms) ...[
          pw.SizedBox(height: 6),
          pw.Text(
            'TERMS & CONDITIONS',
            style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 2),
          ...invoice.paymentTerms.map((term) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 1),
                child: pw.Text(
                  term,
                  style: const pw.TextStyle(fontSize: 7),
                  textAlign: pw.TextAlign.center,
                ),
              )),
        ],
        pw.SizedBox(height: 8),
        pw.Text(
          'Thank you for your business!',
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '* * * * * * * * * * * * * * *',
          style: const pw.TextStyle(fontSize: 10),
          textAlign: pw.TextAlign.center,
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
      child: Text('Thermal Receipt Template\nUse PDF preview to see the full design'),
    );
  }
}
