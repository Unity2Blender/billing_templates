import '../models/item_sale_info.dart' show ItemSaleInfo, ItemBasicInfo;
import '../models/custom_field_value.dart';

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
  /// **Custom Fields Support:**
  /// - customFieldInputs[] → Extracted where fieldSchema.isItemField == true
  /// - Parsed based on fieldSchema.formWidgetType (text, number, date, boolean, etc.)
  /// - Sorted by displayOrder for consistent rendering
  /// - Rendered inline within item name column across all templates
  ///
  /// **Ignored Fields (DocumentReferences and Metadata):**
  /// - item.itemRef → Database reference (not needed for PDF generation)
  /// - item.byFirms → List of firm refs (DB metadata)
  /// - item.partySpecificPrices → Pricing rules (already calculated in partyNetPrice)
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

    // Extract item-level custom fields
    final customFields = _extractItemCustomFields(itemStruct);

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
      customFields: customFields,
    );
  }

  /// Extracts item-level custom fields from customFieldInputs array.
  ///
  /// Filters for item-level fields (where fieldSchema.isItemField == true),
  /// extracts values based on field type, and sorts by displayOrder.
  static List<CustomFieldValue> _extractItemCustomFields(dynamic itemStruct) {
    try {
      // Access customFieldInputs array
      final customFieldInputs = itemStruct.customFieldInputs;
      if (customFieldInputs == null || customFieldInputs.isEmpty) {
        return [];
      }

      final List<CustomFieldValue> fields = [];

      for (var fieldInput in customFieldInputs) {
        final fieldSchema = fieldInput.fieldSchema;

        // Filter: Only include item-level fields
        if (fieldSchema?.isItemField != true) {
          continue;
        }

        // Extract field metadata
        final fieldName = fieldSchema?.nameLabel ?? '';
        final fieldType = _mapKeyboardInputTypeToFieldType(
          fieldSchema?.formWidgetType?.toString() ?? 'text'
        );

        // Extract value based on type
        final value = _extractFieldValue(fieldInput, fieldType);

        // Create CustomFieldValue
        fields.add(CustomFieldValue(
          fieldName: fieldName,
          fieldType: fieldType,
          value: value,
          displayOrder: 0, // FlutterFlow struct doesn't have displayOrder yet
          isRequired: false, // Not available in current struct
        ));
      }

      // Sort by displayOrder (though currently all are 0, this future-proofs the code)
      fields.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

      return fields;
    } catch (e) {
      // Gracefully handle extraction errors - return empty list
      return [];
    }
  }

  /// Maps KeyboardInputType enum to our field type strings.
  static String _mapKeyboardInputTypeToFieldType(String keyboardType) {
    final type = keyboardType.toLowerCase();

    if (type.contains('number') || type.contains('decimal')) {
      return 'number';
    } else if (type.contains('date') || type.contains('time')) {
      return 'date';
    } else if (type.contains('boolean') || type.contains('checkbox')) {
      return 'boolean';
    } else if (type.contains('multiselect')) {
      return 'multiselect';
    } else if (type.contains('select') || type.contains('dropdown')) {
      return 'select';
    } else {
      return 'text'; // Default to text
    }
  }

  /// Extracts the actual value from fieldInput based on field type.
  static dynamic _extractFieldValue(dynamic fieldInput, String fieldType) {
    try {
      // The fieldInputStr contains the value as a string
      final inputStr = fieldInput.fieldInputStr ?? '';

      if (inputStr.isEmpty) {
        return null;
      }

      switch (fieldType) {
        case 'number':
          return double.tryParse(inputStr) ?? 0.0;

        case 'boolean':
          return inputStr.toLowerCase() == 'true' || inputStr == '1';

        case 'date':
          return DateTime.tryParse(inputStr);

        case 'multiselect':
          // Assuming comma-separated values
          return inputStr.split(',').map((s) => s.trim()).toList();

        case 'text':
        case 'select':
        default:
          return inputStr;
      }
    } catch (e) {
      return null;
    }
  }
}

