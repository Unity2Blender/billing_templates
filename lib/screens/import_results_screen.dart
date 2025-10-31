import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/import_result.dart';
import '../importers/item_sheet_importer.dart';
import '../importers/party_sheet_importer.dart';
import 'import_type_selection_screen.dart';

/// Screen for displaying import results with data table and summary
class ImportResultsScreen<T> extends StatefulWidget {
  final ImportResult<List<T>> result;
  final ImportType importType;

  const ImportResultsScreen({
    super.key,
    required this.result,
    required this.importType,
  });

  @override
  State<ImportResultsScreen<T>> createState() => _ImportResultsScreenState<T>();
}

class _ImportResultsScreenState<T> extends State<ImportResultsScreen<T>> {
  int _currentPage = 0;
  static const int _rowsPerPage = 10;
  bool _expandedWarnings = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Import Results',
          style: TextStyle(fontSize: isMobile ? 18 : 20),
        ),
        centerTitle: isMobile,
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Pop all the way back to home
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: widget.result.isSuccess
          ? _buildSuccessView(isMobile)
          : _buildFailureView(isMobile),
    );
  }

  Widget _buildSuccessView(bool isMobile) {
    final data = widget.result.data!;
    final totalPages = (data.length / _rowsPerPage).ceil();

    return Container(
      color: Colors.grey[50],
      child: Column(
        children: [
          // Summary section
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  children: [
                    // Success header
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isMobile ? 12 : 14),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: isMobile ? 32 : 40,
                            color: Colors.green[600],
                          ),
                        ),
                        SizedBox(width: isMobile ? 12 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Import Successful!',
                                style: TextStyle(
                                  fontSize: isMobile ? 18 : 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Successfully imported ${widget.result.successCount} ${widget.importType == ImportType.items ? "items" : "contacts"}',
                                style: TextStyle(
                                  fontSize: isMobile ? 13 : 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isMobile ? 16 : 20),

                    // Statistics cards
                    if (isMobile)
                      Column(
                        children: [
                          _buildStatCard(
                            'Total Rows',
                            widget.result.totalRows.toString(),
                            Icons.table_rows,
                            Colors.blue,
                            isMobile,
                          ),
                          const SizedBox(height: 12),
                          _buildStatCard(
                            'Success',
                            widget.result.successCount.toString(),
                            Icons.check_circle,
                            Colors.green,
                            isMobile,
                          ),
                          if (widget.result.failureCount > 0) ...[
                            const SizedBox(height: 12),
                            _buildStatCard(
                              'Skipped',
                              widget.result.failureCount.toString(),
                              Icons.warning,
                              Colors.orange,
                              isMobile,
                            ),
                          ],
                          const SizedBox(height: 12),
                          _buildStatCard(
                            'Success Rate',
                            widget.result.totalRows > 0
                                ? '${((widget.result.successCount / widget.result.totalRows) * 100).toStringAsFixed(1)}%'
                                : '0.0%',
                            Icons.trending_up,
                            Colors.purple,
                            isMobile,
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Rows',
                              widget.result.totalRows.toString(),
                              Icons.table_rows,
                              Colors.blue,
                              isMobile,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Success',
                              widget.result.successCount.toString(),
                              Icons.check_circle,
                              Colors.green,
                              isMobile,
                            ),
                          ),
                          if (widget.result.failureCount > 0) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                'Skipped',
                                widget.result.failureCount.toString(),
                                Icons.warning,
                                Colors.orange,
                                isMobile,
                              ),
                            ),
                          ],
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Success Rate',
                              widget.result.totalRows > 0
                                  ? '${((widget.result.successCount / widget.result.totalRows) * 100).toStringAsFixed(1)}%'
                                  : '0.0%',
                              Icons.trending_up,
                              Colors.purple,
                              isMobile,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Warnings section (if any)
          if (widget.result.hasWarnings)
            Container(
              color: Colors.orange[50],
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 12 : 16,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _expandedWarnings = !_expandedWarnings;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.orange[700],
                              size: isMobile ? 20 : 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${widget.result.warnings.length} warning(s) detected',
                                style: TextStyle(
                                  fontSize: isMobile ? 13 : 14,
                                  color: Colors.orange[900],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              _expandedWarnings
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.orange[700],
                            ),
                          ],
                        ),
                      ),
                      if (_expandedWarnings) ...[
                        const SizedBox(height: 12),
                        ...widget.result.warnings.take(10).map(
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
                        if (widget.result.warnings.length > 10)
                          Text(
                            '+ ${widget.result.warnings.length - 10} more warnings...',
                            style: TextStyle(
                              fontSize: isMobile ? 11 : 12,
                              color: Colors.orange[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

          // Data table
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isMobile ? 16 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Table header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Imported Data (${data.length} records)',
                            style: TextStyle(
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          if (totalPages > 1)
                            Text(
                              'Page ${_currentPage + 1} of $totalPages',
                              style: TextStyle(
                                fontSize: isMobile ? 12 : 13,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: isMobile ? 12 : 16),

                      // Table
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: widget.importType == ImportType.items
                            ? _buildItemsTable(data as List<ImportedItemData>, isMobile)
                            : _buildPartiesTable(data as List<ImportedPartyData>, isMobile),
                      ),

                      // Pagination
                      if (totalPages > 1) ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _currentPage > 0
                                  ? () => setState(() => _currentPage--)
                                  : null,
                              icon: const Icon(Icons.chevron_left),
                              tooltip: 'Previous page',
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${_currentPage + 1} / $totalPages',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: _currentPage < totalPages - 1
                                  ? () => setState(() => _currentPage++)
                                  : null,
                              icon: const Icon(Icons.chevron_right),
                              tooltip: 'Next page',
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
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
                      onPressed: _downloadJSON,
                      icon: const Icon(Icons.download),
                      label: const Text('Download JSON'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: isMobile ? 14 : 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Done'),
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
    );
  }

  Widget _buildFailureView(bool isMobile) {
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
                  widget.result.errorMessage ?? 'Unknown error occurred',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    color: Colors.red[800],
                    height: 1.4,
                  ),
                ),
                SizedBox(height: isMobile ? 20 : 24),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Go to Home'),
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

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 14 : 16),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 8 : 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: isMobile ? 20 : 24),
            ),
            SizedBox(width: isMobile ? 10 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: isMobile ? 11 : 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsTable(List<ImportedItemData> items, bool isMobile) {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, items.length);
    final pageItems = items.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
        columns: [
          DataColumn(
            label: Text(
              'Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'HSN Code',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Price',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'GST %',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              'Unit',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Stock',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
            numeric: true,
          ),
        ],
        rows: pageItems.map((item) {
          return DataRow(
            cells: [
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Text(
                    item.name,
                    style: TextStyle(fontSize: isMobile ? 12 : 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Text(
                  item.hsnCode.isEmpty ? '-' : item.hsnCode,
                  style: TextStyle(fontSize: isMobile ? 12 : 13),
                ),
              ),
              DataCell(
                Text(
                  '₹${item.defaultNetPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: isMobile ? 12 : 13),
                ),
              ),
              DataCell(
                Text(
                  '${item.gstRate.toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: isMobile ? 12 : 13),
                ),
              ),
              DataCell(
                Text(
                  item.qtyUnit,
                  style: TextStyle(fontSize: isMobile ? 12 : 13),
                ),
              ),
              DataCell(
                Text(
                  item.stockQty.toStringAsFixed(0),
                  style: TextStyle(fontSize: isMobile ? 12 : 13),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPartiesTable(List<ImportedPartyData> parties, bool isMobile) {
    final startIndex = _currentPage * _rowsPerPage;
    final endIndex = (startIndex + _rowsPerPage).clamp(0, parties.length);
    final pageParties = parties.sublist(startIndex, endIndex);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(Colors.grey[100]),
        columns: [
          DataColumn(
            label: Text(
              'Business Name',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Phone',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Email',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'GSTIN',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'State',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: isMobile ? 12 : 13,
              ),
            ),
          ),
        ],
        rows: pageParties.map((party) {
          return DataRow(
            cells: [
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Text(
                    party.businessName,
                    style: TextStyle(fontSize: isMobile ? 12 : 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Text(
                  party.phone.isEmpty ? '-' : party.phone,
                  style: TextStyle(fontSize: isMobile ? 12 : 13),
                ),
              ),
              DataCell(
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 180),
                  child: Text(
                    party.email.isEmpty ? '-' : party.email,
                    style: TextStyle(fontSize: isMobile ? 12 : 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              DataCell(
                Text(
                  party.gstin.isEmpty ? '-' : party.gstin,
                  style: TextStyle(fontSize: isMobile ? 12 : 13),
                ),
              ),
              DataCell(
                Text(
                  party.state.isEmpty ? '-' : party.state,
                  style: TextStyle(fontSize: isMobile ? 12 : 13),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _downloadJSON() async {
    try {
      final data = widget.result.data!;
      final jsonData = data.map((item) {
        if (item is ImportedItemData) {
          return item.toMap();
        } else if (item is ImportedPartyData) {
          return item.toMap();
        }
        return {};
      }).toList();

      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);

      await Clipboard.setData(ClipboardData(text: jsonString));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text('JSON data copied to clipboard!'),
              ),
            ],
          ),
          backgroundColor: Colors.green[700],
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error downloading JSON: $e'),
          backgroundColor: Colors.red[700],
        ),
      );
    }
  }
}
