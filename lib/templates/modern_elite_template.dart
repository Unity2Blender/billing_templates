import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import '../models/item_sale_info.dart';
import '../utils/invoice_colors.dart';
import '../utils/currency_formatter.dart';
import '../utils/pdf_font_helpers.dart';
import 'invoice_template_base.dart';

class ModernEliteTemplate extends InvoiceTemplate {
  @override
  String get id => 'modern_elite';

  @override
  String get name => 'Modern Elite';

  @override
  String get description =>
      'Clean, minimalist design with color theme support';

  @override
  String get screenshotPath =>
      'references/templateScreenshots/Modern_Elite.jpg';

  @override
  bool get supportsColorThemes => true;

  @override
  InvoiceColorTheme get defaultColorTheme => InvoiceThemes.purple;

  @override
  bool get supportsItemCustomFields => true;

  @override
  bool get supportsBusinessCustomFields => true;

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
          _buildInvoiceInfo(invoice),
          pw.SizedBox(height: 20),
          _buildPartyDetails(invoice),
          pw.SizedBox(height: 20),
          _buildItemsTable(invoice, theme),
          pw.SizedBox(height: 20),
          _buildBottomSection(invoice),
        ],
      ),
    );

    return pdf;
  }

  pw.Widget _buildHeader(InvoiceData invoice, InvoiceColorTheme theme) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Company name with logo placeholder
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding:
                      const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: pw.BoxDecoration(
                    color: theme.pdfPrimaryColor,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    '≫',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                ),
              ],
            ),
            pw.Text(
              invoice.invoiceMode.displayName.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          invoice.sellerDetails.businessName,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(invoice.sellerDetails.phone, style: PDFStyles.small),
        pw.Text(invoice.sellerDetails.state, style: PDFStyles.small),

        // Seller custom fields
        if (invoice.sellerDetails.customFields.isNotEmpty)
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 8),
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Additional Details',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 4),
                ...invoice.sellerDetails.customFields.map((field) =>
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Text(
                      '${field.fieldName}: ${field.displayValue}',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _buildInvoiceInfo(InvoiceData invoice) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice', style: PDFStyles.smallBold),
            pw.Text(invoice.fullInvoiceNumber, style: PDFStyles.body),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text('Date:', style: PDFStyles.smallBold),
            pw.Text(
              DateFormat('dd MMM, yyyy').format(invoice.issueDate),
              style: PDFStyles.body,
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildPartyDetails(InvoiceData invoice) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Bill To:', style: PDFStyles.subheading(PdfColors.grey800)),
        pw.SizedBox(height: 4),
        pw.Text(
          invoice.buyerDetails.businessName,
          style: PDFStyles.bodyBold,
        ),
        if (invoice.buyerDetails.phone.isNotEmpty)
          pw.Text('Mobile: ${invoice.buyerDetails.phone}',
              style: PDFStyles.body),
        if (invoice.buyerDetails.pan.isNotEmpty)
          pw.Text('PAN Number: ${invoice.buyerDetails.pan}',
              style: PDFStyles.body),

        // Buyer custom fields
        if (invoice.buyerDetails.customFields.isNotEmpty)
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 8),
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Additional Details',
                  style: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                  ),
                ),
                pw.SizedBox(height: 4),
                ...invoice.buyerDetails.customFields.map((field) =>
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Text(
                      '${field.fieldName}: ${field.displayValue}',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _buildItemsTable(InvoiceData invoice, InvoiceColorTheme theme) {
    // Check if any items have HSN codes
    final showHSN = PDFFontHelpers.hasHSNCodes(invoice.lineItems);

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        // Header
        pw.TableRow(
          decoration: pw.BoxDecoration(color: theme.pdfAccentColor),
          children: [
            _tableHeaderCell('Sample Item'),
            if (showHSN) _tableHeaderCell('HSN', align: pw.TextAlign.center),
            _tableHeaderCell('Quantity', align: pw.TextAlign.right),
            _tableHeaderCell('Price/Unit', align: pw.TextAlign.right),
            _tableHeaderCell('GST', align: pw.TextAlign.right),
            _tableHeaderCell('Amount', align: pw.TextAlign.right),
          ],
        ),
        // Items
        ...invoice.lineItems.map((item) {
          final qty =
              '${item.qtyOnBill.toStringAsFixed(0)} ${item.item.qtyUnit}';
          final gstPercent = '${item.grossTaxCharged.toStringAsFixed(1)}%';

          return pw.TableRow(
            children: [
              _buildItemNameCell(item),
              if (showHSN) _tableCell(item.item.hsnCode, align: pw.TextAlign.center),
              _tableCell(qty, align: pw.TextAlign.right),
              _tableCellRupee(item.partyNetPrice, align: pw.TextAlign.right),
              _tableCell(gstPercent, align: pw.TextAlign.right),
              _tableCellRupee(item.lineTotal, align: pw.TextAlign.right),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildBottomSection(InvoiceData invoice) {
    final hasNotes = invoice.notesFooter.isNotEmpty;
    final hasTerms = invoice.paymentTerms.isNotEmpty;

    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Left side - Notes and/or Terms & Conditions
        if (hasNotes || hasTerms)
          pw.Expanded(
            flex: 1,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Notes section
                if (hasNotes) ...[
                  pw.Text('Notes:', style: PDFStyles.bodyBold),
                  pw.SizedBox(height: 4),
                  pw.Text(invoice.notesFooter, style: PDFStyles.small),
                  if (hasTerms) pw.SizedBox(height: 8),
                ],
                // Terms & Conditions section
                if (hasTerms) ...[
                  pw.Text('Terms & Conditions:', style: PDFStyles.bodyBold),
                  pw.SizedBox(height: 4),
                  ...invoice.paymentTerms.map((term) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Text('• $term', style: PDFStyles.small),
                      )),
                ],
              ],
            ),
          ),
        if (hasNotes || hasTerms) pw.SizedBox(width: 20),
        // Right side - Pricing Summary + Signature
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _buildPricingSummary(invoice),
              pw.SizedBox(height: 20),
              _buildFooter(invoice),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildPricingSummary(InvoiceData invoice) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      padding: const pw.EdgeInsets.all(12),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Sub Total', style: PDFStyles.body),
              PDFFontHelpers.regularRupeeAmount(
                invoice.billSummary.totalTaxableValue,
                fontSize: 10,
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total Amount', style: PDFStyles.bodyBold),
              PDFFontHelpers.boldRupeeAmount(
                invoice.billSummary.totalLineItemsAfterTaxes,
                fontSize: 10,
              ),
            ],
          ),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Received Amount', style: PDFStyles.body),
              PDFFontHelpers.regularRupeeAmount(
                invoice.amountPaid,
                fontSize: 10,
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Transaction Balance', style: PDFStyles.bodyBold),
              PDFFontHelpers.boldRupeeAmount(
                invoice.billSummary.dueBalancePayable,
                fontSize: 10,
              ),
            ],
          ),
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
            pw.Container(height: 40, width: 100),
            pw.Divider(thickness: 1),
            pw.Text(
              'Authorised Signatory For',
              style: PDFStyles.small,
            ),
            pw.Text(
              invoice.sellerDetails.businessName,
              style: PDFStyles.bodyBold,
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _tableHeaderCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: PDFStyles.tableHeader(PdfColors.grey800),
        textAlign: align,
      ),
    );
  }

  pw.Widget _tableCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: PDFStyles.tableCell,
        textAlign: align,
      ),
    );
  }

  pw.Widget _tableCellRupee(double amount, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: PDFFontHelpers.regularRupeeAmount(
        amount,
        fontSize: 9,
        color: PdfColors.grey800,
        align: align,
      ),
    );
  }

  /// Builds the item name cell with description and custom fields stacked vertically
  pw.Widget _buildItemNameCell(ItemSaleInfo item) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          // Item name
          pw.Text(
            item.item.name,
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          // Description (if present)
          if (item.item.description.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                item.item.description,
                style: pw.TextStyle(
                  fontSize: 8,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColors.grey700,
                ),
              ),
            ),

          // Custom fields (if any)
          if (item.customFields.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(
                '(${item.customFields.map((f) => '${f.fieldName}: ${f.displayValue}').join(', ')})',
                style: pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey600,
                ),
              ),
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
    final theme = colorTheme ?? defaultColorTheme;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '≫',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        invoice.sellerDetails.businessName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        invoice.sellerDetails.phone,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                invoice.invoiceMode.displayName.toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Invoice info and rest of preview...
          Text(
            'Invoice: ${invoice.fullInvoiceNumber}',
            style: PreviewStyles.bodyBold,
          ),
          const SizedBox(height: 8),
          Text(
            'Bill To: ${invoice.buyerDetails.businessName}',
            style: PreviewStyles.body,
          ),
          const Spacer(),
          Text(
            'Total: ${CurrencyFormatter.format(invoice.billSummary.totalLineItemsAfterTaxes)}',
            style: PreviewStyles.heading,
          ),
        ],
      ),
    );
  }
}
