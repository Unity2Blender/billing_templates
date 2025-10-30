// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BillSummaryResultsStruct extends FFFirebaseStruct {
  BillSummaryResultsStruct({
    double? totalTaxableValue,
    double? totalDiscount,
    double? totalGst,
    double? totalCess,
    double? totalLineItemsAfterTaxes,

    /// amount remaining = `totalPayableAmount` - `amountPaid`
    double? dueBalancePayable,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _totalTaxableValue = totalTaxableValue,
        _totalDiscount = totalDiscount,
        _totalGst = totalGst,
        _totalCess = totalCess,
        _totalLineItemsAfterTaxes = totalLineItemsAfterTaxes,
        _dueBalancePayable = dueBalancePayable,
        super(firestoreUtilData);

  // "totalTaxableValue" field.
  double? _totalTaxableValue;
  double get totalTaxableValue => _totalTaxableValue ?? 0.0;
  set totalTaxableValue(double? val) => _totalTaxableValue = val;

  void incrementTotalTaxableValue(double amount) =>
      totalTaxableValue = totalTaxableValue + amount;

  bool hasTotalTaxableValue() => _totalTaxableValue != null;

  // "totalDiscount" field.
  double? _totalDiscount;
  double get totalDiscount => _totalDiscount ?? 0.0;
  set totalDiscount(double? val) => _totalDiscount = val;

  void incrementTotalDiscount(double amount) =>
      totalDiscount = totalDiscount + amount;

  bool hasTotalDiscount() => _totalDiscount != null;

  // "totalGst" field.
  double? _totalGst;
  double get totalGst => _totalGst ?? 0.0;
  set totalGst(double? val) => _totalGst = val;

  void incrementTotalGst(double amount) => totalGst = totalGst + amount;

  bool hasTotalGst() => _totalGst != null;

  // "totalCess" field.
  double? _totalCess;
  double get totalCess => _totalCess ?? 0.0;
  set totalCess(double? val) => _totalCess = val;

  void incrementTotalCess(double amount) => totalCess = totalCess + amount;

  bool hasTotalCess() => _totalCess != null;

  // "totalLineItemsAfterTaxes" field.
  double? _totalLineItemsAfterTaxes;
  double get totalLineItemsAfterTaxes => _totalLineItemsAfterTaxes ?? 0.0;
  set totalLineItemsAfterTaxes(double? val) => _totalLineItemsAfterTaxes = val;

  void incrementTotalLineItemsAfterTaxes(double amount) =>
      totalLineItemsAfterTaxes = totalLineItemsAfterTaxes + amount;

  bool hasTotalLineItemsAfterTaxes() => _totalLineItemsAfterTaxes != null;

  // "dueBalancePayable" field.
  double? _dueBalancePayable;
  double get dueBalancePayable => _dueBalancePayable ?? 0.0;
  set dueBalancePayable(double? val) => _dueBalancePayable = val;

  void incrementDueBalancePayable(double amount) =>
      dueBalancePayable = dueBalancePayable + amount;

  bool hasDueBalancePayable() => _dueBalancePayable != null;

  static BillSummaryResultsStruct fromMap(Map<String, dynamic> data) =>
      BillSummaryResultsStruct(
        totalTaxableValue: castToType<double>(data['totalTaxableValue']),
        totalDiscount: castToType<double>(data['totalDiscount']),
        totalGst: castToType<double>(data['totalGst']),
        totalCess: castToType<double>(data['totalCess']),
        totalLineItemsAfterTaxes:
            castToType<double>(data['totalLineItemsAfterTaxes']),
        dueBalancePayable: castToType<double>(data['dueBalancePayable']),
      );

  static BillSummaryResultsStruct? maybeFromMap(dynamic data) => data is Map
      ? BillSummaryResultsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'totalTaxableValue': _totalTaxableValue,
        'totalDiscount': _totalDiscount,
        'totalGst': _totalGst,
        'totalCess': _totalCess,
        'totalLineItemsAfterTaxes': _totalLineItemsAfterTaxes,
        'dueBalancePayable': _dueBalancePayable,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'totalTaxableValue': serializeParam(
          _totalTaxableValue,
          ParamType.double,
        ),
        'totalDiscount': serializeParam(
          _totalDiscount,
          ParamType.double,
        ),
        'totalGst': serializeParam(
          _totalGst,
          ParamType.double,
        ),
        'totalCess': serializeParam(
          _totalCess,
          ParamType.double,
        ),
        'totalLineItemsAfterTaxes': serializeParam(
          _totalLineItemsAfterTaxes,
          ParamType.double,
        ),
        'dueBalancePayable': serializeParam(
          _dueBalancePayable,
          ParamType.double,
        ),
      }.withoutNulls;

  static BillSummaryResultsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      BillSummaryResultsStruct(
        totalTaxableValue: deserializeParam(
          data['totalTaxableValue'],
          ParamType.double,
          false,
        ),
        totalDiscount: deserializeParam(
          data['totalDiscount'],
          ParamType.double,
          false,
        ),
        totalGst: deserializeParam(
          data['totalGst'],
          ParamType.double,
          false,
        ),
        totalCess: deserializeParam(
          data['totalCess'],
          ParamType.double,
          false,
        ),
        totalLineItemsAfterTaxes: deserializeParam(
          data['totalLineItemsAfterTaxes'],
          ParamType.double,
          false,
        ),
        dueBalancePayable: deserializeParam(
          data['dueBalancePayable'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'BillSummaryResultsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BillSummaryResultsStruct &&
        totalTaxableValue == other.totalTaxableValue &&
        totalDiscount == other.totalDiscount &&
        totalGst == other.totalGst &&
        totalCess == other.totalCess &&
        totalLineItemsAfterTaxes == other.totalLineItemsAfterTaxes &&
        dueBalancePayable == other.dueBalancePayable;
  }

  @override
  int get hashCode => const ListEquality().hash([
        totalTaxableValue,
        totalDiscount,
        totalGst,
        totalCess,
        totalLineItemsAfterTaxes,
        dueBalancePayable
      ]);
}

BillSummaryResultsStruct createBillSummaryResultsStruct({
  double? totalTaxableValue,
  double? totalDiscount,
  double? totalGst,
  double? totalCess,
  double? totalLineItemsAfterTaxes,
  double? dueBalancePayable,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    BillSummaryResultsStruct(
      totalTaxableValue: totalTaxableValue,
      totalDiscount: totalDiscount,
      totalGst: totalGst,
      totalCess: totalCess,
      totalLineItemsAfterTaxes: totalLineItemsAfterTaxes,
      dueBalancePayable: dueBalancePayable,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

BillSummaryResultsStruct? updateBillSummaryResultsStruct(
  BillSummaryResultsStruct? billSummaryResults, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    billSummaryResults
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addBillSummaryResultsStructData(
  Map<String, dynamic> firestoreData,
  BillSummaryResultsStruct? billSummaryResults,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (billSummaryResults == null) {
    return;
  }
  if (billSummaryResults.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && billSummaryResults.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final billSummaryResultsData =
      getBillSummaryResultsFirestoreData(billSummaryResults, forFieldValue);
  final nestedData =
      billSummaryResultsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      billSummaryResults.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getBillSummaryResultsFirestoreData(
  BillSummaryResultsStruct? billSummaryResults, [
  bool forFieldValue = false,
]) {
  if (billSummaryResults == null) {
    return {};
  }
  final firestoreData = mapToFirestore(billSummaryResults.toMap());

  // Add any Firestore field values
  billSummaryResults.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getBillSummaryResultsListFirestoreData(
  List<BillSummaryResultsStruct>? billSummaryResultss,
) =>
    billSummaryResultss
        ?.map((e) => getBillSummaryResultsFirestoreData(e, true))
        .toList() ??
    [];
