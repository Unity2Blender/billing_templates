import 'invoice_enums.dart';
import 'business_details.dart';
import 'item_sale_info.dart';
import 'bill_summary.dart';

class InvoiceData {
  final String invoiceNumber;
  final String invoicePrefix;
  final InvoiceMode invoiceMode;
  final DateTime issueDate;
  final DateTime? dueDate;
  final BusinessDetails sellerDetails;
  final BusinessDetails buyerDetails;
  final List<ItemSaleInfo> lineItems;
  final BillSummary billSummary;
  final double amountPaid;
  final PaymentMode paymentMode;
  final String notesFooter;
  final String? logoUrl;
  final String? signatureUrl;
  final List<String> paymentTerms;
  final BankingDetails? bankDetails;

  InvoiceData({
    required this.invoiceNumber,
    this.invoicePrefix = '',
    required this.invoiceMode,
    required this.issueDate,
    this.dueDate,
    required this.sellerDetails,
    required this.buyerDetails,
    required this.lineItems,
    required this.billSummary,
    this.amountPaid = 0.0,
    this.paymentMode = PaymentMode.cash,
    this.notesFooter = '',
    this.logoUrl,
    this.signatureUrl,
    this.paymentTerms = const [],
    this.bankDetails,
  });

  String get fullInvoiceNumber => '$invoicePrefix$invoiceNumber';

  bool get isIntraState =>
      sellerDetails.state.isNotEmpty &&
      buyerDetails.state.isNotEmpty &&
      sellerDetails.state == buyerDetails.state;
}

class BankingDetails {
  final String bankName;
  final String accountNo;
  final String ifsc;
  final String accountHolderName;
  final String upi;
  final String branchAddress;

  BankingDetails({
    required this.bankName,
    required this.accountNo,
    required this.ifsc,
    required this.accountHolderName,
    this.upi = '',
    this.branchAddress = '',
  });
}
