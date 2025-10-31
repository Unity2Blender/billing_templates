import 'custom_field_value.dart';

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

  /// Custom fields for this line item (e.g., warranty, color, batch number)
  ///
  /// These are item-level custom fields (where isItemField == true in schema).
  /// Rendered inline within the item name column across all templates.
  /// Format: (FieldName: Value, Field2: Value2)
  final List<CustomFieldValue> customFields;

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
    this.customFields = const [],
  });
}
