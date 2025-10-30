// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PrefsByInvoiceModeStruct extends FFFirebaseStruct {
  PrefsByInvoiceModeStruct({
    /// Filter by Invoice Mode X Firm name/Ref
    DocumentReference? firmRef,
    InvoiceMode? modeType,
    BillModeConfigStruct? recentModeConfig,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _firmRef = firmRef,
        _modeType = modeType,
        _recentModeConfig = recentModeConfig,
        super(firestoreUtilData);

  // "firmRef" field.
  DocumentReference? _firmRef;
  DocumentReference? get firmRef => _firmRef;
  set firmRef(DocumentReference? val) => _firmRef = val;

  bool hasFirmRef() => _firmRef != null;

  // "modeType" field.
  InvoiceMode? _modeType;
  InvoiceMode? get modeType => _modeType;
  set modeType(InvoiceMode? val) => _modeType = val;

  bool hasModeType() => _modeType != null;

  // "recentModeConfig" field.
  BillModeConfigStruct? _recentModeConfig;
  BillModeConfigStruct get recentModeConfig =>
      _recentModeConfig ?? BillModeConfigStruct();
  set recentModeConfig(BillModeConfigStruct? val) => _recentModeConfig = val;

  void updateRecentModeConfig(Function(BillModeConfigStruct) updateFn) {
    updateFn(_recentModeConfig ??= BillModeConfigStruct());
  }

  bool hasRecentModeConfig() => _recentModeConfig != null;

  static PrefsByInvoiceModeStruct fromMap(Map<String, dynamic> data) =>
      PrefsByInvoiceModeStruct(
        firmRef: data['firmRef'] as DocumentReference?,
        modeType: data['modeType'] is InvoiceMode
            ? data['modeType']
            : deserializeEnum<InvoiceMode>(data['modeType']),
        recentModeConfig: data['recentModeConfig'] is BillModeConfigStruct
            ? data['recentModeConfig']
            : BillModeConfigStruct.maybeFromMap(data['recentModeConfig']),
      );

  static PrefsByInvoiceModeStruct? maybeFromMap(dynamic data) => data is Map
      ? PrefsByInvoiceModeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'firmRef': _firmRef,
        'modeType': _modeType?.serialize(),
        'recentModeConfig': _recentModeConfig?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'firmRef': serializeParam(
          _firmRef,
          ParamType.DocumentReference,
        ),
        'modeType': serializeParam(
          _modeType,
          ParamType.Enum,
        ),
        'recentModeConfig': serializeParam(
          _recentModeConfig,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static PrefsByInvoiceModeStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      PrefsByInvoiceModeStruct(
        firmRef: deserializeParam(
          data['firmRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'firms'],
        ),
        modeType: deserializeParam<InvoiceMode>(
          data['modeType'],
          ParamType.Enum,
          false,
        ),
        recentModeConfig: deserializeStructParam(
          data['recentModeConfig'],
          ParamType.DataStruct,
          false,
          structBuilder: BillModeConfigStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'PrefsByInvoiceModeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PrefsByInvoiceModeStruct &&
        firmRef == other.firmRef &&
        modeType == other.modeType &&
        recentModeConfig == other.recentModeConfig;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([firmRef, modeType, recentModeConfig]);
}

PrefsByInvoiceModeStruct createPrefsByInvoiceModeStruct({
  DocumentReference? firmRef,
  InvoiceMode? modeType,
  BillModeConfigStruct? recentModeConfig,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PrefsByInvoiceModeStruct(
      firmRef: firmRef,
      modeType: modeType,
      recentModeConfig: recentModeConfig ??
          (clearUnsetFields ? BillModeConfigStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PrefsByInvoiceModeStruct? updatePrefsByInvoiceModeStruct(
  PrefsByInvoiceModeStruct? prefsByInvoiceMode, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    prefsByInvoiceMode
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPrefsByInvoiceModeStructData(
  Map<String, dynamic> firestoreData,
  PrefsByInvoiceModeStruct? prefsByInvoiceMode,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (prefsByInvoiceMode == null) {
    return;
  }
  if (prefsByInvoiceMode.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && prefsByInvoiceMode.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final prefsByInvoiceModeData =
      getPrefsByInvoiceModeFirestoreData(prefsByInvoiceMode, forFieldValue);
  final nestedData =
      prefsByInvoiceModeData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      prefsByInvoiceMode.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPrefsByInvoiceModeFirestoreData(
  PrefsByInvoiceModeStruct? prefsByInvoiceMode, [
  bool forFieldValue = false,
]) {
  if (prefsByInvoiceMode == null) {
    return {};
  }
  final firestoreData = mapToFirestore(prefsByInvoiceMode.toMap());

  // Handle nested data for "recentModeConfig" field.
  addBillModeConfigStructData(
    firestoreData,
    prefsByInvoiceMode.hasRecentModeConfig()
        ? prefsByInvoiceMode.recentModeConfig
        : null,
    'recentModeConfig',
    forFieldValue,
  );

  // Add any Firestore field values
  prefsByInvoiceMode.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPrefsByInvoiceModeListFirestoreData(
  List<PrefsByInvoiceModeStruct>? prefsByInvoiceModes,
) =>
    prefsByInvoiceModes
        ?.map((e) => getPrefsByInvoiceModeFirestoreData(e, true))
        .toList() ??
    [];
