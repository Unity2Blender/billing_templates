// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DatesStruct extends FFFirebaseStruct {
  DatesStruct({
    DateTime? issueDate,
    int? paymentTermsDays,
    DateTime? expiryDate,
    DateTime? dueDate,
    DateTime? shipmentDate,
    DateTime? deliveryDate,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _issueDate = issueDate,
        _paymentTermsDays = paymentTermsDays,
        _expiryDate = expiryDate,
        _dueDate = dueDate,
        _shipmentDate = shipmentDate,
        _deliveryDate = deliveryDate,
        super(firestoreUtilData);

  // "issueDate" field.
  DateTime? _issueDate;
  DateTime? get issueDate => _issueDate;
  set issueDate(DateTime? val) => _issueDate = val;

  bool hasIssueDate() => _issueDate != null;

  // "paymentTermsDays" field.
  int? _paymentTermsDays;
  int get paymentTermsDays => _paymentTermsDays ?? 0;
  set paymentTermsDays(int? val) => _paymentTermsDays = val;

  void incrementPaymentTermsDays(int amount) =>
      paymentTermsDays = paymentTermsDays + amount;

  bool hasPaymentTermsDays() => _paymentTermsDays != null;

  // "expiryDate" field.
  DateTime? _expiryDate;
  DateTime? get expiryDate => _expiryDate;
  set expiryDate(DateTime? val) => _expiryDate = val;

  bool hasExpiryDate() => _expiryDate != null;

  // "dueDate" field.
  DateTime? _dueDate;
  DateTime? get dueDate => _dueDate;
  set dueDate(DateTime? val) => _dueDate = val;

  bool hasDueDate() => _dueDate != null;

  // "shipmentDate" field.
  DateTime? _shipmentDate;
  DateTime? get shipmentDate => _shipmentDate;
  set shipmentDate(DateTime? val) => _shipmentDate = val;

  bool hasShipmentDate() => _shipmentDate != null;

  // "deliveryDate" field.
  DateTime? _deliveryDate;
  DateTime? get deliveryDate => _deliveryDate;
  set deliveryDate(DateTime? val) => _deliveryDate = val;

  bool hasDeliveryDate() => _deliveryDate != null;

  static DatesStruct fromMap(Map<String, dynamic> data) => DatesStruct(
        issueDate: data['issueDate'] as DateTime?,
        paymentTermsDays: castToType<int>(data['paymentTermsDays']),
        expiryDate: data['expiryDate'] as DateTime?,
        dueDate: data['dueDate'] as DateTime?,
        shipmentDate: data['shipmentDate'] as DateTime?,
        deliveryDate: data['deliveryDate'] as DateTime?,
      );

  static DatesStruct? maybeFromMap(dynamic data) =>
      data is Map ? DatesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'issueDate': _issueDate,
        'paymentTermsDays': _paymentTermsDays,
        'expiryDate': _expiryDate,
        'dueDate': _dueDate,
        'shipmentDate': _shipmentDate,
        'deliveryDate': _deliveryDate,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'issueDate': serializeParam(
          _issueDate,
          ParamType.DateTime,
        ),
        'paymentTermsDays': serializeParam(
          _paymentTermsDays,
          ParamType.int,
        ),
        'expiryDate': serializeParam(
          _expiryDate,
          ParamType.DateTime,
        ),
        'dueDate': serializeParam(
          _dueDate,
          ParamType.DateTime,
        ),
        'shipmentDate': serializeParam(
          _shipmentDate,
          ParamType.DateTime,
        ),
        'deliveryDate': serializeParam(
          _deliveryDate,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static DatesStruct fromSerializableMap(Map<String, dynamic> data) =>
      DatesStruct(
        issueDate: deserializeParam(
          data['issueDate'],
          ParamType.DateTime,
          false,
        ),
        paymentTermsDays: deserializeParam(
          data['paymentTermsDays'],
          ParamType.int,
          false,
        ),
        expiryDate: deserializeParam(
          data['expiryDate'],
          ParamType.DateTime,
          false,
        ),
        dueDate: deserializeParam(
          data['dueDate'],
          ParamType.DateTime,
          false,
        ),
        shipmentDate: deserializeParam(
          data['shipmentDate'],
          ParamType.DateTime,
          false,
        ),
        deliveryDate: deserializeParam(
          data['deliveryDate'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'DatesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DatesStruct &&
        issueDate == other.issueDate &&
        paymentTermsDays == other.paymentTermsDays &&
        expiryDate == other.expiryDate &&
        dueDate == other.dueDate &&
        shipmentDate == other.shipmentDate &&
        deliveryDate == other.deliveryDate;
  }

  @override
  int get hashCode => const ListEquality().hash([
        issueDate,
        paymentTermsDays,
        expiryDate,
        dueDate,
        shipmentDate,
        deliveryDate
      ]);
}

DatesStruct createDatesStruct({
  DateTime? issueDate,
  int? paymentTermsDays,
  DateTime? expiryDate,
  DateTime? dueDate,
  DateTime? shipmentDate,
  DateTime? deliveryDate,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    DatesStruct(
      issueDate: issueDate,
      paymentTermsDays: paymentTermsDays,
      expiryDate: expiryDate,
      dueDate: dueDate,
      shipmentDate: shipmentDate,
      deliveryDate: deliveryDate,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

DatesStruct? updateDatesStruct(
  DatesStruct? dates, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    dates
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addDatesStructData(
  Map<String, dynamic> firestoreData,
  DatesStruct? dates,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (dates == null) {
    return;
  }
  if (dates.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && dates.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final datesData = getDatesFirestoreData(dates, forFieldValue);
  final nestedData = datesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = dates.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getDatesFirestoreData(
  DatesStruct? dates, [
  bool forFieldValue = false,
]) {
  if (dates == null) {
    return {};
  }
  final firestoreData = mapToFirestore(dates.toMap());

  // Add any Firestore field values
  dates.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getDatesListFirestoreData(
  List<DatesStruct>? datess,
) =>
    datess?.map((e) => getDatesFirestoreData(e, true)).toList() ?? [];
