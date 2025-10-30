import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import '../models/invoice_data.dart';
import '../utils/invoice_colors.dart';
import '../services/pdf_service.dart';
import '../services/template_registry.dart';

class InvoicePreviewScreen extends StatefulWidget {
  final InvoiceData invoice;
  final String templateId;
  final InvoiceColorTheme? initialColorTheme;

  const InvoicePreviewScreen({
    super.key,
    required this.invoice,
    required this.templateId,
    this.initialColorTheme,
  });

  @override
  State<InvoicePreviewScreen> createState() => _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends State<InvoicePreviewScreen> {
  late InvoiceColorTheme? selectedColorTheme;
  final PDFService _pdfService = PDFService();

  @override
  void initState() {
    super.initState();
    selectedColorTheme = widget.initialColorTheme;
  }

  @override
  Widget build(BuildContext context) {
    final template = TemplateRegistry.getTemplate(widget.templateId);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${template.name} - Preview',
          style: TextStyle(fontSize: isMobile ? 16 : 20),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        actions: [
          if (template.supportsColorThemes)
            IconButton(
              icon: const Icon(Icons.palette),
              tooltip: 'Change Color Theme',
              iconSize: isMobile ? 20 : 24,
              onPressed: _showColorThemeDialog,
            ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share PDF',
            iconSize: isMobile ? 20 : 24,
            onPressed: _sharePDF,
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => _pdfService.generatePDF(
          invoice: widget.invoice,
          templateId: widget.templateId,
          colorTheme: selectedColorTheme,
        ),
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: true,
        allowSharing: true,
        pdfFileName: '${widget.invoice.fullInvoiceNumber}.pdf',
        // Optimize for mobile
        maxPageWidth: isMobile ? 400 : 700,
        scrollViewDecoration: BoxDecoration(
          color: Colors.grey[100],
        ),
      ),
    );
  }

  void _showColorThemeDialog() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Color Theme',
          style: TextStyle(fontSize: isMobile ? 18 : 20),
        ),
        contentPadding: EdgeInsets.all(isMobile ? 16 : 20),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: InvoiceThemes.all.length,
            itemBuilder: (context, index) {
              final theme = InvoiceThemes.all[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 16,
                  vertical: isMobile ? 4 : 8,
                ),
                leading: Container(
                  width: isMobile ? 36 : 40,
                  height: isMobile ? 36 : 40,
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                title: Text(
                  theme.name,
                  style: TextStyle(fontSize: isMobile ? 14 : 16),
                ),
                trailing: selectedColorTheme?.name == theme.name
                    ? Icon(
                        Icons.check,
                        color: Colors.green,
                        size: isMobile ? 20 : 24,
                      )
                    : null,
                onTap: () {
                  setState(() {
                    selectedColorTheme = theme;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(fontSize: isMobile ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sharePDF() async {
    // Show loading indicator on mobile
    if (MediaQuery.of(context).size.width < 600) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Preparing PDF...'),
                ],
              ),
            ),
          ),
        ),
      );
    }

    try {
      await _pdfService.sharePDF(
        invoice: widget.invoice,
        templateId: widget.templateId,
        colorTheme: selectedColorTheme,
      );
    } finally {
      if (MediaQuery.of(context).size.width < 600 && mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}
