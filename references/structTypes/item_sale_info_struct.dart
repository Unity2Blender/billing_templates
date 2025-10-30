// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Not directly linked with the manageItem UI but used in the `Invoice` type
/// as a list because we may need more infered and calculated line total
/// insights.
class ItemSaleInfoStruct extends FFFirebaseStruct {
  ItemSaleInfoStruct({
    ItemBasicInfoStruct? item,

    /// defaultNetPrice if no party specific basic net price
    double? partyNetPrice,
    List<CustomFieldInputValueStruct>? customFieldInputs,
    double? qtyOnBill,

    /// Subtotal is the taxable value before discount.
    double? subtotal,
    double? discountPercentage,
    double? discountAmt,
    double? taxableValue,
    double? igst,
    double? csgst,
    double? cessAmt,

    /// GST% + CESS% total
    double? grossTaxCharged,

    /// Total after GST, Discount, Cess
    double? lineTotal,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _item = item,
        _partyNetPrice = partyNetPrice,
        _customFieldInputs = customFieldInputs,
        _qtyOnBill = qtyOnBill,
        _subtotal = subtotal,
        _discountPercentage = discountPercentage,
        _discountAmt = discountAmt,
        _taxableValue = taxableValue,
        _igst = igst,
        _csgst = csgst,
        _cessAmt = cessAmt,
        _grossTaxCharged = grossTaxCharged,
        _lineTotal = lineTotal,
        super(firestoreUtilData);

  // "item" field.
  ItemBasicInfoStruct? _item;
  ItemBasicInfoStruct get item => _item ?? ItemBasicInfoStruct();
  set item(ItemBasicInfoStruct? val) => _item = val;

  void updateItem(Function(ItemBasicInfoStruct) updateFn) {
    updateFn(_item ??= ItemBasicInfoStruct());
  }

  bool hasItem() => _item != null;

  // "partyNetPrice" field.
  double? _partyNetPrice;
  double get partyNetPrice => _partyNetPrice ?? 0.0;
  set partyNetPrice(double? val) => _partyNetPrice = val;

  void incrementPartyNetPrice(double amount) =>
      partyNetPrice = partyNetPrice + amount;

  bool hasPartyNetPrice() => _partyNetPrice != null;

  // "customFieldInputs" field.
  List<CustomFieldInputValueStruct>? _customFieldInputs;
  List<CustomFieldInputValueStruct> get customFieldInputs =>
      _customFieldInputs ?? const [];
  set customFieldInputs(List<CustomFieldInputValueStruct>? val) =>
      _customFieldInputs = val;

  void updateCustomFieldInputs(
      Function(List<CustomFieldInputValueStruct>) updateFn) {
    updateFn(_customFieldInputs ??= []);
  }

  bool hasCustomFieldInputs() => _customFieldInputs != null;

  // "qtyOnBill" field.
  double? _qtyOnBill;
  double get qtyOnBill => _qtyOnBill ?? 0.0;
  set qtyOnBill(double? val) => _qtyOnBill = val;

  void incrementQtyOnBill(double amount) => qtyOnBill = qtyOnBill + amount;

  bool hasQtyOnBill() => _qtyOnBill != null;

  // "subtotal" field.
  double? _subtotal;
  double get subtotal => _subtotal ?? 0.0;
  set subtotal(double? val) => _subtotal = val;

  void incrementSubtotal(double amount) => subtotal = subtotal + amount;

  bool hasSubtotal() => _subtotal != null;

  // "discountPercentage" field.
  double? _discountPercentage;
  double get discountPercentage => _discountPercentage ?? 0.0;
  set discountPercentage(double? val) => _discountPercentage = val;

  void incrementDiscountPercentage(double amount) =>
      discountPercentage = discountPercentage + amount;

  bool hasDiscountPercentage() => _discountPercentage != null;

  // "discountAmt" field.
  double? _discountAmt;
  double get discountAmt => _discountAmt ?? 0.0;
  set discountAmt(double? val) => _discountAmt = val;

  void incrementDiscountAmt(double amount) =>
      discountAmt = discountAmt + amount;

  bool hasDiscountAmt() => _discountAmt != null;

  // "taxableValue" field.
  double? _taxableValue;
  double get taxableValue => _taxableValue ?? 0.0;
  set taxableValue(double? val) => _taxableValue = val;

  void incrementTaxableValue(double amount) =>
      taxableValue = taxableValue + amount;

  bool hasTaxableValue() => _taxableValue != null;

  // "igst" field.
  double? _igst;
  double get igst => _igst ?? 0.0;
  set igst(double? val) => _igst = val;

  void incrementIgst(double amount) => igst = igst + amount;

  bool hasIgst() => _igst != null;

  // "csgst" field.
  double? _csgst;
  double get csgst => _csgst ?? 0.0;
  set csgst(double? val) => _csgst = val;

  void incrementCsgst(double amount) => csgst = csgst + amount;

  bool hasCsgst() => _csgst != null;

  // "cessAmt" field.
  double? _cessAmt;
  double get cessAmt => _cessAmt ?? 0.0;
  set cessAmt(double? val) => _cessAmt = val;

  void incrementCessAmt(double amount) => cessAmt = cessAmt + amount;

  bool hasCessAmt() => _cessAmt != null;

  // "grossTaxCharged" field.
  double? _grossTaxCharged;
  double get grossTaxCharged => _grossTaxCharged ?? 0.0;
  set grossTaxCharged(double? val) => _grossTaxCharged = val;

  void incrementGrossTaxCharged(double amount) =>
      grossTaxCharged = grossTaxCharged + amount;

  bool hasGrossTaxCharged() => _grossTaxCharged != null;

  // "lineTotal" field.
  double? _lineTotal;
  double get lineTotal => _lineTotal ?? 0.0;
  set lineTotal(double? val) => _lineTotal = val;

  void incrementLineTotal(double amount) => lineTotal = lineTotal + amount;

  bool hasLineTotal() => _lineTotal != null;

  static ItemSaleInfoStruct fromMap(Map<String, dynamic> data) =>
      ItemSaleInfoStruct(
        item: data['item'] is ItemBasicInfoStruct
            ? data['item']
            : ItemBasicInfoStruct.maybeFromMap(data['item']),
        partyNetPrice: castToType<double>(data['partyNetPrice']),
        customFieldInputs: getStructList(
          data['customFieldInputs'],
          CustomFieldInputValueStruct.fromMap,
        ),
        qtyOnBill: castToType<double>(data['qtyOnBill']),
        subtotal: castToType<double>(data['subtotal']),
        discountPercentage: castToType<double>(data['discountPercentage']),
        discountAmt: castToType<double>(data['discountAmt']),
        taxableValue: castToType<double>(data['taxableValue']),
        igst: castToType<double>(data['igst']),
        csgst: castToType<double>(data['csgst']),
        cessAmt: castToType<double>(data['cessAmt']),
        grossTaxCharged: castToType<double>(data['grossTaxCharged']),
        lineTotal: castToType<double>(data['lineTotal']),
      );

  static ItemSaleInfoStruct? maybeFromMap(dynamic data) => data is Map
      ? ItemSaleInfoStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'item': _item?.toMap(),
        'partyNetPrice': _partyNetPrice,
        'customFieldInputs': _customFieldInputs?.map((e) => e.toMap()).toList(),
        'qtyOnBill': _qtyOnBill,
        'subtotal': _subtotal,
        'discountPercentage': _discountPercentage,
        'discountAmt': _discountAmt,
        'taxableValue': _taxableValue,
        'igst': _igst,
        'csgst': _csgst,
        'cessAmt': _cessAmt,
        'grossTaxCharged': _grossTaxCharged,
        'lineTotal': _lineTotal,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'item': serializeParam(
          _item,
          ParamType.DataStruct,
        ),
        'partyNetPrice': serializeParam(
          _partyNetPrice,
          ParamType.double,
        ),
        'customFieldInputs': serializeParam(
          _customFieldInputs,
          ParamType.DataStruct,
          isList: true,
        ),
        'qtyOnBill': serializeParam(
          _qtyOnBill,
          ParamType.double,
        ),
        'subtotal': serializeParam(
          _subtotal,
          ParamType.double,
        ),
        'discountPercentage': serializeParam(
          _discountPercentage,
          ParamType.double,
        ),
        'discountAmt': serializeParam(
          _discountAmt,
          ParamType.double,
        ),
        'taxableValue': serializeParam(
          _taxableValue,
          ParamType.double,
        ),
        'igst': serializeParam(
          _igst,
          ParamType.double,
        ),
        'csgst': serializeParam(
          _csgst,
          ParamType.double,
        ),
        'cessAmt': serializeParam(
          _cessAmt,
          ParamType.double,
        ),
        'grossTaxCharged': serializeParam(
          _grossTaxCharged,
          ParamType.double,
        ),
        'lineTotal': serializeParam(
          _lineTotal,
          ParamType.double,
        ),
      }.withoutNulls;

  static ItemSaleInfoStruct fromSerializableMap(Map<String, dynamic> data) =>
      ItemSaleInfoStruct(
        item: deserializeStructParam(
          data['item'],
          ParamType.DataStruct,
          false,
          structBuilder: ItemBasicInfoStruct.fromSerializableMap,
        ),
        partyNetPrice: deserializeParam(
          data['partyNetPrice'],
          ParamType.double,
          false,
        ),
        customFieldInputs: deserializeStructParam<CustomFieldInputValueStruct>(
          data['customFieldInputs'],
          ParamType.DataStruct,
          true,
          structBuilder: CustomFieldInputValueStruct.fromSerializableMap,
        ),
        qtyOnBill: deserializeParam(
          data['qtyOnBill'],
          ParamType.double,
          false,
        ),
        subtotal: deserializeParam(
          data['subtotal'],
          ParamType.double,
          false,
        ),
        discountPercentage: deserializeParam(
          data['discountPercentage'],
          ParamType.double,
          false,
        ),
        discountAmt: deserializeParam(
          data['discountAmt'],
          ParamType.double,
          false,
        ),
        taxableValue: deserializeParam(
          data['taxableValue'],
          ParamType.double,
          false,
        ),
        igst: deserializeParam(
          data['igst'],
          ParamType.double,
          false,
        ),
        csgst: deserializeParam(
          data['csgst'],
          ParamType.double,
          false,
        ),
        cessAmt: deserializeParam(
          data['cessAmt'],
          ParamType.double,
          false,
        ),
        grossTaxCharged: deserializeParam(
          data['grossTaxCharged'],
          ParamType.double,
          false,
        ),
        lineTotal: deserializeParam(
          data['lineTotal'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'ItemSaleInfoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ItemSaleInfoStruct &&
        item == other.item &&
        partyNetPrice == other.partyNetPrice &&
        listEquality.equals(customFieldInputs, other.customFieldInputs) &&
        qtyOnBill == other.qtyOnBill &&
        subtotal == other.subtotal &&
        discountPercentage == other.discountPercentage &&
        discountAmt == other.discountAmt &&
        taxableValue == other.taxableValue &&
        igst == other.igst &&
        csgst == other.csgst &&
        cessAmt == other.cessAmt &&
        grossTaxCharged == other.grossTaxCharged &&
        lineTotal == other.lineTotal;
  }

  @override
  int get hashCode => const ListEquality().hash([
        item,
        partyNetPrice,
        customFieldInputs,
        qtyOnBill,
        subtotal,
        discountPercentage,
        discountAmt,
        taxableValue,
        igst,
        csgst,
        cessAmt,
        grossTaxCharged,
        lineTotal
      ]);
}

ItemSaleInfoStruct createItemSaleInfoStruct({
  ItemBasicInfoStruct? item,
  double? partyNetPrice,
  double? qtyOnBill,
  double? subtotal,
  double? discountPercentage,
  double? discountAmt,
  double? taxableValue,
  double? igst,
  double? csgst,
  double? cessAmt,
  double? grossTaxCharged,
  double? lineTotal,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ItemSaleInfoStruct(
      item: item ?? (clearUnsetFields ? ItemBasicInfoStruct() : null),
      partyNetPrice: partyNetPrice,
      qtyOnBill: qtyOnBill,
      subtotal: subtotal,
      discountPercentage: discountPercentage,
      discountAmt: discountAmt,
      taxableValue: taxableValue,
      igst: igst,
      csgst: csgst,
      cessAmt: cessAmt,
      grossTaxCharged: grossTaxCharged,
      lineTotal: lineTotal,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ItemSaleInfoStruct? updateItemSaleInfoStruct(
  ItemSaleInfoStruct? itemSaleInfo, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    itemSaleInfo
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addItemSaleInfoStructData(
  Map<String, dynamic> firestoreData,
  ItemSaleInfoStruct? itemSaleInfo,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (itemSaleInfo == null) {
    return;
  }
  if (itemSaleInfo.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && itemSaleInfo.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final itemSaleInfoData =
      getItemSaleInfoFirestoreData(itemSaleInfo, forFieldValue);
  final nestedData =
      itemSaleInfoData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = itemSaleInfo.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getItemSaleInfoFirestoreData(
  ItemSaleInfoStruct? itemSaleInfo, [
  bool forFieldValue = false,
]) {
  if (itemSaleInfo == null) {
    return {};
  }
  final firestoreData = mapToFirestore(itemSaleInfo.toMap());

  // Handle nested data for "item" field.
  addItemBasicInfoStructData(
    firestoreData,
    itemSaleInfo.hasItem() ? itemSaleInfo.item : null,
    'item',
    forFieldValue,
  );

  // Add any Firestore field values
  itemSaleInfo.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getItemSaleInfoListFirestoreData(
  List<ItemSaleInfoStruct>? itemSaleInfos,
) =>
    itemSaleInfos?.map((e) => getItemSaleInfoFirestoreData(e, true)).toList() ??
    [];
