// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CustomFieldStruct extends FFFirebaseStruct {
  CustomFieldStruct({
    DocumentReference? fieldRef,
    String? nameLabel,
    KeyboardInputType? formWidgetType,
    String? defaultValueStr,

    /// Discoverable to Item config
    bool? isItemField,

    /// Discoverable to firms and parties config
    ///
    ///
    bool? isBusinessField,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _fieldRef = fieldRef,
        _nameLabel = nameLabel,
        _formWidgetType = formWidgetType,
        _defaultValueStr = defaultValueStr,
        _isItemField = isItemField,
        _isBusinessField = isBusinessField,
        super(firestoreUtilData);

  // "fieldRef" field.
  DocumentReference? _fieldRef;
  DocumentReference? get fieldRef => _fieldRef;
  set fieldRef(DocumentReference? val) => _fieldRef = val;

  bool hasFieldRef() => _fieldRef != null;

  // "nameLabel" field.
  String? _nameLabel;
  String get nameLabel => _nameLabel ?? '';
  set nameLabel(String? val) => _nameLabel = val;

  bool hasNameLabel() => _nameLabel != null;

  // "formWidgetType" field.
  KeyboardInputType? _formWidgetType;
  KeyboardInputType get formWidgetType =>
      _formWidgetType ?? KeyboardInputType.text;
  set formWidgetType(KeyboardInputType? val) => _formWidgetType = val;

  bool hasFormWidgetType() => _formWidgetType != null;

  // "defaultValueStr" field.
  String? _defaultValueStr;
  String get defaultValueStr => _defaultValueStr ?? '';
  set defaultValueStr(String? val) => _defaultValueStr = val;

  bool hasDefaultValueStr() => _defaultValueStr != null;

  // "isItemField" field.
  bool? _isItemField;
  bool get isItemField => _isItemField ?? false;
  set isItemField(bool? val) => _isItemField = val;

  bool hasIsItemField() => _isItemField != null;

  // "isBusinessField" field.
  bool? _isBusinessField;
  bool get isBusinessField => _isBusinessField ?? false;
  set isBusinessField(bool? val) => _isBusinessField = val;

  bool hasIsBusinessField() => _isBusinessField != null;

  static CustomFieldStruct fromMap(Map<String, dynamic> data) =>
      CustomFieldStruct(
        fieldRef: data['fieldRef'] as DocumentReference?,
        nameLabel: data['nameLabel'] as String?,
        formWidgetType: data['formWidgetType'] is KeyboardInputType
            ? data['formWidgetType']
            : deserializeEnum<KeyboardInputType>(data['formWidgetType']),
        defaultValueStr: data['defaultValueStr'] as String?,
        isItemField: data['isItemField'] as bool?,
        isBusinessField: data['isBusinessField'] as bool?,
      );

  static CustomFieldStruct? maybeFromMap(dynamic data) => data is Map
      ? CustomFieldStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'fieldRef': _fieldRef,
        'nameLabel': _nameLabel,
        'formWidgetType': _formWidgetType?.serialize(),
        'defaultValueStr': _defaultValueStr,
        'isItemField': _isItemField,
        'isBusinessField': _isBusinessField,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'fieldRef': serializeParam(
          _fieldRef,
          ParamType.DocumentReference,
        ),
        'nameLabel': serializeParam(
          _nameLabel,
          ParamType.String,
        ),
        'formWidgetType': serializeParam(
          _formWidgetType,
          ParamType.Enum,
        ),
        'defaultValueStr': serializeParam(
          _defaultValueStr,
          ParamType.String,
        ),
        'isItemField': serializeParam(
          _isItemField,
          ParamType.bool,
        ),
        'isBusinessField': serializeParam(
          _isBusinessField,
          ParamType.bool,
        ),
      }.withoutNulls;

  static CustomFieldStruct fromSerializableMap(Map<String, dynamic> data) =>
      CustomFieldStruct(
        fieldRef: deserializeParam(
          data['fieldRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'custom_fields'],
        ),
        nameLabel: deserializeParam(
          data['nameLabel'],
          ParamType.String,
          false,
        ),
        formWidgetType: deserializeParam<KeyboardInputType>(
          data['formWidgetType'],
          ParamType.Enum,
          false,
        ),
        defaultValueStr: deserializeParam(
          data['defaultValueStr'],
          ParamType.String,
          false,
        ),
        isItemField: deserializeParam(
          data['isItemField'],
          ParamType.bool,
          false,
        ),
        isBusinessField: deserializeParam(
          data['isBusinessField'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'CustomFieldStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is CustomFieldStruct &&
        fieldRef == other.fieldRef &&
        nameLabel == other.nameLabel &&
        formWidgetType == other.formWidgetType &&
        defaultValueStr == other.defaultValueStr &&
        isItemField == other.isItemField &&
        isBusinessField == other.isBusinessField;
  }

  @override
  int get hashCode => const ListEquality().hash([
        fieldRef,
        nameLabel,
        formWidgetType,
        defaultValueStr,
        isItemField,
        isBusinessField
      ]);
}

CustomFieldStruct createCustomFieldStruct({
  DocumentReference? fieldRef,
  String? nameLabel,
  KeyboardInputType? formWidgetType,
  String? defaultValueStr,
  bool? isItemField,
  bool? isBusinessField,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    CustomFieldStruct(
      fieldRef: fieldRef,
      nameLabel: nameLabel,
      formWidgetType: formWidgetType,
      defaultValueStr: defaultValueStr,
      isItemField: isItemField,
      isBusinessField: isBusinessField,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

CustomFieldStruct? updateCustomFieldStruct(
  CustomFieldStruct? customField, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    customField
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCustomFieldStructData(
  Map<String, dynamic> firestoreData,
  CustomFieldStruct? customField,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (customField == null) {
    return;
  }
  if (customField.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && customField.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final customFieldData =
      getCustomFieldFirestoreData(customField, forFieldValue);
  final nestedData =
      customFieldData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = customField.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCustomFieldFirestoreData(
  CustomFieldStruct? customField, [
  bool forFieldValue = false,
]) {
  if (customField == null) {
    return {};
  }
  final firestoreData = mapToFirestore(customField.toMap());

  // Add any Firestore field values
  customField.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCustomFieldListFirestoreData(
  List<CustomFieldStruct>? customFields,
) =>
    customFields?.map((e) => getCustomFieldFirestoreData(e, true)).toList() ??
    [];
