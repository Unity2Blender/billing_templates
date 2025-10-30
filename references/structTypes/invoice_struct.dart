// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// The Invoice must be copyable as well as Duplicatable by the user (Quick
/// duplicate invoices usually would first need party change).
///
/// Duplicate invoice -> Clear Shipment & Dates details
class InvoiceStruct extends FFFirebaseStruct {
  InvoiceStruct({
    DocumentReference? invoiceRef,
    BillModeConfigStruct? modeSpecifcDetails,
    DocumentReference? sellerFirm,

    /// Vendor or Customer party
    BusinessDetailsStruct? billToParty,
    List<ItemSaleInfoStruct>? lines,
    BillSummaryResultsStruct? billSummary,

    /// amount remaining = `totalPayableAmount` - `amountPaid`
    double? amountPaid,
    PaymentMode? paymentMode,
    ShipmentDetailsStruct? shipmentInfo,

    /// @left of the Footer Make Bill (CTA @right)
    String? notesFooter,
    DocumentReference? referenceInvoiceRef,
    DateTime? lastUpdatedAt,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _invoiceRef = invoiceRef,
        _modeSpecifcDetails = modeSpecifcDetails,
        _sellerFirm = sellerFirm,
        _billToParty = billToParty,
        _lines = lines,
        _billSummary = billSummary,
        _amountPaid = amountPaid,
        _paymentMode = paymentMode,
        _shipmentInfo = shipmentInfo,
        _notesFooter = notesFooter,
        _referenceInvoiceRef = referenceInvoiceRef,
        _lastUpdatedAt = lastUpdatedAt,
        super(firestoreUtilData);

  // "invoiceRef" field.
  DocumentReference? _invoiceRef;
  DocumentReference? get invoiceRef => _invoiceRef;
  set invoiceRef(DocumentReference? val) => _invoiceRef = val;

  bool hasInvoiceRef() => _invoiceRef != null;

  // "modeSpecifcDetails" field.
  BillModeConfigStruct? _modeSpecifcDetails;
  BillModeConfigStruct get modeSpecifcDetails =>
      _modeSpecifcDetails ?? BillModeConfigStruct();
  set modeSpecifcDetails(BillModeConfigStruct? val) =>
      _modeSpecifcDetails = val;

  void updateModeSpecifcDetails(Function(BillModeConfigStruct) updateFn) {
    updateFn(_modeSpecifcDetails ??= BillModeConfigStruct());
  }

  bool hasModeSpecifcDetails() => _modeSpecifcDetails != null;

  // "sellerFirm" field.
  DocumentReference? _sellerFirm;
  DocumentReference? get sellerFirm => _sellerFirm;
  set sellerFirm(DocumentReference? val) => _sellerFirm = val;

  bool hasSellerFirm() => _sellerFirm != null;

  // "billToParty" field.
  BusinessDetailsStruct? _billToParty;
  BusinessDetailsStruct get billToParty =>
      _billToParty ?? BusinessDetailsStruct();
  set billToParty(BusinessDetailsStruct? val) => _billToParty = val;

  void updateBillToParty(Function(BusinessDetailsStruct) updateFn) {
    updateFn(_billToParty ??= BusinessDetailsStruct());
  }

  bool hasBillToParty() => _billToParty != null;

  // "lines" field.
  List<ItemSaleInfoStruct>? _lines;
  List<ItemSaleInfoStruct> get lines => _lines ?? const [];
  set lines(List<ItemSaleInfoStruct>? val) => _lines = val;

  void updateLines(Function(List<ItemSaleInfoStruct>) updateFn) {
    updateFn(_lines ??= []);
  }

  bool hasLines() => _lines != null;

  // "billSummary" field.
  BillSummaryResultsStruct? _billSummary;
  BillSummaryResultsStruct get billSummary =>
      _billSummary ?? BillSummaryResultsStruct();
  set billSummary(BillSummaryResultsStruct? val) => _billSummary = val;

  void updateBillSummary(Function(BillSummaryResultsStruct) updateFn) {
    updateFn(_billSummary ??= BillSummaryResultsStruct());
  }

  bool hasBillSummary() => _billSummary != null;

  // "amountPaid" field.
  double? _amountPaid;
  double get amountPaid => _amountPaid ?? 0.0;
  set amountPaid(double? val) => _amountPaid = val;

  void incrementAmountPaid(double amount) => amountPaid = amountPaid + amount;

  bool hasAmountPaid() => _amountPaid != null;

  // "paymentMode" field.
  PaymentMode? _paymentMode;
  PaymentMode get paymentMode => _paymentMode ?? PaymentMode.CASH;
  set paymentMode(PaymentMode? val) => _paymentMode = val;

  bool hasPaymentMode() => _paymentMode != null;

  // "shipmentInfo" field.
  ShipmentDetailsStruct? _shipmentInfo;
  ShipmentDetailsStruct get shipmentInfo =>
      _shipmentInfo ?? ShipmentDetailsStruct();
  set shipmentInfo(ShipmentDetailsStruct? val) => _shipmentInfo = val;

  void updateShipmentInfo(Function(ShipmentDetailsStruct) updateFn) {
    updateFn(_shipmentInfo ??= ShipmentDetailsStruct());
  }

  bool hasShipmentInfo() => _shipmentInfo != null;

  // "notesFooter" field.
  String? _notesFooter;
  String get notesFooter => _notesFooter ?? '';
  set notesFooter(String? val) => _notesFooter = val;

  bool hasNotesFooter() => _notesFooter != null;

  // "referenceInvoiceRef" field.
  DocumentReference? _referenceInvoiceRef;
  DocumentReference? get referenceInvoiceRef => _referenceInvoiceRef;
  set referenceInvoiceRef(DocumentReference? val) => _referenceInvoiceRef = val;

  bool hasReferenceInvoiceRef() => _referenceInvoiceRef != null;

  // "lastUpdatedAt" field.
  DateTime? _lastUpdatedAt;
  DateTime? get lastUpdatedAt => _lastUpdatedAt;
  set lastUpdatedAt(DateTime? val) => _lastUpdatedAt = val;

  bool hasLastUpdatedAt() => _lastUpdatedAt != null;

  static InvoiceStruct fromMap(Map<String, dynamic> data) => InvoiceStruct(
        invoiceRef: data['invoiceRef'] as DocumentReference?,
        modeSpecifcDetails: data['modeSpecifcDetails'] is BillModeConfigStruct
            ? data['modeSpecifcDetails']
            : BillModeConfigStruct.maybeFromMap(data['modeSpecifcDetails']),
        sellerFirm: data['sellerFirm'] as DocumentReference?,
        billToParty: data['billToParty'] is BusinessDetailsStruct
            ? data['billToParty']
            : BusinessDetailsStruct.maybeFromMap(data['billToParty']),
        lines: getStructList(
          data['lines'],
          ItemSaleInfoStruct.fromMap,
        ),
        billSummary: data['billSummary'] is BillSummaryResultsStruct
            ? data['billSummary']
            : BillSummaryResultsStruct.maybeFromMap(data['billSummary']),
        amountPaid: castToType<double>(data['amountPaid']),
        paymentMode: data['paymentMode'] is PaymentMode
            ? data['paymentMode']
            : deserializeEnum<PaymentMode>(data['paymentMode']),
        shipmentInfo: data['shipmentInfo'] is ShipmentDetailsStruct
            ? data['shipmentInfo']
            : ShipmentDetailsStruct.maybeFromMap(data['shipmentInfo']),
        notesFooter: data['notesFooter'] as String?,
        referenceInvoiceRef: data['referenceInvoiceRef'] as DocumentReference?,
        lastUpdatedAt: data['lastUpdatedAt'] as DateTime?,
      );

  static InvoiceStruct? maybeFromMap(dynamic data) =>
      data is Map ? InvoiceStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'invoiceRef': _invoiceRef,
        'modeSpecifcDetails': _modeSpecifcDetails?.toMap(),
        'sellerFirm': _sellerFirm,
        'billToParty': _billToParty?.toMap(),
        'lines': _lines?.map((e) => e.toMap()).toList(),
        'billSummary': _billSummary?.toMap(),
        'amountPaid': _amountPaid,
        'paymentMode': _paymentMode?.serialize(),
        'shipmentInfo': _shipmentInfo?.toMap(),
        'notesFooter': _notesFooter,
        'referenceInvoiceRef': _referenceInvoiceRef,
        'lastUpdatedAt': _lastUpdatedAt,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'invoiceRef': serializeParam(
          _invoiceRef,
          ParamType.DocumentReference,
        ),
        'modeSpecifcDetails': serializeParam(
          _modeSpecifcDetails,
          ParamType.DataStruct,
        ),
        'sellerFirm': serializeParam(
          _sellerFirm,
          ParamType.DocumentReference,
        ),
        'billToParty': serializeParam(
          _billToParty,
          ParamType.DataStruct,
        ),
        'lines': serializeParam(
          _lines,
          ParamType.DataStruct,
          isList: true,
        ),
        'billSummary': serializeParam(
          _billSummary,
          ParamType.DataStruct,
        ),
        'amountPaid': serializeParam(
          _amountPaid,
          ParamType.double,
        ),
        'paymentMode': serializeParam(
          _paymentMode,
          ParamType.Enum,
        ),
        'shipmentInfo': serializeParam(
          _shipmentInfo,
          ParamType.DataStruct,
        ),
        'notesFooter': serializeParam(
          _notesFooter,
          ParamType.String,
        ),
        'referenceInvoiceRef': serializeParam(
          _referenceInvoiceRef,
          ParamType.DocumentReference,
        ),
        'lastUpdatedAt': serializeParam(
          _lastUpdatedAt,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static InvoiceStruct fromSerializableMap(Map<String, dynamic> data) =>
      InvoiceStruct(
        invoiceRef: deserializeParam(
          data['invoiceRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'invoices'],
        ),
        modeSpecifcDetails: deserializeStructParam(
          data['modeSpecifcDetails'],
          ParamType.DataStruct,
          false,
          structBuilder: BillModeConfigStruct.fromSerializableMap,
        ),
        sellerFirm: deserializeParam(
          data['sellerFirm'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'firms'],
        ),
        billToParty: deserializeStructParam(
          data['billToParty'],
          ParamType.DataStruct,
          false,
          structBuilder: BusinessDetailsStruct.fromSerializableMap,
        ),
        lines: deserializeStructParam<ItemSaleInfoStruct>(
          data['lines'],
          ParamType.DataStruct,
          true,
          structBuilder: ItemSaleInfoStruct.fromSerializableMap,
        ),
        billSummary: deserializeStructParam(
          data['billSummary'],
          ParamType.DataStruct,
          false,
          structBuilder: BillSummaryResultsStruct.fromSerializableMap,
        ),
        amountPaid: deserializeParam(
          data['amountPaid'],
          ParamType.double,
          false,
        ),
        paymentMode: deserializeParam<PaymentMode>(
          data['paymentMode'],
          ParamType.Enum,
          false,
        ),
        shipmentInfo: deserializeStructParam(
          data['shipmentInfo'],
          ParamType.DataStruct,
          false,
          structBuilder: ShipmentDetailsStruct.fromSerializableMap,
        ),
        notesFooter: deserializeParam(
          data['notesFooter'],
          ParamType.String,
          false,
        ),
        referenceInvoiceRef: deserializeParam(
          data['referenceInvoiceRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'invoices'],
        ),
        lastUpdatedAt: deserializeParam(
          data['lastUpdatedAt'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'InvoiceStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is InvoiceStruct &&
        invoiceRef == other.invoiceRef &&
        modeSpecifcDetails == other.modeSpecifcDetails &&
        sellerFirm == other.sellerFirm &&
        billToParty == other.billToParty &&
        listEquality.equals(lines, other.lines) &&
        billSummary == other.billSummary &&
        amountPaid == other.amountPaid &&
        paymentMode == other.paymentMode &&
        shipmentInfo == other.shipmentInfo &&
        notesFooter == other.notesFooter &&
        referenceInvoiceRef == other.referenceInvoiceRef &&
        lastUpdatedAt == other.lastUpdatedAt;
  }

  @override
  int get hashCode => const ListEquality().hash([
        invoiceRef,
        modeSpecifcDetails,
        sellerFirm,
        billToParty,
        lines,
        billSummary,
        amountPaid,
        paymentMode,
        shipmentInfo,
        notesFooter,
        referenceInvoiceRef,
        lastUpdatedAt
      ]);
}

InvoiceStruct createInvoiceStruct({
  DocumentReference? invoiceRef,
  BillModeConfigStruct? modeSpecifcDetails,
  DocumentReference? sellerFirm,
  BusinessDetailsStruct? billToParty,
  BillSummaryResultsStruct? billSummary,
  double? amountPaid,
  PaymentMode? paymentMode,
  ShipmentDetailsStruct? shipmentInfo,
  String? notesFooter,
  DocumentReference? referenceInvoiceRef,
  DateTime? lastUpdatedAt,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    InvoiceStruct(
      invoiceRef: invoiceRef,
      modeSpecifcDetails: modeSpecifcDetails ??
          (clearUnsetFields ? BillModeConfigStruct() : null),
      sellerFirm: sellerFirm,
      billToParty:
          billToParty ?? (clearUnsetFields ? BusinessDetailsStruct() : null),
      billSummary:
          billSummary ?? (clearUnsetFields ? BillSummaryResultsStruct() : null),
      amountPaid: amountPaid,
      paymentMode: paymentMode,
      shipmentInfo:
          shipmentInfo ?? (clearUnsetFields ? ShipmentDetailsStruct() : null),
      notesFooter: notesFooter,
      referenceInvoiceRef: referenceInvoiceRef,
      lastUpdatedAt: lastUpdatedAt,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

InvoiceStruct? updateInvoiceStruct(
  InvoiceStruct? invoice, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    invoice
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addInvoiceStructData(
  Map<String, dynamic> firestoreData,
  InvoiceStruct? invoice,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (invoice == null) {
    return;
  }
  if (invoice.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && invoice.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final invoiceData = getInvoiceFirestoreData(invoice, forFieldValue);
  final nestedData = invoiceData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = invoice.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getInvoiceFirestoreData(
  InvoiceStruct? invoice, [
  bool forFieldValue = false,
]) {
  if (invoice == null) {
    return {};
  }
  final firestoreData = mapToFirestore(invoice.toMap());

  // Handle nested data for "modeSpecifcDetails" field.
  addBillModeConfigStructData(
    firestoreData,
    invoice.hasModeSpecifcDetails() ? invoice.modeSpecifcDetails : null,
    'modeSpecifcDetails',
    forFieldValue,
  );

  // Handle nested data for "billToParty" field.
  addBusinessDetailsStructData(
    firestoreData,
    invoice.hasBillToParty() ? invoice.billToParty : null,
    'billToParty',
    forFieldValue,
  );

  // Handle nested data for "billSummary" field.
  addBillSummaryResultsStructData(
    firestoreData,
    invoice.hasBillSummary() ? invoice.billSummary : null,
    'billSummary',
    forFieldValue,
  );

  // Handle nested data for "shipmentInfo" field.
  addShipmentDetailsStructData(
    firestoreData,
    invoice.hasShipmentInfo() ? invoice.shipmentInfo : null,
    'shipmentInfo',
    forFieldValue,
  );

  // Add any Firestore field values
  invoice.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getInvoiceListFirestoreData(
  List<InvoiceStruct>? invoices,
) =>
    invoices?.map((e) => getInvoiceFirestoreData(e, true)).toList() ?? [];
