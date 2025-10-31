import '../models/business_details.dart';
import '../models/custom_field_value.dart';

/// Adapter to convert FlutterFlow BusinessDetailsStruct to internal BusinessDetails model.
///
/// Handles conversion of business/party information including GST details,
/// contact information, and address fields.
class BusinessAdapter {
  /// Converts FlutterFlow BusinessDetailsStruct to internal BusinessDetails model.
  ///
  /// **Field Mapping:**
  /// - businessName → businessName
  /// - gstin → gstin (GST Identification Number)
  /// - pan → pan (Permanent Account Number)
  /// - state → state (for intra/inter-state GST determination)
  /// - district → district
  /// - businessAddress → businessAddress
  /// - phone → phone
  /// - email → email
  ///
  /// **Custom Fields Support:**
  /// - customFieldValues[] → Extracted where fieldSchema.isBusinessField == true
  /// - Rendered in "Additional Details" section within seller/buyer details
  /// - Party-specific filtering NOT implemented (deferred to v2.1)
  /// - All business-level custom fields apply universally
  ///
  /// **Ignored Fields (DocumentReferences and Metadata):**
  /// - partyRef → Database reference (not needed for PDF generation)
  /// - isCustomer → Business type flag (DB metadata, not rendered)
  /// - isVendor → Business type flag (DB metadata, not rendered)
  ///
  /// **Note:** This adapter is used for both seller and buyer business details.
  /// The same struct type (BusinessDetailsStruct) is used for both parties in invoices.
  static BusinessDetails fromFlutterFlowStruct(dynamic businessStruct) {
    // Extract business-level custom fields
    final customFields = _extractBusinessCustomFields(businessStruct);

    return BusinessDetails(
      businessName: businessStruct.businessName ?? '',
      gstin: businessStruct.gstin ?? '',
      pan: businessStruct.pan ?? '',
      state: businessStruct.state ?? '',
      district: businessStruct.district ?? '',
      businessAddress: businessStruct.businessAddress ?? '',
      phone: businessStruct.phone ?? '',
      email: businessStruct.email ?? '',
      customFields: customFields,
    );
  }

  /// Extracts business-level custom fields from customFieldValues array.
  ///
  /// Filters for business-level fields (where fieldSchema.isBusinessField == true),
  /// extracts values based on field type, and sorts by displayOrder.
  ///
  /// Note: Party-specific filtering (by partyRef) is not implemented in v2.0.
  /// All business custom fields apply universally.
  static List<CustomFieldValue> _extractBusinessCustomFields(dynamic businessStruct) {
    try {
      // Access customFieldValues array
      final customFieldValues = businessStruct.customFieldValues;
      if (customFieldValues == null || customFieldValues.isEmpty) {
        return [];
      }

      final List<CustomFieldValue> fields = [];

      for (var fieldValue in customFieldValues) {
        final fieldSchema = fieldValue.fieldSchema;

        // Filter: Only include business-level fields
        if (fieldSchema?.isBusinessField != true) {
          continue;
        }

        // Extract field metadata
        final fieldName = fieldSchema?.nameLabel ?? '';
        final fieldType = _mapKeyboardInputTypeToFieldType(
          fieldSchema?.formWidgetType?.toString() ?? 'text'
        );

        // Extract value based on type
        final value = _extractFieldValue(fieldValue, fieldType);

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

  /// Extracts the actual value from fieldValue based on field type.
  static dynamic _extractFieldValue(dynamic fieldValue, String fieldType) {
    try {
      // The fieldInputStr contains the value as a string
      final inputStr = fieldValue.fieldInputStr ?? '';

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

