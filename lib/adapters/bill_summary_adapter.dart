import '../models/bill_summary.dart';

/// Adapter to convert FlutterFlow BillSummaryResultsStruct to internal BillSummary model.
///
/// Handles conversion of invoice totals, tax summaries, and payment calculations.
class BillSummaryAdapter {
  /// Converts FlutterFlow BillSummaryResultsStruct to internal BillSummary model.
  ///
  /// **Field Mapping:**
  /// - totalTaxableValue → subtotal (before tax)
  /// - totalDiscount → totalDiscount
  /// - totalGst → totalTax (GST amount)
  /// - totalCess → totalCess
  /// - totalLineItemsAfterTaxes → grandTotal (final amount)
  /// - dueBalancePayable → balance (amount remaining)
  ///
  /// **Parameters:**
  /// - `billSummaryStruct`: FlutterFlow BillSummaryResultsStruct
  /// - `amountPaid`: Amount already paid (from InvoiceStruct.amountPaid)
  ///
  /// **Calculation Notes:**
  /// - Round-off is calculated as: grandTotal - (subtotal - discount + tax + cess)
  /// - This accounts for rounding differences in individual line items
  static BillSummary fromFlutterFlowStruct(
    dynamic billSummaryStruct,
    double amountPaid,
  ) {
    final subtotal = billSummaryStruct.totalTaxableValue ?? 0.0;
    final discount = billSummaryStruct.totalDiscount ?? 0.0;
    final tax = billSummaryStruct.totalGst ?? 0.0;
    final cess = billSummaryStruct.totalCess ?? 0.0;
    final grandTotal = billSummaryStruct.totalLineItemsAfterTaxes ?? 0.0;

    // Calculate round-off (accounts for rounding in line items)
    final calculatedTotal = subtotal - discount + tax + cess;
    final roundOff = grandTotal - calculatedTotal;

    return BillSummary(
      subtotal: subtotal,
      totalDiscount: discount,
      totalTax: tax,
      totalCess: cess,
      roundOff: roundOff,
      grandTotal: grandTotal,
      amountPaid: amountPaid,
      balance: billSummaryStruct.dueBalancePayable ?? (grandTotal - amountPaid),
    );
  }
}
