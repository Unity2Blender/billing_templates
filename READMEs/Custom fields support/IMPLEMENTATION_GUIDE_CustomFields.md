# Custom Fields Template Implementation Guide

## Status: Phase 1 Complete ✅, Phase 2 In Progress

### Completed (Phase 1):
- ✅ CustomFieldValue model created
- ✅ ItemSaleInfo and BusinessDetails models updated
- ✅ ItemAdapter extracting custom fields
- ✅ BusinessAdapter extracting custom fields
- ✅ InvoiceTemplate base class updated

### Remaining Work (Phase 2):

## Template Updates Pattern

All 7 templates need two types of updates:

### 1. Item Custom Fields (Inline Rendering)

**Location:** In the method that builds item rows/cells in the items table

**Pattern:**
```dart
// BEFORE: Single Text widget for item name
pw.Text(item.item.name, style: boldStyle)

// AFTER: Column with name, description, and custom fields
pw.Column(
  crossAxisAlignment: pw.CrossAxisAlignment.start,
  mainAxisSize: pw.MainAxisSize.min,
  children: [
    // Item name
    pw.Text(
      item.item.name,
      style: pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
      ),
    ),

    // Description (if present)
    if (item.item.description.isNotEmpty)
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 2),
        child: pw.Text(
          item.item.description,
          style: pw.TextStyle(
            fontSize: 8,
            fontStyle: pw.FontStyle.italic,
            color: PdfColors.grey700,
          ),
        ),
      ),

    // Custom fields (if any)
    if (item.customFields.isNotEmpty)
      pw.Padding(
        padding: const pw.EdgeInsets.only(top: 2),
        child: pw.Text(
          '(${item.customFields.map((f) => '${f.fieldName}: ${f.displayValue}').join(', ')})',
          style: pw.TextStyle(
            fontSize: 8,
            color: PdfColors.grey600,
          ),
        ),
      ),
  ],
)
```

**Key Points:**
- Use `pw.Column` with `crossAxisAlignment: pw.CrossAxisAlignment.start`
- Add `mainAxisSize: pw.MainAxisSize.min` to prevent unnecessary expansion
- Maintain vertical stacking order: Name → Description → Custom Fields
- Use smaller font size (8pt) for custom fields
- Use grey color to differentiate from main item name
- Format: `(FieldName: Value, Field2: Value2)`

### 2. Business Custom Fields (Additional Details Section)

**Location:** In the method that builds seller/buyer business details sections

**Pattern:**
```dart
// Add AFTER standard business details (name, GSTIN, address, etc.)
// and BEFORE signature section (if applicable)

if (businessDetails.customFields.isNotEmpty)
  pw.Container(
    margin: const pw.EdgeInsets.only(top: 6),
    padding: const pw.EdgeInsets.all(6),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey400),
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(3)),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Additional Details',
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.SizedBox(height: 3),
        ...businessDetails.customFields.map((field) =>
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(
              '${field.fieldName}: ${field.displayValue}',
              style: pw.TextStyle(
                fontSize: 8,
                color: PdfColors.grey700,
              ),
            ),
          ),
        ),
      ],
    ),
  )
```

**Key Points:**
- Add bordered container to visually separate from standard fields
- Use "Additional Details" header
- Each custom field on its own line
- Apply to BOTH seller and buyer details sections
- Margin from other elements: 6pt

### 3. Enable Support Flags

**Location:** Top of template class, near other property overrides

**Pattern:**
```dart
@override
bool get supportsItemCustomFields => true;

@override
bool get supportsBusinessCustomFields => true;
```

---

## Template-Specific Notes

### Tally Templates (mbbook_tally_template.dart, tally_professional_template.dart)

**Item Table Structure:**
- Typically uses `pw.Table` with many columns
- Item name is usually in a narrow column (flex: 2-3)
- May need to adjust column widths if custom fields cause overflow
- Consider reducing font size to 8pt for item name if needed

**Business Details:**
- Often in bordered boxes/cards
- Left column for seller, right column for buyer
- Add custom fields at bottom of each column

**GST Summary Table:**
- No changes needed - custom fields don't affect HSN summary

### Modern Templates (mbbook_modern_template.dart, mbbook_stylish_template.dart, modern_elite_template.dart)

**Item Table Structure:**
- Clean, spacious layout
- Wider columns for item names (flex: 4-5)
- More room for custom fields
- Maintain minimalist aesthetic

**Business Details:**
- Card/container based layouts
- Often with subtle shadows or borders
- Match existing design style for custom fields container

**Color Theme Support:**
- Use theme colors for custom fields container borders if desired
- Example: `border: pw.Border.all(color: colorTheme.primaryColor.withOpacity(0.3))`

### Compact Templates (a5_compact_template.dart, thermal_theme2_template.dart)

**Item Table Structure:**
- Very limited horizontal space
- May need to use smaller fonts (7-8pt for everything)
- Consider abbreviating field names if too long
- Test with multiple custom fields to ensure no overflow

**Business Details:**
- Minimal spacing
- May omit custom fields container border to save space
- Use simple bullet-point style for custom fields

**Special Considerations:**
- Test extensively with 3+ custom fields
- May need to increase item row height
- Consider ellipsis for very long field values: `overflow: pw.TextOverflow.clip`

---

## Testing Checklist (Per Template)

For each template after updates:

### Visual Tests:
- [ ] Item with 0 custom fields (should render normally)
- [ ] Item with 1 custom field
- [ ] Item with 3 custom fields
- [ ] Item with custom field + description
- [ ] Item with no description but custom fields
- [ ] Long custom field values (50+ chars)
- [ ] Business details with 0 custom fields
- [ ] Business details with 3+ custom fields
- [ ] Both seller and buyer with custom fields

### Layout Tests:
- [ ] No column overflow in items table
- [ ] Item name column accommodates stacked content
- [ ] Business details section doesn't break page flow
- [ ] Multi-page invoices handle custom fields correctly
- [ ] Color themes work (if applicable)

### Edge Cases:
- [ ] Empty fieldName (should show empty string)
- [ ] Null values (should show '-')
- [ ] Special characters in field values
- [ ] Very long field names (20+ chars)
- [ ] Mixed field types in same invoice

---

## Common Issues and Solutions

### Issue: Item name column too narrow
**Solution:** Increase flex value for item name column from 2 to 3 or 4

### Issue: Custom fields text wraps awkwardly
**Solution:** Use `softWrap: true` and `maxLines: 2` in pw.Text widget

### Issue: Table row height too small
**Solution:** Add explicit height to TableRow or use flexible column

### Issue: Custom fields overlap with next column
**Solution:** Add right padding to item name column or reduce font size

### Issue: Business details container looks cluttered
**Solution:** Increase padding to 8pt, use lighter border color

### Issue: Color theme not applied to custom fields
**Solution:** Pass colorTheme parameter through and use theme colors in styles

---

## Implementation Order (Recommended)

1. **mbbook_tally_template.dart** - Most complex, establishes pattern
2. **tally_professional_template.dart** - Similar to Tally, quick adaptation
3. **mbbook_modern_template.dart** - Different structure, second major pattern
4. **mbbook_stylish_template.dart** - Similar to Modern
5. **modern_elite_template.dart** - Similar to Modern
6. **a5_compact_template.dart** - Space-constrained, special handling
7. **thermal_theme2_template.dart** - Most constrained, careful testing

---

## Code Search Patterns

To find where to make changes in each template:

### Find item rendering:
```bash
# Search for item name rendering
grep -n "item.item.name" lib/templates/[template_name].dart

# Search for TableRow with item data
grep -n "TableRow" lib/templates/[template_name].dart -A 5
```

### Find business details rendering:
```bash
# Search for business name
grep -n "businessDetails.businessName" lib/templates/[template_name].dart

# Search for GSTIN rendering
grep -n "gstin" lib/templates/[template_name].dart -i
```

---

## Next Steps

1. Apply the pattern to **mbbook_tally_template.dart** (highest priority)
2. Test with demo invoice containing custom fields
3. Once validated, apply to remaining templates
4. Create 12 demo invoices (Phase 3)
5. Comprehensive visual testing
6. Update documentation

---

## Questions or Issues?

If you encounter any issues:
1. Check this guide for the specific template type
2. Review the pattern example above
3. Test with simple demo data first
4. Verify support flags are set to true
5. Check console for any errors during PDF generation

Good luck with the implementation! The foundation is solid, and the pattern is straightforward. 🚀
