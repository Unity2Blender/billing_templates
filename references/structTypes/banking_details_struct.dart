// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class BankingDetailsStruct extends FFFirebaseStruct {
  BankingDetailsStruct({
    /// Business/Firm name
    String? makeChequeFor,

    /// UPI ID for payment
    String? upi,
    int? accountNo,
    String? ifsc,
    String? bankName,
    String? branchAddress,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _makeChequeFor = makeChequeFor,
        _upi = upi,
        _accountNo = accountNo,
        _ifsc = ifsc,
        _bankName = bankName,
        _branchAddress = branchAddress,
        super(firestoreUtilData);

  // "makeChequeFor" field.
  String? _makeChequeFor;
  String get makeChequeFor => _makeChequeFor ?? '';
  set makeChequeFor(String? val) => _makeChequeFor = val;

  bool hasMakeChequeFor() => _makeChequeFor != null;

  // "upi" field.
  String? _upi;
  String get upi => _upi ?? '';
  set upi(String? val) => _upi = val;

  bool hasUpi() => _upi != null;

  // "accountNo" field.
  int? _accountNo;
  int get accountNo => _accountNo ?? 0;
  set accountNo(int? val) => _accountNo = val;

  void incrementAccountNo(int amount) => accountNo = accountNo + amount;

  bool hasAccountNo() => _accountNo != null;

  // "ifsc" field.
  String? _ifsc;
  String get ifsc => _ifsc ?? '';
  set ifsc(String? val) => _ifsc = val;

  bool hasIfsc() => _ifsc != null;

  // "bankName" field.
  String? _bankName;
  String get bankName => _bankName ?? '';
  set bankName(String? val) => _bankName = val;

  bool hasBankName() => _bankName != null;

  // "branchAddress" field.
  String? _branchAddress;
  String get branchAddress => _branchAddress ?? '';
  set branchAddress(String? val) => _branchAddress = val;

  bool hasBranchAddress() => _branchAddress != null;

  static BankingDetailsStruct fromMap(Map<String, dynamic> data) =>
      BankingDetailsStruct(
        makeChequeFor: data['makeChequeFor'] as String?,
        upi: data['upi'] as String?,
        accountNo: castToType<int>(data['accountNo']),
        ifsc: data['ifsc'] as String?,
        bankName: data['bankName'] as String?,
        branchAddress: data['branchAddress'] as String?,
      );

  static BankingDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? BankingDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'makeChequeFor': _makeChequeFor,
        'upi': _upi,
        'accountNo': _accountNo,
        'ifsc': _ifsc,
        'bankName': _bankName,
        'branchAddress': _branchAddress,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'makeChequeFor': serializeParam(
          _makeChequeFor,
          ParamType.String,
        ),
        'upi': serializeParam(
          _upi,
          ParamType.String,
        ),
        'accountNo': serializeParam(
          _accountNo,
          ParamType.int,
        ),
        'ifsc': serializeParam(
          _ifsc,
          ParamType.String,
        ),
        'bankName': serializeParam(
          _bankName,
          ParamType.String,
        ),
        'branchAddress': serializeParam(
          _branchAddress,
          ParamType.String,
        ),
      }.withoutNulls;

  static BankingDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      BankingDetailsStruct(
        makeChequeFor: deserializeParam(
          data['makeChequeFor'],
          ParamType.String,
          false,
        ),
        upi: deserializeParam(
          data['upi'],
          ParamType.String,
          false,
        ),
        accountNo: deserializeParam(
          data['accountNo'],
          ParamType.int,
          false,
        ),
        ifsc: deserializeParam(
          data['ifsc'],
          ParamType.String,
          false,
        ),
        bankName: deserializeParam(
          data['bankName'],
          ParamType.String,
          false,
        ),
        branchAddress: deserializeParam(
          data['branchAddress'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'BankingDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is BankingDetailsStruct &&
        makeChequeFor == other.makeChequeFor &&
        upi == other.upi &&
        accountNo == other.accountNo &&
        ifsc == other.ifsc &&
        bankName == other.bankName &&
        branchAddress == other.branchAddress;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([makeChequeFor, upi, accountNo, ifsc, bankName, branchAddress]);
}

BankingDetailsStruct createBankingDetailsStruct({
  String? makeChequeFor,
  String? upi,
  int? accountNo,
  String? ifsc,
  String? bankName,
  String? branchAddress,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    BankingDetailsStruct(
      makeChequeFor: makeChequeFor,
      upi: upi,
      accountNo: accountNo,
      ifsc: ifsc,
      bankName: bankName,
      branchAddress: branchAddress,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

BankingDetailsStruct? updateBankingDetailsStruct(
  BankingDetailsStruct? bankingDetails, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    bankingDetails
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addBankingDetailsStructData(
  Map<String, dynamic> firestoreData,
  BankingDetailsStruct? bankingDetails,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (bankingDetails == null) {
    return;
  }
  if (bankingDetails.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && bankingDetails.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final bankingDetailsData =
      getBankingDetailsFirestoreData(bankingDetails, forFieldValue);
  final nestedData =
      bankingDetailsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = bankingDetails.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getBankingDetailsFirestoreData(
  BankingDetailsStruct? bankingDetails, [
  bool forFieldValue = false,
]) {
  if (bankingDetails == null) {
    return {};
  }
  final firestoreData = mapToFirestore(bankingDetails.toMap());

  // Add any Firestore field values
  bankingDetails.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getBankingDetailsListFirestoreData(
  List<BankingDetailsStruct>? bankingDetailss,
) =>
    bankingDetailss
        ?.map((e) => getBankingDetailsFirestoreData(e, true))
        .toList() ??
    [];
