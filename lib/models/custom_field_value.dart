/// Represents a custom field value extracted from FlutterFlow structs.
///
/// Custom fields can be item-level (displayed inline within item name column)
/// or business-level (displayed in "Additional Details" section of business details).
///
/// This model is the internal representation used by templates for rendering.
/// It is populated by adapters from CustomFieldInputValueStruct data.
class CustomFieldValue {
  /// Display label for the field (e.g., "Warranty", "HUID", "Vendor Code")
  final String fieldName;

  /// Field type identifier: 'text', 'number', 'date', 'boolean', 'select', 'multiselect'
  final String fieldType;

  /// The actual field value (type varies based on fieldType)
  ///
  /// - text/select: String
  /// - number: double
  /// - boolean: bool
  /// - date: DateTime
  /// - multiselect: List<String>
  final dynamic value;

  /// Sort order for rendering (lower numbers appear first)
  final int displayOrder;

  /// Whether this field is required (metadata, not enforced by renderer)
  final bool isRequired;

  CustomFieldValue({
    required this.fieldName,
    required this.fieldType,
    required this.value,
    this.displayOrder = 0,
    this.isRequired = false,
  });

  /// Returns the value formatted for display in PDFs
  ///
  /// Handles type-specific formatting:
  /// - boolean: 'Yes' / 'No'
  /// - date: DD-MM-YYYY format
  /// - number: 2 decimal places
  /// - multiselect: Comma-separated list
  /// - text/select: As-is string
  String get displayValue {
    if (value == null) return '-';

    switch (fieldType.toLowerCase()) {
      case 'boolean':
        return value == true ? 'Yes' : 'No';

      case 'date':
        if (value is DateTime) {
          final date = value as DateTime;
          return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
        }
        return value.toString();

      case 'number':
        if (value is double) {
          return value.toStringAsFixed(2);
        } else if (value is int) {
          return value.toString();
        }
        return value.toString();

      case 'multiselect':
        if (value is List) {
          return (value as List).join(', ');
        }
        return value.toString();

      case 'text':
      case 'select':
      default:
        return value.toString();
    }
  }

  /// Returns a concise string representation for debugging
  @override
  String toString() => 'CustomFieldValue(name: $fieldName, type: $fieldType, value: $value)';

  /// Creates a copy with optional field updates
  CustomFieldValue copyWith({
    String? fieldName,
    String? fieldType,
    dynamic value,
    int? displayOrder,
    bool? isRequired,
  }) {
    return CustomFieldValue(
      fieldName: fieldName ?? this.fieldName,
      fieldType: fieldType ?? this.fieldType,
      value: value ?? this.value,
      displayOrder: displayOrder ?? this.displayOrder,
      isRequired: isRequired ?? this.isRequired,
    );
  }

  /// Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomFieldValue &&
        other.fieldName == fieldName &&
        other.fieldType == fieldType &&
        other.value == value &&
        other.displayOrder == displayOrder &&
        other.isRequired == isRequired;
  }

  @override
  int get hashCode {
    return Object.hash(
      fieldName,
      fieldType,
      value,
      displayOrder,
      isRequired,
    );
  }
}
