/// Flutter Invoice PDF Template Library
///
/// A comprehensive library for generating professional, GST-compliant invoice PDFs
/// from FlutterFlow data structures. Supports multiple templates, color themes,
/// and various invoice modes.
///
/// **Usage:**
/// ```dart
/// import 'package:billing_templates/billing_templates.dart';
///
/// // Convert your FlutterFlow structs to internal format
/// final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
///   invoice: myInvoiceStruct,
///   sellerFirm: myFirmConfigStruct,
/// );
///
/// // Generate PDF
/// final pdfBytes = await PDFService().generatePDF(
///   invoice: invoiceData,
///   templateId: 'mbbook_modern',
///   colorTheme: InvoiceThemes.blue,
/// );
/// ```
///
/// **Available Templates:**
/// - `mbbook_tally` - Traditional GST-compliant with HSN summary
/// - `tally_professional` - Professional Tally variant
/// - `mbbook_modern` - Modern minimalist design
/// - `mbbook_stylish` - Stylish with color theme support
/// - `modern_elite` - Premium modern design
/// - `a5_compact` - A5 format for retail
/// - `thermal_theme2` - Thermal printer format
///
/// **See Also:**
/// - [PubSpecImportGuide.md] for detailed integration instructions
/// - [CLAUDE.md] for architecture and implementation details
library billing_templates;

// ============================================================================
// PUBLIC API - Adapters
// ============================================================================
// These adapters convert FlutterFlow structs to internal models

export 'adapters/invoice_adapter.dart';
// Note: Individual adapters (Business, Item, BillSummary, Banking) are used
// internally by InvoiceAdapter and don't need to be exported

// ============================================================================
// PUBLIC API - Services
// ============================================================================
// Core services for PDF generation and template management

export 'services/pdf_service.dart';
export 'services/template_registry.dart';

// ============================================================================
// PUBLIC API - Utilities
// ============================================================================
// Color themes for templates that support customization

export 'utils/invoice_colors.dart' show InvoiceThemes, InvoiceColorTheme;

// ============================================================================
// INTERNAL (NOT EXPORTED)
// ============================================================================
// The following are internal implementation details and NOT part of public API:
// - Internal models (InvoiceData, ItemSaleInfo, BusinessDetails, etc.)
// - Template implementations (only access via TemplateRegistry)
// - Demo data and screens
// - Other internal utilities
//
// Your app should only depend on:
// 1. InvoiceAdapter to convert your structs
// 2. PDFService to generate/print/share PDFs
// 3. TemplateRegistry to list and select templates
// 4. InvoiceThemes for color customization
