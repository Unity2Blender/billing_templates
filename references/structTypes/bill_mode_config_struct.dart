// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// > Modal sheet: Also ask to enter Shipping details (sheet)
///
/// - Sales bill, Delivery challan & Credit Note
/// - Proforma, Estimate & Quotation
/// - Purchase Order, Debit Note
class BillModeConfigStruct extends FFFirebaseStruct {
  BillModeConfigStruct({
    InvoiceMode? modeType,
    String? modeTitle,
    int? modeId,
    String? modeIdPrefix,
    int? lastUsedId,
    DatesStruct? dates,
    List<String>? paymentTerms,

    /// jsonEncode(extraFields) and store in here.
    ///
    /// Retrieve decoded mode specific json during Invoice editing/printing
    String? extraFieldsJsonStr,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _modeType = modeType,
        _modeTitle = modeTitle,
        _modeId = modeId,
        _modeIdPrefix = modeIdPrefix,
        _lastUsedId = lastUsedId,
        _dates = dates,
        _paymentTerms = paymentTerms,
        _extraFieldsJsonStr = extraFieldsJsonStr,
        super(firestoreUtilData);

  // "modeType" field.
  InvoiceMode? _modeType;
  InvoiceMode? get modeType => _modeType;
  set modeType(InvoiceMode? val) => _modeType = val;

  bool hasModeType() => _modeType != null;

  // "modeTitle" field.
  String? _modeTitle;
  String get modeTitle => _modeTitle ?? 'Invoice';
  set modeTitle(String? val) => _modeTitle = val;

  bool hasModeTitle() => _modeTitle != null;

  // "modeId" field.
  int? _modeId;
  int get modeId => _modeId ?? 0;
  set modeId(int? val) => _modeId = val;

  void incrementModeId(int amount) => modeId = modeId + amount;

  bool hasModeId() => _modeId != null;

  // "modeIdPrefix" field.
  String? _modeIdPrefix;
  String get modeIdPrefix => _modeIdPrefix ?? '';
  set modeIdPrefix(String? val) => _modeIdPrefix = val;

  bool hasModeIdPrefix() => _modeIdPrefix != null;

  // "lastUsedId" field.
  int? _lastUsedId;
  int get lastUsedId => _lastUsedId ?? 0;
  set lastUsedId(int? val) => _lastUsedId = val;

  void incrementLastUsedId(int amount) => lastUsedId = lastUsedId + amount;

  bool hasLastUsedId() => _lastUsedId != null;

  // "dates" field.
  DatesStruct? _dates;
  DatesStruct get dates => _dates ?? DatesStruct();
  set dates(DatesStruct? val) => _dates = val;

  void updateDates(Function(DatesStruct) updateFn) {
    updateFn(_dates ??= DatesStruct());
  }

  bool hasDates() => _dates != null;

  // "paymentTerms" field.
  List<String>? _paymentTerms;
  List<String> get paymentTerms => _paymentTerms ?? const [];
  set paymentTerms(List<String>? val) => _paymentTerms = val;

  void updatePaymentTerms(Function(List<String>) updateFn) {
    updateFn(_paymentTerms ??= []);
  }

  bool hasPaymentTerms() => _paymentTerms != null;

  // "extraFieldsJsonStr" field.
  String? _extraFieldsJsonStr;
  String get extraFieldsJsonStr => _extraFieldsJsonStr ?? '';
  set extraFieldsJsonStr(String? val) => _extraFieldsJsonStr = val;

  bool hasExtraFieldsJsonStr() => _extraFieldsJsonStr != null;

  static BillModeConfigStruct fromMap(Map<String, dynamic> data) =>
      BillModeConfigStruct(
        modeType: data['modeType'] is InvoiceMode
            ? data['modeType']
            : deserializeEnum<InvoiceMode>(data['modeType']),
        modeTitle: data['modeTitle'] as String?,
        modeId: castToType<int>(data['modeId']),
        modeIdPrefix: data['modeIdPrefix'] as String?,
        lastUsedId: castToType<int>(data['lastUsedId']),
        dates: data['dates'] is DatesStruct
            ? data['dates']
            : DatesStruct.maybeFromMap(data['dates']),
        paymentTerms: getDataList(data['paymentTerms']),
        extraFieldsJsonStr: data['extraFieldsJsonStr'] as String?,
      );

  static BillModeConfigStruct? maybeFromMap(dynamic data) => data is Map
      ? BillModeConfigStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'modeType': _modeType?.serialize(),
        'modeTitle': _modeTitle,
        'modeId': _modeId,
        'modeIdPrefix': _modeIdPrefix,
        'lastUsedId': _lastUsedId,
        'dates': _dates?.toMap(),
        'paymentTerms': _paymentTerms,
        'extraFieldsJsonStr': _extraFieldsJsonStr,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'modeType': serializeParam(
          _modeType,
          ParamType.Enum,
        ),
        'modeTitle': serializeParam(
          _modeTitle,
          ParamType.String,
        ),
        'modeId': serializeParam(
          _modeId,
          ParamType.int,
        ),
        'modeIdPrefix': serializeParam(
          _modeIdPrefix,
          ParamType.String,
        ),
        'lastUsedId': serializeParam(
          _lastUsedId,
          ParamType.int,
        ),
        'dates': serializeParam(
          _dates,
          ParamType.DataStruct,
        ),
        'paymentTerms': serializeParam(
          _paymentTerms,
          ParamType.String,
          isList: true,
        ),
        'extraFieldsJsonStr': serializeParam(
          _extraFieldsJsonStr,
          ParamType.String,
        ),
      }.withoutNulls;

  static BillModeConfigStruct fromSerializableMap(Map<String, dynamic> data) =>
      BillModeConfigStruct(
        modeType: deserializeParam<InvoiceMode>(
          data['modeType'],
          ParamType.Enum,
          false,
        ),
        modeTitle: deserializeParam(
          data['modeTitle'],
          ParamType.String,
          false,
        ),
        modeId: deserializeParam(
          data['modeId'],
          ParamType.int,
          false,
        ),
        modeIdPrefix: deserializeParam(
          data['modeIdPrefix'],
          ParamType.String,
          false,
        ),
        lastUsedId: deserializeParam(
          data['lastUsedId'],
          ParamType.int,
          false,
        ),
        dates: deserializeStructParam(
          data['dates'],
          ParamType.DataStruct,
          false,
          structBuilder: DatesStruct.fromSerializableMap,
        ),
        paymentTerms: deserializeParam<String>(
          data['paymentTerms'],
          ParamType.String,
          true,
        ),
        extraFieldsJsonStr: deserializeParam(
          data['extraFieldsJsonStr'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'BillModeConfigStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is BillModeConfigStruct &&
        modeType == other.modeType &&
        modeTitle == other.modeTitle &&
        modeId == other.modeId &&
        modeIdPrefix == other.modeIdPrefix &&
        lastUsedId == other.lastUsedId &&
        dates == other.dates &&
        listEquality.equals(paymentTerms, other.paymentTerms) &&
        extraFieldsJsonStr == other.extraFieldsJsonStr;
  }

  @override
  int get hashCode => const ListEquality().hash([
        modeType,
        modeTitle,
        modeId,
        modeIdPrefix,
        lastUsedId,
        dates,
        paymentTerms,
        extraFieldsJsonStr
      ]);
}

BillModeConfigStruct createBillModeConfigStruct({
  InvoiceMode? modeType,
  String? modeTitle,
  int? modeId,
  String? modeIdPrefix,
  int? lastUsedId,
  DatesStruct? dates,
  String? extraFieldsJsonStr,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    BillModeConfigStruct(
      modeType: modeType,
      modeTitle: modeTitle,
      modeId: modeId,
      modeIdPrefix: modeIdPrefix,
      lastUsedId: lastUsedId,
      dates: dates ?? (clearUnsetFields ? DatesStruct() : null),
      extraFieldsJsonStr: extraFieldsJsonStr,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

BillModeConfigStruct? updateBillModeConfigStruct(
  BillModeConfigStruct? billModeConfig, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    billModeConfig
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addBillModeConfigStructData(
  Map<String, dynamic> firestoreData,
  BillModeConfigStruct? billModeConfig,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (billModeConfig == null) {
    return;
  }
  if (billModeConfig.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && billModeConfig.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final billModeConfigData =
      getBillModeConfigFirestoreData(billModeConfig, forFieldValue);
  final nestedData =
      billModeConfigData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = billModeConfig.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getBillModeConfigFirestoreData(
  BillModeConfigStruct? billModeConfig, [
  bool forFieldValue = false,
]) {
  if (billModeConfig == null) {
    return {};
  }
  final firestoreData = mapToFirestore(billModeConfig.toMap());

  // Handle nested data for "dates" field.
  addDatesStructData(
    firestoreData,
    billModeConfig.hasDates() ? billModeConfig.dates : null,
    'dates',
    forFieldValue,
  );

  // Add any Firestore field values
  billModeConfig.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getBillModeConfigListFirestoreData(
  List<BillModeConfigStruct>? billModeConfigs,
) =>
    billModeConfigs
        ?.map((e) => getBillModeConfigFirestoreData(e, true))
        .toList() ??
    [];
