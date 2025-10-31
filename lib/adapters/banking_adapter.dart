import '../models/invoice_data.dart';

/// Adapter to convert FlutterFlow BankingDetailsStruct to internal BankingDetails model.
///
/// Handles conversion of banking information for payment details in invoices.
class BankingAdapter {
  /// Converts FlutterFlow BankingDetailsStruct to internal BankingDetails model.
  ///
  /// **Field Mapping:**
  /// - makeChequeFor → accountHolderName (business/firm name)
  /// - upi → upi (UPI ID for payments)
  /// - accountNo → accountNo (converted from int to String)
  /// - ifsc → ifsc (IFSC code)
  /// - bankName → bankName
  /// - branchAddress → branchAddress
  ///
  /// **Note:** Account number is stored as int in FlutterFlow struct but
  /// converted to String for display in PDFs.
  static BankingDetails fromFlutterFlowStruct(dynamic bankingStruct) {
    return BankingDetails(
      accountHolderName: bankingStruct.makeChequeFor ?? '',
      upi: bankingStruct.upi ?? '',
      accountNo: bankingStruct.accountNo?.toString() ?? '',
      ifsc: bankingStruct.ifsc ?? '',
      bankName: bankingStruct.bankName ?? '',
      branchAddress: bankingStruct.branchAddress ?? '',
    );
  }
}
