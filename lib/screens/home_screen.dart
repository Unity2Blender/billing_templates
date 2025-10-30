import 'package:flutter/material.dart';
import '../data/demo_invoices.dart';
import '../services/template_registry.dart';
import '../utils/invoice_colors.dart';
import '../models/invoice_data.dart';
import '../models/invoice_enums.dart';
import 'invoice_preview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<InvoiceData> _demoInvoices = DemoInvoices.getAllSamples();
  int _selectedInvoiceIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isWideScreen = screenWidth >= 1200;
    
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
      body: Column(
        children: [
          // Demo data selector with better styling
          Container(
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
                    // Use dropdown for mobile, chips for larger screens
                    if (isMobile)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButton<int>(
                          isExpanded: true,
                          value: _selectedInvoiceIndex,
                          underline: const SizedBox(),
                          items: List.generate(_demoInvoices.length, (index) {
                            final invoice = _demoInvoices[index];
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text(
                                '${invoice.invoiceMode.displayName} - ${invoice.fullInvoiceNumber}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedInvoiceIndex = value;
                              });
                            }
                          },
                        ),
                      )
                    else
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: List.generate(_demoInvoices.length, (index) {
                          final invoice = _demoInvoices[index];
                          final isSelected = _selectedInvoiceIndex == index;

                          return ChoiceChip(
                            label: Text(
                              '${invoice.invoiceMode.displayName} - ${invoice.fullInvoiceNumber}',
                            ),
                            selected: isSelected,
                            selectedColor: Colors.blue[600],
                            backgroundColor: Colors.grey[100],
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedInvoiceIndex = index;
                                });
                              }
                            },
                          );
                        }),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Templates grid with centered content
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: GridView.builder(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
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
        ],
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  Widget _buildTemplateCard(template, bool isMobile) {
    final currentInvoice = _demoInvoices[_selectedInvoiceIndex];

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
                  Text(
                    template.name,
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    // Show color theme selection dialog if template supports it
    if (template.supportsColorThemes) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Select Color Theme',
            style: TextStyle(fontSize: isMobile ? 18 : 20),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 3,
                childAspectRatio: 1,
                crossAxisSpacing: isMobile ? 8 : 12,
                mainAxisSpacing: isMobile ? 8 : 12,
              ),
              itemCount: InvoiceThemes.all.length,
              itemBuilder: (context, index) {
                final theme = InvoiceThemes.all[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToPreview(template, invoice, theme);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: isMobile ? 50 : 60,
                        height: isMobile ? 50 : 60,
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        theme.name,
                        style: TextStyle(fontSize: isMobile ? 11 : 12),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToPreview(template, invoice, null);
              },
              child: const Text('Use Default'),
            ),
          ],
        ),
      );
    } else {
      _navigateToPreview(template, invoice, null);
    }
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
}
