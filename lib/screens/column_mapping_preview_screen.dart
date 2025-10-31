import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/sheets_importer_service.dart';
import '../models/column_mapping.dart';
import '../models/import_result.dart';
import '../importers/item_sheet_importer.dart';
import '../importers/party_sheet_importer.dart';
import 'import_type_selection_screen.dart';
import 'import_results_screen.dart';

/// Screen for previewing column mappings before import
class ColumnMappingPreviewScreen extends StatefulWidget {
  final Uint8List fileBytes;
  final String fileName;
  final ImportType importType;

  const ColumnMappingPreviewScreen({
    super.key,
    required this.fileBytes,
    required this.fileName,
    required this.importType,
  });

  @override
  State<ColumnMappingPreviewScreen> createState() =>
      _ColumnMappingPreviewScreenState();
}

class _ColumnMappingPreviewScreenState
    extends State<ColumnMappingPreviewScreen> {
  bool _isProcessing = false;
  ImportResult<dynamic>? _importResult;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _analyzeFile();
  }

  Future<void> _analyzeFile() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final service = SheetsImporterService();

      // Perform import to get both column mappings and data
      if (widget.importType == ImportType.items) {
        final result = await service.importItems(
          fileBytes: widget.fileBytes,
          fileName: widget.fileName,
        );

        if (result.isSuccess) {
          setState(() {
            _importResult = result;
            _isProcessing = false;
          });
        } else {
          setState(() {
            _errorMessage = result.errorMessage ?? 'Failed to analyze file';
            _isProcessing = false;
          });
        }
      } else {
        final result = await service.importParties(
          fileBytes: widget.fileBytes,
          fileName: widget.fileName,
        );

        if (result.isSuccess) {
          setState(() {
            _importResult = result;
            _isProcessing = false;
          });
        } else {
          setState(() {
            _errorMessage = result.errorMessage ?? 'Failed to analyze file';
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error analyzing file: $e';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Column Mapping Preview',
          style: TextStyle(fontSize: isMobile ? 18 : 20),
        ),
        centerTitle: isMobile,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? _buildErrorView(isMobile)
              : _buildMappingView(isMobile),
    );
  }

  Widget _buildErrorView(bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Card(
          elevation: 2,
          color: Colors.red[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.red[300]!, width: 1),
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 20 : 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  size: isMobile ? 48 : 64,
                  color: Colors.red[700],
                ),
                SizedBox(height: isMobile ? 16 : 20),
                Text(
                  'Import Failed',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[900],
                  ),
                ),
                SizedBox(height: isMobile ? 8 : 12),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    color: Colors.red[800],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 24),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 24,
                      vertical: isMobile ? 12 : 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMappingView(bool isMobile) {
    if (_importResult == null || _importResult!.columnMappings == null) {
      return const Center(child: Text('No mappings available'));
    }

    final columnMappings = _importResult!.columnMappings!;

    // Separate required and optional mappings
    final requiredMappings = columnMappings.entries
        .where((e) => e.value.isRequired)
        .toList();
    final optionalMappings = columnMappings.entries
        .where((e) => !e.value.isRequired)
        .toList();

    return Container(
      color: Colors.grey[50],
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // File info card
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 16 : 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    color: Colors.blue[700],
                                    size: isMobile ? 20 : 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.fileName,
                                          style: TextStyle(
                                            fontSize: isMobile ? 14 : 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Type: ${widget.importType == ImportType.items ? "Items/Products" : "Parties/Contacts"}',
                                          style: TextStyle(
                                            fontSize: isMobile ? 12 : 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 16 : 20),

                      // Summary card
                      Card(
                        elevation: 0,
                        color: _importResult!.successCount > 0 ? Colors.green[50] : Colors.orange[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: _importResult!.successCount > 0 ? Colors.green[200]! : Colors.orange[200]!,
                            width: 1,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isMobile ? 16 : 20),
                          child: Row(
                            children: [
                              Icon(
                                _importResult!.successCount > 0
                                    ? Icons.check_circle_outline
                                    : Icons.warning_amber,
                                color: _importResult!.successCount > 0 ? Colors.green[700] : Colors.orange[700],
                                size: isMobile ? 20 : 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Matched ${columnMappings.length} columns using fuzzy matching',
                                      style: TextStyle(
                                        fontSize: isMobile ? 13 : 14,
                                        color: _importResult!.successCount > 0 ? Colors.green[900] : Colors.orange[900],
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _importResult!.successCount > 0
                                          ? '${_importResult!.successCount} record(s) ready to import'
                                          : 'Warning: 0 records found. Check your data rows.',
                                      style: TextStyle(
                                        fontSize: isMobile ? 12 : 13,
                                        color: _importResult!.successCount > 0 ? Colors.green[800] : Colors.orange[800],
                                        fontWeight: FontWeight.w600,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isMobile ? 20 : 24),

                      // Warnings section (if any)
                      if (_importResult!.hasWarnings) ...[
                        Card(
                          elevation: 0,
                          color: Colors.orange[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.orange[200]!, width: 1),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.warning_amber,
                                      color: Colors.orange[700],
                                      size: isMobile ? 20 : 24,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        '${_importResult!.warnings.length} warning(s) detected',
                                        style: TextStyle(
                                          fontSize: isMobile ? 14 : 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange[900],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ..._importResult!.warnings.take(3).map(
                                  (warning) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          size: 16,
                                          color: Colors.orange[600],
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            warning.message,
                                            style: TextStyle(
                                              fontSize: isMobile ? 12 : 13,
                                              color: Colors.orange[900],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_importResult!.warnings.length > 3)
                                  Text(
                                    '+ ${_importResult!.warnings.length - 3} more warnings...',
                                    style: TextStyle(
                                      fontSize: isMobile ? 11 : 12,
                                      color: Colors.orange[700],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: isMobile ? 20 : 24),
                      ],

                      // Required mappings
                      if (requiredMappings.isNotEmpty) ...[
                        Text(
                          'Required Fields',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...requiredMappings.map((entry) =>
                          _buildMappingCard(entry.value, isMobile)),
                        SizedBox(height: isMobile ? 20 : 24),
                      ],

                      // Optional mappings
                      if (optionalMappings.isNotEmpty) ...[
                        Text(
                          'Optional Fields',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...optionalMappings.map((entry) =>
                          _buildMappingCard(entry.value, isMobile)),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom action bar
              Container(
                padding: EdgeInsets.all(isMobile ? 16 : 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Back'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 14 : 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _proceedWithImport,
                          icon: const Icon(Icons.download),
                          label: const Text('Proceed with Import'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 14 : 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMappingCard(ColumnMapping mapping, bool isMobile) {
    // Determine confidence level
    Color confidenceColor;
    String confidenceLabel;
    IconData confidenceIcon;

    if (mapping.isHighConfidence) {
      confidenceColor = Colors.green;
      confidenceLabel = 'High';
      confidenceIcon = Icons.check_circle;
    } else if (mapping.isMediumConfidence) {
      confidenceColor = Colors.orange;
      confidenceLabel = 'Medium';
      confidenceIcon = Icons.warning_amber;
    } else {
      confidenceColor = Colors.red;
      confidenceLabel = 'Low';
      confidenceIcon = Icons.error_outline;
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: mapping.isHighConfidence ? Colors.green[200]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 14 : 16),
        child: Row(
          children: [
            // Confidence indicator
            Container(
              padding: EdgeInsets.all(isMobile ? 8 : 10),
              decoration: BoxDecoration(
                color: confidenceColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                confidenceIcon,
                size: isMobile ? 20 : 24,
                color: confidenceColor,
              ),
            ),
            const SizedBox(width: 12),

            // Mapping details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mapping.fieldName,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      if (mapping.isRequired)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Required',
                            style: TextStyle(
                              fontSize: isMobile ? 10 : 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.red[800],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Sheet column: "${mapping.sheetColumnName}"',
                          style: TextStyle(
                            fontSize: isMobile ? 12 : 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Confidence badge
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 8 : 10,
                    vertical: isMobile ? 4 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: confidenceColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    confidenceLabel,
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      fontWeight: FontWeight.w600,
                      color: confidenceColor,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${mapping.confidenceScore.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _proceedWithImport() async {
    // Reuse the already imported result - no need to re-import
    if (_importResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No import data available'),
          backgroundColor: Colors.red[700],
        ),
      );
      return;
    }

    // Navigate directly to results screen with the cached result
    if (!mounted) return;

    if (widget.importType == ImportType.items) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ImportResultsScreen<ImportedItemData>(
            result: _importResult! as ImportResult<List<ImportedItemData>>,
            importType: widget.importType,
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ImportResultsScreen<ImportedPartyData>(
            result: _importResult! as ImportResult<List<ImportedPartyData>>,
            importType: widget.importType,
          ),
        ),
      );
    }
  }
}
