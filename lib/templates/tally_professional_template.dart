import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import '../models/item_sale_info.dart';
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
  bool get supportsItemCustomFields => true;

  @override
  bool get supportsBusinessCustomFields => true;

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
          pw.SizedBox(height: 12),
          _buildGSTSummaryTable(invoice),
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

                    // Seller custom fields
                    if (invoice.sellerDetails.customFields.isNotEmpty)
                      pw.Container(
                        margin: const pw.EdgeInsets.only(top: 6),
                        padding: const pw.EdgeInsets.all(6),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey400),
                          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Additional Details',
                              style: pw.TextStyle(
                                fontSize: 8,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.grey800,
                              ),
                            ),
                            pw.SizedBox(height: 3),
                            ...invoice.sellerDetails.customFields.map((field) =>
                              pw.Padding(
                                padding: const pw.EdgeInsets.only(bottom: 2),
                                child: pw.Text(
                                  '${field.fieldName}: ${field.displayValue}',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    color: PdfColors.grey700,
                                  ),
                                ),
                              ),
                            ),
                          ],
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

                  // Buyer custom fields
                  if (invoice.buyerDetails.customFields.isNotEmpty)
                    pw.Container(
                      margin: const pw.EdgeInsets.only(top: 6),
                      padding: const pw.EdgeInsets.all(6),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400),
                        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Additional Details',
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                          ),
                          pw.SizedBox(height: 3),
                          ...invoice.buyerDetails.customFields.map((field) =>
                            pw.Padding(
                              padding: const pw.EdgeInsets.only(bottom: 2),
                              child: pw.Text(
                                '${field.fieldName}: ${field.displayValue}',
                                style: pw.TextStyle(
                                  fontSize: 7,
                                  color: PdfColors.grey700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
              _buildItemNameCell(item),
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

  /// Builds the item name cell with description and custom fields stacked vertically
  pw.Widget _buildItemNameCell(ItemSaleInfo item) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          // Item name
          pw.Text(
            item.item.name,
            style: pw.TextStyle(
              fontSize: 7,
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
                  fontSize: 6,
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
                  fontSize: 6,
                  color: PdfColors.grey600,
                ),
              ),
            ),
        ],
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

  pw.Widget _buildGSTSummaryTable(InvoiceData invoice) {
    // Check if any item has CESS
    final hasCess = invoice.lineItems.any((item) => item.cessAmt > 0);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          child: pw.Text(
            'Tax Summary:',
            style: pw.TextStyle(
              fontSize: 9,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.black, width: 1.5),
          ),
          child: pw.Table(
            border: pw.TableBorder.all(color: PdfColors.black),
            columnWidths: _getGSTTableColumnWidths(invoice.isIntraState, hasCess),
            children: [
              _buildGSTTableHeader(invoice.isIntraState, hasCess),
              ..._buildGSTTableRows(invoice),
              _buildGSTTableTotalsRow(invoice, hasCess),
            ],
          ),
        ),
      ],
    );
  }

  Map<int, pw.TableColumnWidth> _getGSTTableColumnWidths(bool isIntraState, bool hasCess) {
    if (isIntraState) {
      return hasCess
          ? {
              0: const pw.FlexColumnWidth(1.5), // HSN/SAC
              1: const pw.FlexColumnWidth(1.5), // Taxable Amount
              2: const pw.FlexColumnWidth(1), // CGST Rate
              3: const pw.FlexColumnWidth(1.2), // CGST Amount
              4: const pw.FlexColumnWidth(1), // SGST Rate
              5: const pw.FlexColumnWidth(1.2), // SGST Amount
              6: const pw.FlexColumnWidth(1), // CESS
              7: const pw.FlexColumnWidth(1.3), // Total Tax
            }
          : {
              0: const pw.FlexColumnWidth(1.5), // HSN/SAC
              1: const pw.FlexColumnWidth(1.5), // Taxable Amount
              2: const pw.FlexColumnWidth(1), // CGST Rate
              3: const pw.FlexColumnWidth(1.2), // CGST Amount
              4: const pw.FlexColumnWidth(1), // SGST Rate
              5: const pw.FlexColumnWidth(1.2), // SGST Amount
              6: const pw.FlexColumnWidth(1.3), // Total Tax
            };
    } else {
      return hasCess
          ? {
              0: const pw.FlexColumnWidth(1.5), // HSN/SAC
              1: const pw.FlexColumnWidth(1.5), // Taxable Amount
              2: const pw.FlexColumnWidth(1), // IGST Rate
              3: const pw.FlexColumnWidth(1.2), // IGST Amount
              4: const pw.FlexColumnWidth(1), // CESS
              5: const pw.FlexColumnWidth(1.3), // Total Tax
            }
          : {
              0: const pw.FlexColumnWidth(1.5), // HSN/SAC
              1: const pw.FlexColumnWidth(1.5), // Taxable Amount
              2: const pw.FlexColumnWidth(1), // IGST Rate
              3: const pw.FlexColumnWidth(1.2), // IGST Amount
              4: const pw.FlexColumnWidth(1.3), // Total Tax
            };
    }
  }

  pw.TableRow _buildGSTTableHeader(bool isIntraState, bool hasCess) {
    final List<pw.Widget> headerCells = [
      _buildGSTHeaderCell('HSN/SAC'),
      _buildGSTHeaderCell('Taxable\nAmount'),
    ];

    if (isIntraState) {
      headerCells.addAll([
        _buildGSTHeaderCell('CGST\nRate (%)'),
        _buildGSTHeaderCell('CGST\nAmount'),
        _buildGSTHeaderCell('SGST\nRate (%)'),
        _buildGSTHeaderCell('SGST\nAmount'),
      ]);
    } else {
      headerCells.addAll([
        _buildGSTHeaderCell('IGST\nRate (%)'),
        _buildGSTHeaderCell('IGST\nAmount'),
      ]);
    }

    if (hasCess) {
      headerCells.add(_buildGSTHeaderCell('CESS'));
    }

    headerCells.add(_buildGSTHeaderCell('Total Tax'));

    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: headerCells,
    );
  }

  pw.Widget _buildGSTHeaderCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 7,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  List<pw.TableRow> _buildGSTTableRows(InvoiceData invoice) {
    final hasCess = invoice.lineItems.any((item) => item.cessAmt > 0);

    return invoice.lineItems.map((item) {
      final List<pw.Widget> cells = [
        _buildGSTDataCell(item.item.hsnCode.isEmpty ? '-' : item.item.hsnCode),
        _buildGSTDataCellRupee(item.taxableValue),
      ];

      if (invoice.isIntraState) {
        // Calculate CGST and SGST (split csgst in half)
        final cgstAmt = item.csgst / 2;
        final sgstAmt = item.csgst / 2;
        final cgstRate = _calculateTaxRate(cgstAmt, item.taxableValue);
        final sgstRate = _calculateTaxRate(sgstAmt, item.taxableValue);

        cells.addAll([
          _buildGSTDataCell(cgstRate.toStringAsFixed(2)),
          _buildGSTDataCellRupee(cgstAmt),
          _buildGSTDataCell(sgstRate.toStringAsFixed(2)),
          _buildGSTDataCellRupee(sgstAmt),
        ]);
      } else {
        // IGST
        final igstRate = _calculateTaxRate(item.igst, item.taxableValue);

        cells.addAll([
          _buildGSTDataCell(igstRate.toStringAsFixed(2)),
          _buildGSTDataCellRupee(item.igst),
        ]);
      }

      if (hasCess) {
        cells.add(_buildGSTDataCellRupee(item.cessAmt));
      }

      cells.add(_buildGSTDataCellRupee(item.grossTaxCharged));

      return pw.TableRow(children: cells);
    }).toList();
  }

  pw.TableRow _buildGSTTableTotalsRow(InvoiceData invoice, bool hasCess) {
    final List<pw.Widget> cells = [
      _buildGSTTotalCell('Total'),
      _buildGSTDataCellRupee(invoice.billSummary.totalTaxableValue, isBold: true),
    ];

    if (invoice.isIntraState) {
      final totalCgst = invoice.billSummary.totalGst / 2;
      final totalSgst = invoice.billSummary.totalGst / 2;

      cells.addAll([
        _buildGSTDataCell(''), // Empty rate cell
        _buildGSTDataCellRupee(totalCgst, isBold: true),
        _buildGSTDataCell(''), // Empty rate cell
        _buildGSTDataCellRupee(totalSgst, isBold: true),
      ]);
    } else {
      cells.addAll([
        _buildGSTDataCell(''), // Empty rate cell
        _buildGSTDataCellRupee(invoice.billSummary.totalGst, isBold: true),
      ]);
    }

    if (hasCess) {
      cells.add(_buildGSTDataCellRupee(invoice.billSummary.totalCess, isBold: true));
    }

    cells.add(_buildGSTDataCellRupee(invoice.billSummary.totalGst + invoice.billSummary.totalCess, isBold: true));

    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey300),
      children: cells,
    );
  }

  pw.Widget _buildGSTTotalCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 7,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildGSTDataCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 7),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildGSTDataCellRupee(double amount, {bool isBold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      child: isBold
          ? PDFFontHelpers.boldRupeeAmount(
              amount,
              fontSize: 7,
              align: pw.TextAlign.right,
            )
          : PDFFontHelpers.regularRupeeAmount(
              amount,
              fontSize: 7,
              color: PdfColors.grey800,
              align: pw.TextAlign.right,
            ),
    );
  }

  double _calculateTaxRate(double taxAmount, double taxableValue) {
    if (taxableValue == 0) {
      print('Warning: Taxable value is 0, cannot calculate tax rate. Returning 0%.');
      return 0.0;
    }
    return (taxAmount / taxableValue) * 100;
  }

  pw.Widget _buildFooter(InvoiceData invoice, pw.Context context) {
    final hasNotes = invoice.notesFooter.isNotEmpty;
    final hasTerms = invoice.paymentTerms.isNotEmpty;

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 1.5),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Left side - Notes and/or Terms & Conditions
          pw.Expanded(
            flex: 1,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Notes section
                if (hasNotes) ...[
                  pw.Text(
                    'Notes:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    invoice.notesFooter,
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                  if (hasTerms) pw.SizedBox(height: 8),
                ],
                // Terms & Conditions section
                if (hasTerms) ...[
                  pw.Text(
                    'Terms & Conditions:',
                    style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  ...invoice.paymentTerms.map((term) => pw.Padding(
                        padding: const pw.EdgeInsets.only(bottom: 2),
                        child: pw.Text(
                          '• $term',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      )),
                ],
                // If neither, show minimal placeholder
                if (!hasNotes && !hasTerms)
                  pw.Text(
                    'Thank you for your business.',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
              ],
            ),
          ),
          pw.SizedBox(width: 12),
          // Right side - Signature
          pw.Expanded(
            flex: 1,
            child: pw.Column(
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
