// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Firm Ref is simply Business Name (but it's changeable)
///
/// So let's try for /billling/{uid}/firms subcollection
class FirmConfigStruct extends FFFirebaseStruct {
  FirmConfigStruct({
    DocumentReference? firmRef,
    String? shopLogo,
    String? signLogo,
    BusinessDetailsStruct? businessDetails,
    List<BankingDetailsStruct>? bankAccounts,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _firmRef = firmRef,
        _shopLogo = shopLogo,
        _signLogo = signLogo,
        _businessDetails = businessDetails,
        _bankAccounts = bankAccounts,
        super(firestoreUtilData);

  // "firmRef" field.
  DocumentReference? _firmRef;
  DocumentReference? get firmRef => _firmRef;
  set firmRef(DocumentReference? val) => _firmRef = val;

  bool hasFirmRef() => _firmRef != null;

  // "shopLogo" field.
  String? _shopLogo;
  String get shopLogo => _shopLogo ?? '';
  set shopLogo(String? val) => _shopLogo = val;

  bool hasShopLogo() => _shopLogo != null;

  // "signLogo" field.
  String? _signLogo;
  String get signLogo => _signLogo ?? '';
  set signLogo(String? val) => _signLogo = val;

  bool hasSignLogo() => _signLogo != null;

  // "businessDetails" field.
  BusinessDetailsStruct? _businessDetails;
  BusinessDetailsStruct get businessDetails =>
      _businessDetails ?? BusinessDetailsStruct();
  set businessDetails(BusinessDetailsStruct? val) => _businessDetails = val;

  void updateBusinessDetails(Function(BusinessDetailsStruct) updateFn) {
    updateFn(_businessDetails ??= BusinessDetailsStruct());
  }

  bool hasBusinessDetails() => _businessDetails != null;

  // "bankAccounts" field.
  List<BankingDetailsStruct>? _bankAccounts;
  List<BankingDetailsStruct> get bankAccounts => _bankAccounts ?? const [];
  set bankAccounts(List<BankingDetailsStruct>? val) => _bankAccounts = val;

  void updateBankAccounts(Function(List<BankingDetailsStruct>) updateFn) {
    updateFn(_bankAccounts ??= []);
  }

  bool hasBankAccounts() => _bankAccounts != null;

  static FirmConfigStruct fromMap(Map<String, dynamic> data) =>
      FirmConfigStruct(
        firmRef: data['firmRef'] as DocumentReference?,
        shopLogo: data['shopLogo'] as String?,
        signLogo: data['signLogo'] as String?,
        businessDetails: data['businessDetails'] is BusinessDetailsStruct
            ? data['businessDetails']
            : BusinessDetailsStruct.maybeFromMap(data['businessDetails']),
        bankAccounts: getStructList(
          data['bankAccounts'],
          BankingDetailsStruct.fromMap,
        ),
      );

  static FirmConfigStruct? maybeFromMap(dynamic data) => data is Map
      ? FirmConfigStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'firmRef': _firmRef,
        'shopLogo': _shopLogo,
        'signLogo': _signLogo,
        'businessDetails': _businessDetails?.toMap(),
        'bankAccounts': _bankAccounts?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'firmRef': serializeParam(
          _firmRef,
          ParamType.DocumentReference,
        ),
        'shopLogo': serializeParam(
          _shopLogo,
          ParamType.String,
        ),
        'signLogo': serializeParam(
          _signLogo,
          ParamType.String,
        ),
        'businessDetails': serializeParam(
          _businessDetails,
          ParamType.DataStruct,
        ),
        'bankAccounts': serializeParam(
          _bankAccounts,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static FirmConfigStruct fromSerializableMap(Map<String, dynamic> data) =>
      FirmConfigStruct(
        firmRef: deserializeParam(
          data['firmRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'firms'],
        ),
        shopLogo: deserializeParam(
          data['shopLogo'],
          ParamType.String,
          false,
        ),
        signLogo: deserializeParam(
          data['signLogo'],
          ParamType.String,
          false,
        ),
        businessDetails: deserializeStructParam(
          data['businessDetails'],
          ParamType.DataStruct,
          false,
          structBuilder: BusinessDetailsStruct.fromSerializableMap,
        ),
        bankAccounts: deserializeStructParam<BankingDetailsStruct>(
          data['bankAccounts'],
          ParamType.DataStruct,
          true,
          structBuilder: BankingDetailsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'FirmConfigStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is FirmConfigStruct &&
        firmRef == other.firmRef &&
        shopLogo == other.shopLogo &&
        signLogo == other.signLogo &&
        businessDetails == other.businessDetails &&
        listEquality.equals(bankAccounts, other.bankAccounts);
  }

  @override
  int get hashCode => const ListEquality()
      .hash([firmRef, shopLogo, signLogo, businessDetails, bankAccounts]);
}

FirmConfigStruct createFirmConfigStruct({
  DocumentReference? firmRef,
  String? shopLogo,
  String? signLogo,
  BusinessDetailsStruct? businessDetails,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    FirmConfigStruct(
      firmRef: firmRef,
      shopLogo: shopLogo,
      signLogo: signLogo,
      businessDetails: businessDetails ??
          (clearUnsetFields ? BusinessDetailsStruct() : null),
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

FirmConfigStruct? updateFirmConfigStruct(
  FirmConfigStruct? firmConfig, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    firmConfig
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addFirmConfigStructData(
  Map<String, dynamic> firestoreData,
  FirmConfigStruct? firmConfig,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (firmConfig == null) {
    return;
  }
  if (firmConfig.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && firmConfig.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final firmConfigData = getFirmConfigFirestoreData(firmConfig, forFieldValue);
  final nestedData = firmConfigData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = firmConfig.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getFirmConfigFirestoreData(
  FirmConfigStruct? firmConfig, [
  bool forFieldValue = false,
]) {
  if (firmConfig == null) {
    return {};
  }
  final firestoreData = mapToFirestore(firmConfig.toMap());

  // Handle nested data for "businessDetails" field.
  addBusinessDetailsStructData(
    firestoreData,
    firmConfig.hasBusinessDetails() ? firmConfig.businessDetails : null,
    'businessDetails',
    forFieldValue,
  );

  // Add any Firestore field values
  firmConfig.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getFirmConfigListFirestoreData(
  List<FirmConfigStruct>? firmConfigs,
) =>
    firmConfigs?.map((e) => getFirmConfigFirestoreData(e, true)).toList() ?? [];
