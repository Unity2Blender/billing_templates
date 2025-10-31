import '../models/demo_invoice_metadata.dart';
import '../data/demo_invoices.dart';

class DemoHelpers {
  /// Get all demo invoice metadata with categories and compatibility info
  static List<DemoInvoiceMetadata> getAllDemoMetadata() {
    return [
      // === BASIC DEMOS ===
      DemoInvoiceMetadata(
        id: 'solar_panel',
        descriptiveLabel: 'Solar Panel (High-Value Single Item)',
        category: DemoCategory.basic,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '1 item • ₹4.8L • CGST+SGST',
        testingPurpose: 'High-value single item transaction',
        invoiceGetter: DemoInvoices.getSampleInvoice1,
      ),
      DemoInvoiceMetadata(
        id: 'basic_sample',
        descriptiveLabel: 'Basic Invoice (Simple Demo)',
        category: DemoCategory.basic,
        recommendedTemplates: [
          TemplateType.mbbookModern,
          TemplateType.modernElite,
          TemplateType.a5Compact,
        ],
        quickInfo: '1 item • ₹2,596 • 18% GST',
        testingPurpose: 'Minimal invoice for quick testing',
        invoiceGetter: DemoInvoices.getSampleInvoice2,
      ),
      DemoInvoiceMetadata(
        id: 'electronics_b2b',
        descriptiveLabel: 'Electronics B2B (Multi-Item, Discount)',
        category: DemoCategory.basic,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '3 items • ₹2.8L • IGST + Discount',
        testingPurpose: 'Inter-state with discounts and bank details',
        invoiceGetter: DemoInvoices.getSampleInvoice3,
      ),
      DemoInvoiceMetadata(
        id: 'fashion_proforma',
        descriptiveLabel: 'Fashion Proforma (Mixed GST Rates)',
        category: DemoCategory.documentTypes,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.mbbookModern,
        ],
        quickInfo: '2 items • ₹64.5K • 5% & 10% GST',
        testingPurpose: 'Proforma invoice with mixed GST rates',
        invoiceGetter: DemoInvoices.getSampleInvoice4,
      ),
      DemoInvoiceMetadata(
        id: 'a5_retail_bill',
        descriptiveLabel: 'A5 Retail Bill (5-7 Items, A5 Format)',
        category: DemoCategory.basic,
        recommendedTemplates: [
          TemplateType.a5Compact,
          TemplateType.thermal,
        ],
        quickInfo: '5 items • ₹1,650 • Mixed GST',
        testingPurpose: 'Compact format for small paper size',
        invoiceGetter: DemoInvoices.getA5RetailBill,
      ),
      DemoInvoiceMetadata(
        id: 'service_invoice',
        descriptiveLabel: 'Service Invoice (Consulting, Software)',
        category: DemoCategory.basic,
        recommendedTemplates: [
          TemplateType.mbbookModern,
          TemplateType.modernElite,
          TemplateType.mbbookStylish,
        ],
        quickInfo: '2 services • ₹1.12L • 18% GST',
        testingPurpose: 'Service-based invoice with bank details',
        invoiceGetter: DemoInvoices.getSimpleServiceInvoice,
      ),

      // === GST TESTING DEMOS ===
      DemoInvoiceMetadata(
        id: 'multi_gst_rates',
        descriptiveLabel: 'Multi-GST Manufacturing (5%, 12%, 18%, 28%)',
        category: DemoCategory.gstTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '4 items • ₹14.7K • 4 GST rates',
        testingPurpose: 'All common GST rates in single invoice',
        invoiceGetter: DemoInvoices.getMultiGstRatesInvoice,
      ),
      DemoInvoiceMetadata(
        id: 'cess_heavy',
        descriptiveLabel: 'CESS Heavy Goods (Luxury Vehicle)',
        category: DemoCategory.gstTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
          TemplateType.mbbookStylish,
        ],
        quickInfo: '2 items • ₹32.9L • CESS ₹3.75L',
        testingPurpose: 'High CESS on luxury automobile',
        invoiceGetter: DemoInvoices.getCessHeavyGoods,
      ),
      DemoInvoiceMetadata(
        id: 'zero_rated_export',
        descriptiveLabel: 'Zero-Rated Export (0% GST)',
        category: DemoCategory.gstTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
          TemplateType.mbbookStylish,
        ],
        quickInfo: '2 items • ₹7.4L • 0% Export',
        testingPurpose: 'Export invoice with zero GST',
        invoiceGetter: DemoInvoices.getZeroRatedExport,
      ),
      DemoInvoiceMetadata(
        id: 'intra_state_detailed',
        descriptiveLabel: 'Intra-State CGST+SGST (Detailed)',
        category: DemoCategory.gstTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '2 items • ₹6.37L • CGST+SGST',
        testingPurpose: 'Intra-state with detailed GST breakdown',
        invoiceGetter: DemoInvoices.getIntraStateDetailed,
      ),
      DemoInvoiceMetadata(
        id: 'inter_state_igst',
        descriptiveLabel: 'Inter-State IGST (Cross-Border)',
        category: DemoCategory.gstTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '2 items • ₹9.56L • IGST only',
        testingPurpose: 'Inter-state with IGST only',
        invoiceGetter: DemoInvoices.getInterStateIgst,
      ),
      DemoInvoiceMetadata(
        id: 'composite_unregistered',
        descriptiveLabel: 'Composite/Unregistered (No GSTIN)',
        category: DemoCategory.gstTesting,
        recommendedTemplates: [
          TemplateType.a5Compact,
          TemplateType.thermal,
          TemplateType.mbbookStylish,
        ],
        quickInfo: '2 items • ₹9K • No GST',
        testingPurpose: 'Unregistered dealer, no GST charged',
        invoiceGetter: DemoInvoices.getCompositeUnregistered,
      ),

      // === DOCUMENT TYPES ===
      DemoInvoiceMetadata(
        id: 'estimate_quote',
        descriptiveLabel: 'Estimate/Quote (Home Renovation)',
        category: DemoCategory.documentTypes,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.mbbookModern,
          TemplateType.modernElite,
        ],
        quickInfo: '3 services • ₹1.29L • Estimate',
        testingPurpose: 'Quotation/estimate document type',
        invoiceGetter: DemoInvoices.getEstimateQuote,
      ),
      DemoInvoiceMetadata(
        id: 'purchase_order',
        descriptiveLabel: 'Purchase Order (Industrial)',
        category: DemoCategory.documentTypes,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '2 items • ₹6.84L • PO',
        testingPurpose: 'Purchase order document',
        invoiceGetter: DemoInvoices.getPurchaseOrder,
      ),
      DemoInvoiceMetadata(
        id: 'credit_note',
        descriptiveLabel: 'Credit Note (Product Return)',
        category: DemoCategory.documentTypes,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.mbbookModern,
          TemplateType.modernElite,
        ],
        quickInfo: '1 item • -₹4,950 • Credit Note',
        testingPurpose: 'Credit note for returns',
        invoiceGetter: DemoInvoices.getCreditNote,
      ),
      DemoInvoiceMetadata(
        id: 'debit_note',
        descriptiveLabel: 'Debit Note (Price Adjustment)',
        category: DemoCategory.documentTypes,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.mbbookModern,
        ],
        quickInfo: '1 item • ₹5,600 • Debit Note',
        testingPurpose: 'Debit note for additional charges',
        invoiceGetter: DemoInvoices.getDebitNote,
      ),
      DemoInvoiceMetadata(
        id: 'delivery_challan',
        descriptiveLabel: 'Delivery Challan (No Value)',
        category: DemoCategory.documentTypes,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.a5Compact,
        ],
        quickInfo: '2 items • ₹0 • Challan',
        testingPurpose: 'Delivery challan without commercial value',
        invoiceGetter: DemoInvoices.getDeliveryChallan,
      ),

      // === THERMAL/POS DEMOS ===
      DemoInvoiceMetadata(
        id: 'restaurant_bill',
        descriptiveLabel: 'Restaurant Bill (8+ Items, Thermal)',
        category: DemoCategory.thermalPos,
        recommendedTemplates: [
          TemplateType.thermal,
          TemplateType.a5Compact,
        ],
        quickInfo: '8 items • ₹2,360 • Restaurant',
        testingPurpose: 'Multi-item restaurant bill for thermal printer',
        invoiceGetter: DemoInvoices.getRestaurantBill,
      ),
      DemoInvoiceMetadata(
        id: 'grocery_receipt',
        descriptiveLabel: 'Retail Grocery Receipt (10+ Items)',
        category: DemoCategory.thermalPos,
        recommendedTemplates: [
          TemplateType.thermal,
          TemplateType.a5Compact,
        ],
        quickInfo: '10 items • ₹1,212 • Grocery',
        testingPurpose: 'Grocery store POS receipt',
        invoiceGetter: DemoInvoices.getRetailGroceryReceipt,
      ),

      // === EDGE CASES ===
      DemoInvoiceMetadata(
        id: 'stress_test',
        descriptiveLabel: 'Stress Test (15 Items, Long Names)',
        category: DemoCategory.edgeCases,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
          TemplateType.mbbookStylish,
        ],
        quickInfo: '15 items • ₹54.9L • Long text',
        testingPurpose: 'Tests layout with many items and long names',
        invoiceGetter: DemoInvoices.getStressTestManyItems,
      ),
      DemoInvoiceMetadata(
        id: 'partial_payment',
        descriptiveLabel: 'Partial Payment (Advance Received)',
        category: DemoCategory.edgeCases,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '3 items • ₹9.66L • ₹5L paid',
        testingPurpose: 'Partial payment scenario with balance due',
        invoiceGetter: DemoInvoices.getPartialPaymentScenario,
      ),
      DemoInvoiceMetadata(
        id: 'minimal_data',
        descriptiveLabel: 'Minimal Data (Sparse Fields)',
        category: DemoCategory.edgeCases,
        recommendedTemplates: [
          TemplateType.a5Compact,
          TemplateType.thermal,
          TemplateType.modernElite,
        ],
        quickInfo: '2 items • ₹1,100 • Minimal',
        testingPurpose: 'Tests template with minimal data fields',
        invoiceGetter: DemoInvoices.getMinimalDataInvoice,
      ),

      // === NOTES & TERMS CONDITIONS TESTING ===

      // Tally Schema Tests
      DemoInvoiceMetadata(
        id: 'tally_schema_notes',
        descriptiveLabel: 'Tally Schema - Notes Only',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.mbbookTally, TemplateType.tallyProfessional],
        quickInfo: '2 items • ₹1.18L • Notes only',
        testingPurpose: 'Test Tally schema footer with notes only (no T&C)',
        invoiceGetter: DemoInvoices.getTallySchemaWithNotes,
      ),
      DemoInvoiceMetadata(
        id: 'tally_schema_terms',
        descriptiveLabel: 'Tally Schema - Terms Only',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.mbbookTally, TemplateType.tallyProfessional],
        quickInfo: '2 items • ₹1.18L • T&C only',
        testingPurpose: 'Test Tally schema footer with terms & conditions only (no notes)',
        invoiceGetter: DemoInvoices.getTallySchemaWithTerms,
      ),
      DemoInvoiceMetadata(
        id: 'tally_schema_both',
        descriptiveLabel: 'Tally Schema - Notes + Terms',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.mbbookTally, TemplateType.tallyProfessional],
        quickInfo: '2 items • ₹1.18L • Both notes & T&C',
        testingPurpose: 'Test Tally schema footer with both notes and T&C (row layout)',
        invoiceGetter: DemoInvoices.getTallySchemaWithBoth,
      ),
      DemoInvoiceMetadata(
        id: 'tally_schema_none',
        descriptiveLabel: 'Tally Schema - Neither',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.mbbookTally, TemplateType.tallyProfessional],
        quickInfo: '2 items • ₹1.18L • No notes/T&C',
        testingPurpose: 'Test Tally schema footer when both notes and T&C are absent',
        invoiceGetter: DemoInvoices.getTallySchemaWithNone,
      ),

      // Modern Schema Tests
      DemoInvoiceMetadata(
        id: 'modern_schema_notes',
        descriptiveLabel: 'Modern Schema - Notes Only',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.mbbookStylish, TemplateType.modernElite],
        quickInfo: '2 items • ₹1.18L • Notes only',
        testingPurpose: 'Test Modern schema layout with notes only (no T&C)',
        invoiceGetter: DemoInvoices.getModernSchemaWithNotes,
      ),
      DemoInvoiceMetadata(
        id: 'modern_schema_terms',
        descriptiveLabel: 'Modern Schema - Terms Only',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.mbbookStylish, TemplateType.modernElite],
        quickInfo: '2 items • ₹1.18L • T&C only',
        testingPurpose: 'Test Modern schema layout with terms & conditions only',
        invoiceGetter: DemoInvoices.getModernSchemaWithTerms,
      ),
      DemoInvoiceMetadata(
        id: 'modern_schema_both',
        descriptiveLabel: 'Modern Schema - Notes + Terms',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.mbbookStylish, TemplateType.modernElite],
        quickInfo: '2 items • ₹1.18L • Both notes & T&C',
        testingPurpose: 'Test Modern schema with both notes and T&C (column layout)',
        invoiceGetter: DemoInvoices.getModernSchemaWithBoth,
      ),
      DemoInvoiceMetadata(
        id: 'modern_schema_none',
        descriptiveLabel: 'Modern Schema - Neither',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.mbbookStylish, TemplateType.modernElite],
        quickInfo: '2 items • ₹1.18L • No notes/T&C',
        testingPurpose: 'Test Modern schema when both notes and T&C are absent',
        invoiceGetter: DemoInvoices.getModernSchemaWithNone,
      ),

      // A5/Thermal Schema Tests
      DemoInvoiceMetadata(
        id: 'a5_thermal_schema_notes',
        descriptiveLabel: 'A5/Thermal Schema - Notes Only',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.a5Compact, TemplateType.thermal],
        quickInfo: '2 items • ₹1.18L • Notes only',
        testingPurpose: 'Test A5/Thermal compact format with notes only',
        invoiceGetter: DemoInvoices.getA5ThermalSchemaWithNotes,
      ),
      DemoInvoiceMetadata(
        id: 'a5_thermal_schema_terms',
        descriptiveLabel: 'A5/Thermal Schema - Terms Only',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.a5Compact, TemplateType.thermal],
        quickInfo: '2 items • ₹1.18L • T&C only',
        testingPurpose: 'Test A5/Thermal compact format with terms & conditions only',
        invoiceGetter: DemoInvoices.getA5ThermalSchemaWithTerms,
      ),
      DemoInvoiceMetadata(
        id: 'a5_thermal_schema_both',
        descriptiveLabel: 'A5/Thermal Schema - Notes + Terms',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.a5Compact, TemplateType.thermal],
        quickInfo: '2 items • ₹1.18L • Both notes & T&C',
        testingPurpose: 'Test A5/Thermal format with both notes and T&C (space-constrained)',
        invoiceGetter: DemoInvoices.getA5ThermalSchemaWithBoth,
      ),
      DemoInvoiceMetadata(
        id: 'a5_thermal_schema_none',
        descriptiveLabel: 'A5/Thermal Schema - Neither',
        category: DemoCategory.notesAndTermsTesting,
        recommendedTemplates: [TemplateType.a5Compact, TemplateType.thermal],
        quickInfo: '2 items • ₹1.18L • No notes/T&C',
        testingPurpose: 'Test A5/Thermal format when both notes and T&C are absent',
        invoiceGetter: DemoInvoices.getA5ThermalSchemaWithNone,
      ),

      // === CUSTOM FIELDS TESTING DEMOS ===

      // Item Custom Fields Tests
      DemoInvoiceMetadata(
        id: 'item_custom_fields_basic',
        descriptiveLabel: 'Item Fields - Basic (1-2 Fields)',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
          TemplateType.mbbookModern,
        ],
        quickInfo: '2 items • ₹1.1L • Warranty, Serial No, Color',
        testingPurpose: 'Test basic item custom fields rendering (1-2 fields, text types)',
        invoiceGetter: DemoInvoices.getItemCustomFieldsBasic,
      ),
      DemoInvoiceMetadata(
        id: 'item_custom_fields_multiple',
        descriptiveLabel: 'Item Fields - Multiple (5 Fields, All Types)',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '1 item • ₹1.3L • HUID, Weight, Purity, Certified, Cert Date',
        testingPurpose: 'Test multiple item custom fields with all 6 field types (jewellery use case)',
        invoiceGetter: DemoInvoices.getItemCustomFieldsMultiple,
      ),
      DemoInvoiceMetadata(
        id: 'item_custom_fields_mixed',
        descriptiveLabel: 'Item Fields - Mixed (Some Items With/Without)',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookModern,
          TemplateType.modernElite,
        ],
        quickInfo: '3 items • ₹9.4K • Batch No, Expiry, MRP (pharma)',
        testingPurpose: 'Test mixed scenario where some items have custom fields, others do not',
        invoiceGetter: DemoInvoices.getItemCustomFieldsMixed,
      ),
      DemoInvoiceMetadata(
        id: 'item_custom_fields_edge_case',
        descriptiveLabel: 'Item Fields - Edge Cases (Long Names/Values, Unicode)',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '1 item • ₹29.5K • Long strings, special chars, Unicode',
        testingPurpose: 'Test layout boundaries with very long field names/values, special characters, Unicode',
        invoiceGetter: DemoInvoices.getItemCustomFieldsEdgeCase,
      ),

      // Business Custom Fields Tests
      DemoInvoiceMetadata(
        id: 'business_custom_fields_seller',
        descriptiveLabel: 'Business Fields - Seller Only',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
          TemplateType.mbbookModern,
        ],
        quickInfo: '1 item • ₹1.65L • IEC Code, Export License, ISO Certified',
        testingPurpose: 'Test business custom fields on seller side only (export business)',
        invoiceGetter: DemoInvoices.getBusinessCustomFieldsSeller,
      ),
      DemoInvoiceMetadata(
        id: 'business_custom_fields_buyer',
        descriptiveLabel: 'Business Fields - Buyer Only',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookStylish,
          TemplateType.modernElite,
        ],
        quickInfo: '1 item • ₹29.5K • Customer Code, Credit Limit, Payment Terms',
        testingPurpose: 'Test business custom fields on buyer side only (B2B customer)',
        invoiceGetter: DemoInvoices.getBusinessCustomFieldsBuyer,
      ),
      DemoInvoiceMetadata(
        id: 'business_custom_fields_both',
        descriptiveLabel: 'Business Fields - Both Seller & Buyer',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookModern,
          TemplateType.mbbookStylish,
          TemplateType.modernElite,
        ],
        quickInfo: '1 item • ₹59K • MSME, TAN, Account Mgr, Territory, VIP',
        testingPurpose: 'Test business custom fields on both seller and buyer sides',
        invoiceGetter: DemoInvoices.getBusinessCustomFieldsBoth,
      ),
      DemoInvoiceMetadata(
        id: 'business_custom_fields_all_types',
        descriptiveLabel: 'Business Fields - All 6 Field Types',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '1 item • ₹11.8K • Text, Number, Date, Boolean, Select, Multiselect',
        testingPurpose: 'Test all 6 custom field types rendering in business details',
        invoiceGetter: DemoInvoices.getBusinessCustomFieldsAllTypes,
      ),

      // Combined Tests
      DemoInvoiceMetadata(
        id: 'custom_fields_full',
        descriptiveLabel: 'Combined - Item + Business Fields',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
        ],
        quickInfo: '2 items • ₹6.2L • Full custom fields integration',
        testingPurpose: 'Test item AND business custom fields combined (comprehensive test)',
        invoiceGetter: DemoInvoices.getCustomFieldsFull,
      ),
      DemoInvoiceMetadata(
        id: 'custom_fields_with_notes_terms',
        descriptiveLabel: 'Combined - Fields + Notes + Terms',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.tallyProfessional,
          TemplateType.mbbookModern,
        ],
        quickInfo: '1 item • ₹88.5K • Custom fields + notes + T&C',
        testingPurpose: 'Test custom fields alongside notes and terms & conditions (layout conflict test)',
        invoiceGetter: DemoInvoices.getCustomFieldsWithNotesTerms,
      ),
      DemoInvoiceMetadata(
        id: 'custom_fields_compact_layout',
        descriptiveLabel: 'Combined - A5/Thermal Stress Test',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.a5Compact,
          TemplateType.thermal,
        ],
        quickInfo: '3 items • ₹1.65K • Space-constrained layouts',
        testingPurpose: 'Test custom fields in compact layouts (A5/Thermal space constraints)',
        invoiceGetter: DemoInvoices.getCustomFieldsCompactLayout,
      ),
      DemoInvoiceMetadata(
        id: 'custom_fields_empty',
        descriptiveLabel: 'Backward Compatibility - Zero Custom Fields',
        category: DemoCategory.customFieldsTesting,
        recommendedTemplates: [
          TemplateType.mbbookTally,
          TemplateType.mbbookModern,
          TemplateType.a5Compact,
        ],
        quickInfo: '1 item • ₹11.8K • No custom fields',
        testingPurpose: 'Test backward compatibility with zero custom fields (empty arrays)',
        invoiceGetter: DemoInvoices.getCustomFieldsEmpty,
      ),
    ];
  }

  /// Get demos filtered by category
  static List<DemoInvoiceMetadata> getDemosByCategory(DemoCategory category) {
    return getAllDemoMetadata()
        .where((demo) => demo.category == category)
        .toList();
  }

  /// Get demo metadata by ID
  static DemoInvoiceMetadata? getDemoById(String id) {
    try {
      return getAllDemoMetadata().firstWhere((demo) => demo.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get demos compatible with a specific template
  static List<DemoInvoiceMetadata> getDemosForTemplate(TemplateType template) {
    return getAllDemoMetadata()
        .where((demo) => demo.recommendedTemplates.contains(template))
        .toList();
  }

  /// Format quick info for display in tooltips
  static String formatQuickInfo(DemoInvoiceMetadata demo) {
    return '${demo.quickInfo}\n\nPurpose: ${demo.testingPurpose}\n\nBest for: ${demo.recommendedTemplates.map((t) => t.displayName).join(", ")}';
  }

  /// Get total count of demos
  static int getTotalDemoCount() {
    return getAllDemoMetadata().length;
  }

  /// Get count of demos by category
  static Map<DemoCategory, int> getDemoCountByCategory() {
    final Map<DemoCategory, int> counts = {};
    for (var demo in getAllDemoMetadata()) {
      counts[demo.category] = (counts[demo.category] ?? 0) + 1;
    }
    return counts;
  }

  /// Check if a template is recommended for a demo
  static bool isTemplateRecommended(
      DemoInvoiceMetadata demo, TemplateType template) {
    return demo.recommendedTemplates.contains(template);
  }

  /// Get badge text for template compatibility
  static String getCompatibilityBadge(
      DemoInvoiceMetadata demo, TemplateType template) {
    if (demo.recommendedTemplates.contains(template)) {
      return 'Recommended';
    } else if (demo.recommendedTemplates.isEmpty) {
      return 'Universal';
    } else {
      return 'Compatible';
    }
  }
}
