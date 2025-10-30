/// Types of Invoice modes
enum InvoiceMode {
  salesInv,
  proformaInv,
  estimateInv,
  quotationInv,
  purchaseOrderInv,
  creditNoteInv,
  debitNoteInv,
  deliveryChallanInv,
}

enum PaymentMode {
  cash,
  upi,
  cheque,
  bankTransfer,
  credit,
}

extension InvoiceModeExtension on InvoiceMode {
  String get displayName {
    switch (this) {
      case InvoiceMode.salesInv:
        return 'Tax Invoice';
      case InvoiceMode.proformaInv:
        return 'Proforma Invoice';
      case InvoiceMode.estimateInv:
        return 'Estimate';
      case InvoiceMode.quotationInv:
        return 'Quotation';
      case InvoiceMode.purchaseOrderInv:
        return 'Purchase Order';
      case InvoiceMode.creditNoteInv:
        return 'Credit Note';
      case InvoiceMode.debitNoteInv:
        return 'Debit Note';
      case InvoiceMode.deliveryChallanInv:
        return 'Delivery Challan';
    }
  }
}

extension PaymentModeExtension on PaymentMode {
  String get displayName {
    switch (this) {
      case PaymentMode.cash:
        return 'Cash';
      case PaymentMode.upi:
        return 'UPI';
      case PaymentMode.cheque:
        return 'Cheque';
      case PaymentMode.bankTransfer:
        return 'Bank Transfer';
      case PaymentMode.credit:
        return 'Credit';
    }
  }
}
