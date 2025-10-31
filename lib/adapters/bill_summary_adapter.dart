import '../models/bill_summary.dart';

/// Adapter to convert FlutterFlow BillSummaryResultsStruct to internal BillSummary model.
///
/// Handles conversion of invoice totals, tax summaries, and payment calculations.
class BillSummaryAdapter {
  /// Converts FlutterFlow BillSummaryResultsStruct to internal BillSummary model.
  ///
  /// **Field Mapping:**
  /// - totalTaxableValue → totalTaxableValue (before tax)
  /// - totalDiscount → totalDiscount
  /// - totalGst → totalGst (GST amount)
  /// - totalCess → totalCess
  /// - totalLineItemsAfterTaxes → totalLineItemsAfterTaxes (final amount)
  /// - dueBalancePayable → dueBalancePayable (amount remaining)
  ///
  /// **Parameters:**
  /// - `billSummaryStruct`: FlutterFlow BillSummaryResultsStruct
  /// - `amountPaid`: Amount already paid (from InvoiceStruct.amountPaid)
  ///
  /// **Calculation Notes:**
  /// - Balance is calculated as: grandTotal - amountPaid if not provided in struct
  static BillSummary fromFlutterFlowStruct(
    dynamic billSummaryStruct,
    double amountPaid,
  ) {
    final subtotal = billSummaryStruct.totalTaxableValue ?? 0.0;
    final discount = billSummaryStruct.totalDiscount ?? 0.0;
    final tax = billSummaryStruct.totalGst ?? 0.0;
    final cess = billSummaryStruct.totalCess ?? 0.0;
    final grandTotal = billSummaryStruct.totalLineItemsAfterTaxes ?? 0.0;

    return BillSummary(
      totalTaxableValue: subtotal,
      totalDiscount: discount,
      totalGst: tax,
      totalCess: cess,
      totalLineItemsAfterTaxes: grandTotal,
      dueBalancePayable: billSummaryStruct.dueBalancePayable ?? (grandTotal - amountPaid),
    );
  }
}
