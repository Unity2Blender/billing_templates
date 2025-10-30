class BillSummary {
  final double totalTaxableValue;
  final double totalDiscount;
  final double totalGst;
  final double totalCess;
  final double totalLineItemsAfterTaxes;
  final double dueBalancePayable;

  BillSummary({
    required this.totalTaxableValue,
    this.totalDiscount = 0.0,
    required this.totalGst,
    this.totalCess = 0.0,
    required this.totalLineItemsAfterTaxes,
    required this.dueBalancePayable,
  });
}
