# Adapter System

This directory contains adapters that convert FlutterFlow data structures to internal models used by the invoice PDF generation library.

## Overview

**Purpose:** Bridge FlutterFlow app data with the template library's internal models

**Architecture:** One-way, pure conversion (FlutterFlow structs → Internal models)

**Key Principle:** Your app fetches ALL data from Firestore; adapters only transform structure

---

## Adapter Files

### 1. InvoiceAdapter
**File:** `invoice_adapter.dart`

**Role:** Main orchestrator for complete invoice conversion

**Converts:** `InvoiceStruct` + `FirmConfigStruct` → `InvoiceData`

**Delegates to:**
- BusinessAdapter (seller/buyer details)
- ItemAdapter (line items)
- BillSummaryAdapter (invoice totals)
- BankingAdapter (payment details)

**Key Mappings:**
- `modeSpecifcDetails.modeType` → `InvoiceMode` enum
- `modeSpecifcDetails.modeId` + `modeIdPrefix` → invoice number
- `modeSpecifcDetails.dates` → `issueDate`, `dueDate`
- `sellerFirm.businessDetails` → seller `BusinessDetails`
- `invoice.billToParty` → buyer `BusinessDetails`
- `invoice.lines[]` → `List<ItemSaleInfo>`
- `invoice.billSummary` → `BillSummary`
- `sellerFirm.bankAccounts[0]` → `BankingDetails`

**Ignored Fields:**
- `invoice.invoiceRef` (DB self-reference)
- `invoice.sellerFirm` (DocumentReference - use passed `sellerFirm` struct instead)
- `invoice.referenceInvoiceRef` (DB reference to related invoice)
- All `customFieldValues[].fieldRef` (custom field schemas)

---

### 2. BusinessAdapter
**File:** `business_adapter.dart`

**Role:** Convert business/party information (used for both seller and buyer)

**Converts:** `BusinessDetailsStruct` → `BusinessDetails`

**Field Mappings:**
```
businessName     → businessName
gstin            → gstin (GST Identification Number)
pan              → pan (Permanent Account Number)
state            → state (used for intra/inter-state GST determination)
district         → district
businessAddress  → businessAddress
phone            → phone
email            → email
```

**Ignored Fields:**
- `partyRef` (DocumentReference to party)
- `customFieldValues` (custom fields - not yet implemented, see `TODO-CustomFields.md` for v2.0 plan)
- `isCustomer` (DB metadata flag)
- `isVendor` (DB metadata flag)

---

### 3. ItemAdapter
**File:** `item_adapter.dart`

**Role:** Convert line items with pricing and tax calculations

**Converts:** `ItemSaleInfoStruct` → `ItemSaleInfo`

**Field Mappings:**
```
item.name                       → itemName
item.hsnCode                    → hsnCode (product classification)
item.description                → description
qtyOnBill                       → quantity
item.qtyUnit                    → unit (e.g., "Nos", "Kg", "Ltr")
partyNetPrice (or defaultNetPrice) → rate
subtotal                        → subtotal (before discount)
discountPercentage              → discount %
discountAmt                     → discountAmount
taxableValue                    → taxableValue (after discount)
igst                            → igst (inter-state GST amount)
csgst                           → csgst (combined CGST+SGST for intra-state)
cessAmt                         → cessAmt (compensation cess)
grossTaxCharged                 → taxRate (total GST % + CESS %)
lineTotal                       → total (final line amount)
```

**Tax Handling:**
- `csgst` contains **combined** CGST+SGST amount for intra-state transactions
- `igst` used for inter-state transactions (csgst = 0 in this case)
- Your app must pre-calculate all tax amounts before passing to adapter
- Templates handle CGST/SGST display split if needed

**Ignored Fields:**
- `item.itemRef` (DocumentReference to item)
- `item.byFirms[]` (list of firm DocumentReferences)
- `item.partySpecificPrices` (pricing rules, already applied in `partyNetPrice`)
- `customFieldInputs` (custom field values - not yet implemented, see `TODO-CustomFields.md` for v2.0 plan)

---

### 4. BillSummaryAdapter
**File:** `bill_summary_adapter.dart`

**Role:** Convert invoice totals and payment summary

**Converts:** `BillSummaryResultsStruct` → `BillSummary`

**Field Mappings:**
```
totalTaxableValue          → totalTaxableValue (sum of all taxable amounts)
totalDiscount              → totalDiscount (sum of all discounts)
totalGst                   → totalGst (sum of all GST amounts)
totalCess                  → totalCess (sum of all CESS amounts)
totalLineItemsAfterTaxes   → totalLineItemsAfterTaxes (grand total)
dueBalancePayable          → dueBalancePayable (balance remaining)
```

**Additional Input:**
- `amountPaid` (from `InvoiceStruct.amountPaid`) - used to calculate balance if not provided

**Calculation Notes:**
- If `dueBalancePayable` is null in struct, calculated as: `totalLineItemsAfterTaxes - amountPaid`
- All tax calculations expected to be done by your app before passing to adapter

---

### 5. BankingAdapter
**File:** `banking_adapter.dart`

**Role:** Convert banking details for payment instructions

**Converts:** `BankingDetailsStruct` → `BankingDetails`

**Field Mappings:**
```
makeChequeFor  → accountHolderName (firm/business name)
upi            → upi (UPI ID)
accountNo      → accountNo (int → String conversion)
ifsc           → ifsc (IFSC code)
bankName       → bankName
branchAddress  → branchAddress
```

**Type Conversions:**
- Account number stored as `int` in FlutterFlow, converted to `String` for PDF display

---

## Usage Pattern

### Complete Integration Flow

```dart
// 1. YOUR APP: Fetch data from Firestore
final invoiceDoc = await FirebaseFirestore.instance
    .collection('invoices')
    .doc(invoiceId)
    .get();
final invoice = InvoiceStruct.fromMap(invoiceDoc.data()!);

final firmDoc = await FirebaseFirestore.instance
    .collection('firms')
    .doc(firmId)
    .get();
final firm = FirmConfigStruct.fromMap(firmDoc.data()!);

// 2. ADAPTER: Convert to internal model (pure, synchronous)
final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
  invoice: invoice,
  sellerFirm: firm,
);

// 3. PDF SERVICE: Generate PDF
await PDFService().printInvoice(
  invoice: invoiceData,
  templateId: 'mbbook_modern',
  colorTheme: InvoiceThemes.lightBlue,
);
```

---

## DocumentReferences Handling

All DocumentReference fields in FlutterFlow structs are **ignored** by adapters:

**Why?**
- PDF generation needs data, not database pointers
- All required data should be denormalized in structs
- Your app handles fetching and populating nested structs
- Keeps adapter logic simple and side-effect free

**Ignored References:**
- Invoice references: `invoiceRef`, `sellerFirm`, `referenceInvoiceRef`
- Party references: `partyRef`, `buyerDetails.partyRef`
- Item references: `itemRef`, `byFirms[]`
- Field schema references: All `customFieldValues[].fieldRef`

---

## Adapter Characteristics

### Pure Functions
- **Synchronous** (no async/await)
- **No I/O operations** (no Firestore reads)
- **No side effects** (just data transformation)
- **Safe to call repeatedly** (idempotent)

### Null Safety
- All fields have default fallbacks (empty strings, 0.0, empty arrays)
- Missing nested structs handled gracefully
- Invalid enum values fall back to sensible defaults

### Performance
- Conversion typically takes <1ms
- No network calls or database queries
- Safe to call in build methods if memoized

---

## Testing Adapters

### Unit Test Pattern

```dart
test('InvoiceAdapter converts FlutterFlow struct correctly', () {
  // Arrange: Create mock FlutterFlow structs
  final invoice = InvoiceStruct(/* ... */);
  final firm = FirmConfigStruct(/* ... */);

  // Act: Convert
  final result = InvoiceAdapter.fromFlutterFlowStruct(
    invoice: invoice,
    sellerFirm: firm,
  );

  // Assert: Verify mappings
  expect(result.invoiceNumber, equals('123'));
  expect(result.sellerDetails.businessName, equals('ACME Corp'));
  // ... more assertions
});
```

### Integration Testing
- Fetch real invoice data from your Firestore
- Convert using adapters
- Generate PDF and verify output
- Test across different invoice modes and scenarios

---

## Error Handling

### Adapter Errors
- **Null/missing fields** → Default values applied (empty strings, 0.0)
- **Invalid enum values** → Fallback to defaults (e.g., `InvoiceMode.salesInv`)
- **Malformed structs** → May throw exceptions (validate before passing)

### Best Practice
```dart
try {
  final invoiceData = InvoiceAdapter.fromFlutterFlowStruct(
    invoice: invoice,
    sellerFirm: firm,
  );
  await PDFService().generatePDF(invoice: invoiceData);
} catch (e) {
  print('Invoice conversion failed: $e');
  // Handle error (show user message, log to analytics, etc.)
}
```

---

## Extending Adapters

### Adding New Fields

1. **Update FlutterFlow Struct** (in your app)
2. **Update Internal Model** (in this package)
3. **Update Adapter Mapping** (add field conversion)
4. **Update Tests** (verify conversion)

Example:
```dart
// In ItemAdapter.fromFlutterFlowStruct()
return ItemSaleInfo(
  // ... existing fields
  newField: itemStruct.newField ?? defaultValue, // Add this
);
```

### Custom Adapter Logic

If you need special handling (e.g., data transformation, calculations):

```dart
static InvoiceData fromFlutterFlowStruct({
  required dynamic invoice,
  required dynamic sellerFirm,
}) {
  // Custom logic example: compute invoice total if missing
  final computedTotal = invoice.billSummary.totalLineItemsAfterTaxes ??
      _calculateTotal(invoice.lines);

  return InvoiceData(/* ... */);
}

static double _calculateTotal(List<dynamic> lines) {
  return lines.fold(0.0, (sum, line) => sum + (line.lineTotal ?? 0.0));
}
```

---

## Migration Notes

### From v0.x to v1.0
- **BillSummary fields renamed** to match FlutterFlow structs exactly:
  - `subtotal` → `totalTaxableValue`
  - `totalTax` → `totalGst`
  - `grandTotal` → `totalLineItemsAfterTaxes`
  - `balance` → `dueBalancePayable`
  - Removed `roundOff` field (not in source struct)

- **InvoiceMode enum values** updated with "Inv" suffix:
  - `sales` → `salesInv`
  - `proforma` → `proformaInv`
  - `estimate` → `estimateInv`
  - etc.

If you were using older versions, update your code accordingly.

---

## Future: Custom Fields Support

Custom fields are **planned for v2.0** but not yet implemented. See `TODO-CustomFields.md` for complete specification.

**When implemented, adapters will:**
- Extract `customFieldInputs[]` from ItemSaleInfoStruct (item-level fields where `isItemField: true`)
- Extract `customFieldValues[]` from BusinessDetailsStruct (business-level fields where `isBusinessField: true`)
- Support party-specific custom fields (filtered by `partyRef`)
- Convert to new `CustomFieldValue` model with 6 field types (text, number, date, boolean, select, multiselect)

**Why not in v1.0:**
- Requires major template refactoring (dynamic table columns)
- Breaking changes to internal models
- Complex rendering strategies needed for different templates

---

## Related Documentation

- **CLAUDE.md** - Full project architecture and conventions
- **TODO-CustomFields.md** - v2.0 custom fields implementation plan
- **lib/models/** - Internal model definitions
- **lib/services/pdf_service.dart** - PDF generation service
- **example/integration_example.dart** - Complete integration example
- **references/structTypes/custom_field_struct.dart** - FlutterFlow CustomFieldStruct definition
