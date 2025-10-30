import 'package:collection/collection.dart';
import 'package:ff_commons/flutter_flow/enums.dart';
export 'package:ff_commons/flutter_flow/enums.dart';

/// Types of Bill modes
enum InvoiceMode {
  salesInv,
  proformaInv,
  estimateInv,
  quotationInv,
  purchaseOrderInv,
  creditNoteInv,
  debitNoteInv,
  deliveryChallanInv,
}

enum PaymentMode {
  CASH,
  UPI,
  CHEQUE,
  BANK_TRANSFER,
  CREDIT,
}

enum KeyboardInputType {
  text,
  longParagraph,
  integerNumberId,
  decimalAmount,
  date,
  dateTime,
  booleanCheckbox,
}

T? deserializeEnum<T>(String? value) {
  switch (T) {
    case (InvoiceMode):
      return InvoiceMode.values.deserialize(value) as T?;
    case (PaymentMode):
      return PaymentMode.values.deserialize(value) as T?;
    case (KeyboardInputType):
      return KeyboardInputType.values.deserialize(value) as T?;
    default:
      return null;
  }
}
