// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PriceByPartyRefStruct extends FFFirebaseStruct {
  PriceByPartyRefStruct({
    DocumentReference? partyRef,

    /// Excl.
    ///
    /// Taxes
    double? netPrice,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _partyRef = partyRef,
        _netPrice = netPrice,
        super(firestoreUtilData);

  // "partyRef" field.
  DocumentReference? _partyRef;
  DocumentReference? get partyRef => _partyRef;
  set partyRef(DocumentReference? val) => _partyRef = val;

  bool hasPartyRef() => _partyRef != null;

  // "netPrice" field.
  double? _netPrice;
  double get netPrice => _netPrice ?? 0.0;
  set netPrice(double? val) => _netPrice = val;

  void incrementNetPrice(double amount) => netPrice = netPrice + amount;

  bool hasNetPrice() => _netPrice != null;

  static PriceByPartyRefStruct fromMap(Map<String, dynamic> data) =>
      PriceByPartyRefStruct(
        partyRef: data['partyRef'] as DocumentReference?,
        netPrice: castToType<double>(data['netPrice']),
      );

  static PriceByPartyRefStruct? maybeFromMap(dynamic data) => data is Map
      ? PriceByPartyRefStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'partyRef': _partyRef,
        'netPrice': _netPrice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'partyRef': serializeParam(
          _partyRef,
          ParamType.DocumentReference,
        ),
        'netPrice': serializeParam(
          _netPrice,
          ParamType.double,
        ),
      }.withoutNulls;

  static PriceByPartyRefStruct fromSerializableMap(Map<String, dynamic> data) =>
      PriceByPartyRefStruct(
        partyRef: deserializeParam(
          data['partyRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'parties'],
        ),
        netPrice: deserializeParam(
          data['netPrice'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'PriceByPartyRefStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PriceByPartyRefStruct &&
        partyRef == other.partyRef &&
        netPrice == other.netPrice;
  }

  @override
  int get hashCode => const ListEquality().hash([partyRef, netPrice]);
}

PriceByPartyRefStruct createPriceByPartyRefStruct({
  DocumentReference? partyRef,
  double? netPrice,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    PriceByPartyRefStruct(
      partyRef: partyRef,
      netPrice: netPrice,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

PriceByPartyRefStruct? updatePriceByPartyRefStruct(
  PriceByPartyRefStruct? priceByPartyRef, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    priceByPartyRef
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addPriceByPartyRefStructData(
  Map<String, dynamic> firestoreData,
  PriceByPartyRefStruct? priceByPartyRef,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (priceByPartyRef == null) {
    return;
  }
  if (priceByPartyRef.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && priceByPartyRef.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final priceByPartyRefData =
      getPriceByPartyRefFirestoreData(priceByPartyRef, forFieldValue);
  final nestedData =
      priceByPartyRefData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = priceByPartyRef.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getPriceByPartyRefFirestoreData(
  PriceByPartyRefStruct? priceByPartyRef, [
  bool forFieldValue = false,
]) {
  if (priceByPartyRef == null) {
    return {};
  }
  final firestoreData = mapToFirestore(priceByPartyRef.toMap());

  // Add any Firestore field values
  priceByPartyRef.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getPriceByPartyRefListFirestoreData(
  List<PriceByPartyRefStruct>? priceByPartyRefs,
) =>
    priceByPartyRefs
        ?.map((e) => getPriceByPartyRefFirestoreData(e, true))
        .toList() ??
    [];
