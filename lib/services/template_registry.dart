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

  static bool hasTemplate(String id) {
    return _templates.containsKey(id);
  }
}
