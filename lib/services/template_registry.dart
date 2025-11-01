import '../templates/invoice_template_base.dart';
import '../templates/modern_elite_template.dart';
import '../templates/mbbook_stylish_template.dart';
import '../templates/mbbook_modern_template.dart';
import '../templates/mbbook_tally_template.dart';
import '../templates/a5_compact_template.dart';
import '../templates/tally_professional_template.dart';
import '../templates/thermal_theme2_template.dart';

class TemplateRegistry {
  static final Map<String, InvoiceTemplate> _templates = {
    'modern_elite': ModernEliteTemplate(),
    'mbbook_stylish': MBBookStylishTemplate(),
    'mbbook_modern': MBBookModernTemplate(),
    'mbbook_tally': MBBookTallyTemplate(),
    'a5_compact': A5CompactTemplate(),
    'tally_professional': TallyProfessionalTemplate(),
    'thermal_theme2': ThermalTheme2Template(),
  };

  static InvoiceTemplate getTemplate(String id) {
    return _templates[id] ?? ModernEliteTemplate();
  }

  static List<InvoiceTemplate> getAllTemplates() {
    return _templates.values.toList();
  }

  /// Returns a list of all available template IDs in alphabetical order.
  ///
  /// This is useful for building UI selectors or validating template IDs
  /// without needing to access full template objects.
  ///
  /// Example:
  /// ```dart
  /// final templateIds = TemplateRegistry.getAllTemplateIds();
  /// // Returns: ['a5_compact', 'mbbook_modern', 'mbbook_stylish', ...]
  /// ```
  static List<String> getAllTemplateIds() {
    final ids = _templates.keys.toList();
    ids.sort(); // Sort alphabetically for consistency
    return ids;
  }

  static bool hasTemplate(String id) {
    return _templates.containsKey(id);
  }
}
