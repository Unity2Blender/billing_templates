import 'package:flutter/material.dart';
import '../services/template_registry.dart';
import '../utils/invoice_colors.dart';
import '../utils/demo_helpers.dart';
import '../models/invoice_data.dart';
import '../models/demo_invoice_metadata.dart';
import 'invoice_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<DemoInvoiceMetadata> _allDemos = DemoHelpers.getAllDemoMetadata();
  DemoInvoiceMetadata? _selectedDemo;

  @override
  void initState() {
    super.initState();
    _selectedDemo = _allDemos.isNotEmpty ? _allDemos[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    // Determine grid columns based on screen size
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isMobile ? 'Invoice Templates' : 'Invoice Templates Demo',
          style: TextStyle(fontSize: isMobile ? 18 : 20),
        ),
        centerTitle: isMobile,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: CustomScrollView(
        slivers: [
          // Demo data selector with better styling
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: isMobile ? 16 : 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.receipt_long,
                            color: Colors.blue[700],
                            size: isMobile ? 20 : 24,
                          ),
                          SizedBox(width: isMobile ? 8 : 12),
                          Expanded(
                            child: Text(
                              'Select Demo Invoice:',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      // Use categorized dropdown for mobile, expansion panels for larger screens
                      if (isMobile)
                        _buildMobileDropdown()
                      else
                        _buildCategorizedDemoSelector(isMobile),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Templates grid with centered content
          SliverPadding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: isMobile ? 1.2 : 0.75,
                      crossAxisSpacing: isMobile ? 12 : 20,
                      mainAxisSpacing: isMobile ? 12 : 20,
                    ),
                    itemCount: TemplateRegistry.getAllTemplates().length,
                    itemBuilder: (context, index) {
                      final template = TemplateRegistry.getAllTemplates()[index];
                      return _buildTemplateCard(template, isMobile);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildTemplateCard(template, bool isMobile) {
    if (_selectedDemo == null) return const SizedBox.shrink();
    final currentInvoice = _selectedDemo!.getInvoice();
    final isRecommended = DemoHelpers.isTemplateRecommended(_selectedDemo!,
      _getTemplateTypeById(template.id));

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      ),
      child: InkWell(
        onTap: () => _previewTemplate(template, currentInvoice),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Template screenshot preview
            Expanded(
              flex: isMobile ? 2 : 3,
              child: Container(
                color: Colors.grey[100],
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Try to load screenshot, fallback to placeholder
                    Image.asset(
                      template.screenshotPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Icon(
                              Icons.receipt_long,
                              size: isMobile ? 48 : 64,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                    // Hover overlay effect
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.0),
                              Colors.black.withValues(alpha: 0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Color theme indicators for templates that support it
                    if (template.supportsColorThemes && !isMobile)
                      Positioned(
                        top: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: InvoiceThemes.all.take(7).map((theme) {
                            return Container(
                              width: 28,
                              height: 28,
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Template info
            Container(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          template.name,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isRecommended && !isMobile) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Recommended',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: isMobile ? 4 : 6),
                  Text(
                    template.description,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isMobile ? 6 : 8),
                  Row(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: isMobile ? 12 : 14,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Tap to preview',
                        style: TextStyle(
                          fontSize: isMobile ? 11 : 12,
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _previewTemplate(template, InvoiceData invoice) {
    // Navigate directly to preview with default color theme
    // Users can change color using the palette icon in the preview screen
    _navigateToPreview(template, invoice, null);
  }

  void _navigateToPreview(
    template,
    InvoiceData invoice,
    InvoiceColorTheme? colorTheme,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoicePreviewScreen(
          invoice: invoice,
          templateId: template.id,
          initialColorTheme: colorTheme,
        ),
      ),
    );
  }

  // === NEW HELPER METHODS ===

  /// Build categorized demo selector for web/tablet
  Widget _buildCategorizedDemoSelector(bool isMobile) {
    final categories = DemoCategory.values;
    final demoCounts = DemoHelpers.getDemoCountByCategory();

    return Column(
      children: categories.map((category) {
        final categoryDemos = DemoHelpers.getDemosByCategory(category);
        if (categoryDemos.isEmpty) return const SizedBox.shrink();

        return ExpansionTile(
          title: Row(
            children: [
              Icon(
                _getCategoryIcon(category),
                size: 18,
                color: Colors.blue[700],
              ),
              const SizedBox(width: 8),
              Text(
                category.displayName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${demoCounts[category] ?? 0}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[800],
                  ),
                ),
              ),
            ],
          ),
          subtitle: Text(
            category.description,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          initiallyExpanded: category == DemoCategory.basic,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: categoryDemos.map((demo) {
                  final isSelected = _selectedDemo?.id == demo.id;

                  return Tooltip(
                    message: DemoHelpers.formatQuickInfo(demo),
                    waitDuration: const Duration(milliseconds: 500),
                    child: ChoiceChip(
                      label: Text(demo.descriptiveLabel),
                      selected: isSelected,
                      selectedColor: Colors.blue[600],
                      backgroundColor: Colors.grey[100],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        fontSize: 13,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedDemo = demo;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  /// Build mobile dropdown with categories
  Widget _buildMobileDropdown() {
    final categories = DemoCategory.values;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: _selectedDemo?.id,
        underline: const SizedBox(),
        items: [
          ...categories.expand((category) {
            final categoryDemos = DemoHelpers.getDemosByCategory(category);
            if (categoryDemos.isEmpty) return <DropdownMenuItem<String>>[];

            return [
              // Category header (non-selectable)
              DropdownMenuItem<String>(
                value: null,
                enabled: false,
                child: Text(
                  category.displayName.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue[800],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Demo items
              ...categoryDemos.map((demo) {
                return DropdownMenuItem<String>(
                  value: demo.id,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          demo.descriptiveLabel,
                          style: const TextStyle(fontSize: 13),
                        ),
                        Text(
                          demo.quickInfo,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ];
          }),
        ],
        onChanged: (value) {
          if (value != null) {
            final demo = DemoHelpers.getDemoById(value);
            if (demo != null) {
              setState(() {
                _selectedDemo = demo;
              });
            }
          }
        },
      ),
    );
  }

  /// Get category icon
  IconData _getCategoryIcon(DemoCategory category) {
    switch (category) {
      case DemoCategory.basic:
        return Icons.receipt;
      case DemoCategory.gstTesting:
        return Icons.calculate;
      case DemoCategory.documentTypes:
        return Icons.description;
      case DemoCategory.thermalPos:
        return Icons.print;
      case DemoCategory.edgeCases:
        return Icons.bug_report;
      case DemoCategory.notesAndTermsTesting:
        return Icons.notes;
    }
  }

  /// Map template ID to TemplateType enum
  TemplateType _getTemplateTypeById(String templateId) {
    switch (templateId) {
      case 'a5_compact':
        return TemplateType.a5Compact;
      case 'mbbook_tally':
        return TemplateType.mbbookTally;
      case 'tally_professional':
        return TemplateType.tallyProfessional;
      case 'mbbook_modern':
        return TemplateType.mbbookModern;
      case 'mbbook_stylish':
        return TemplateType.mbbookStylish;
      case 'modern_elite':
        return TemplateType.modernElite;
      case 'thermal_theme2':
        return TemplateType.thermal;
      default:
        return TemplateType.mbbookStylish;
    }
  }
}
