import '../models/item_sale_info.dart' show ItemSaleInfo, ItemBasicInfo;

/// Adapter to convert FlutterFlow ItemSaleInfoStruct to internal ItemSaleInfo model.
///
/// Handles conversion of line items including product details, pricing,
/// quantities, discounts, and tax calculations.
class ItemAdapter {
  /// Converts FlutterFlow ItemSaleInfoStruct to internal ItemSaleInfo model.
  ///
  /// **Field Mapping:**
  /// - item.name → itemName
  /// - item.hsnCode → hsnCode
  /// - item.description → description
  /// - qtyOnBill → quantity
  /// - item.qtyUnit → unit
  /// - partyNetPrice (or item.defaultNetPrice if null) → rate
  /// - subtotal → subtotal (before discount)
  /// - discountPercentage → discount (%)
  /// - discountAmt → discountAmount
  /// - taxableValue → taxableValue (after discount)
  /// - igst → igst (inter-state GST amount)
  /// - csgst → csgst (combined CGST+SGST for intra-state, kept as-is)
  /// - cessAmt → cessAmt
  /// - grossTaxCharged → taxRate (total GST % + CESS %)
  /// - lineTotal → total (final amount)
  ///
  /// **Ignored Fields (DocumentReferences and Metadata):**
  /// - item.itemRef → Database reference (not needed for PDF generation)
  /// - item.byFirms → List of firm refs (DB metadata)
  /// - item.partySpecificPrices → Pricing rules (already calculated in partyNetPrice)
  /// - customFieldInputs → Custom field values (not rendered in standard templates)
  ///
  /// **Tax Calculation Notes:**
  /// - The `csgst` field in FlutterFlow struct represents CGST+SGST combined amount
  /// - We pass it through as-is to the internal model (templates handle CGST/SGST split)
  /// - For inter-state transactions, only `igst` is used (csgst will be 0)
  /// - For intra-state transactions, `igst` will be 0 and csgst contains combined value
  /// - Total tax rate percentage is stored in `grossTaxCharged` field
  /// - Your app should pre-calculate all tax amounts before passing to this adapter
  static ItemSaleInfo fromFlutterFlowStruct(dynamic itemStruct) {
    final item = itemStruct.item; // ItemBasicInfoStruct

    // Extract tax configuration from item (used as fallback if grossTaxCharged is null)
    final taxConfig = item.taxRatesConfig;
    final gstPercent = taxConfig.gstPercent ?? 0.0;
    final cessPercent = taxConfig.cessPercent ?? 0.0;

    // Create ItemBasicInfo from nested item struct
    final itemBasicInfo = ItemBasicInfo(
      name: item.name ?? '',
      description: item.description ?? '',
      hsnCode: item.hsnCode ?? '',
      qtyUnit: item.qtyUnit ?? 'Nos',
    );

    return ItemSaleInfo(
      item: itemBasicInfo,
      partyNetPrice: itemStruct.partyNetPrice ?? item.defaultNetPrice ?? 0.0,
      qtyOnBill: itemStruct.qtyOnBill ?? 0.0,
      subtotal: itemStruct.subtotal ?? 0.0,
      discountPercentage: itemStruct.discountPercentage ?? 0.0,
      discountAmt: itemStruct.discountAmt ?? 0.0,
      taxableValue: itemStruct.taxableValue ?? 0.0,
      grossTaxCharged: itemStruct.grossTaxCharged ?? (gstPercent + cessPercent),
      igst: itemStruct.igst ?? 0.0,
      csgst: itemStruct.csgst ?? 0.0, // Combined CGST+SGST for intra-state
      cessAmt: itemStruct.cessAmt ?? 0.0,
      lineTotal: itemStruct.lineTotal ?? 0.0,
    );
  }
}

