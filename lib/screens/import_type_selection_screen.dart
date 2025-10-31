import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/sheets_importer_service.dart';
import 'column_mapping_preview_screen.dart';

/// Screen for selecting import type (Items or Parties)
class ImportTypeSelectionScreen extends StatelessWidget {
  const ImportTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Import Data from Sheets',
          style: TextStyle(fontSize: isMobile ? 18 : 20),
        ),
        centerTitle: isMobile,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header section
                  Card(
                    elevation: 0,
                    color: Colors.blue[50],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blue[200]!, width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 16 : 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue[700],
                            size: isMobile ? 20 : 24,
                          ),
                          SizedBox(width: isMobile ? 8 : 12),
                          Expanded(
                            child: Text(
                              'Import items/products or business contacts from CSV/Excel files with intelligent column matching.',
                              style: TextStyle(
                                fontSize: isMobile ? 13 : 14,
                                color: Colors.blue[900],
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 24 : 32),

                  // Import type cards
                  if (isMobile || isTablet)
                    // Single column layout for mobile/tablet
                    Column(
                      children: [
                        _buildImportTypeCard(
                          context: context,
                          title: 'Import Items / Products',
                          subtitle: 'Bulk import inventory items with pricing and tax rates',
                          icon: Icons.inventory_2,
                          iconColor: Colors.orange,
                          importType: ImportType.items,
                          isMobile: isMobile,
                        ),
                        SizedBox(height: isMobile ? 16 : 20),
                        _buildImportTypeCard(
                          context: context,
                          title: 'Import Parties / Contacts',
                          subtitle: 'Bulk import business contacts with GST details',
                          icon: Icons.people,
                          iconColor: Colors.green,
                          importType: ImportType.parties,
                          isMobile: isMobile,
                        ),
                      ],
                    )
                  else
                    // Two column layout for desktop
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildImportTypeCard(
                            context: context,
                            title: 'Import Items / Products',
                            subtitle: 'Bulk import inventory items with pricing and tax rates',
                            icon: Icons.inventory_2,
                            iconColor: Colors.orange,
                            importType: ImportType.items,
                            isMobile: isMobile,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildImportTypeCard(
                            context: context,
                            title: 'Import Parties / Contacts',
                            subtitle: 'Bulk import business contacts with GST details',
                            icon: Icons.people,
                            iconColor: Colors.green,
                            importType: ImportType.parties,
                            isMobile: isMobile,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImportTypeCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required ImportType importType,
    required bool isMobile,
  }) {
    final service = SheetsImporterService();
    final fieldSummary = importType == ImportType.items
        ? service.getItemFieldSummary()
        : service.getPartyFieldSummary();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      ),
      child: InkWell(
        onTap: () => _handleImportTypeSelection(context, importType),
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 20 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                    ),
                    child: Icon(
                      icon,
                      size: isMobile ? 32 : 40,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isMobile ? 18 : 20,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: isMobile ? 13 : 14,
                            color: Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 16 : 20),

              // Divider
              Divider(color: Colors.grey[300], height: 1),
              SizedBox(height: isMobile ? 16 : 20),

              // Field summary
              Text(
                'Supported Fields:',
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),

              ...fieldSummary.entries.take(5).map((entry) {
                final isRequired = entry.value.contains('Required');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        isRequired ? Icons.check_circle : Icons.circle_outlined,
                        size: isMobile ? 16 : 18,
                        color: isRequired ? Colors.green : Colors.grey[400],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: isMobile ? 12 : 13,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                            children: [
                              TextSpan(
                                text: entry.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: isRequired ? ' (Required)' : ' (Optional)',
                                style: TextStyle(
                                  fontSize: isMobile ? 11 : 12,
                                  color: isRequired ? Colors.green[700] : Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              if (fieldSummary.length > 5) ...[
                const SizedBox(height: 4),
                Text(
                  '+ ${fieldSummary.length - 5} more fields...',
                  style: TextStyle(
                    fontSize: isMobile ? 11 : 12,
                    color: Colors.grey[500],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],

              SizedBox(height: isMobile ? 20 : 24),

              // Action button
              Container(
                width: double.infinity,
                height: isMobile ? 44 : 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[600]!, Colors.blue[700]!],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.upload_file, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Select CSV / Excel File',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isMobile ? 14 : 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleImportTypeSelection(
    BuildContext context,
    ImportType importType,
  ) async {
    try {
      // Open file picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx', 'xls'],
        withData: true, // Load file bytes into memory
      );

      if (result != null && result.files.single.bytes != null) {
        final fileBytes = result.files.single.bytes!;
        final fileName = result.files.single.name;

        if (!context.mounted) return;

        // Navigate to column mapping preview
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ColumnMappingPreviewScreen(
              fileBytes: fileBytes,
              fileName: fileName,
              importType: importType,
            ),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting file: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }
}

/// Enum for import types
enum ImportType {
  items,
  parties,
}
