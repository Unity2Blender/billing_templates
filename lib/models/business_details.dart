import 'custom_field_value.dart';

class BusinessDetails {
  final String businessName;
  final String phone;
  final String email;
  final String gstin;
  final String pan;
  final String state;
  final String district;
  final String businessAddress;

  /// Custom fields for this business (e.g., vendor code, credit limit, certifications)
  ///
  /// These are business-level custom fields (where isBusinessField == true in schema).
  /// Rendered in a separate "Additional Details" section within seller/buyer details.
  /// Note: Party-specific filtering is not implemented (deferred to v2.1).
  final List<CustomFieldValue> customFields;

  BusinessDetails({
    required this.businessName,
    this.phone = '',
    this.email = '',
    this.gstin = '',
    this.pan = '',
    this.state = '',
    this.district = '',
    this.businessAddress = '',
    this.customFields = const [],
  });
}
