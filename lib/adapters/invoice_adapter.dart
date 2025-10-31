import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import 'business_adapter.dart';
import 'item_adapter.dart';
import 'bill_summary_adapter.dart';
import 'banking_adapter.dart';

/// Adapter to convert FlutterFlow InvoiceStruct to internal InvoiceData model.
///
/// This adapter bridges your FlutterFlow app's data structures with the
/// invoice template library's internal models. It handles the conversion
/// of complex nested structures while preserving all invoice metadata.
///
/// **Important:** Your app is responsible for fetching ALL data from Firestore
/// before calling this adapter. Pass fully populated structs, not DocumentReferences.
///
/// Usage:
/// ```dart
/// // Your app fetches complete data
/// final invoice = InvoiceStruct.fromMap(invoiceDoc.data()!);
/// final firm = FirmConfigStruct.fromMap(firmDoc.data()!);
///
/// // Adapter converts (pure, synchronous)
/// final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
///   invoice: invoice,
///   sellerFirm: firm,
/// );
/// ```
class InvoiceAdapter {
  /// Converts a FlutterFlow InvoiceStruct to internal InvoiceData model.
  ///
  /// **Required Parameters:**
  /// - `invoice`: Your FlutterFlow InvoiceStruct with all invoice details
  ///   (fully populated, including nested structs)
  /// - `sellerFirm`: FirmConfigStruct with complete seller information
  ///   (not a DocumentReference - your app must fetch this first)
  ///
  /// **Data Extraction:**
  /// - Seller details: sellerFirm.businessDetails
  /// - Logos: sellerFirm.shopLogo, sellerFirm.signLogo
  /// - Banking: sellerFirm.bankAccounts[0] (if available)
  /// - Buyer details: invoice.billToParty
  /// - Line items: invoice.lines
  /// - Bill summary: invoice.billSummary
  ///
  /// **Ignored Fields (DocumentReferences):**
  /// - invoice.invoiceRef (DB metadata)
  /// - invoice.sellerFirm (we use the passed struct instead)
  /// - invoice.referenceInvoiceRef (DB metadata)
  /// - All custom field refs (we only use field values)
  ///
  /// **Mapping Notes:**
  /// - Invoice mode: modeSpecifcDetails.modeType → InvoiceMode
  /// - Dates: modeSpecifcDetails.dates → issueDate, dueDate
  /// - Line items: invoice.lines → List<ItemSaleInfo>
  /// - Bill summary: invoice.billSummary → BillSummary
  /// - Payment: invoice.amountPaid, invoice.paymentMode
  static InvoiceData fromFlutterFlowStruct({
    required dynamic invoice, // InvoiceStruct from your app
    required dynamic sellerFirm, // FirmConfigStruct (not DocumentReference!)
  }) {
    // Extract invoice mode configuration
    final modeConfig = invoice.modeSpecifcDetails;
    final invoiceMode = _mapInvoiceMode(modeConfig.modeType);

    // Build invoice number (prefix + ID)
    final invoiceNumber = modeConfig.modeId.toString();
    final invoicePrefix = modeConfig.modeIdPrefix ?? '';

    // Extract dates
    final dates = modeConfig.dates;
    final issueDate = dates.issueDate ?? DateTime.now();
    final dueDate = dates.dueDate;

    // Convert business details (seller from firm, buyer from invoice)
    final sellerDetails = BusinessAdapter.fromFlutterFlowStruct(
      sellerFirm.businessDetails,
    );
    final buyerDetails = BusinessAdapter.fromFlutterFlowStruct(
      invoice.billToParty,
    );

    // Extract logos from firm
    final logoUrl = sellerFirm.shopLogo ?? '';
    final signatureUrl = sellerFirm.signLogo ?? '';

    // Convert line items
    final lineItems = invoice.lines
        .map<dynamic>((line) => ItemAdapter.fromFlutterFlowStruct(line))
        .toList();

    // Convert bill summary
    final billSummary = BillSummaryAdapter.fromFlutterFlowStruct(
      invoice.billSummary,
      invoice.amountPaid ?? 0.0,
    );

    // Map payment mode
    final paymentMode = _mapPaymentMode(invoice.paymentMode);

    // Extract payment terms
    final paymentTerms = modeConfig.paymentTerms ?? <String>[];

    // Convert banking details (first account if available)
    final bankingDetails = sellerFirm.bankAccounts != null &&
            sellerFirm.bankAccounts.isNotEmpty
        ? BankingAdapter.fromFlutterFlowStruct(sellerFirm.bankAccounts.first)
        : null;

    return InvoiceData(
      invoiceNumber: invoiceNumber,
      invoicePrefix: invoicePrefix,
      invoiceMode: invoiceMode,
      issueDate: issueDate,
      dueDate: dueDate,
      sellerDetails: sellerDetails,
      buyerDetails: buyerDetails,
      lineItems: lineItems,
      billSummary: billSummary,
      amountPaid: invoice.amountPaid ?? 0.0,
      paymentMode: paymentMode,
      notesFooter: invoice.notesFooter ?? '',
      logoUrl: logoUrl.isEmpty ? null : logoUrl,
      signatureUrl: signatureUrl.isEmpty ? null : signatureUrl,
      paymentTerms: paymentTerms,
      bankDetails: bankingDetails,
    );
  }

  /// Maps FlutterFlow InvoiceMode enum to internal InvoiceMode enum.
  static dynamic _mapInvoiceMode(dynamic flutterFlowMode) {
    // InvoiceMode enum values from FlutterFlow:
    // salesInv, proformaInv, estimateInv, quotationInv,
    // purchaseOrderInv, creditNoteInv, debitNoteInv, deliveryChallanInv

    final modeString = flutterFlowMode.toString().split('.').last;

    switch (modeString) {
      case 'salesInv':
        return InvoiceMode.salesInv;
      case 'proformaInv':
        return InvoiceMode.proformaInv;
      case 'estimateInv':
        return InvoiceMode.estimateInv;
      case 'quotationInv':
        return InvoiceMode.quotationInv;
      case 'purchaseOrderInv':
        return InvoiceMode.purchaseOrderInv;
      case 'creditNoteInv':
        return InvoiceMode.creditNoteInv;
      case 'debitNoteInv':
        return InvoiceMode.debitNoteInv;
      case 'deliveryChallanInv':
        return InvoiceMode.deliveryChallanInv;
      default:
        return InvoiceMode.salesInv; // Default fallback
    }
  }

  /// Maps FlutterFlow PaymentMode enum to internal PaymentMode enum.
  static dynamic _mapPaymentMode(dynamic flutterFlowMode) {
    final modeString = flutterFlowMode.toString().split('.').last;

    switch (modeString) {
      case 'CASH':
        return PaymentMode.cash;
      case 'UPI':
        return PaymentMode.upi;
      case 'CHEQUE':
        return PaymentMode.cheque;
      case 'BANK_TRANSFER':
        return PaymentMode.bankTransfer;
      case 'CREDIT':
        return PaymentMode.credit;
      default:
        return PaymentMode.cash;
    }
  }

}
