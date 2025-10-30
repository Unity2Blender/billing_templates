import '../models/invoice_data.dart';
import '../models/business_details.dart';
import '../models/item_sale_info.dart';
import '../models/bill_summary.dart';
import '../models/invoice_enums.dart';

class DemoInvoices {
  static InvoiceData getSampleInvoice1() {
    final seller = BusinessDetails(
      businessName: 'Murtaza',
      phone: '7387951082',
      email: 'contact@murtaza.com',
      gstin: '',
      pan: 'AAIPZ6382L',
      state: 'Maharashtra',
      businessAddress: 'Maharashtra',
    );

    final buyer = BusinessDetails(
      businessName: 'GST Calculator App',
      phone: '8459716606',
      email: 'customer@gstcalc.com',
      gstin: '',
      pan: 'AAIPZ6382L',
      state: 'Maharashtra',
      businessAddress: 'Maharashtra',
    );

    final item1 = ItemSaleInfo(
      item: ItemBasicInfo(
        name: 'Solar Panel 80k',
        description: '',
        hsnCode: '',
        qtyUnit: 'BDL',
      ),
      partyNetPrice: 1405.97,
      qtyOnBill: 3,
      subtotal: 4217.92,
      taxableValue: 4217.92,
      csgst: 29103.69,
      grossTaxCharged: 13.8,
      lineTotal: 480000,
    );

    final billSummary = BillSummary(
      totalTaxableValue: 4217.92,
      totalGst: 58207.38,
      totalLineItemsAfterTaxes: 480000,
      dueBalancePayable: 480000,
    );

    return InvoiceData(
      invoiceNumber: '5',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime(2025, 10, 8),
      dueDate: DateTime(2025, 10, 15),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: [item1],
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter:
          '1. Goods once sold will not be taken back or exchanged\n2. All disputes are subject to Jalgaon jurisdiction only',
    );
  }

  static InvoiceData getSampleInvoice2() {
    final seller = BusinessDetails(
      businessName: 'gstapps.com - AI',
      phone: '8459716606',
      email: 'hello@gstapps.com',
      gstin: '',
      pan: '',
      state: 'India',
      businessAddress: 'India',
    );

    final buyer = BusinessDetails(
      businessName: 'Mmz',
      phone: '',
      email: '',
      gstin: '',
      pan: '',
      state: '',
      businessAddress: '',
    );

    final item1 = ItemSaleInfo(
      item: ItemBasicInfo(
        name: 'Sample Item',
        description: '',
        hsnCode: '',
        qtyUnit: 'Bag',
      ),
      partyNetPrice: 100.00,
      qtyOnBill: 22,
      subtotal: 2200.00,
      taxableValue: 2200.00,
      grossTaxCharged: 18.0,
      lineTotal: 2596.00,
    );

    final billSummary = BillSummary(
      totalTaxableValue: 2596.00,
      totalGst: 396.00,
      totalLineItemsAfterTaxes: 2596.00,
      dueBalancePayable: 2596.00,
    );

    return InvoiceData(
      invoiceNumber: '001',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: [item1],
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'Thank you for doing business with us.',
    );
  }

  static InvoiceData getSampleInvoice3() {
    final seller = BusinessDetails(
      businessName: 'Tech Solutions Pvt Ltd',
      phone: '+91 98765 43210',
      email: 'sales@techsolutions.com',
      gstin: '29ABCDE1234F1Z5',
      pan: 'ABCDE1234F',
      state: 'Karnataka',
      district: 'Bangalore',
      businessAddress:
          '123, MG Road, Bangalore, Karnataka - 560001',
    );

    final buyer = BusinessDetails(
      businessName: 'Retail Enterprises',
      phone: '+91 87654 32109',
      email: 'purchase@retailent.com',
      gstin: '27FGHIJ5678K2L6',
      pan: 'FGHIJ5678K',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress:
          '456, Andheri East, Mumbai, Maharashtra - 400069',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Laptop Dell Inspiron 15',
          description: '15.6" FHD, Intel i5, 8GB RAM, 512GB SSD',
          hsnCode: '84713010',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 45000.00,
        qtyOnBill: 5,
        subtotal: 225000.00,
        taxableValue: 225000.00,
        igst: 40500.00,
        grossTaxCharged: 18.0,
        lineTotal: 265500.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Wireless Mouse Logitech',
          description: 'M331 Silent Plus, Wireless, 2.4 GHz',
          hsnCode: '85176290',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 800.00,
        qtyOnBill: 10,
        subtotal: 8000.00,
        taxableValue: 8000.00,
        igst: 1440.00,
        grossTaxCharged: 18.0,
        lineTotal: 9440.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'USB Hub 4-Port',
          description: 'USB 3.0 High-Speed Data Transfer',
          hsnCode: '85176290',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 500.00,
        qtyOnBill: 15,
        subtotal: 7500.00,
        discountPercentage: 10.0,
        discountAmt: 750.00,
        taxableValue: 6750.00,
        igst: 1215.00,
        grossTaxCharged: 18.0,
        lineTotal: 7965.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 239750.00,
      totalDiscount: 750.00,
      totalGst: 43155.00,
      totalLineItemsAfterTaxes: 282905.00,
      dueBalancePayable: 282905.00,
    );

    final bankDetails = BankingDetails(
      bankName: 'HDFC Bank',
      accountNo: '12345678901234',
      ifsc: 'HDFC0001234',
      accountHolderName: 'Tech Solutions Pvt Ltd',
      upi: 'techsolutions@hdfc',
      branchAddress: 'MG Road, Bangalore',
    );

    return InvoiceData(
      invoiceNumber: '2024/INV/1523',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      paymentTerms: ['Net 30 days', 'Late payment charges: 2% per month'],
      notesFooter:
          'Terms & Conditions:\n1. Goods once sold will not be taken back\n2. Subject to Bangalore jurisdiction\n3. Warranty as per manufacturer terms',
      bankDetails: bankDetails,
    );
  }

  static InvoiceData getSampleInvoice4() {
    final seller = BusinessDetails(
      businessName: 'Fashion Boutique',
      phone: '+91 99999 88888',
      email: 'sales@fashionboutique.in',
      gstin: '27XYZAB1234C1D2',
      pan: 'XYZAB1234C',
      state: 'Maharashtra',
      district: 'Pune',
      businessAddress: '789, FC Road, Pune, Maharashtra - 411004',
    );

    final buyer = BusinessDetails(
      businessName: 'Style Store',
      phone: '+91 88888 77777',
      email: 'purchase@stylestore.com',
      gstin: '27PQRST5678U3V4',
      pan: 'PQRST5678U',
      state: 'Maharashtra',
      district: 'Nagpur',
      businessAddress: '321, Sitabuldi, Nagpur, Maharashtra - 440012',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Womens Kurti Set',
          description: 'Cotton, Medium Size, Floral Print',
          hsnCode: '62043100',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 1200.00,
        qtyOnBill: 25,
        subtotal: 30000.00,
        taxableValue: 30000.00,
        csgst: 750.00,
        grossTaxCharged: 5.0,
        lineTotal: 31500.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Mens Casual Shirt',
          description: 'Linen, L Size, Solid Color',
          hsnCode: '62052000',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 1500.00,
        qtyOnBill: 20,
        subtotal: 30000.00,
        taxableValue: 30000.00,
        csgst: 1500.00,
        grossTaxCharged: 10.0,
        lineTotal: 33000.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 60000.00,
      totalGst: 4500.00,
      totalLineItemsAfterTaxes: 64500.00,
      dueBalancePayable: 64500.00,
    );

    return InvoiceData(
      invoiceNumber: 'FB-2024-892',
      invoiceMode: InvoiceMode.proformaInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 15)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.credit,
      paymentTerms: ['Payment on delivery', 'Credit period: 15 days'],
      notesFooter:
          'This is a proforma invoice.\nPlease make payment before shipment.',
    );
  }

  static List<InvoiceData> getAllSamples() {
    return [
      getSampleInvoice1(),
      getSampleInvoice2(),
      getSampleInvoice3(),
      getSampleInvoice4(),
    ];
  }
}
