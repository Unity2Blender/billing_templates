// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GstCessConfigStruct extends FFFirebaseStruct {
  GstCessConfigStruct({
    String? label,
    double? gstPercent,
    double? cessPercent,
    double? grossPercent,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _label = label,
        _gstPercent = gstPercent,
        _cessPercent = cessPercent,
        _grossPercent = grossPercent,
        super(firestoreUtilData);

  // "label" field.
  String? _label;
  String get label => _label ?? 'GST @';
  set label(String? val) => _label = val;

  bool hasLabel() => _label != null;

  // "gstPercent" field.
  double? _gstPercent;
  double get gstPercent => _gstPercent ?? 0.0;
  set gstPercent(double? val) => _gstPercent = val;

  void incrementGstPercent(double amount) => gstPercent = gstPercent + amount;

  bool hasGstPercent() => _gstPercent != null;

  // "cessPercent" field.
  double? _cessPercent;
  double get cessPercent => _cessPercent ?? 0.0;
  set cessPercent(double? val) => _cessPercent = val;

  void incrementCessPercent(double amount) =>
      cessPercent = cessPercent + amount;

  bool hasCessPercent() => _cessPercent != null;

  // "grossPercent" field.
  double? _grossPercent;
  double get grossPercent => _grossPercent ?? 0.0;
  set grossPercent(double? val) => _grossPercent = val;

  void incrementGrossPercent(double amount) =>
      grossPercent = grossPercent + amount;

  bool hasGrossPercent() => _grossPercent != null;

  static GstCessConfigStruct fromMap(Map<String, dynamic> data) =>
      GstCessConfigStruct(
        label: data['label'] as String?,
        gstPercent: castToType<double>(data['gstPercent']),
        cessPercent: castToType<double>(data['cessPercent']),
        grossPercent: castToType<double>(data['grossPercent']),
      );

  static GstCessConfigStruct? maybeFromMap(dynamic data) => data is Map
      ? GstCessConfigStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'label': _label,
        'gstPercent': _gstPercent,
        'cessPercent': _cessPercent,
        'grossPercent': _grossPercent,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'label': serializeParam(
          _label,
          ParamType.String,
        ),
        'gstPercent': serializeParam(
          _gstPercent,
          ParamType.double,
        ),
        'cessPercent': serializeParam(
          _cessPercent,
          ParamType.double,
        ),
        'grossPercent': serializeParam(
          _grossPercent,
          ParamType.double,
        ),
      }.withoutNulls;

  static GstCessConfigStruct fromSerializableMap(Map<String, dynamic> data) =>
      GstCessConfigStruct(
        label: deserializeParam(
          data['label'],
          ParamType.String,
          false,
        ),
        gstPercent: deserializeParam(
          data['gstPercent'],
          ParamType.double,
          false,
        ),
        cessPercent: deserializeParam(
          data['cessPercent'],
          ParamType.double,
          false,
        ),
        grossPercent: deserializeParam(
          data['grossPercent'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'GstCessConfigStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is GstCessConfigStruct &&
        label == other.label &&
        gstPercent == other.gstPercent &&
        cessPercent == other.cessPercent &&
        grossPercent == other.grossPercent;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([label, gstPercent, cessPercent, grossPercent]);
}

GstCessConfigStruct createGstCessConfigStruct({
  String? label,
  double? gstPercent,
  double? cessPercent,
  double? grossPercent,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    GstCessConfigStruct(
      label: label,
      gstPercent: gstPercent,
      cessPercent: cessPercent,
      grossPercent: grossPercent,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

GstCessConfigStruct? updateGstCessConfigStruct(
  GstCessConfigStruct? gstCessConfig, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    gstCessConfig
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addGstCessConfigStructData(
  Map<String, dynamic> firestoreData,
  GstCessConfigStruct? gstCessConfig,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (gstCessConfig == null) {
    return;
  }
  if (gstCessConfig.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && gstCessConfig.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final gstCessConfigData =
      getGstCessConfigFirestoreData(gstCessConfig, forFieldValue);
  final nestedData =
      gstCessConfigData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = gstCessConfig.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getGstCessConfigFirestoreData(
  GstCessConfigStruct? gstCessConfig, [
  bool forFieldValue = false,
]) {
  if (gstCessConfig == null) {
    return {};
  }
  final firestoreData = mapToFirestore(gstCessConfig.toMap());

  // Add any Firestore field values
  gstCessConfig.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getGstCessConfigListFirestoreData(
  List<GstCessConfigStruct>? gstCessConfigs,
) =>
    gstCessConfigs
        ?.map((e) => getGstCessConfigFirestoreData(e, true))
        .toList() ??
    [];
