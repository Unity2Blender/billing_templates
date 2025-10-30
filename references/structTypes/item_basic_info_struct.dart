// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// From 'AI Actions'/Save Items tray -> Select an item
///
/// (manageItemSheet) Prefill lineItem fields from `about_bill_items` struct.
class ItemBasicInfoStruct extends FFFirebaseStruct {
  ItemBasicInfoStruct({
    DocumentReference? itemRef,

    /// List of FirmRefs which sell/list this item
    List<DocumentReference>? byFirms,
    String? name,

    /// trySubstring for 4 digits chapter-heading as well as 6-digits subheading
    /// inclusive hsnCode prefixes
    String? hsnCode,
    List<PriceByPartyRefStruct>? partySpecificPrices,

    /// common or general net price for all parties if no party specific pricing
    double? defaultNetPrice,
    String? qtyUnit,
    GstCessConfigStruct? taxRatesConfig,
    String? description,

    /// Use firm-cdn, subdomain R2 bucket for storing product images, firm logo
    /// and signature.
    String? imageThumbnailUrl,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _itemRef = itemRef,
        _byFirms = byFirms,
        _name = name,
        _hsnCode = hsnCode,
        _partySpecificPrices = partySpecificPrices,
        _defaultNetPrice = defaultNetPrice,
        _qtyUnit = qtyUnit,
        _taxRatesConfig = taxRatesConfig,
        _description = description,
        _imageThumbnailUrl = imageThumbnailUrl,
        super(firestoreUtilData);

  // "itemRef" field.
  DocumentReference? _itemRef;
  DocumentReference? get itemRef => _itemRef;
  set itemRef(DocumentReference? val) => _itemRef = val;

  bool hasItemRef() => _itemRef != null;

  // "byFirms" field.
  List<DocumentReference>? _byFirms;
  List<DocumentReference> get byFirms => _byFirms ?? const [];
  set byFirms(List<DocumentReference>? val) => _byFirms = val;

  void updateByFirms(Function(List<DocumentReference>) updateFn) {
    updateFn(_byFirms ??= []);
  }

  bool hasByFirms() => _byFirms != null;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "hsnCode" field.
  String? _hsnCode;
  String get hsnCode => _hsnCode ?? '';
  set hsnCode(String? val) => _hsnCode = val;

  bool hasHsnCode() => _hsnCode != null;

  // "partySpecificPrices" field.
  List<PriceByPartyRefStruct>? _partySpecificPrices;
  List<PriceByPartyRefStruct> get partySpecificPrices =>
      _partySpecificPrices ?? const [];
  set partySpecificPrices(List<PriceByPartyRefStruct>? val) =>
      _partySpecificPrices = val;

  void updatePartySpecificPrices(
      Function(List<PriceByPartyRefStruct>) updateFn) {
    updateFn(_partySpecificPrices ??= []);
  }

  bool hasPartySpecificPrices() => _partySpecificPrices != null;

  // "defaultNetPrice" field.
  double? _defaultNetPrice;
  double get defaultNetPrice => _defaultNetPrice ?? 0.0;
  set defaultNetPrice(double? val) => _defaultNetPrice = val;

  void incrementDefaultNetPrice(double amount) =>
      defaultNetPrice = defaultNetPrice + amount;

  bool hasDefaultNetPrice() => _defaultNetPrice != null;

  // "qtyUnit" field.
  String? _qtyUnit;
  String get qtyUnit => _qtyUnit ?? '';
  set qtyUnit(String? val) => _qtyUnit = val;

  bool hasQtyUnit() => _qtyUnit != null;

  // "taxRatesConfig" field.
  GstCessConfigStruct? _taxRatesConfig;
  GstCessConfigStruct get taxRatesConfig =>
      _taxRatesConfig ?? GstCessConfigStruct();
  set taxRatesConfig(GstCessConfigStruct? val) => _taxRatesConfig = val;

  void updateTaxRatesConfig(Function(GstCessConfigStruct) updateFn) {
    updateFn(_taxRatesConfig ??= GstCessConfigStruct());
  }

  bool hasTaxRatesConfig() => _taxRatesConfig != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "imageThumbnailUrl" field.
  String? _imageThumbnailUrl;
  String get imageThumbnailUrl => _imageThumbnailUrl ?? '';
  set imageThumbnailUrl(String? val) => _imageThumbnailUrl = val;

  bool hasImageThumbnailUrl() => _imageThumbnailUrl != null;

  static ItemBasicInfoStruct fromMap(Map<String, dynamic> data) =>
      ItemBasicInfoStruct(
        itemRef: data['itemRef'] as DocumentReference?,
        byFirms: getDataList(data['byFirms']),
        name: data['name'] as String?,
        hsnCode: data['hsnCode'] as String?,
        partySpecificPrices: getStructList(
          data['partySpecificPrices'],
          PriceByPartyRefStruct.fromMap,
        ),
        defaultNetPrice: castToType<double>(data['defaultNetPrice']),
        qtyUnit: data['qtyUnit'] as String?,
        taxRatesConfig: data['taxRatesConfig'] is GstCessConfigStruct
            ? data['taxRatesConfig']
            : GstCessConfigStruct.maybeFromMap(data['taxRatesConfig']),
        description: data['description'] as String?,
        imageThumbnailUrl: data['imageThumbnailUrl'] as String?,
      );

  static ItemBasicInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? ItemBasicInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'itemRef': _itemRef,
        'byFirms': _byFirms,
        'name': _name,
        'hsnCode': _hsnCode,
        'partySpecificPrices':
            _partySpecificPrices?.map((e) => e.toMap()).toList(),
        'defaultNetPrice': _defaultNetPrice,
        'qtyUnit': _qtyUnit,
        'taxRatesConfig': _taxRatesConfig?.toMap(),
        'description': _description,
        'imageThumbnailUrl': _imageThumbnailUrl,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'itemRef': serializeParam(
          _itemRef,
          ParamType.DocumentReference,
        ),
        'byFirms': serializeParam(
          _byFirms,
          ParamType.DocumentReference,
          isList: true,
        ),
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'hsnCode': serializeParam(
          _hsnCode,
          ParamType.String,
        ),
        'partySpecificPrices': serializeParam(
          _partySpecificPrices,
          ParamType.DataStruct,
          isList: true,
        ),
        'defaultNetPrice': serializeParam(
          _defaultNetPrice,
          ParamType.double,
        ),
        'qtyUnit': serializeParam(
          _qtyUnit,
          ParamType.String,
        ),
        'taxRatesConfig': serializeParam(
          _taxRatesConfig,
          ParamType.DataStruct,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'imageThumbnailUrl': serializeParam(
          _imageThumbnailUrl,
          ParamType.String,
        ),
      }.withoutNulls;

  static ItemBasicInfoStruct fromSerializableMap(Map<String, dynamic> data) =>
      ItemBasicInfoStruct(
        itemRef: deserializeParam(
          data['itemRef'],
          ParamType.DocumentReference,
          false,
          collectionNamePath: ['billing', 'items'],
        ),
        byFirms: deserializeParam<DocumentReference>(
          data['byFirms'],
          ParamType.DocumentReference,
          true,
          collectionNamePath: ['billing', 'firms'],
        ),
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        hsnCode: deserializeParam(
          data['hsnCode'],
          ParamType.String,
          false,
        ),
        partySpecificPrices: deserializeStructParam<PriceByPartyRefStruct>(
          data['partySpecificPrices'],
          ParamType.DataStruct,
          true,
          structBuilder: PriceByPartyRefStruct.fromSerializableMap,
        ),
        defaultNetPrice: deserializeParam(
          data['defaultNetPrice'],
          ParamType.double,
          false,
        ),
        qtyUnit: deserializeParam(
          data['qtyUnit'],
          ParamType.String,
          false,
        ),
        taxRatesConfig: deserializeStructParam(
          data['taxRatesConfig'],
          ParamType.DataStruct,
          false,
          structBuilder: GstCessConfigStruct.fromSerializableMap,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        imageThumbnailUrl: deserializeParam(
          data['imageThumbnailUrl'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ItemBasicInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ItemBasicInfoStruct &&
        itemRef == other.itemRef &&
        listEquality.equals(byFirms, other.byFirms) &&
        name == other.name &&
        hsnCode == other.hsnCode &&
        listEquality.equals(partySpecificPrices, other.partySpecificPrices) &&
        defaultNetPrice == other.defaultNetPrice &&
        qtyUnit == other.qtyUnit &&
        taxRatesConfig == other.taxRatesConfig &&
        description == other.description &&
        imageThumbnailUrl == other.imageThumbnailUrl;
  }

  @override
  int get hashCode => const ListEquality().hash([
        itemRef,
        byFirms,
        name,
        hsnCode,
        partySpecificPrices,
        defaultNetPrice,
        qtyUnit,
        taxRatesConfig,
        description,
        imageThumbnailUrl
      ]);
}

ItemBasicInfoStruct createItemBasicInfoStruct({
  DocumentReference? itemRef,
  String? name,
  String? hsnCode,
  double? defaultNetPrice,
  String? qtyUnit,
  GstCessConfigStruct? taxRatesConfig,
  String? description,
  String? imageThumbnailUrl,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ItemBasicInfoStruct(
      itemRef: itemRef,
      name: name,
      hsnCode: hsnCode,
      defaultNetPrice: defaultNetPrice,
      qtyUnit: qtyUnit,
      taxRatesConfig:
          taxRatesConfig ?? (clearUnsetFields ? GstCessConfigStruct() : null),
      description: description,
      imageThumbnailUrl: imageThumbnailUrl,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ItemBasicInfoStruct? updateItemBasicInfoStruct(
  ItemBasicInfoStruct? itemBasicInfo, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    itemBasicInfo
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addItemBasicInfoStructData(
  Map<String, dynamic> firestoreData,
  ItemBasicInfoStruct? itemBasicInfo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (itemBasicInfo == null) {
    return;
  }
  if (itemBasicInfo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && itemBasicInfo.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final itemBasicInfoData =
      getItemBasicInfoFirestoreData(itemBasicInfo, forFieldValue);
  final nestedData =
      itemBasicInfoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = itemBasicInfo.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getItemBasicInfoFirestoreData(
  ItemBasicInfoStruct? itemBasicInfo, [
  bool forFieldValue = false,
]) {
  if (itemBasicInfo == null) {
    return {};
  }
  final firestoreData = mapToFirestore(itemBasicInfo.toMap());

  // Handle nested data for "taxRatesConfig" field.
  addGstCessConfigStructData(
    firestoreData,
    itemBasicInfo.hasTaxRatesConfig() ? itemBasicInfo.taxRatesConfig : null,
    'taxRatesConfig',
    forFieldValue,
  );

  // Add any Firestore field values
  itemBasicInfo.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getItemBasicInfoListFirestoreData(
  List<ItemBasicInfoStruct>? itemBasicInfos,
) =>
    itemBasicInfos
        ?.map((e) => getItemBasicInfoFirestoreData(e, true))
        .toList() ??
    [];
