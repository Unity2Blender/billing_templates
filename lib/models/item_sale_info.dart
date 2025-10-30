class ItemBasicInfo {
  final String name;
  final String description;
  final String hsnCode;
  final String qtyUnit;

  ItemBasicInfo({
    required this.name,
    this.description = '',
    this.hsnCode = '',
    this.qtyUnit = 'Nos',
  });
}

class ItemSaleInfo {
  final ItemBasicInfo item;
  final double partyNetPrice;
  final double qtyOnBill;
  final double subtotal;
  final double discountPercentage;
  final double discountAmt;
  final double taxableValue;
  final double igst;
  final double csgst;
  final double cessAmt;
  final double grossTaxCharged;
  final double lineTotal;

  ItemSaleInfo({
    required this.item,
    required this.partyNetPrice,
    required this.qtyOnBill,
    required this.subtotal,
    this.discountPercentage = 0.0,
    this.discountAmt = 0.0,
    required this.taxableValue,
    this.igst = 0.0,
    this.csgst = 0.0,
    this.cessAmt = 0.0,
    required this.grossTaxCharged,
    required this.lineTotal,
  });
}
