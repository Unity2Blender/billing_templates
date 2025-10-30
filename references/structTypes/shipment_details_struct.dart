// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import '/backend/schema/enums/enums.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

/// Manage - ShippingDetails editor,
/// If [mode: proformaInv -> Must]
class ShipmentDetailsStruct extends FFFirebaseStruct {
  ShipmentDetailsStruct({
    /// Vehicle identification
    String? vehicleNo,

    /// Location of the Goods loading point
    String? goodsLoadingPoint,

    /// Default: Assume and Prefill the party's address or the seller's address if
    /// Purchase Order bill mode
    String? deliveryPoint,

    /// BlueDart - 1001234566
    String? trackingInfo,

    /// delivery method
    String? deliveryMode,
    DateTime? dispatchDate,

    /// The user would enter how many hours/days/weeks/months would it take for
    /// the delivery.
    String? expectedShipmentDuration,

    /// Final date when the Delivery is expected once it's shipped and processing
    /// days/month for Delivery have passed.
    DateTime? expectedDeliveryDate,

    /// Weight in Kgs, Quintals or Tons.
    String? totalWeight,
    double? netCharges,
    double? gstRate,
    double? chargesTotalInclGst,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _vehicleNo = vehicleNo,
        _goodsLoadingPoint = goodsLoadingPoint,
        _deliveryPoint = deliveryPoint,
        _trackingInfo = trackingInfo,
        _deliveryMode = deliveryMode,
        _dispatchDate = dispatchDate,
        _expectedShipmentDuration = expectedShipmentDuration,
        _expectedDeliveryDate = expectedDeliveryDate,
        _totalWeight = totalWeight,
        _netCharges = netCharges,
        _gstRate = gstRate,
        _chargesTotalInclGst = chargesTotalInclGst,
        super(firestoreUtilData);

  // "vehicleNo" field.
  String? _vehicleNo;
  String get vehicleNo => _vehicleNo ?? '';
  set vehicleNo(String? val) => _vehicleNo = val;

  bool hasVehicleNo() => _vehicleNo != null;

  // "goodsLoadingPoint" field.
  String? _goodsLoadingPoint;
  String get goodsLoadingPoint => _goodsLoadingPoint ?? '';
  set goodsLoadingPoint(String? val) => _goodsLoadingPoint = val;

  bool hasGoodsLoadingPoint() => _goodsLoadingPoint != null;

  // "deliveryPoint" field.
  String? _deliveryPoint;
  String get deliveryPoint => _deliveryPoint ?? '';
  set deliveryPoint(String? val) => _deliveryPoint = val;

  bool hasDeliveryPoint() => _deliveryPoint != null;

  // "trackingInfo" field.
  String? _trackingInfo;
  String get trackingInfo => _trackingInfo ?? '';
  set trackingInfo(String? val) => _trackingInfo = val;

  bool hasTrackingInfo() => _trackingInfo != null;

  // "deliveryMode" field.
  String? _deliveryMode;
  String get deliveryMode => _deliveryMode ?? '';
  set deliveryMode(String? val) => _deliveryMode = val;

  bool hasDeliveryMode() => _deliveryMode != null;

  // "dispatchDate" field.
  DateTime? _dispatchDate;
  DateTime? get dispatchDate => _dispatchDate;
  set dispatchDate(DateTime? val) => _dispatchDate = val;

  bool hasDispatchDate() => _dispatchDate != null;

  // "expectedShipmentDuration" field.
  String? _expectedShipmentDuration;
  String get expectedShipmentDuration => _expectedShipmentDuration ?? '';
  set expectedShipmentDuration(String? val) => _expectedShipmentDuration = val;

  bool hasExpectedShipmentDuration() => _expectedShipmentDuration != null;

  // "expectedDeliveryDate" field.
  DateTime? _expectedDeliveryDate;
  DateTime? get expectedDeliveryDate => _expectedDeliveryDate;
  set expectedDeliveryDate(DateTime? val) => _expectedDeliveryDate = val;

  bool hasExpectedDeliveryDate() => _expectedDeliveryDate != null;

  // "totalWeight" field.
  String? _totalWeight;
  String get totalWeight => _totalWeight ?? '';
  set totalWeight(String? val) => _totalWeight = val;

  bool hasTotalWeight() => _totalWeight != null;

  // "netCharges" field.
  double? _netCharges;
  double get netCharges => _netCharges ?? 0.0;
  set netCharges(double? val) => _netCharges = val;

  void incrementNetCharges(double amount) => netCharges = netCharges + amount;

  bool hasNetCharges() => _netCharges != null;

  // "gstRate" field.
  double? _gstRate;
  double get gstRate => _gstRate ?? 0.0;
  set gstRate(double? val) => _gstRate = val;

  void incrementGstRate(double amount) => gstRate = gstRate + amount;

  bool hasGstRate() => _gstRate != null;

  // "chargesTotalInclGst" field.
  double? _chargesTotalInclGst;
  double get chargesTotalInclGst => _chargesTotalInclGst ?? 0.0;
  set chargesTotalInclGst(double? val) => _chargesTotalInclGst = val;

  void incrementChargesTotalInclGst(double amount) =>
      chargesTotalInclGst = chargesTotalInclGst + amount;

  bool hasChargesTotalInclGst() => _chargesTotalInclGst != null;

  static ShipmentDetailsStruct fromMap(Map<String, dynamic> data) =>
      ShipmentDetailsStruct(
        vehicleNo: data['vehicleNo'] as String?,
        goodsLoadingPoint: data['goodsLoadingPoint'] as String?,
        deliveryPoint: data['deliveryPoint'] as String?,
        trackingInfo: data['trackingInfo'] as String?,
        deliveryMode: data['deliveryMode'] as String?,
        dispatchDate: data['dispatchDate'] as DateTime?,
        expectedShipmentDuration: data['expectedShipmentDuration'] as String?,
        expectedDeliveryDate: data['expectedDeliveryDate'] as DateTime?,
        totalWeight: data['totalWeight'] as String?,
        netCharges: castToType<double>(data['netCharges']),
        gstRate: castToType<double>(data['gstRate']),
        chargesTotalInclGst: castToType<double>(data['chargesTotalInclGst']),
      );

  static ShipmentDetailsStruct? maybeFromMap(dynamic data) => data is Map
      ? ShipmentDetailsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'vehicleNo': _vehicleNo,
        'goodsLoadingPoint': _goodsLoadingPoint,
        'deliveryPoint': _deliveryPoint,
        'trackingInfo': _trackingInfo,
        'deliveryMode': _deliveryMode,
        'dispatchDate': _dispatchDate,
        'expectedShipmentDuration': _expectedShipmentDuration,
        'expectedDeliveryDate': _expectedDeliveryDate,
        'totalWeight': _totalWeight,
        'netCharges': _netCharges,
        'gstRate': _gstRate,
        'chargesTotalInclGst': _chargesTotalInclGst,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'vehicleNo': serializeParam(
          _vehicleNo,
          ParamType.String,
        ),
        'goodsLoadingPoint': serializeParam(
          _goodsLoadingPoint,
          ParamType.String,
        ),
        'deliveryPoint': serializeParam(
          _deliveryPoint,
          ParamType.String,
        ),
        'trackingInfo': serializeParam(
          _trackingInfo,
          ParamType.String,
        ),
        'deliveryMode': serializeParam(
          _deliveryMode,
          ParamType.String,
        ),
        'dispatchDate': serializeParam(
          _dispatchDate,
          ParamType.DateTime,
        ),
        'expectedShipmentDuration': serializeParam(
          _expectedShipmentDuration,
          ParamType.String,
        ),
        'expectedDeliveryDate': serializeParam(
          _expectedDeliveryDate,
          ParamType.DateTime,
        ),
        'totalWeight': serializeParam(
          _totalWeight,
          ParamType.String,
        ),
        'netCharges': serializeParam(
          _netCharges,
          ParamType.double,
        ),
        'gstRate': serializeParam(
          _gstRate,
          ParamType.double,
        ),
        'chargesTotalInclGst': serializeParam(
          _chargesTotalInclGst,
          ParamType.double,
        ),
      }.withoutNulls;

  static ShipmentDetailsStruct fromSerializableMap(Map<String, dynamic> data) =>
      ShipmentDetailsStruct(
        vehicleNo: deserializeParam(
          data['vehicleNo'],
          ParamType.String,
          false,
        ),
        goodsLoadingPoint: deserializeParam(
          data['goodsLoadingPoint'],
          ParamType.String,
          false,
        ),
        deliveryPoint: deserializeParam(
          data['deliveryPoint'],
          ParamType.String,
          false,
        ),
        trackingInfo: deserializeParam(
          data['trackingInfo'],
          ParamType.String,
          false,
        ),
        deliveryMode: deserializeParam(
          data['deliveryMode'],
          ParamType.String,
          false,
        ),
        dispatchDate: deserializeParam(
          data['dispatchDate'],
          ParamType.DateTime,
          false,
        ),
        expectedShipmentDuration: deserializeParam(
          data['expectedShipmentDuration'],
          ParamType.String,
          false,
        ),
        expectedDeliveryDate: deserializeParam(
          data['expectedDeliveryDate'],
          ParamType.DateTime,
          false,
        ),
        totalWeight: deserializeParam(
          data['totalWeight'],
          ParamType.String,
          false,
        ),
        netCharges: deserializeParam(
          data['netCharges'],
          ParamType.double,
          false,
        ),
        gstRate: deserializeParam(
          data['gstRate'],
          ParamType.double,
          false,
        ),
        chargesTotalInclGst: deserializeParam(
          data['chargesTotalInclGst'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'ShipmentDetailsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ShipmentDetailsStruct &&
        vehicleNo == other.vehicleNo &&
        goodsLoadingPoint == other.goodsLoadingPoint &&
        deliveryPoint == other.deliveryPoint &&
        trackingInfo == other.trackingInfo &&
        deliveryMode == other.deliveryMode &&
        dispatchDate == other.dispatchDate &&
        expectedShipmentDuration == other.expectedShipmentDuration &&
        expectedDeliveryDate == other.expectedDeliveryDate &&
        totalWeight == other.totalWeight &&
        netCharges == other.netCharges &&
        gstRate == other.gstRate &&
        chargesTotalInclGst == other.chargesTotalInclGst;
  }

  @override
  int get hashCode => const ListEquality().hash([
        vehicleNo,
        goodsLoadingPoint,
        deliveryPoint,
        trackingInfo,
        deliveryMode,
        dispatchDate,
        expectedShipmentDuration,
        expectedDeliveryDate,
        totalWeight,
        netCharges,
        gstRate,
        chargesTotalInclGst
      ]);
}

ShipmentDetailsStruct createShipmentDetailsStruct({
  String? vehicleNo,
  String? goodsLoadingPoint,
  String? deliveryPoint,
  String? trackingInfo,
  String? deliveryMode,
  DateTime? dispatchDate,
  String? expectedShipmentDuration,
  DateTime? expectedDeliveryDate,
  String? totalWeight,
  double? netCharges,
  double? gstRate,
  double? chargesTotalInclGst,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    ShipmentDetailsStruct(
      vehicleNo: vehicleNo,
      goodsLoadingPoint: goodsLoadingPoint,
      deliveryPoint: deliveryPoint,
      trackingInfo: trackingInfo,
      deliveryMode: deliveryMode,
      dispatchDate: dispatchDate,
      expectedShipmentDuration: expectedShipmentDuration,
      expectedDeliveryDate: expectedDeliveryDate,
      totalWeight: totalWeight,
      netCharges: netCharges,
      gstRate: gstRate,
      chargesTotalInclGst: chargesTotalInclGst,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

ShipmentDetailsStruct? updateShipmentDetailsStruct(
  ShipmentDetailsStruct? shipmentDetails, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    shipmentDetails
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addShipmentDetailsStructData(
  Map<String, dynamic> firestoreData,
  ShipmentDetailsStruct? shipmentDetails,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (shipmentDetails == null) {
    return;
  }
  if (shipmentDetails.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields =
      !forFieldValue && shipmentDetails.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final shipmentDetailsData =
      getShipmentDetailsFirestoreData(shipmentDetails, forFieldValue);
  final nestedData =
      shipmentDetailsData.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = shipmentDetails.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getShipmentDetailsFirestoreData(
  ShipmentDetailsStruct? shipmentDetails, [
  bool forFieldValue = false,
]) {
  if (shipmentDetails == null) {
    return {};
  }
  final firestoreData = mapToFirestore(shipmentDetails.toMap());

  // Add any Firestore field values
  shipmentDetails.firestoreUtilData.fieldValues
      .forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getShipmentDetailsListFirestoreData(
  List<ShipmentDetailsStruct>? shipmentDetailss,
) =>
    shipmentDetailss
        ?.map((e) => getShipmentDetailsFirestoreData(e, true))
        .toList() ??
    [];
