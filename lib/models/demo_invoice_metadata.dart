import 'invoice_data.dart';

/// Categories for organizing demo invoices
enum DemoCategory {
  basic('Basic Demos', 'Simple invoices for getting started'),
  gstTesting('GST Testing', 'Various GST scenarios and tax calculations'),
  documentTypes('Document Types', 'Different document formats and purposes'),
  thermalPos('Thermal/POS', 'Receipt formats for POS systems'),
  edgeCases('Edge Cases', 'Stress tests and unusual scenarios');

  const DemoCategory(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// Template identifiers for compatibility matching
enum TemplateType {
  a5Compact('A5 Compact'),
  mbbookTally('MBBook Tally'),
  tallyProfessional('Tally Professional'),
  mbbookModern('MBBook Modern'),
  mbbookDefault('MBBook Default'),
  modernElite('Modern Elite'),
  thermal('Thermal Receipt');

  const TemplateType(this.displayName);
  final String displayName;
}

/// Metadata for demo invoices with descriptive labels and compatibility info
class DemoInvoiceMetadata {
  final String id;
  final String descriptiveLabel;
  final DemoCategory category;
  final List<TemplateType> recommendedTemplates;
  final String quickInfo;
  final String testingPurpose;
  final InvoiceData Function() invoiceGetter;

  const DemoInvoiceMetadata({
    required this.id,
    required this.descriptiveLabel,
    required this.category,
    required this.recommendedTemplates,
    required this.quickInfo,
    required this.testingPurpose,
    required this.invoiceGetter,
  });

  /// Get the actual invoice data
  InvoiceData getInvoice() => invoiceGetter();
}
