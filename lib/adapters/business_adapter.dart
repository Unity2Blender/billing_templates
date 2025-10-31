import '../models/business_details.dart';

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
  /// **Ignored Fields (DocumentReferences and Metadata):**
  /// - partyRef → Database reference (not needed for PDF generation)
  /// - customFieldValues → Custom field values with refs (not rendered in standard templates)
  /// - isCustomer → Business type flag (DB metadata, not rendered)
  /// - isVendor → Business type flag (DB metadata, not rendered)
  ///
  /// **Note:** This adapter is used for both seller and buyer business details.
  /// The same struct type (BusinessDetailsStruct) is used for both parties in invoices.
  static BusinessDetails fromFlutterFlowStruct(dynamic businessStruct) {
    return BusinessDetails(
      businessName: businessStruct.businessName ?? '',
      gstin: businessStruct.gstin ?? '',
      pan: businessStruct.pan ?? '',
      state: businessStruct.state ?? '',
      district: businessStruct.district ?? '',
      businessAddress: businessStruct.businessAddress ?? '',
      phone: businessStruct.phone ?? '',
      email: businessStruct.email ?? '',
    );
  }
}

