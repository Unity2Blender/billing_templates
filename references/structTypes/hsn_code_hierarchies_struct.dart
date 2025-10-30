// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class HsnCodeHierarchiesStruct extends FFFirebaseStruct {
  HsnCodeHierarchiesStruct({
    String? fourDigit,
    String? sixDigit,
    String? eightDigit,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _fourDigit = fourDigit,
        _sixDigit = sixDigit,
        _eightDigit = eightDigit,
        super(firestoreUtilData);

  // "fourDigit" field.
  String? _fourDigit;
  String get fourDigit => _fourDigit ?? '';
  set fourDigit(String? val) => _fourDigit = val;

  bool hasFourDigit() => _fourDigit != null;

  // "sixDigit" field.
  String? _sixDigit;
  String get sixDigit => _sixDigit ?? '';
  set sixDigit(String? val) => _sixDigit = val;

  bool hasSixDigit() => _sixDigit != null;

  // "eightDigit" field.
  String? _eightDigit;
  String get eightDigit => _eightDigit ?? '';
  set eightDigit(String? val) => _eightDigit = val;

  bool hasEightDigit() => _eightDigit != null;

  static HsnCodeHierarchiesStruct fromMap(Map<String, dynamic> data) =>
      HsnCodeHierarchiesStruct(
        fourDigit: data['fourDigit'] as String?,
        sixDigit: data['sixDigit'] as String?,
        eightDigit: data['eightDigit'] as String?,
      );

  static HsnCodeHierarchiesStruct? maybeFromMap(dynamic data) => data is Map
      ? HsnCodeHierarchiesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fourDigit': _fourDigit,
        'sixDigit': _sixDigit,
        'eightDigit': _eightDigit,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fourDigit': serializeParam(
          _fourDigit,
          ParamType.String,
        ),
        'sixDigit': serializeParam(
          _sixDigit,
          ParamType.String,
        ),
        'eightDigit': serializeParam(
          _eightDigit,
          ParamType.String,
        ),
      }.withoutNulls;

  static HsnCodeHierarchiesStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      HsnCodeHierarchiesStruct(
        fourDigit: deserializeParam(
          data['fourDigit'],
          ParamType.String,
          false,
        ),
        sixDigit: deserializeParam(
          data['sixDigit'],
          ParamType.String,
          false,
        ),
        eightDigit: deserializeParam(
          data['eightDigit'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'HsnCodeHierarchiesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is HsnCodeHierarchiesStruct &&
        fourDigit == other.fourDigit &&
        sixDigit == other.sixDigit &&
        eightDigit == other.eightDigit;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([fourDigit, sixDigit, eightDigit]);
}

HsnCodeHierarchiesStruct createHsnCodeHierarchiesStruct({
  String? fourDigit,
  String? sixDigit,
  String? eightDigit,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    HsnCodeHierarchiesStruct(
      fourDigit: fourDigit,
      sixDigit: sixDigit,
      eightDigit: eightDigit,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

HsnCodeHierarchiesStruct? updateHsnCodeHierarchiesStruct(
  HsnCodeHierarchiesStruct? hsnCodeHierarchies, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    hsnCodeHierarchies
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addHsnCodeHierarchiesStructData(
  Map<String, dynamic> firestoreData,
  HsnCodeHierarchiesStruct? hsnCodeHierarchies,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (hsnCodeHierarchies == null) {
    return;
  }
  if (hsnCodeHierarchies.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && hsnCodeHierarchies.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final hsnCodeHierarchiesData =
      getHsnCodeHierarchiesFirestoreData(hsnCodeHierarchies, forFieldValue);
  final nestedData =
      hsnCodeHierarchiesData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      hsnCodeHierarchies.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getHsnCodeHierarchiesFirestoreData(
  HsnCodeHierarchiesStruct? hsnCodeHierarchies, [
  bool forFieldValue = false,
]) {
  if (hsnCodeHierarchies == null) {
    return {};
  }
  final firestoreData = mapToFirestore(hsnCodeHierarchies.toMap());

  // Add any Firestore field values
  hsnCodeHierarchies.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getHsnCodeHierarchiesListFirestoreData(
  List<HsnCodeHierarchiesStruct>? hsnCodeHierarchiess,
) =>
    hsnCodeHierarchiess
        ?.map((e) => getHsnCodeHierarchiesFirestoreData(e, true))
        .toList() ??
    [];
