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

**Custom Fields Handling:**
- `customFieldValues[]` - Extracts business-level custom fields where `isBusiness: true`
- Field values mapped to `CustomFieldValue` objects
- Sorted by `displayOrder` for consistent rendering
- Supports all 6 field types: text, number, date, boolean, select, multiselect
- Party-specific fields filtered by `partyRef` (if applicable)
- `fieldRef` DocumentReferences are ignored (schema already denormalized)

**Ignored Fields:**
- `partyRef` (DocumentReference to party)
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

**Custom Fields Handling:**
- `customFieldInputs[]` - Extracts item-level custom fields where `isBusiness: false`
- Field values mapped to `CustomFieldValue` objects
- Sorted by `displayOrder` for consistent rendering
- Supports all 6 field types: text, number, date, boolean, select, multiselect
- `fieldRef` DocumentReferences are ignored (schema already denormalized)

**Ignored Fields:**
- `item.itemRef` (DocumentReference to item)
- `item.byFirms[]` (list of firm DocumentReferences)
- `item.partySpecificPrices` (pricing rules, already applied in `partyNetPrice`)

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

## Custom Fields Support (v2.0+)

Custom fields are **now implemented** and fully supported across all adapters and templates.

### CustomFieldValue Model

**Location:** `lib/models/custom_field_value.dart`

```dart
class CustomFieldValue {
  final String fieldName;      // Display label (e.g., "Warranty", "HUID")
  final String fieldType;      // 'text', 'number', 'date', 'boolean', 'select', 'multiselect'
  final dynamic value;         // Actual field value (type varies by fieldType)
  final int displayOrder;      // Sort order for rendering
  final bool isRequired;       // Metadata flag

  String get displayValue;     // Type-specific formatted value for PDFs
}
```

### Item-Level Custom Fields

**Source:** `ItemSaleInfoStruct.customFieldInputs[]`

**Extraction Logic:**
1. Filter where `isBusiness == false` (item-level fields only)
2. Map to `CustomFieldValue` objects
3. Sort by `displayOrder` (ascending)
4. Ignore `fieldRef` DocumentReferences

**Example:**
```dart
final items = invoice.lines.map((lineStruct) =>
  ItemAdapter.fromFlutterFlowStruct(lineStruct)
).toList();

// Result: ItemSaleInfo with customFields populated
items[0].customFields // [CustomFieldValue(Warranty: '2 Years'), ...]
```

### Business-Level Custom Fields

**Source:** `BusinessDetailsStruct.customFieldValues[]`

**Extraction Logic:**
1. Filter where `isBusiness == true` (business-level fields only)
2. Filter by `partyRef` for party-specific fields (buyer only)
3. Map to `CustomFieldValue` objects
4. Sort by `displayOrder` (ascending)
5. Ignore `fieldRef` DocumentReferences

**Example:**
```dart
final seller = BusinessAdapter.fromFlutterFlowStruct(
  firmStruct.businessDetails,
  currentPartyRef: null, // Seller doesn't have party-specific fields
);

final buyer = BusinessAdapter.fromFlutterFlowStruct(
  invoice.billToParty,
  currentPartyRef: invoice.billToParty.partyRef, // Filter party-specific
);

// Result: BusinessDetails with customFields populated
seller.customFields // [CustomFieldValue(IEC Code: 'IEC123'), ...]
buyer.customFields  // [CustomFieldValue(Customer Code: 'CUST001'), ...]
```

### Field Types & Value Extraction

| Field Type    | Struct Property     | Internal Type | Display Format       |
|---------------|---------------------|---------------|----------------------|
| text          | stringValue         | String        | As-is                |
| number        | numberValue         | double        | 2 decimal places     |
| date          | dateValue           | DateTime      | DD-MM-YYYY           |
| boolean       | boolValue           | bool          | 'Yes' / 'No'         |
| select        | stringValue         | String        | As-is                |
| multiselect   | multiSelectValues   | List\<String\> | Comma-separated      |

### Template Rendering

**Item Custom Fields:**
- Rendered inline within item name column (below item name)
- Displayed as compact text: "Field1: Value1 • Field2: Value2"
- Font size: 7-8pt (smaller than item name)
- Color: Grey for visual differentiation

**Business Custom Fields:**
- Rendered in "Additional Details" section
- Displayed after standard fields (GSTIN, PAN, address, etc.)
- Bordered container for visual grouping
- Format: "Field Name: Field Value" (one per line)

### Party-Specific Fields

**Use Case:** Different buyers may have different custom fields (e.g., Customer Code, Credit Limit, Account Manager).

**Implementation:**
- Buyer custom fields filtered by `billToParty.partyRef`
- Only fields with matching `partyRef` or `null` partyRef are included
- Seller custom fields always use firm's fields (no party filtering)

**Example:**
```dart
// Party A has fields: Customer Code, Credit Limit
// Party B has fields: VIP Status, Account Manager

// When generating invoice for Party A:
buyer.customFields // [CustomerCode, CreditLimit] only

// When generating invoice for Party B:
buyer.customFields // [VIPStatus, AccountManager] only
```

### Backward Compatibility

**Empty Custom Fields:**
- All models default `customFields` to empty list `[]`
- Templates conditionally render: `if (customFields.isNotEmpty)`
- No breaking changes for existing invoices

**Legacy Invoices:**
- Invoices without custom fields render identically to before
- No visual changes unless custom fields are explicitly provided
- 100% backward compatible with v1.0 data structures

---

## Related Documentation

- **CLAUDE.md** - Full project architecture and conventions
- **TODO-CustomFields.md** - v2.0 custom fields implementation plan
- **lib/models/** - Internal model definitions
- **lib/services/pdf_service.dart** - PDF generation service
- **example/integration_example.dart** - Complete integration example
- **references/structTypes/custom_field_struct.dart** - FlutterFlow CustomFieldStruct definition
