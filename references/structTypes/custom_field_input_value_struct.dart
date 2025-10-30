// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CustomFieldInputValueStruct extends FFFirebaseStruct {
  CustomFieldInputValueStruct({
    CustomFieldStruct? fieldSchema,
    String? fieldInputStr,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _fieldSchema = fieldSchema,
        _fieldInputStr = fieldInputStr,
        super(firestoreUtilData);

  // "fieldSchema" field.
  CustomFieldStruct? _fieldSchema;
  CustomFieldStruct get fieldSchema => _fieldSchema ?? CustomFieldStruct();
  set fieldSchema(CustomFieldStruct? val) => _fieldSchema = val;

  void updateFieldSchema(Function(CustomFieldStruct) updateFn) {
    updateFn(_fieldSchema ??= CustomFieldStruct());
  }

  bool hasFieldSchema() => _fieldSchema != null;

  // "fieldInputStr" field.
  String? _fieldInputStr;
  String get fieldInputStr => _fieldInputStr ?? '';
  set fieldInputStr(String? val) => _fieldInputStr = val;

  bool hasFieldInputStr() => _fieldInputStr != null;

  static CustomFieldInputValueStruct fromMap(Map<String, dynamic> data) =>
      CustomFieldInputValueStruct(
        fieldSchema: data['fieldSchema'] is CustomFieldStruct
            ? data['fieldSchema']
            : CustomFieldStruct.maybeFromMap(data['fieldSchema']),
        fieldInputStr: data['fieldInputStr'] as String?,
      );

  static CustomFieldInputValueStruct? maybeFromMap(dynamic data) => data is Map
      ? CustomFieldInputValueStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fieldSchema': _fieldSchema?.toMap(),
        'fieldInputStr': _fieldInputStr,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fieldSchema': serializeParam(
          _fieldSchema,
          ParamType.DataStruct,
        ),
        'fieldInputStr': serializeParam(
          _fieldInputStr,
          ParamType.String,
        ),
      }.withoutNulls;

  static CustomFieldInputValueStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      CustomFieldInputValueStruct(
        fieldSchema: deserializeStructParam(
          data['fieldSchema'],
          ParamType.DataStruct,
          false,
          structBuilder: CustomFieldStruct.fromSerializableMap,
        ),
        fieldInputStr: deserializeParam(
          data['fieldInputStr'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'CustomFieldInputValueStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CustomFieldInputValueStruct &&
        fieldSchema == other.fieldSchema &&
        fieldInputStr == other.fieldInputStr;
  }

  @override
  int get hashCode => const ListEquality().hash([fieldSchema, fieldInputStr]);
}

CustomFieldInputValueStruct createCustomFieldInputValueStruct({
  CustomFieldStruct? fieldSchema,
  String? fieldInputStr,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CustomFieldInputValueStruct(
      fieldSchema:
          fieldSchema ?? (clearUnsetFields ? CustomFieldStruct() : null),
      fieldInputStr: fieldInputStr,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CustomFieldInputValueStruct? updateCustomFieldInputValueStruct(
  CustomFieldInputValueStruct? customFieldInputValue, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    customFieldInputValue
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCustomFieldInputValueStructData(
  Map<String, dynamic> firestoreData,
  CustomFieldInputValueStruct? customFieldInputValue,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (customFieldInputValue == null) {
    return;
  }
  if (customFieldInputValue.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue &&
      customFieldInputValue.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final customFieldInputValueData = getCustomFieldInputValueFirestoreData(
      customFieldInputValue, forFieldValue);
  final nestedData =
      customFieldInputValueData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields =
      customFieldInputValue.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCustomFieldInputValueFirestoreData(
  CustomFieldInputValueStruct? customFieldInputValue, [
  bool forFieldValue = false,
]) {
  if (customFieldInputValue == null) {
    return {};
  }
  final firestoreData = mapToFirestore(customFieldInputValue.toMap());

  // Handle nested data for "fieldSchema" field.
  addCustomFieldStructData(
    firestoreData,
    customFieldInputValue.hasFieldSchema()
        ? customFieldInputValue.fieldSchema
        : null,
    'fieldSchema',
    forFieldValue,
  );

  // Add any Firestore field values
  customFieldInputValue.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCustomFieldInputValueListFirestoreData(
  List<CustomFieldInputValueStruct>? customFieldInputValues,
) =>
    customFieldInputValues
        ?.map((e) => getCustomFieldInputValueFirestoreData(e, true))
        .toList() ??
    [];
