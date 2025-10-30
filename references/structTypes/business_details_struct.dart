// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Email changes, Anon Changes -> partyRef, parentDocRef (EmailBillingDoc,
/// AnonBillingDoc)
///
/// Very loosely coupled bcz we aren't planning to deleting Anon docs?
class BusinessDetailsStruct extends FFFirebaseStruct {
  BusinessDetailsStruct({
    /// Excl.
    ///
    /// Seller's own Business details?
    DocumentReference? partyRef,
    String? businessName,

    /// On editor, Query (.isBusinessField fieldDocs).
    ///
    /// docRef = customFieldValues.fieldSchema.fieldRef
    ///
    /// Ex: Licenses, etc.
    List<CustomFieldInputValueStruct>? customFieldValues,

    /// Party is Customer
    bool? isCustomer,

    /// Party is Vendor
    bool? isVendor,
    String? phone,
    String? email,
    String? gstin,

    /// PAN is mandatory to be mentioned for Seller and Party both if invoice sum
    /// >= 200,000
    String? pan,
    String? state,
    String? district,
    String? businessAddress,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _partyRef = partyRef,
        _businessName = businessName,
        _customFieldValues = customFieldValues,
        _isCustomer = isCustomer,
        _isVendor = isVendor,
        _phone = phone,
        _email = email,
        _gstin = gstin,
        _pan = pan,
        _state = state,
        _district = district,
        _businessAddress = businessAddress,
        super(firestoreUtilData);

  // "partyRef" field.
  DocumentReference? _partyRef;
  DocumentReference? get partyRef => _partyRef;
  set partyRef(DocumentReference? val) => _partyRef = val;

  bool hasPartyRef() => _partyRef != null;

  // "businessName" field.
  String? _businessName;
  String get businessName => _businessName ?? '';
  set businessName(String? val) => _businessName = val;

  bool hasBusinessName() => _businessName != null;

  // "customFieldValues" field.
  List<CustomFieldInputValueStruct>? _customFieldValues;
  List<CustomFieldInputValueStruct> get customFieldValues =>
      _customFieldValues ?? const [];
  set customFieldValues(List<CustomFieldInputValueStruct>? val) =>
      _customFieldValues = val;

  void updateCustomFieldValues(
      Function(List<CustomFieldInputValueStruct>) updateFn) {
    updateFn(_customFieldValues ??= []);
  }

  bool hasCustomFieldValues() => _customFieldValues != null;

  // "isCustomer" field.
  bool? _isCustomer;
  bool get isCustomer => _isCustomer ?? false;
  set isCustomer(bool? val) => _isCustomer = val;

  bool hasIsCustomer() => _isCustomer != null;

  // "isVendor" field.
  bool? _isVendor;
  bool get isVendor => _isVendor ?? false;
  set isVendor(bool? val) => _isVendor = val;

  bool hasIsVendor() => _isVendor != null;

  // "phone" field.
  String? _phone;
  String get phone => _phone ?? '';
  set phone(String? val) => _phone = val;

  bool hasPhone() => _phone != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  set email(String? val) => _email = val;

  bool hasEmail() => _email != null;

  // "gstin" field.
  String? _gstin;
  String get gstin => _gstin ?? '';
  set gstin(String? val) => _gstin = val;

  bool hasGstin() => _gstin != null;

  // "pan" field.
  String? _pan;
  String get pan => _pan ?? '';
  set pan(String? val) => _pan = val;

  bool hasPan() => _pan != null;

  // "state" field.
  String? _state;
  String get state => _state ?? '';
  set state(String? val) => _state = val;

  bool hasState() => _state != null;

  // "district" field.
  String? _district;
  String get district => _district ?? '';
  set district(String? val) => _district = val;

  bool hasDistrict() => _district != null;

  // "businessAddress" field.
  String? _businessAddress;
  String get businessAddress => _businessAddress ?? '';
  set businessAddress(String? val) => _businessAddress = val;

  bool hasBusinessAddress() => _businessAddress != null;

  static BusinessDetailsStruct fromMap(Map<String, dynamic> data) =>
      BusinessDetailsStruct(
        partyRef: data['partyRef'] as DocumentReference?,
        businessName: data['businessName'] as String?,
        customFieldValues: getStructList(
          data['customFieldValues'],
          CustomFieldInputValueStruct.fromMap,
        ),
        isCustomer: data['isCustomer'] as bool?,
        isVendor: data['isVendor'] as bool?,
        phone: data['phone'] as String?,
        email: data['email'] as String?,
        gstin: data['gstin'] as String?,
        pan: data['pan'] as String?,
        state: data['state'] as String?,
        district: data['district'] as String?,
        businessAddress: data['businessAddress'] as String?,
      );

  static BusinessDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? BusinessDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'partyRef': _partyRef,
        'businessName': _businessName,
        'customFieldValues': _customFieldValues?.map((e) => e.toMap()).toList(),
        'isCustomer': _isCustomer,
        'isVendor': _isVendor,
        'phone': _phone,
        'email': _email,
        'gstin': _gstin,
        'pan': _pan,
        'state': _state,
        'district': _district,
        'businessAddress': _businessAddress,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'partyRef': serializeParam(
          _partyRef,
          ParamType.DocumentReference,
        ),
        'businessName': serializeParam(
          _businessName,
          ParamType.String,
        ),
        'customFieldValues': serializeParam(
          _customFieldValues,
          ParamType.DataStruct,
          isList: true,
        ),
        'isCustomer': serializeParam(
          _isCustomer,
          ParamType.bool,
        ),
        'isVendor': serializeParam(
          _isVendor,
          ParamType.bool,
        ),
        'phone': serializeParam(
          _phone,
          ParamType.String,
        ),
        'email': serializeParam(
          _email,
          ParamType.String,
        ),
        'gstin': serializeParam(
          _gstin,
          ParamType.String,
        ),
        'pan': serializeParam(
          _pan,
          ParamType.String,
        ),
        'state': serializeParam(
          _state,
          ParamType.String,
        ),
        'district': serializeParam(
          _district,
          ParamType.String,
        ),
        'businessAddress': serializeParam(
          _businessAddress,
          ParamType.String,
        ),
      }.withoutNulls;

  static BusinessDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      BusinessDetailsStruct(
        partyRef: deserializeParam(
          data['partyRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'parties'],
        ),
        businessName: deserializeParam(
          data['businessName'],
          ParamType.String,
          false,
        ),
        customFieldValues: deserializeStructParam<CustomFieldInputValueStruct>(
          data['customFieldValues'],
          ParamType.DataStruct,
          true,
          structBuilder: CustomFieldInputValueStruct.fromSerializableMap,
        ),
        isCustomer: deserializeParam(
          data['isCustomer'],
          ParamType.bool,
          false,
        ),
        isVendor: deserializeParam(
          data['isVendor'],
          ParamType.bool,
          false,
        ),
        phone: deserializeParam(
          data['phone'],
          ParamType.String,
          false,
        ),
        email: deserializeParam(
          data['email'],
          ParamType.String,
          false,
        ),
        gstin: deserializeParam(
          data['gstin'],
          ParamType.String,
          false,
        ),
        pan: deserializeParam(
          data['pan'],
          ParamType.String,
          false,
        ),
        state: deserializeParam(
          data['state'],
          ParamType.String,
          false,
        ),
        district: deserializeParam(
          data['district'],
          ParamType.String,
          false,
        ),
        businessAddress: deserializeParam(
          data['businessAddress'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'BusinessDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is BusinessDetailsStruct &&
        partyRef == other.partyRef &&
        businessName == other.businessName &&
        listEquality.equals(customFieldValues, other.customFieldValues) &&
        isCustomer == other.isCustomer &&
        isVendor == other.isVendor &&
        phone == other.phone &&
        email == other.email &&
        gstin == other.gstin &&
        pan == other.pan &&
        state == other.state &&
        district == other.district &&
        businessAddress == other.businessAddress;
  }

  @override
  int get hashCode => const ListEquality().hash([
        partyRef,
        businessName,
        customFieldValues,
        isCustomer,
        isVendor,
        phone,
        email,
        gstin,
        pan,
        state,
        district,
        businessAddress
      ]);
}

BusinessDetailsStruct createBusinessDetailsStruct({
  DocumentReference? partyRef,
  String? businessName,
  bool? isCustomer,
  bool? isVendor,
  String? phone,
  String? email,
  String? gstin,
  String? pan,
  String? state,
  String? district,
  String? businessAddress,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    BusinessDetailsStruct(
      partyRef: partyRef,
      businessName: businessName,
      isCustomer: isCustomer,
      isVendor: isVendor,
      phone: phone,
      email: email,
      gstin: gstin,
      pan: pan,
      state: state,
      district: district,
      businessAddress: businessAddress,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

BusinessDetailsStruct? updateBusinessDetailsStruct(
  BusinessDetailsStruct? businessDetails, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    businessDetails
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addBusinessDetailsStructData(
  Map<String, dynamic> firestoreData,
  BusinessDetailsStruct? businessDetails,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (businessDetails == null) {
    return;
  }
  if (businessDetails.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && businessDetails.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final businessDetailsData =
      getBusinessDetailsFirestoreData(businessDetails, forFieldValue);
  final nestedData =
      businessDetailsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = businessDetails.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getBusinessDetailsFirestoreData(
  BusinessDetailsStruct? businessDetails, [
  bool forFieldValue = false,
]) {
  if (businessDetails == null) {
    return {};
  }
  final firestoreData = mapToFirestore(businessDetails.toMap());

  // Add any Firestore field values
  businessDetails.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getBusinessDetailsListFirestoreData(
  List<BusinessDetailsStruct>? businessDetailss,
) =>
    businessDetailss
        ?.map((e) => getBusinessDetailsFirestoreData(e, true))
        .toList() ??
    [];
