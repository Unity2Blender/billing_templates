# TODO: Custom Fields Integration

**Status:** Planned Major Refactor
**Priority:** High
**Estimated Effort:** Large (3-5 days)

---

## Overview

Implement comprehensive custom fields support for invoice templates, enabling rendering of custom field values for both **item-level fields** (in the items table) and **business-level fields** (in seller/buyer business details sections).

### Current State
- Custom field values exist in FlutterFlow structs but are **ignored** by adapters
- `customFieldValues[]` arrays contain field data with `fieldRef` (DocumentReference to schema)
- No rendering logic exists in any template
- Adapters skip custom field processing entirely

### Target State
- Custom fields rendered dynamically in appropriate template sections
- Item custom fields displayed as additional columns in items table
- Business custom fields displayed in business details sections
- Field visibility controlled by `isBusiness` flag in custom field schema
- Party-specific custom fields supported (different fields per party)

---

## Custom Field Data Structure

### FlutterFlow Struct: CustomFieldValueStruct

```dart
class CustomFieldValueStruct {
  DocumentReference fieldRef;        // Reference to CustomFieldSchemaStruct
  bool isBusiness;                   // true = business field, false = item field

  // Value storage (one of these will be populated based on field type)
  String? stringValue;
  double? numberValue;
  bool? boolValue;
  DateTime? dateValue;
  List<String>? multiSelectValues;

  // Metadata
  String fieldName;                  // Display name
  String fieldType;                  // "text", "number", "date", "boolean", "select", "multiselect"
  int displayOrder;                  // Sort order for rendering
  bool isRequired;

  // Party-specific fields
  DocumentReference? partyRef;       // If set, this field is party-specific
}
```

### Field Types to Support

1. **Text** - Single-line string input
2. **Number** - Numeric value (with optional currency/unit)
3. **Date** - Date value
4. **Boolean** - Checkbox/toggle
5. **Select** - Dropdown (single selection)
6. **Multi-Select** - Multiple choice selections

---

## Implementation Phases

### Phase 1: Adapter Updates (Foundation)

#### 1.1 Update ItemAdapter

**File:** `lib/adapters/item_adapter.dart`

**Changes:**
- Add `customFields` list to `ItemSaleInfo` model
- Parse `customFieldInputs[]` from FlutterFlow struct
- Filter where `isBusiness == false` (item-level fields only)
- Ignore `fieldRef` (DocumentReference) but extract field values
- Sort by `displayOrder`

**New Model Class:**
```dart
class CustomFieldValue {
  final String fieldName;
  final String fieldType;
  final dynamic value;           // Holds stringValue, numberValue, etc.
  final int displayOrder;
  final bool isRequired;

  CustomFieldValue({
    required this.fieldName,
    required this.fieldType,
    required this.value,
    this.displayOrder = 0,
    this.isRequired = false,
  });
}
```

**Adapter Logic:**
```dart
static ItemSaleInfo fromFlutterFlowStruct(dynamic itemStruct) {
  // ... existing code ...

  // Extract item-level custom fields
  final customFields = itemStruct.customFieldInputs
      ?.where((field) => field.isBusiness == false)
      ?.map((field) => CustomFieldValue(
            fieldName: field.fieldName ?? '',
            fieldType: field.fieldType ?? 'text',
            value: _extractFieldValue(field),
            displayOrder: field.displayOrder ?? 0,
            isRequired: field.isRequired ?? false,
          ))
      ?.toList()
      ?.sort((a, b) => a.displayOrder.compareTo(b.displayOrder))
      ?? [];

  return ItemSaleInfo(
    // ... existing fields ...
    customFields: customFields,
  );
}

static dynamic _extractFieldValue(dynamic field) {
  switch (field.fieldType) {
    case 'text':
    case 'select':
      return field.stringValue ?? '';
    case 'number':
      return field.numberValue ?? 0.0;
    case 'boolean':
      return field.boolValue ?? false;
    case 'date':
      return field.dateValue;
    case 'multiselect':
      return field.multiSelectValues ?? [];
    default:
      return field.stringValue ?? '';
  }
}
```

#### 1.2 Update BusinessAdapter

**File:** `lib/adapters/business_adapter.dart`

**Changes:**
- Add `customFields` list to `BusinessDetails` model
- Parse `customFieldValues[]` from FlutterFlow struct
- Filter where `isBusiness == true` (business-level fields only)
- Handle party-specific fields (check `partyRef`)
- Sort by `displayOrder`

**Adapter Logic:**
```dart
static BusinessDetails fromFlutterFlowStruct(
  dynamic businessStruct, {
  DocumentReference? currentPartyRef, // For party-specific filtering
}) {
  // ... existing code ...

  // Extract business-level custom fields
  final customFields = businessStruct.customFieldValues
      ?.where((field) {
        // Include if it's a business field
        if (field.isBusiness != true) return false;

        // Include if party-specific and matches current party
        if (field.partyRef != null && currentPartyRef != null) {
          return field.partyRef == currentPartyRef;
        }

        // Include if not party-specific
        return field.partyRef == null;
      })
      ?.map((field) => CustomFieldValue(/* ... */))
      ?.toList()
      ?.sort((a, b) => a.displayOrder.compareTo(b.displayOrder))
      ?? [];

  return BusinessDetails(
    // ... existing fields ...
    customFields: customFields,
  );
}
```

#### 1.3 Update Models

**File:** `lib/models/item_sale_info.dart`

```dart
class ItemSaleInfo {
  // ... existing fields ...
  final List<CustomFieldValue> customFields;

  ItemSaleInfo({
    // ... existing parameters ...
    this.customFields = const [],
  });
}
```

**File:** `lib/models/business_details.dart`

```dart
class BusinessDetails {
  // ... existing fields ...
  final List<CustomFieldValue> customFields;

  BusinessDetails({
    // ... existing parameters ...
    this.customFields = const [],
  });
}
```

**New File:** `lib/models/custom_field_value.dart`

```dart
/// Represents a custom field value extracted from FlutterFlow structs.
///
/// Custom fields can be item-level (displayed in items table) or
/// business-level (displayed in business details sections).
class CustomFieldValue {
  final String fieldName;
  final String fieldType;
  final dynamic value;
  final int displayOrder;
  final bool isRequired;

  CustomFieldValue({
    required this.fieldName,
    required this.fieldType,
    required this.value,
    this.displayOrder = 0,
    this.isRequired = false,
  });

  /// Returns the value formatted for display in PDFs
  String get displayValue {
    if (value == null) return '';

    switch (fieldType) {
      case 'boolean':
        return value == true ? 'Yes' : 'No';
      case 'date':
        return value is DateTime
            ? '${value.day.toString().padLeft(2, '0')}-${value.month.toString().padLeft(2, '0')}-${value.year}'
            : value.toString();
      case 'number':
        return value is double
            ? value.toStringAsFixed(2)
            : value.toString();
      case 'multiselect':
        return value is List ? (value as List).join(', ') : value.toString();
      default:
        return value.toString();
    }
  }
}
```

---

### Phase 2: Template Rendering (Item Custom Fields)

#### 2.1 Items Table Layout Strategy

**Challenge:** Dynamic column count based on custom fields present

**Options:**

**Option A: Append Custom Columns (Recommended)**
```
| Sr | Item | HSN | Qty | Rate | Disc | Tax | Amt | [Custom1] | [Custom2] | ... |
```

**Option B: Expand Item Description**
```
| Sr | Item Name               | HSN | Qty | Rate | Disc | Tax | Amt |
|    | [Custom fields inline]  |     |     |      |      |     |     |
```

**Option C: Dedicated Custom Fields Column**
```
| Sr | Item | HSN | Qty | Rate | Disc | Tax | Amt | Custom Fields          |
|    |      |     |     |      |      |     |     | Field1: Value1         |
|    |      |     |     |      |      |     |     | Field2: Value2         |
```

**Recommendation:** Use **Option A** for templates with horizontal space (Tally, Modern), **Option B** for compact templates (A5, Thermal).

#### 2.2 Update Template Base Class

**File:** `lib/templates/invoice_template_base.dart`

Add abstract methods for custom field rendering:

```dart
abstract class InvoiceTemplate {
  // ... existing methods ...

  /// Whether this template supports item-level custom fields
  bool get supportsItemCustomFields => false;

  /// Whether this template supports business-level custom fields
  bool get supportsBusinessCustomFields => false;

  /// Maximum number of item custom fields this template can display
  /// (null = unlimited, for templates with flexible layouts)
  int? get maxItemCustomFields => 3;

  /// Custom field rendering strategy for items table
  /// 'columns' = separate columns (Option A)
  /// 'inline' = inside item description (Option B)
  /// 'grouped' = single column with all fields (Option C)
  String get itemCustomFieldStrategy => 'columns';
}
```

#### 2.3 Template Implementation Examples

##### Example 1: Tally Template (Horizontal Columns)

**File:** `lib/templates/mbbook_tally_template.dart`

```dart
@override
bool get supportsItemCustomFields => true;

@override
int? get maxItemCustomFields => 3; // Limit to 3 for layout constraints

@override
String get itemCustomFieldStrategy => 'columns';

pw.TableRow _buildItemsTableHeader(InvoiceData invoice) {
  // Get custom fields from first item (assumes all items have same fields)
  final customFields = invoice.lineItems.isNotEmpty
      ? invoice.lineItems.first.customFields.take(maxItemCustomFields ?? 3)
      : <CustomFieldValue>[];

  return pw.TableRow(
    decoration: pw.BoxDecoration(color: PdfColors.grey300),
    children: [
      _headerCell('Sr.'),
      _headerCell('Item Name'),
      _headerCell('HSN'),
      _headerCell('Qty'),
      _headerCell('Rate'),
      _headerCell('Disc %'),
      _headerCell('CGST'),
      _headerCell('SGST'),
      _headerCell('CESS'),
      _headerCell('Amount'),
      // Dynamic custom field headers
      ...customFields.map((field) => _headerCell(field.fieldName)),
    ],
  );
}

pw.TableRow _buildItemRow(ItemSaleInfo item, int index, InvoiceData invoice) {
  final customFields = item.customFields.take(maxItemCustomFields ?? 3);

  return pw.TableRow(
    children: [
      _cell('${index + 1}'),
      _cell(item.item.name),
      _cell(item.item.hsnCode),
      _cell('${item.qtyOnBill} ${item.item.qtyUnit}'),
      _cell('₹${item.partyNetPrice.toStringAsFixed(2)}'),
      _cell('${item.discountPercentage.toStringAsFixed(1)}%'),
      _cell('₹${(item.csgst / 2).toStringAsFixed(2)}'),
      _cell('₹${(item.csgst / 2).toStringAsFixed(2)}'),
      _cell('₹${item.cessAmt.toStringAsFixed(2)}'),
      _cell('₹${item.lineTotal.toStringAsFixed(2)}'),
      // Dynamic custom field values
      ...customFields.map((field) => _cell(field.displayValue)),
    ],
  );
}
```

##### Example 2: Modern Template (Inline)

**File:** `lib/templates/mbbook_modern_template.dart`

```dart
@override
bool get supportsItemCustomFields => true;

@override
String get itemCustomFieldStrategy => 'inline';

pw.Widget _buildItemRow(ItemSaleInfo item, int index) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      // Main item row
      pw.Row(/* standard item row */),

      // Custom fields inline below item name
      if (item.customFields.isNotEmpty)
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 20, top: 2),
          child: pw.Text(
            item.customFields
                .map((field) => '${field.fieldName}: ${field.displayValue}')
                .join(' • '),
            style: pw.TextStyle(fontSize: 8, color: PdfColors.grey700),
          ),
        ),
    ],
  );
}
```

##### Example 3: Compact/Thermal Template (Grouped)

**File:** `lib/templates/a5_compact_template.dart`

```dart
@override
bool get supportsItemCustomFields => true;

@override
String get itemCustomFieldStrategy => 'grouped';

pw.TableRow _buildItemsTableHeader() {
  return pw.TableRow(
    children: [
      _headerCell('Item'),
      _headerCell('Qty'),
      _headerCell('Rate'),
      _headerCell('Amt'),
      _headerCell('Details'), // Custom fields grouped here
    ],
  );
}

pw.TableRow _buildItemRow(ItemSaleInfo item, int index) {
  final customFieldsText = item.customFields.isNotEmpty
      ? item.customFields
          .map((f) => '${f.fieldName}: ${f.displayValue}')
          .join('\n')
      : '-';

  return pw.TableRow(
    children: [
      _cell(item.item.name),
      _cell('${item.qtyOnBill}'),
      _cell('₹${item.partyNetPrice.toStringAsFixed(2)}'),
      _cell('₹${item.lineTotal.toStringAsFixed(2)}'),
      _cell(customFieldsText, fontSize: 7),
    ],
  );
}
```

---

### Phase 3: Template Rendering (Business Custom Fields)

#### 3.1 Business Details Section Strategy

**Placement Options:**

1. **Inline with existing fields** (e.g., after GSTIN, PAN)
2. **Separate "Additional Details" section** below standard fields
3. **Conditional rendering** based on field importance/required flag

#### 3.2 Template Implementation Example

**File:** `lib/templates/mbbook_tally_template.dart`

```dart
@override
bool get supportsBusinessCustomFields => true;

pw.Widget _buildBusinessDetailsSection(BusinessDetails business, String title) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      // Standard fields
      pw.Text(business.businessName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      if (business.gstin.isNotEmpty) pw.Text('GSTIN: ${business.gstin}'),
      if (business.pan.isNotEmpty) pw.Text('PAN: ${business.pan}'),
      pw.Text(business.businessAddress),
      if (business.phone.isNotEmpty) pw.Text('Phone: ${business.phone}'),
      if (business.email.isNotEmpty) pw.Text('Email: ${business.email}'),

      // Custom fields (if any)
      if (business.customFields.isNotEmpty) ...[
        pw.SizedBox(height: 4),
        pw.Container(
          padding: const pw.EdgeInsets.all(4),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Additional Details',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
              pw.SizedBox(height: 2),
              ...business.customFields.map((field) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 1),
                    child: pw.Row(
                      children: [
                        pw.Text(
                          '${field.fieldName}: ',
                          style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          field.displayValue,
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    ],
  );
}
```

---

### Phase 4: Demo Data & Testing

#### 4.1 Create Demo Invoices with Custom Fields

**File:** `lib/data/demo_invoices.dart`

Add new demo invoice methods:

```dart
static InvoiceData getCustomFieldsItemDemo() {
  return InvoiceData(
    invoiceNumber: 'CF-ITEM-001',
    // ... standard fields ...
    lineItems: [
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Custom Widget', hsnCode: '8536'),
        quantity: 10,
        rate: 500.0,
        customFields: [
          CustomFieldValue(
            fieldName: 'Warranty',
            fieldType: 'text',
            value: '2 Years',
            displayOrder: 1,
          ),
          CustomFieldValue(
            fieldName: 'Color',
            fieldType: 'select',
            value: 'Blue',
            displayOrder: 2,
          ),
          CustomFieldValue(
            fieldName: 'Certified',
            fieldType: 'boolean',
            value: true,
            displayOrder: 3,
          ),
        ],
        // ... other fields ...
      ),
    ],
  );
}

static InvoiceData getCustomFieldsBusinessDemo() {
  return InvoiceData(
    invoiceNumber: 'CF-BIZ-001',
    sellerDetails: BusinessDetails(
      businessName: 'Tech Solutions Ltd',
      // ... standard fields ...
      customFields: [
        CustomFieldValue(
          fieldName: 'Vendor Code',
          fieldType: 'text',
          value: 'VEN-2024-001',
          displayOrder: 1,
        ),
        CustomFieldValue(
          fieldName: 'Credit Limit',
          fieldType: 'number',
          value: 100000.0,
          displayOrder: 2,
        ),
        CustomFieldValue(
          fieldName: 'Approved Vendor',
          fieldType: 'boolean',
          value: true,
          displayOrder: 3,
        ),
      ],
    ),
    // ... other fields ...
  );
}

static InvoiceData getCustomFieldsFullDemo() {
  // Demo with BOTH item and business custom fields
  return InvoiceData(/* ... */);
}
```

#### 4.2 Update Demo Metadata

**File:** `lib/models/demo_invoice_metadata.dart`

Add new category:

```dart
enum DemoCategory {
  basic,
  gstTesting,
  documentTypes,
  thermalPos,
  edgeCases,
  notesTesting,
  customFields, // NEW
}
```

#### 4.3 Testing Checklist

- [ ] Item custom fields render correctly in all templates
- [ ] Business custom fields render correctly in all templates
- [ ] Templates without custom field support degrade gracefully (no errors)
- [ ] Field types display correctly (text, number, date, boolean, select, multiselect)
- [ ] Field ordering by `displayOrder` works
- [ ] Party-specific custom fields filter correctly
- [ ] Long custom field values don't break table layouts
- [ ] Multi-page invoices handle custom fields correctly
- [ ] Custom fields work with all invoice modes (sales, proforma, etc.)
- [ ] Empty custom field arrays don't cause rendering issues

---

## Technical Challenges & Solutions

### Challenge 1: Dynamic Table Column Count

**Problem:** PDF tables require fixed column structure, but custom fields are dynamic.

**Solution:**
- Use `maxItemCustomFields` to cap column count
- Templates detect custom fields on first pass
- Build table structure dynamically based on detected fields
- Overflow fields handled via `itemCustomFieldStrategy` (inline/grouped)

### Challenge 2: Party-Specific Custom Fields

**Problem:** Different parties may have different custom fields.

**Solution:**
- Pass `partyRef` context to `BusinessAdapter`
- Filter custom fields by matching `partyRef`
- For invoices, buyer's `partyRef` is used to filter buyer-specific fields
- Seller fields use firm's own custom fields (no party filter)

### Challenge 3: Field Value Type Handling

**Problem:** Different field types stored in different struct properties.

**Solution:**
- Create unified `CustomFieldValue.displayValue` getter
- Type-specific formatting logic centralized in model
- Templates don't need to know about field types
- Use dynamic `value` storage with type-safe extraction

### Challenge 4: Layout Breaking with Many Fields

**Problem:** Too many custom fields can break PDF layout.

**Solution:**
- Implement `maxItemCustomFields` limit per template
- Templates choose appropriate strategy (columns/inline/grouped)
- Font size reduction for compact layouts
- Consider pagination for items with extensive custom fields

### Challenge 5: Backward Compatibility

**Problem:** Existing invoices without custom fields shouldn't break.

**Solution:**
- Default `customFields` to empty list in models
- Conditional rendering: `if (customFields.isNotEmpty)`
- All templates work with or without custom fields
- No breaking changes to existing public API

---

## Breaking Changes & Migration

### API Changes

**ItemSaleInfo:**
```dart
// Before
ItemSaleInfo(
  item: itemBasicInfo,
  quantity: 10,
  rate: 500.0,
);

// After (backward compatible - customFields optional)
ItemSaleInfo(
  item: itemBasicInfo,
  quantity: 10,
  rate: 500.0,
  customFields: [], // Optional, defaults to empty list
);
```

**BusinessDetails:**
```dart
// Before
BusinessDetails(
  businessName: 'ACME Corp',
  gstin: '27XXXXX',
);

// After (backward compatible)
BusinessDetails(
  businessName: 'ACME Corp',
  gstin: '27XXXXX',
  customFields: [], // Optional, defaults to empty list
);
```

### Migration Path for Existing Apps

1. **No immediate action required** - empty `customFields` lists are backward compatible
2. Update to new version, test existing invoices (should work unchanged)
3. Implement custom field fetching in your app (when ready)
4. Start passing custom field data to adapters

---

## Documentation Updates

### Files to Update

1. **lib/adapters/AdapterReadme.md**
   - Add CustomFieldValue mapping documentation
   - Document party-specific field filtering
   - Add examples for custom field extraction

2. **CLAUDE.md**
   - Update "Adapter System" section with custom fields support
   - Add to "Future Enhancement Ideas" → "Completed Enhancements"
   - Document field type support

3. **lib/templates/invoice_template_base.dart** (inline docs)
   - Document new abstract properties
   - Explain custom field strategies

4. **New File: references/README/CustomFields.md**
   - Complete guide to custom fields architecture
   - Field type specifications
   - Template implementation patterns
   - FlutterFlow integration guide

---

## Implementation Timeline

### Week 1: Foundation
- [ ] Day 1-2: Create `CustomFieldValue` model
- [ ] Day 2-3: Update ItemAdapter with custom field extraction
- [ ] Day 3-4: Update BusinessAdapter with custom field extraction
- [ ] Day 4-5: Update InvoiceData and BusinessDetails models
- [ ] Day 5: Write adapter unit tests

### Week 2: Template Rendering
- [ ] Day 1: Update InvoiceTemplate base class
- [ ] Day 2: Implement Tally template custom fields (columns strategy)
- [ ] Day 3: Implement Modern template custom fields (inline strategy)
- [ ] Day 4: Implement Compact/Thermal templates (grouped strategy)
- [ ] Day 5: Update remaining templates (Stylish, Elite, Professional)

### Week 3: Testing & Documentation
- [ ] Day 1-2: Create comprehensive demo invoices
- [ ] Day 2-3: Visual testing across all templates
- [ ] Day 3-4: Write documentation (AdapterReadme, CLAUDE.md, CustomFields.md)
- [ ] Day 4-5: Integration testing with FlutterFlow app
- [ ] Day 5: Performance testing with many custom fields

---

## Testing Strategy

### Unit Tests

```dart
// test/adapters/item_adapter_test.dart
test('ItemAdapter extracts item-level custom fields', () {
  final itemStruct = MockItemSaleInfoStruct(
    customFieldInputs: [
      MockCustomFieldValue(
        isBusiness: false,
        fieldName: 'Warranty',
        fieldType: 'text',
        stringValue: '2 Years',
      ),
      MockCustomFieldValue(
        isBusiness: true, // Should be filtered out
        fieldName: 'Vendor Code',
        fieldType: 'text',
        stringValue: 'VEN-001',
      ),
    ],
  );

  final result = ItemAdapter.fromFlutterFlowStruct(itemStruct);

  expect(result.customFields.length, equals(1));
  expect(result.customFields.first.fieldName, equals('Warranty'));
  expect(result.customFields.first.value, equals('2 Years'));
});

// test/adapters/business_adapter_test.dart
test('BusinessAdapter filters party-specific custom fields', () {
  final partyRef = MockDocumentReference('parties/party123');

  final businessStruct = MockBusinessDetailsStruct(
    customFieldValues: [
      MockCustomFieldValue(
        isBusiness: true,
        fieldName: 'Credit Limit',
        partyRef: partyRef,
        numberValue: 50000.0,
      ),
      MockCustomFieldValue(
        isBusiness: true,
        fieldName: 'General Field',
        partyRef: null, // Global field, not party-specific
        stringValue: 'Value',
      ),
    ],
  );

  final result = BusinessAdapter.fromFlutterFlowStruct(
    businessStruct,
    currentPartyRef: partyRef,
  );

  expect(result.customFields.length, equals(2)); // Both included
});
```

### Integration Tests

```dart
// test/templates/custom_fields_integration_test.dart
testWidgets('Tally template renders item custom fields', (tester) async {
  final invoice = DemoInvoices.getCustomFieldsItemDemo();
  final template = MBBookTallyTemplate();

  final pdf = await template.generatePDF(invoice);

  // Verify PDF contains custom field headers and values
  // (use pdf package inspection or visual regression testing)
});
```

### Visual Regression Tests

- Capture PDF screenshots for each template with custom fields
- Compare against baseline images
- Ensure layouts don't break with varying custom field counts

---

## Performance Considerations

### Optimization Strategies

1. **Limit custom field count** via `maxItemCustomFields`
2. **Cache field metadata** if rendering multiple pages
3. **Lazy evaluation** - only parse custom fields if template supports them
4. **Font size scaling** - reduce font for many columns
5. **Pagination** - break items across pages if needed

### Expected Impact

- **Adapter conversion:** +5-10ms (minimal impact)
- **PDF generation:** +50-100ms for complex custom fields (depends on count)
- **Memory:** Negligible (custom field data is lightweight)

---

## Future Enhancements

### Post-Initial Implementation

1. **Custom field templates** - Allow users to define field layouts
2. **Conditional rendering** - Show/hide fields based on rules
3. **Field grouping** - Group related custom fields visually
4. **Formula fields** - Calculate values from other fields
5. **Rich text support** - Formatted text in custom fields
6. **Image custom fields** - Support image URLs in custom values
7. **QR code fields** - Generate QR codes from field values
8. **Internationalization** - Translate custom field names

---

## Questions & Decisions

### To Resolve Before Implementation

1. **Should custom fields affect column width calculations?**
   - Option A: Fixed width columns (may truncate)
   - Option B: Dynamic width based on content (may affect alignment)
   - **Recommendation:** Fixed width with text wrapping

2. **How to handle very long custom field values?**
   - Option A: Truncate with ellipsis
   - Option B: Wrap to multiple lines
   - Option C: Font size reduction
   - **Recommendation:** Wrap for business fields, truncate for item fields

3. **Should `maxItemCustomFields` be user-configurable?**
   - Currently template-level constant
   - Could be passed as parameter to `generatePDF()`
   - **Recommendation:** Keep template-level for v1, make configurable in v2

4. **How to handle missing custom field values (null)?**
   - Option A: Show "-" or "N/A"
   - Option B: Hide the field entirely
   - Option C: Show empty string
   - **Recommendation:** Show "-" for consistency

5. **Should party-specific fields override general fields?**
   - If both party-specific and general field exist with same name
   - **Recommendation:** Party-specific takes precedence

---

## Related Files

### New Files to Create
- `lib/models/custom_field_value.dart` - Custom field model
- `test/models/custom_field_value_test.dart` - Model tests
- `test/adapters/custom_field_extraction_test.dart` - Adapter tests
- `references/README/CustomFields.md` - Architecture documentation

### Files to Modify
- `lib/adapters/item_adapter.dart` - Add custom field extraction
- `lib/adapters/business_adapter.dart` - Add custom field extraction
- `lib/models/item_sale_info.dart` - Add customFields property
- `lib/models/business_details.dart` - Add customFields property
- `lib/templates/invoice_template_base.dart` - Add custom field support flags
- All template files (7 templates) - Implement rendering logic
- `lib/data/demo_invoices.dart` - Add demo invoices with custom fields
- `lib/adapters/AdapterReadme.md` - Document custom field mappings
- `CLAUDE.md` - Update architecture documentation

---

## Success Criteria

Implementation is complete when:

- [x] CustomFieldValue model created and tested
- [ ] ItemAdapter extracts item-level custom fields correctly
- [ ] BusinessAdapter extracts business-level custom fields with party filtering
- [ ] All 7 templates render item custom fields (with appropriate strategy)
- [ ] All 7 templates render business custom fields
- [ ] Demo invoices showcase all field types (text, number, date, boolean, select, multiselect)
- [ ] Visual testing passes for all templates
- [ ] Documentation updated (AdapterReadme, CLAUDE.md, new CustomFields.md)
- [ ] No breaking changes to existing API
- [ ] Backward compatibility verified (invoices without custom fields work unchanged)
- [ ] Performance impact is acceptable (<100ms added to PDF generation)

---

## Notes & Caveats

1. **DocumentReference Ignored:** The `fieldRef` in custom field structs points to schema definitions (field type, validation rules, etc.). We extract only the **resolved field name and type**, not the reference itself.

2. **Schema Denormalization Required:** Your FlutterFlow app must denormalize custom field schema data into the `customFieldInputs` array. The adapter cannot fetch field schemas from Firestore.

3. **Party-Specific Logic:** Party-specific custom fields require passing the party's DocumentReference for filtering. This is only relevant for buyer business details (seller always uses firm's custom fields).

4. **Template Opt-In:** Templates must explicitly set `supportsItemCustomFields` and `supportsBusinessCustomFields` to `true`. Default is `false` for backward compatibility.

5. **Layout Constraints:** Some templates (e.g., Thermal) have strict width constraints. Use `maxItemCustomFields` conservatively (1-2 fields max).

6. **Field Type Extensibility:** The `CustomFieldValue.displayValue` getter can be extended for new field types without breaking existing templates.

---

**End of TODO Document**

*Last Updated: 2025-10-31*
*Status: Planning Phase - Ready for Implementation*
