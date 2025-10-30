# Null Safety and Undefined Handling Guidelines

## Project Motto

**"Prevent undefined from reaching Firestore, handle null at the boundary"**

## Project Intent

This project is committed to implementing comprehensive null safety across all types, functions, and Firestore operations. Our goal is to:

1. **Eliminate runtime errors** caused by undefined values and null pointer exceptions
2. **Ensure data integrity** by preventing undefined values from being written to Firestore
3. **Provide clear contracts** through TypeScript types that explicitly mark nullable fields
4. **Handle edge cases gracefully** with proper null/undefined checks at data boundaries
5. **Maintain consistency** by following standardized patterns throughout the codebase

## Core Principles

### 1. Type System Foundation

**Use explicit optional markers for nullable fields:**

```typescript
// ✅ GOOD: Clear type contract
export interface ReportsRecord {
  userId: string;           // Required, never null
  state?: string;           // Optional, may be undefined
  district?: string;        // Optional, may be undefined
  createdAt: Timestamp;     // Required, never null
}

// ❌ BAD: Ambiguous types
export interface ReportsRecord {
  userId: string;
  state: string;            // Looks required but might be missing
  district: string | undefined; // Verbose, use ? instead
}
```

### 2. Boundary Safety

**Check for null/undefined at data entry points:**

```typescript
// ✅ GOOD: Validate at boundary
export function extractInvoiceData(
  snapshot: FirebaseFirestore.DocumentSnapshot
): InvoiceStruct | null {
  // Check 1: Document exists
  if (!snapshot.exists) {
    return null;
  }

  // Check 2: Document has data
  const data = snapshot.data();
  if (!data) {
    return null;
  }

  // Check 3: Required field exists
  const invoiceRecord = data as {invoiceConfig?: InvoiceStruct};
  if (!invoiceRecord.invoiceConfig) {
    return null;
  }

  return invoiceRecord.invoiceConfig;
}

// ❌ BAD: No boundary checks
export function extractInvoiceData(snapshot: any) {
  return snapshot.data().invoiceConfig; // Multiple failure points
}
```

### 3. Firestore Write Safety

**Filter undefined values before writing to Firestore:**

```typescript
// ✅ GOOD: Filter undefined values
const dataToSet: Record<string, unknown> = {
  userId: userId,
  billingRef: billingRef,
  createdAt: FieldValue.serverTimestamp(),
};

// Only add optional fields if they have defined values
if (geoInfo?.state !== undefined) {
  dataToSet.state = geoInfo.state;
}
if (geoInfo?.district !== undefined) {
  dataToSet.district = geoInfo.district;
}
if (geoInfo?.districtId !== undefined) {
  dataToSet.districtId = geoInfo.districtId;
}

await reportsRef.set(dataToSet);

// ❌ BAD: Writing undefined to Firestore
await reportsRef.set({
  userId: userId,
  state: geoInfo.state,        // ERROR if undefined
  district: geoInfo.district,  // ERROR if undefined
});
```

### 4. Safe Property Access

**Use optional chaining for nested properties:**

```typescript
// ✅ GOOD: Safe chaining
const state = invoiceData?.invoiceConfig?.billToParty?.state || undefined;
const totalAmount = invoiceData?.invoiceConfig?.billSummary?.totalPayableAmount || 0;

// ✅ GOOD: Explicit checks
if (invoiceData && invoiceData.invoiceConfig && invoiceData.invoiceConfig.billToParty) {
  const state = invoiceData.invoiceConfig.billToParty.state;
  // Use state safely here
}

// ❌ BAD: Unsafe access
const state = invoiceData.invoiceConfig.billToParty.state; // Throws if any is null
```

### 5. Return Type Clarity

**Use explicit null/undefined in return types:**

```typescript
// ✅ GOOD: Clear return contract
export function createDistrictId(
  state?: string,
  district?: string
): DistrictIdentifier | undefined {
  if (!state) return undefined;
  if (!district) return state;
  return `${state}-${district}`;
}

// ✅ GOOD: Null for missing data
export function extractInvoiceData(
  snapshot: DocumentSnapshot
): InvoiceStruct | null {
  if (!snapshot.exists) return null;
  // ...
}

// ❌ BAD: Unclear what's returned when data is missing
export function createDistrictId(state: string, district: string): string {
  return `${state}-${district}`; // Breaks if inputs are undefined
}
```

## Implementation Patterns

### Pattern 1: Data Extraction from Firestore

**Template for safely extracting data:**

```typescript
export function extractDataFromSnapshot<T>(
  snapshot: FirebaseFirestore.DocumentSnapshot,
  fieldPath: string
): T | null {
  // Step 1: Check document exists
  if (!snapshot.exists) {
    logger.warn(`Document does not exist: ${snapshot.ref.path}`);
    return null;
  }

  // Step 2: Check document has data
  const data = snapshot.data();
  if (!data) {
    logger.warn(`Document has no data: ${snapshot.ref.path}`);
    return null;
  }

  // Step 3: Extract field safely
  const value = data[fieldPath];
  if (value === undefined || value === null) {
    logger.warn(`Field ${fieldPath} is missing in ${snapshot.ref.path}`);
    return null;
  }

  return value as T;
}
```

**Real-world example from deltaHelpers.ts:**

```typescript
export function extractInvoiceData(
  snapshot: FirebaseFirestore.DocumentSnapshot
): InvoiceStruct | null {
  if (!snapshot.exists) {
    return null;
  }
  const data = snapshot.data();
  if (!data) {
    return null;
  }
  // InvoicesRecord has invoiceConfig field that contains InvoiceStruct
  const invoiceRecord = data as {invoiceConfig?: InvoiceStruct};
  return invoiceRecord.invoiceConfig || null;
}
```

### Pattern 2: Building Objects for Firestore

**Template for safely building Firestore data:**

```typescript
export async function createDocumentWithOptionalFields(
  requiredData: RequiredFields,
  optionalData: OptionalFields
): Promise<void> {
  // Step 1: Start with required fields only
  const dataToWrite: Record<string, unknown> = {
    ...requiredData,
    createdAt: FieldValue.serverTimestamp(),
  };

  // Step 2: Add optional fields only if defined
  if (optionalData.field1 !== undefined) {
    dataToWrite.field1 = optionalData.field1;
  }
  if (optionalData.field2 !== undefined) {
    dataToWrite.field2 = optionalData.field2;
  }

  // Step 3: Write to Firestore
  await docRef.set(dataToWrite);
}
```

**Real-world example from aggregationHelpers.ts:**

```typescript
export async function getOrCreateReportsDoc(
  userId: string,
  billingRef: admin.firestore.DocumentReference,
  geoInfo?: { state?: string; district?: string; districtId?: DistrictIdentifier }
): Promise<admin.firestore.DocumentReference> {
  const reportsRef = db.collection("reports").doc(userId);
  const reportsDoc = await reportsRef.get();

  if (!reportsDoc.exists) {
    // Filter out undefined values from geoInfo to prevent Firestore errors
    const dataToSet: any = {
      billingRef,
      userId,
      createdAt: FieldValue.serverTimestamp(),
      lastUpdatedAt: FieldValue.serverTimestamp(),
    };

    // Only add geographic fields if they have defined values
    if (geoInfo) {
      if (geoInfo.state !== undefined) dataToSet.state = geoInfo.state;
      if (geoInfo.district !== undefined) dataToSet.district = geoInfo.district;
      if (geoInfo.districtId !== undefined) dataToSet.districtId = geoInfo.districtId;
    }

    await reportsRef.set(dataToSet);
  }

  return reportsRef;
}
```

### Pattern 3: Handling Optional Nested Data

**Template for extracting optional nested properties:**

```typescript
export function extractNestedOptionalData(
  data: ParentType
): ExtractedType {
  // Use optional chaining and provide defaults
  const nestedValue = data?.nested?.property || undefined;
  const nestedNumber = data?.nested?.count || 0;
  const nestedString = data?.nested?.name || "";

  // For objects, check existence first
  const nestedObject = data?.nested?.object
    ? { ...data.nested.object }
    : undefined;

  return {
    nestedValue,
    nestedNumber,
    nestedString,
    nestedObject,
  };
}
```

**Real-world example from aggregationHelpers.ts:**

```typescript
function extractGeographicInfo(
  invoiceData: InvoicesRecord,
  invoiceType: InvoiceType
): { state?: string; district?: string; districtId?: DistrictIdentifier } {
  // For both sales and purchases, we use billToParty
  const billToParty = invoiceData.invoiceConfig.billToParty;

  if (!billToParty) {
    return {};
  }

  const state = billToParty.state || undefined;
  const district = billToParty.district || undefined;
  const districtId = createDistrictId(state, district);

  return { state, district, districtId };
}
```

### Pattern 4: Null-Safe Metadata Building

**Template for building metadata objects:**

```typescript
export function buildMetadataObject(
  source: SourceData
): MetadataObject {
  // Start with empty object
  const metadata: Record<string, unknown> = {};

  // Add fields only if they exist
  const field1 = source.field1;
  if (field1 !== undefined) {
    metadata.field1 = field1;
  }

  const field2 = source.nested?.field2;
  if (field2 !== undefined) {
    metadata.field2 = field2;
  }

  // Calculated fields with null checks
  const total = source.items?.reduce((sum, item) => sum + item.amount, 0);
  if (total !== undefined && total > 0) {
    metadata.total = total;
  }

  return metadata;
}
```

**Real-world example from deltaHelpers.ts:**

```typescript
export function createInvoiceDelta(
  operationType: "create" | "update" | "delete",
  invoiceId: string,
  billingId: string,
  oldData: InvoiceStruct | null,
  newData: InvoiceStruct | null,
  userId?: string
): InvoiceDelta {
  const changes = calculateFieldChanges(
    oldData as Record<string, unknown> | null,
    newData as Record<string, unknown> | null
  );

  // Build metadata object, excluding undefined values
  const metadata: Record<string, unknown> = {};

  const invoiceNumber = newData?.modeSpecifcDetails?.invoiceNumber ||
    oldData?.modeSpecifcDetails?.invoiceNumber;
  if (invoiceNumber !== undefined) {
    metadata.invoiceNumber = invoiceNumber;
  }

  const billMode = newData?.modeSpecifcDetails?.billMode ||
    oldData?.modeSpecifcDetails?.billMode;
  if (billMode !== undefined) {
    metadata.billMode = billMode;
  }

  const oldAmount = oldData?.billSummary?.totalPayableAmount || 0;
  const newAmount = newData?.billSummary?.totalPayableAmount || 0;

  if (newAmount) {
    metadata.totalAmount = newAmount;
  }

  if (oldAmount) {
    metadata.previousTotalAmount = oldAmount;
  }

  if (operationType === "update" && amountDifference !== 0) {
    metadata.amountDifference = amountDifference;
  }

  return {
    operationType,
    timestamp: Timestamp.now(),
    invoiceId,
    billingId,
    userId,
    changes,
    metadata,
  };
}
```

## Common Pitfalls and Solutions

### Pitfall 1: Assuming Data Exists

```typescript
// ❌ BAD: Assumes billSummary exists
function getTotalAmount(invoice: InvoiceStruct): number {
  return invoice.billSummary.totalPayableAmount; // Throws if billSummary is null
}

// ✅ GOOD: Checks existence and provides default
function getTotalAmount(invoice: InvoiceStruct): number {
  return invoice.billSummary?.totalPayableAmount || 0;
}
```

### Pitfall 2: Writing Undefined to Firestore

```typescript
// ❌ BAD: Can write undefined
await docRef.update({
  state: party.state,  // ERROR if undefined
});

// ✅ GOOD: Only write if defined
const updates: Record<string, unknown> = {};
if (party.state !== undefined) {
  updates.state = party.state;
}
if (Object.keys(updates).length > 0) {
  await docRef.update(updates);
}
```

### Pitfall 3: Using || with Falsy Values

```typescript
// ❌ BAD: 0 becomes undefined
const count = invoice.itemCount || undefined; // 0 is falsy!

// ✅ GOOD: Use nullish coalescing
const count = invoice.itemCount ?? undefined;

// Or explicit check
const count = invoice.itemCount !== undefined ? invoice.itemCount : undefined;
```

### Pitfall 4: Not Handling FieldValue

```typescript
// ❌ BAD: Doesn't handle FieldValue
const createdAt = invoice.created_at as Timestamp;
// ERROR: created_at might be FieldValue.serverTimestamp()

// ✅ GOOD: Check type before using
const createdAt = invoice.created_at;
if (createdAt instanceof Timestamp) {
  const date = createdAt.toDate();
  // Use date safely
} else {
  logger.warn("created_at is not a Timestamp, likely a FieldValue");
  return null;
}
```

## Testing for Null Safety

### Unit Test Template

```typescript
describe("extractData", () => {
  it("should return null for non-existent snapshot", () => {
    const snapshot = {
      exists: false,
      data: () => undefined,
    } as any;

    const result = extractData(snapshot);
    expect(result).toBeNull();
  });

  it("should return null for snapshot with no data", () => {
    const snapshot = {
      exists: true,
      data: () => undefined,
    } as any;

    const result = extractData(snapshot);
    expect(result).toBeNull();
  });

  it("should return null for missing required field", () => {
    const snapshot = {
      exists: true,
      data: () => ({ otherField: "value" }),
    } as any;

    const result = extractData(snapshot);
    expect(result).toBeNull();
  });

  it("should extract data when valid", () => {
    const snapshot = {
      exists: true,
      data: () => ({ requiredField: { config: "data" } }),
    } as any;

    const result = extractData(snapshot);
    expect(result).toEqual({ config: "data" });
  });
});
```

## Checklist for New Code

When writing new functions or types:

- [ ] Mark all optional fields with `?` in type definitions
- [ ] Check for null/undefined at function entry points
- [ ] Use optional chaining (`?.`) for nested property access
- [ ] Filter undefined values before Firestore writes
- [ ] Use explicit null checks instead of truthy/falsy
- [ ] Return `null` for missing data (not `undefined`)
- [ ] Provide sensible defaults with nullish coalescing (`??`)
- [ ] Log warnings for unexpected null/undefined values
- [ ] Write tests for null/undefined edge cases
- [ ] Document null safety assumptions in JSDoc comments

## Migration Strategy

For existing code that doesn't follow these patterns:

1. **Audit**: Identify functions that access nested properties without checks
2. **Prioritize**: Fix Firestore write operations first (they cause immediate errors)
3. **Refactor**: Apply patterns from this guide systematically
4. **Test**: Add unit tests for null/undefined cases
5. **Document**: Update function JSDoc with null safety notes

## References

- **TypeScript Optional Chaining**: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-7.html#optional-chaining
- **TypeScript Nullish Coalescing**: https://www.typescriptlang.org/docs/handbook/release-notes/typescript-3-7.html#nullish-coalescing
- **Firestore Data Types**: https://firebase.google.com/docs/firestore/manage-data/data-types

## Examples in Codebase

### Implemented Patterns

1. **deltaHelpers.ts:32-61** - Null handling in `calculateFieldChanges`
2. **deltaHelpers.ts:150-173** - Metadata building without undefined
3. **deltaHelpers.ts:305-318** - Safe data extraction from snapshots
4. **aggregationHelpers.ts:58-75** - Geographic info extraction with optional chaining
5. **aggregationHelpers.ts:177-190** - Filtering undefined before Firestore write
6. **aggregationHelpers.ts:241-249** - Conditional field addition in transactions
7. **types.ts:395-399** - Utility function with optional return

---

**Last Updated**: 2024-10-17
**Version**: 1.0.0
**Status**: Active - All new code must follow these guidelines
