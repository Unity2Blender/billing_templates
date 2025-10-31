import '../models/invoice_data.dart';
import '../models/business_details.dart';
import '../models/item_sale_info.dart';
import '../models/bill_summary.dart';
import '../models/invoice_enums.dart';
import '../models/custom_field_value.dart';

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

  // === BASIC DEMOS ===

  static InvoiceData getA5RetailBill() {
    final seller = BusinessDetails(
      businessName: 'Quick Mart',
      phone: '9876543210',
      email: 'quickmart@shop.com',
      gstin: '27QUICK1234M1Z8',
      pan: 'QUICK1234M',
      state: 'Maharashtra',
      businessAddress: 'Shop 12, Main Market, Mumbai - 400001',
    );

    final buyer = BusinessDetails(
      businessName: 'Walk-in Customer',
      phone: '9123456789',
      email: '',
      gstin: '',
      pan: '',
      state: 'Maharashtra',
      businessAddress: '',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Rice 1kg',
          description: 'Basmati Premium',
          hsnCode: '1006',
          qtyUnit: 'Kg',
        ),
        partyNetPrice: 120.00,
        qtyOnBill: 5,
        subtotal: 600.00,
        taxableValue: 600.00,
        csgst: 3.00,
        grossTaxCharged: 1.0,
        lineTotal: 606.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Cooking Oil 1L',
          description: 'Sunflower Oil',
          hsnCode: '1512',
          qtyUnit: 'L',
        ),
        partyNetPrice: 150.00,
        qtyOnBill: 2,
        subtotal: 300.00,
        taxableValue: 300.00,
        csgst: 7.50,
        grossTaxCharged: 5.0,
        lineTotal: 315.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Sugar 1kg',
          description: 'White Crystal',
          hsnCode: '1701',
          qtyUnit: 'Kg',
        ),
        partyNetPrice: 45.00,
        qtyOnBill: 3,
        subtotal: 135.00,
        taxableValue: 135.00,
        csgst: 3.38,
        grossTaxCharged: 5.0,
        lineTotal: 141.76,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Tea 250g',
          description: 'Premium Assam',
          hsnCode: '0902',
          qtyUnit: 'Pack',
        ),
        partyNetPrice: 200.00,
        qtyOnBill: 1,
        subtotal: 200.00,
        taxableValue: 200.00,
        csgst: 5.00,
        grossTaxCharged: 5.0,
        lineTotal: 210.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Biscuits 400g',
          description: 'Cream Cookies',
          hsnCode: '1905',
          qtyUnit: 'Pack',
        ),
        partyNetPrice: 80.00,
        qtyOnBill: 4,
        subtotal: 320.00,
        taxableValue: 320.00,
        csgst: 28.80,
        grossTaxCharged: 18.0,
        lineTotal: 377.60,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 1555.00,
      totalGst: 95.36,
      totalLineItemsAfterTaxes: 1650.36,
      dueBalancePayable: 1650.36,
    );

    return InvoiceData(
      invoiceNumber: 'QM-2024-0156',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'Thank you for shopping with us!',
    );
  }

  static InvoiceData getSimpleServiceInvoice() {
    final seller = BusinessDetails(
      businessName: 'CloudTech Solutions',
      phone: '+91 98765 00001',
      email: 'billing@cloudtech.in',
      gstin: '29CLOUD1234G1Z7',
      pan: 'CLOUD1234G',
      state: 'Karnataka',
      district: 'Bangalore',
      businessAddress: '45, Koramangala, Bangalore - 560034',
    );

    final buyer = BusinessDetails(
      businessName: 'StartupXYZ Pvt Ltd',
      phone: '+91 87654 00002',
      email: 'accounts@startupxyz.com',
      gstin: '29START5678H2K8',
      pan: 'START5678H',
      state: 'Karnataka',
      district: 'Bangalore',
      businessAddress: '12, Indiranagar, Bangalore - 560038',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Web Development Services',
          description: 'Frontend development - React.js (40 hours)',
          hsnCode: '998314',
          qtyUnit: 'Hrs',
        ),
        partyNetPrice: 2000.00,
        qtyOnBill: 40,
        subtotal: 80000.00,
        taxableValue: 80000.00,
        csgst: 7200.00,
        grossTaxCharged: 18.0,
        lineTotal: 94400.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Cloud Hosting Setup',
          description: 'AWS infrastructure setup and configuration',
          hsnCode: '998315',
          qtyUnit: 'Service',
        ),
        partyNetPrice: 15000.00,
        qtyOnBill: 1,
        subtotal: 15000.00,
        taxableValue: 15000.00,
        csgst: 1350.00,
        grossTaxCharged: 18.0,
        lineTotal: 17700.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 95000.00,
      totalGst: 17100.00,
      totalLineItemsAfterTaxes: 112100.00,
      dueBalancePayable: 112100.00,
    );

    final bankDetails = BankingDetails(
      bankName: 'ICICI Bank',
      accountNo: '098765432109876',
      ifsc: 'ICIC0001234',
      accountHolderName: 'CloudTech Solutions',
      upi: 'cloudtech@icici',
      branchAddress: 'Koramangala, Bangalore',
    );

    return InvoiceData(
      invoiceNumber: 'CTS/2024/342',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 15)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      paymentTerms: ['Payment due within 15 days', '2% late payment fee applies'],
      notesFooter: 'Thank you for your business!',
      bankDetails: bankDetails,
    );
  }

  // === GST TESTING DEMOS ===

  static InvoiceData getMultiGstRatesInvoice() {
    final seller = BusinessDetails(
      businessName: 'Universal Traders',
      phone: '+91 99999 11111',
      email: 'sales@universaltraders.com',
      gstin: '27UNIV1234T1R2',
      pan: 'UNIV1234T',
      state: 'Maharashtra',
      district: 'Pune',
      businessAddress: '88, MG Road, Pune - 411001',
    );

    final buyer = BusinessDetails(
      businessName: 'Retail Superstore',
      phone: '+91 88888 22222',
      email: 'purchase@retailstore.com',
      gstin: '27RETAIL678S3T4',
      pan: 'RETAIL678S',
      state: 'Maharashtra',
      district: 'Pune',
      businessAddress: '120, Camp Area, Pune - 411002',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Milk Powder 500g',
          description: 'Full Cream',
          hsnCode: '0402',
          qtyUnit: 'Pack',
        ),
        partyNetPrice: 300.00,
        qtyOnBill: 10,
        subtotal: 3000.00,
        taxableValue: 3000.00,
        csgst: 75.00,
        grossTaxCharged: 5.0,
        lineTotal: 3150.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Wheat Flour 5kg',
          description: 'Premium Quality',
          hsnCode: '1101',
          qtyUnit: 'Bag',
        ),
        partyNetPrice: 250.00,
        qtyOnBill: 20,
        subtotal: 5000.00,
        taxableValue: 5000.00,
        csgst: 300.00,
        grossTaxCharged: 12.0,
        lineTotal: 5600.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Packaged Snacks',
          description: 'Namkeen Mix 200g',
          hsnCode: '1905',
          qtyUnit: 'Pack',
        ),
        partyNetPrice: 50.00,
        qtyOnBill: 50,
        subtotal: 2500.00,
        taxableValue: 2500.00,
        csgst: 225.00,
        grossTaxCharged: 18.0,
        lineTotal: 2950.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Energy Drink 250ml',
          description: 'Carbonated',
          hsnCode: '2202',
          qtyUnit: 'Can',
        ),
        partyNetPrice: 80.00,
        qtyOnBill: 30,
        subtotal: 2400.00,
        taxableValue: 2400.00,
        csgst: 336.00,
        grossTaxCharged: 28.0,
        lineTotal: 3072.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 12900.00,
      totalGst: 1872.00,
      totalLineItemsAfterTaxes: 14772.00,
      dueBalancePayable: 14772.00,
    );

    return InvoiceData(
      invoiceNumber: 'UT/2024/778',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.credit,
      notesFooter: 'Demonstrating GST rates: 5%, 12%, 18%, 28%',
    );
  }

  static InvoiceData getCessHeavyGoods() {
    final seller = BusinessDetails(
      businessName: 'Luxury Automobiles',
      phone: '+91 77777 33333',
      email: 'sales@luxuryautos.com',
      gstin: '07LUXURY123A1B2',
      pan: 'LUXURY123A',
      state: 'Delhi',
      district: 'New Delhi',
      businessAddress: 'Connaught Place, New Delhi - 110001',
    );

    final buyer = BusinessDetails(
      businessName: 'Premium Lifestyle Ltd',
      phone: '+91 66666 44444',
      email: 'accounts@premiumlife.com',
      gstin: '07PREM5678C3D4',
      pan: 'PREM5678C',
      state: 'Delhi',
      district: 'South Delhi',
      businessAddress: 'Defence Colony, New Delhi - 110024',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Premium SUV - Model X',
          description: '2000cc, Diesel, BS-VI',
          hsnCode: '8703',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 2500000.00,
        qtyOnBill: 1,
        subtotal: 2500000.00,
        taxableValue: 2500000.00,
        csgst: 350000.00,
        cessAmt: 375000.00,
        grossTaxCharged: 28.0,
        lineTotal: 3225000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Luxury Sedan Accessories',
          description: 'Premium Floor Mats, Seat Covers',
          hsnCode: '8708',
          qtyUnit: 'Set',
        ),
        partyNetPrice: 50000.00,
        qtyOnBill: 1,
        subtotal: 50000.00,
        taxableValue: 50000.00,
        csgst: 14000.00,
        grossTaxCharged: 28.0,
        lineTotal: 64000.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 2550000.00,
      totalGst: 728000.00,
      totalCess: 375000.00,
      totalLineItemsAfterTaxes: 3289000.00,
      dueBalancePayable: 3289000.00,
    );

    final bankDetails = BankingDetails(
      bankName: 'State Bank of India',
      accountNo: '12340000567890',
      ifsc: 'SBIN0001234',
      accountHolderName: 'Luxury Automobiles',
      upi: 'luxuryautos@sbi',
      branchAddress: 'Connaught Place, Delhi',
    );

    return InvoiceData(
      invoiceNumber: 'LA/2024/001',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      paymentTerms: ['50% advance, 50% on delivery'],
      notesFooter: 'Vehicle registration and insurance not included.\nCompensation CESS applicable on luxury vehicles.',
      bankDetails: bankDetails,
    );
  }

  static InvoiceData getZeroRatedExport() {
    final seller = BusinessDetails(
      businessName: 'Export House India',
      phone: '+91 55555 66666',
      email: 'exports@exporthouse.in',
      gstin: '24EXPORT12E1F2',
      pan: 'EXPORT12E',
      state: 'Gujarat',
      district: 'Ahmedabad',
      businessAddress: 'GIDC Industrial Area, Ahmedabad - 382424',
    );

    final buyer = BusinessDetails(
      businessName: 'Global Imports LLC',
      phone: '+1-555-1234567',
      email: 'purchasing@globalimports.com',
      gstin: '',
      pan: '',
      state: 'Export',
      businessAddress: '123 Trade Center, New York, USA',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Cotton Fabric Rolls',
          description: '100% Cotton, 50 meters per roll',
          hsnCode: '5208',
          qtyUnit: 'Roll',
        ),
        partyNetPrice: 5000.00,
        qtyOnBill: 100,
        subtotal: 500000.00,
        taxableValue: 500000.00,
        grossTaxCharged: 0.0,
        lineTotal: 500000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Handicraft Items',
          description: 'Traditional Indian Handicrafts',
          hsnCode: '4420',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 1200.00,
        qtyOnBill: 200,
        subtotal: 240000.00,
        taxableValue: 240000.00,
        grossTaxCharged: 0.0,
        lineTotal: 240000.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 740000.00,
      totalGst: 0.00,
      totalLineItemsAfterTaxes: 740000.00,
      dueBalancePayable: 740000.00,
    );

    final bankDetails = BankingDetails(
      bankName: 'HDFC Bank',
      accountNo: '50070012345678',
      ifsc: 'HDFC0000123',
      accountHolderName: 'Export House India',
      branchAddress: 'Ahmedabad Main',
    );

    return InvoiceData(
      invoiceNumber: 'EXP/2024/1234',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      paymentTerms: ['Payment via LC (Letter of Credit)', 'Shipping: FOB Mundra Port'],
      notesFooter: 'Export Invoice - GST Zero Rated\nShipping Bill No: SB-2024-567890\nIEC Code: 0123456789',
      bankDetails: bankDetails,
    );
  }

  static InvoiceData getIntraStateDetailed() {
    final seller = BusinessDetails(
      businessName: 'State Electronics',
      phone: '+91 44444 77777',
      email: 'info@stateelectronics.com',
      gstin: '33SELEC1234T1N2',
      pan: 'SELEC1234T',
      state: 'Tamil Nadu',
      district: 'Chennai',
      businessAddress: 'T Nagar, Chennai - 600017',
    );

    final buyer = BusinessDetails(
      businessName: 'Local Distributors',
      phone: '+91 33333 88888',
      email: 'purchase@localdist.com',
      gstin: '33LOCAL5678D2S3',
      pan: 'LOCAL5678D',
      state: 'Tamil Nadu',
      district: 'Coimbatore',
      businessAddress: 'RS Puram, Coimbatore - 641002',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'LED TV 43 inch',
          description: 'Smart TV, 4K UHD',
          hsnCode: '85287110',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 28000.00,
        qtyOnBill: 15,
        subtotal: 420000.00,
        taxableValue: 420000.00,
        csgst: 37800.00,
        grossTaxCharged: 18.0,
        lineTotal: 495600.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Sound Bar',
          description: '2.1 Channel, 120W',
          hsnCode: '85182200',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 8000.00,
        qtyOnBill: 15,
        subtotal: 120000.00,
        taxableValue: 120000.00,
        csgst: 10800.00,
        grossTaxCharged: 18.0,
        lineTotal: 141600.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 540000.00,
      totalGst: 97200.00,
      totalLineItemsAfterTaxes: 637200.00,
      dueBalancePayable: 637200.00,
    );

    return InvoiceData(
      invoiceNumber: 'SE/TN/2024/445',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.credit,
      paymentTerms: ['Net 30 days', '1.5% interest on overdue'],
      notesFooter: 'Intra-State Supply: CGST + SGST applicable\nPlace of Supply: Tamil Nadu (33)',
    );
  }

  static InvoiceData getInterStateIgst() {
    final seller = BusinessDetails(
      businessName: 'Northern Manufacturing',
      phone: '+91 22222 99999',
      email: 'sales@northmfg.com',
      gstin: '09NORTH123M1F2',
      pan: 'NORTH123M',
      state: 'Uttar Pradesh',
      district: 'Noida',
      businessAddress: 'Sector 62, Noida - 201309',
    );

    final buyer = BusinessDetails(
      businessName: 'Southern Wholesale',
      phone: '+91 11111 00000',
      email: 'accounts@southwholesale.com',
      gstin: '36SOUTH567W3H4',
      pan: 'SOUTH567W',
      state: 'Telangana',
      district: 'Hyderabad',
      businessAddress: 'Banjara Hills, Hyderabad - 500034',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Industrial Machinery Parts',
          description: 'CNC Machine Components',
          hsnCode: '8466',
          qtyUnit: 'Set',
        ),
        partyNetPrice: 150000.00,
        qtyOnBill: 5,
        subtotal: 750000.00,
        taxableValue: 750000.00,
        igst: 135000.00,
        grossTaxCharged: 18.0,
        lineTotal: 885000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Lubricants & Oils',
          description: 'Industrial Grade 20L',
          hsnCode: '2710',
          qtyUnit: 'Can',
        ),
        partyNetPrice: 3000.00,
        qtyOnBill: 20,
        subtotal: 60000.00,
        taxableValue: 60000.00,
        igst: 10800.00,
        grossTaxCharged: 18.0,
        lineTotal: 70800.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 810000.00,
      totalGst: 145800.00,
      totalLineItemsAfterTaxes: 955800.00,
      dueBalancePayable: 955800.00,
    );

    return InvoiceData(
      invoiceNumber: 'NM/2024/889',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 45)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      paymentTerms: ['Payment: 45 days from invoice date'],
      notesFooter: 'Inter-State Supply: IGST applicable\nPlace of Supply: Telangana (36)',
    );
  }

  static InvoiceData getCompositeUnregistered() {
    final seller = BusinessDetails(
      businessName: 'Small Trader Co',
      phone: '+91 98765 11111',
      email: 'smalltrader@gmail.com',
      gstin: '',
      pan: 'SMALL1234P',
      state: 'Rajasthan',
      businessAddress: 'Local Market, Jaipur - 302001',
    );

    final buyer = BusinessDetails(
      businessName: 'Consumer Retail',
      phone: '+91 87654 22222',
      email: 'retail@consumer.com',
      gstin: '08CONSU5678R3T4',
      pan: 'CONSU5678R',
      state: 'Rajasthan',
      businessAddress: 'MI Road, Jaipur - 302001',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Plastic Containers',
          description: 'Assorted sizes',
          hsnCode: '3923',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 50.00,
        qtyOnBill: 100,
        subtotal: 5000.00,
        taxableValue: 5000.00,
        grossTaxCharged: 0.0,
        lineTotal: 5000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Kitchen Utensils',
          description: 'Stainless Steel',
          hsnCode: '7323',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 80.00,
        qtyOnBill: 50,
        subtotal: 4000.00,
        taxableValue: 4000.00,
        grossTaxCharged: 0.0,
        lineTotal: 4000.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 9000.00,
      totalGst: 0.00,
      totalLineItemsAfterTaxes: 9000.00,
      dueBalancePayable: 9000.00,
    );

    return InvoiceData(
      invoiceNumber: 'ST/2024/112',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'Composite Scheme: No GST charged\nUnregistered dealer under composition',
    );
  }

  // === DOCUMENT TYPES ===

  static InvoiceData getEstimateQuote() {
    final seller = BusinessDetails(
      businessName: 'Home Renovation Pro',
      phone: '+91 77777 88888',
      email: 'quotes@homereno.com',
      gstin: '29RENO1234H1P2',
      pan: 'RENO1234H',
      state: 'Karnataka',
      district: 'Mysore',
      businessAddress: 'Devaraja Mohalla, Mysore - 570001',
    );

    final buyer = BusinessDetails(
      businessName: 'Mr. Rajesh Kumar',
      phone: '+91 99999 00000',
      email: 'rajesh.k@email.com',
      gstin: '',
      pan: '',
      state: 'Karnataka',
      businessAddress: 'Gokulam, Mysore - 570002',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'False Ceiling Work',
          description: 'POP false ceiling - 400 sq ft',
          hsnCode: '995415',
          qtyUnit: 'Sqft',
        ),
        partyNetPrice: 120.00,
        qtyOnBill: 400,
        subtotal: 48000.00,
        taxableValue: 48000.00,
        csgst: 4320.00,
        grossTaxCharged: 18.0,
        lineTotal: 56640.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Wall Painting',
          description: 'Interior paint - Asian Paints Premium',
          hsnCode: '995414',
          qtyUnit: 'Sqft',
        ),
        partyNetPrice: 30.00,
        qtyOnBill: 1200,
        subtotal: 36000.00,
        taxableValue: 36000.00,
        csgst: 3240.00,
        grossTaxCharged: 18.0,
        lineTotal: 42480.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Electrical Wiring',
          description: 'Complete house rewiring',
          hsnCode: '995418',
          qtyUnit: 'Service',
        ),
        partyNetPrice: 25000.00,
        qtyOnBill: 1,
        subtotal: 25000.00,
        taxableValue: 25000.00,
        csgst: 2250.00,
        grossTaxCharged: 18.0,
        lineTotal: 29500.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 109000.00,
      totalGst: 19620.00,
      totalLineItemsAfterTaxes: 128620.00,
      dueBalancePayable: 128620.00,
    );

    return InvoiceData(
      invoiceNumber: 'EST-2024-056',
      invoiceMode: InvoiceMode.estimateInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 15)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      paymentTerms: ['Estimate valid for 15 days', '30% advance required'],
      notesFooter: 'This is an estimate. Final invoice will be issued upon project completion.',
    );
  }

  static InvoiceData getPurchaseOrder() {
    final seller = BusinessDetails(
      businessName: 'Industrial Supplier Co',
      phone: '+91 66666 77777',
      email: 'sales@industrialsupply.com',
      gstin: '27INDUS123S1C2',
      pan: 'INDUS123S',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Andheri MIDC, Mumbai - 400093',
    );

    final buyer = BusinessDetails(
      businessName: 'Manufacturing Unit Ltd',
      phone: '+91 55555 88888',
      email: 'procurement@mfgunit.com',
      gstin: '27MFG567U2L3',
      pan: 'MFG567U2L',
      state: 'Maharashtra',
      district: 'Thane',
      businessAddress: 'Thane MIDC, Thane - 400604',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Raw Material - Steel Sheets',
          description: 'Cold Rolled 1mm thick, 4x8 ft',
          hsnCode: '7209',
          qtyUnit: 'Sheet',
        ),
        partyNetPrice: 2500.00,
        qtyOnBill: 200,
        subtotal: 500000.00,
        taxableValue: 500000.00,
        csgst: 90000.00,
        grossTaxCharged: 18.0,
        lineTotal: 590000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Welding Electrodes',
          description: 'E7018, 3.15mm, 5kg pack',
          hsnCode: '8311',
          qtyUnit: 'Pack',
        ),
        partyNetPrice: 800.00,
        qtyOnBill: 100,
        subtotal: 80000.00,
        taxableValue: 80000.00,
        csgst: 14400.00,
        grossTaxCharged: 18.0,
        lineTotal: 94400.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 580000.00,
      totalGst: 104400.00,
      totalLineItemsAfterTaxes: 684400.00,
      dueBalancePayable: 684400.00,
    );

    return InvoiceData(
      invoiceNumber: 'PO-2024-3345',
      invoiceMode: InvoiceMode.purchaseOrderInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.credit,
      paymentTerms: ['Delivery: Within 30 days', 'Payment: Against delivery'],
      notesFooter: 'Purchase Order - Please deliver as per schedule\nQuality certificates required',
    );
  }

  static InvoiceData getCreditNote() {
    final seller = BusinessDetails(
      businessName: 'Fashion Retail Store',
      phone: '+91 44444 55555',
      email: 'returns@fashionretail.com',
      gstin: '07FASHION12R1S2',
      pan: 'FASHION12R',
      state: 'Delhi',
      businessAddress: 'Connaught Place, New Delhi - 110001',
    );

    final buyer = BusinessDetails(
      businessName: 'Customer Name',
      phone: '+91 98765 44444',
      email: 'customer@email.com',
      gstin: '',
      pan: '',
      state: 'Delhi',
      businessAddress: '',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Mens Jacket - Size L',
          description: 'Leather Jacket - Black (Returned)',
          hsnCode: '6203',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 4500.00,
        qtyOnBill: 1,
        subtotal: 4500.00,
        taxableValue: 4500.00,
        csgst: 225.00,
        grossTaxCharged: 10.0,
        lineTotal: 4950.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 4500.00,
      totalGst: 450.00,
      totalLineItemsAfterTaxes: 4950.00,
      dueBalancePayable: -4950.00,
    );

    return InvoiceData(
      invoiceNumber: 'CN-2024-0089',
      invoiceMode: InvoiceMode.creditNoteInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'Credit Note against Invoice: INV-2024-5678\nReason: Product return - size mismatch\nRefund processed',
    );
  }

  static InvoiceData getDebitNote() {
    final seller = BusinessDetails(
      businessName: 'Office Supplies Hub',
      phone: '+91 33333 66666',
      email: 'accounts@officesupplies.com',
      gstin: '24OFFICE12H1U2',
      pan: 'OFFICE12H',
      state: 'Gujarat',
      district: 'Surat',
      businessAddress: 'Ring Road, Surat - 395002',
    );

    final buyer = BusinessDetails(
      businessName: 'Corporate Solutions Ltd',
      phone: '+91 22222 77777',
      email: 'purchase@corpsolutions.com',
      gstin: '24CORP567S2L3',
      pan: 'CORP567S2',
      state: 'Gujarat',
      district: 'Ahmedabad',
      businessAddress: 'SG Highway, Ahmedabad - 380054',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Price Difference Adjustment',
          description: 'Additional charges for premium paper quality',
          hsnCode: '4802',
          qtyUnit: 'Service',
        ),
        partyNetPrice: 5000.00,
        qtyOnBill: 1,
        subtotal: 5000.00,
        taxableValue: 5000.00,
        csgst: 600.00,
        grossTaxCharged: 12.0,
        lineTotal: 5600.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 5000.00,
      totalGst: 600.00,
      totalLineItemsAfterTaxes: 5600.00,
      dueBalancePayable: 5600.00,
    );

    return InvoiceData(
      invoiceNumber: 'DN-2024-0034',
      invoiceMode: InvoiceMode.debitNoteInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'Debit Note against Invoice: INV-2024-2345\nReason: Price revision for premium quality upgrade',
    );
  }

  static InvoiceData getDeliveryChallan() {
    final seller = BusinessDetails(
      businessName: 'Warehouse Distribution',
      phone: '+91 11111 22222',
      email: 'dispatch@warehouse.com',
      gstin: '36WARE123D1C2',
      pan: 'WARE123D',
      state: 'Telangana',
      district: 'Hyderabad',
      businessAddress: 'IDA Jeedimetla, Hyderabad - 500055',
    );

    final buyer = BusinessDetails(
      businessName: 'Retail Chain Stores',
      phone: '+91 99999 33333',
      email: 'receiving@retailchain.com',
      gstin: '36RETAIL78C2S3',
      pan: 'RETAIL78C',
      state: 'Telangana',
      district: 'Secunderabad',
      businessAddress: 'SD Road, Secunderabad - 500003',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Consumer Electronics Box',
          description: 'Assorted electronics - for display',
          hsnCode: '8517',
          qtyUnit: 'Box',
        ),
        partyNetPrice: 0.00,
        qtyOnBill: 10,
        subtotal: 0.00,
        taxableValue: 0.00,
        grossTaxCharged: 0.0,
        lineTotal: 0.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Display Stands',
          description: 'Promotional display units',
          hsnCode: '9403',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 0.00,
        qtyOnBill: 5,
        subtotal: 0.00,
        taxableValue: 0.00,
        grossTaxCharged: 0.0,
        lineTotal: 0.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 0.00,
      totalGst: 0.00,
      totalLineItemsAfterTaxes: 0.00,
      dueBalancePayable: 0.00,
    );

    return InvoiceData(
      invoiceNumber: 'DC-2024-1122',
      invoiceMode: InvoiceMode.deliveryChallanInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'Delivery Challan - No commercial value\nGoods sent for display purpose\nTo be returned after exhibition',
    );
  }

  // === THERMAL/POS DEMOS ===

  static InvoiceData getRestaurantBill() {
    final seller = BusinessDetails(
      businessName: 'Tasty Bites Restaurant',
      phone: '1800-TASTY-01',
      email: 'info@tastybites.com',
      gstin: '27TASTY123R1E2',
      pan: 'TASTY123R',
      state: 'Maharashtra',
      businessAddress: 'Shop 5, Food Court, Mumbai - 400001',
    );

    final buyer = BusinessDetails(
      businessName: 'Table 12',
      phone: '',
      email: '',
      gstin: '',
      pan: '',
      state: '',
      businessAddress: '',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Paneer Butter Masala',
          description: '',
          hsnCode: '9963',
          qtyUnit: 'Plate',
        ),
        partyNetPrice: 280.00,
        qtyOnBill: 2,
        subtotal: 560.00,
        taxableValue: 560.00,
        csgst: 14.00,
        grossTaxCharged: 5.0,
        lineTotal: 588.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Dal Fry',
          description: '',
          hsnCode: '9963',
          qtyUnit: 'Plate',
        ),
        partyNetPrice: 180.00,
        qtyOnBill: 2,
        subtotal: 360.00,
        taxableValue: 360.00,
        csgst: 9.00,
        grossTaxCharged: 5.0,
        lineTotal: 378.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Butter Naan',
          description: '',
          hsnCode: '9963',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 50.00,
        qtyOnBill: 6,
        subtotal: 300.00,
        taxableValue: 300.00,
        csgst: 7.50,
        grossTaxCharged: 5.0,
        lineTotal: 315.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Veg Biryani',
          description: '',
          hsnCode: '9963',
          qtyUnit: 'Plate',
        ),
        partyNetPrice: 220.00,
        qtyOnBill: 2,
        subtotal: 440.00,
        taxableValue: 440.00,
        csgst: 11.00,
        grossTaxCharged: 5.0,
        lineTotal: 462.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Raita',
          description: '',
          hsnCode: '9963',
          qtyUnit: 'Bowl',
        ),
        partyNetPrice: 60.00,
        qtyOnBill: 2,
        subtotal: 120.00,
        taxableValue: 120.00,
        csgst: 3.00,
        grossTaxCharged: 5.0,
        lineTotal: 126.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Gulab Jamun',
          description: '',
          hsnCode: '9963',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 40.00,
        qtyOnBill: 4,
        subtotal: 160.00,
        taxableValue: 160.00,
        csgst: 4.00,
        grossTaxCharged: 5.0,
        lineTotal: 168.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Mango Lassi',
          description: '',
          hsnCode: '9963',
          qtyUnit: 'Glass',
        ),
        partyNetPrice: 80.00,
        qtyOnBill: 3,
        subtotal: 240.00,
        taxableValue: 240.00,
        csgst: 6.00,
        grossTaxCharged: 5.0,
        lineTotal: 252.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Mineral Water',
          description: '1L',
          hsnCode: '2201',
          qtyUnit: 'Bottle',
        ),
        partyNetPrice: 20.00,
        qtyOnBill: 3,
        subtotal: 60.00,
        taxableValue: 60.00,
        csgst: 5.40,
        grossTaxCharged: 18.0,
        lineTotal: 70.80,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 2240.00,
      totalGst: 119.80,
      totalLineItemsAfterTaxes: 2359.80,
      dueBalancePayable: 2359.80,
    );

    return InvoiceData(
      invoiceNumber: 'TB-2024-8834',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'Thank you for dining with us!\nVisit again!',
    );
  }

  static InvoiceData getRetailGroceryReceipt() {
    final seller = BusinessDetails(
      businessName: 'Fresh Mart Grocery',
      phone: '1800-FRESH-99',
      email: '',
      gstin: '29FRESH123G1M2',
      pan: 'FRESH123G',
      state: 'Karnataka',
      businessAddress: 'MG Road, Bangalore - 560001',
    );

    final buyer = BusinessDetails(
      businessName: 'Customer',
      phone: '',
      email: '',
      gstin: '',
      pan: '',
      state: '',
      businessAddress: '',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Tomato', description: '', hsnCode: '0702', qtyUnit: 'Kg'),
        partyNetPrice: 40.00,
        qtyOnBill: 2,
        subtotal: 80.00,
        taxableValue: 80.00,
        grossTaxCharged: 0.0,
        lineTotal: 80.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Onion', description: '', hsnCode: '0703', qtyUnit: 'Kg'),
        partyNetPrice: 35.00,
        qtyOnBill: 3,
        subtotal: 105.00,
        taxableValue: 105.00,
        grossTaxCharged: 0.0,
        lineTotal: 105.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Potato', description: '', hsnCode: '0701', qtyUnit: 'Kg'),
        partyNetPrice: 30.00,
        qtyOnBill: 5,
        subtotal: 150.00,
        taxableValue: 150.00,
        grossTaxCharged: 0.0,
        lineTotal: 150.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Milk 1L', description: 'Full Cream', hsnCode: '0401', qtyUnit: 'Pack'),
        partyNetPrice: 55.00,
        qtyOnBill: 2,
        subtotal: 110.00,
        taxableValue: 110.00,
        grossTaxCharged: 0.0,
        lineTotal: 110.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Bread', description: 'White Bread', hsnCode: '1905', qtyUnit: 'Pack'),
        partyNetPrice: 35.00,
        qtyOnBill: 2,
        subtotal: 70.00,
        taxableValue: 70.00,
        grossTaxCharged: 0.0,
        lineTotal: 70.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Eggs', description: 'Farm Fresh', hsnCode: '0407', qtyUnit: 'Tray'),
        partyNetPrice: 60.00,
        qtyOnBill: 1,
        subtotal: 60.00,
        taxableValue: 60.00,
        grossTaxCharged: 0.0,
        lineTotal: 60.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Biscuits', description: 'Marie', hsnCode: '1905', qtyUnit: 'Pack'),
        partyNetPrice: 30.00,
        qtyOnBill: 3,
        subtotal: 90.00,
        taxableValue: 90.00,
        csgst: 8.10,
        grossTaxCharged: 18.0,
        lineTotal: 106.20,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Soap', description: 'Bath Soap 100g', hsnCode: '3401', qtyUnit: 'Pcs'),
        partyNetPrice: 40.00,
        qtyOnBill: 4,
        subtotal: 160.00,
        taxableValue: 160.00,
        csgst: 14.40,
        grossTaxCharged: 18.0,
        lineTotal: 188.80,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Shampoo', description: '200ml', hsnCode: '3305', qtyUnit: 'Bottle'),
        partyNetPrice: 120.00,
        qtyOnBill: 1,
        subtotal: 120.00,
        taxableValue: 120.00,
        csgst: 10.80,
        grossTaxCharged: 18.0,
        lineTotal: 141.60,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(name: 'Toothpaste', description: '150g', hsnCode: '3306', qtyUnit: 'Tube'),
        partyNetPrice: 85.00,
        qtyOnBill: 2,
        subtotal: 170.00,
        taxableValue: 170.00,
        csgst: 15.30,
        grossTaxCharged: 18.0,
        lineTotal: 200.30,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 1115.00,
      totalGst: 96.90,
      totalLineItemsAfterTaxes: 1211.90,
      dueBalancePayable: 1211.90,
    );

    return InvoiceData(
      invoiceNumber: 'FM-8923',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.upi,
      notesFooter: 'Thanks for shopping!\nSave this bill for returns',
    );
  }

  // === EDGE CASES ===

  static InvoiceData getStressTestManyItems() {
    final seller = BusinessDetails(
      businessName: 'Mega Electronics Superstore - Premium Gadgets & Accessories Division',
      phone: '+91 22 4567 8901',
      email: 'sales@megaelectronics.verylongdomainname.com',
      gstin: '27MEGAELEC123X1Y2',
      pan: 'MEGAELEC123X',
      state: 'Maharashtra',
      district: 'Mumbai Suburban',
      businessAddress: 'Plot No. 456, Very Long Street Name Road, Near Famous Landmark, Andheri West Industrial Area, Mumbai - 400053',
    );

    final buyer = BusinessDetails(
      businessName: 'Corporate Enterprises International Business Solutions Private Limited',
      phone: '+91 11 9876 5432',
      email: 'procurement.department@corporateenterprises.internationalbusiness.co.in',
      gstin: '07CORP567ENT2E3R4',
      pan: 'CORP567ENT2',
      state: 'Delhi',
      district: 'New Delhi Central',
      businessAddress: 'Office Tower 7, Floor 12, Wing B, Business Complex Delta, Extremely Long Address Street Name, Connaught Place Extension, New Delhi - 110001',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Samsung Galaxy Premium Smartphone 256GB Midnight Black with Extended Warranty',
          description: 'Latest model with all accessories and protective case included',
          hsnCode: '85171200',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 45000.00,
        qtyOnBill: 10,
        subtotal: 450000.00,
        taxableValue: 450000.00,
        csgst: 40500.00,
        grossTaxCharged: 18.0,
        lineTotal: 531000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Apple MacBook Pro 16-inch M3 Pro Chip 512GB SSD Space Gray Professional Edition',
          description: 'Top-of-the-line laptop for professional use',
          hsnCode: '84713010',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 250000.00,
        qtyOnBill: 5,
        subtotal: 1250000.00,
        taxableValue: 1250000.00,
        csgst: 112500.00,
        grossTaxCharged: 18.0,
        lineTotal: 1475000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Sony Professional Noise Cancelling Wireless Headphones WH-1000XM5 Premium',
          description: 'Industry-leading noise cancellation technology',
          hsnCode: '85183000',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 28000.00,
        qtyOnBill: 15,
        subtotal: 420000.00,
        taxableValue: 420000.00,
        csgst: 37800.00,
        grossTaxCharged: 18.0,
        lineTotal: 495600.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Dell UltraSharp 27-inch 4K USB-C Monitor U2723DE Professional Display',
          description: 'Perfect for design professionals',
          hsnCode: '85285200',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 55000.00,
        qtyOnBill: 8,
        subtotal: 440000.00,
        taxableValue: 440000.00,
        csgst: 39600.00,
        grossTaxCharged: 18.0,
        lineTotal: 519600.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Logitech MX Master 3S Wireless Performance Mouse for Business Professionals',
          description: 'Ergonomic design with precision scrolling',
          hsnCode: '85176290',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 8500.00,
        qtyOnBill: 20,
        subtotal: 170000.00,
        discountPercentage: 10.0,
        discountAmt: 17000.00,
        taxableValue: 153000.00,
        csgst: 13770.00,
        grossTaxCharged: 18.0,
        lineTotal: 180540.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Keychron K8 Pro Wireless Mechanical Keyboard RGB Backlit Hot-swappable',
          description: 'Premium mechanical switches with customization',
          hsnCode: '84716060',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 12000.00,
        qtyOnBill: 20,
        subtotal: 240000.00,
        taxableValue: 240000.00,
        csgst: 21600.00,
        grossTaxCharged: 18.0,
        lineTotal: 283200.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'SanDisk Extreme Pro 1TB Portable External SSD USB-C High-Speed Storage',
          description: 'Read speeds up to 1050MB/s',
          hsnCode: '84717050',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 14000.00,
        qtyOnBill: 12,
        subtotal: 168000.00,
        taxableValue: 168000.00,
        csgst: 15120.00,
        grossTaxCharged: 18.0,
        lineTotal: 198240.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Anker PowerCore 20000mAh Ultra-High Capacity Portable Charger Power Bank',
          description: 'Fast charging with multiple ports',
          hsnCode: '85076000',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 4500.00,
        qtyOnBill: 25,
        subtotal: 112500.00,
        discountPercentage: 5.0,
        discountAmt: 5625.00,
        taxableValue: 106875.00,
        csgst: 9618.75,
        grossTaxCharged: 18.0,
        lineTotal: 126112.50,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Belkin USB-C 11-in-1 Multiport Docking Station with Dual 4K Display Support',
          description: 'Complete connectivity solution',
          hsnCode: '85176290',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 22000.00,
        qtyOnBill: 10,
        subtotal: 220000.00,
        taxableValue: 220000.00,
        csgst: 19800.00,
        grossTaxCharged: 18.0,
        lineTotal: 259800.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'APC Back-UPS Pro 1500VA/900W Battery Backup & Surge Protector UPS',
          description: 'Reliable power protection',
          hsnCode: '85044020',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 18000.00,
        qtyOnBill: 15,
        subtotal: 270000.00,
        taxableValue: 270000.00,
        csgst: 24300.00,
        grossTaxCharged: 18.0,
        lineTotal: 318600.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'TP-Link AX6000 WiFi 6 Router - Next-Gen Gigabit Wireless Internet Router',
          description: '8-stream dual-band router with OFDMA',
          hsnCode: '85176200',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 16000.00,
        qtyOnBill: 10,
        subtotal: 160000.00,
        taxableValue: 160000.00,
        csgst: 14400.00,
        grossTaxCharged: 18.0,
        lineTotal: 188800.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Seagate IronWolf Pro 8TB NAS Hard Drive 7200 RPM Enterprise Grade HDD',
          description: 'Designed for 24/7 operation',
          hsnCode: '84717050',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 24000.00,
        qtyOnBill: 8,
        subtotal: 192000.00,
        taxableValue: 192000.00,
        csgst: 17280.00,
        grossTaxCharged: 18.0,
        lineTotal: 226560.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Blue Yeti Professional USB Microphone for Recording, Streaming, Gaming',
          description: 'Studio-quality sound',
          hsnCode: '85181000',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 12500.00,
        qtyOnBill: 12,
        subtotal: 150000.00,
        taxableValue: 150000.00,
        csgst: 13500.00,
        grossTaxCharged: 18.0,
        lineTotal: 177000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Elgato Stream Deck XL Advanced Controller with 32 Customizable LCD Keys',
          description: 'For content creators',
          hsnCode: '84716060',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 28000.00,
        qtyOnBill: 6,
        subtotal: 168000.00,
        discountPercentage: 8.0,
        discountAmt: 13440.00,
        taxableValue: 154560.00,
        csgst: 13910.40,
        grossTaxCharged: 18.0,
        lineTotal: 182380.80,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'HDMI 2.1 Ultra High Speed Cable 8K 60Hz 4K 120Hz - 2 Meter Certified',
          description: 'Premium braided cable',
          hsnCode: '85444290',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 1500.00,
        qtyOnBill: 50,
        subtotal: 75000.00,
        taxableValue: 75000.00,
        csgst: 6750.00,
        grossTaxCharged: 18.0,
        lineTotal: 88500.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 4649435.00,
      totalDiscount: 36065.00,
      totalGst: 836049.15,
      totalLineItemsAfterTaxes: 5485484.15,
      dueBalancePayable: 5485484.15,
    );

    final bankDetails = BankingDetails(
      bankName: 'HDFC Bank Limited',
      accountNo: '50200012345678',
      ifsc: 'HDFC0001234',
      accountHolderName: 'Mega Electronics Superstore Pvt Ltd',
      upi: 'megaelectronics@hdfcbank',
      branchAddress: 'Andheri West Branch, Mumbai',
    );

    return InvoiceData(
      invoiceNumber: 'MEGA/2024/CORP/9999',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 60)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      paymentTerms: [
        'Payment Terms: Net 60 days from invoice date',
        'Late payment will attract interest @ 2% per month',
        'Bulk order discount: 5-10% applied on select items',
      ],
      notesFooter:
          'Terms & Conditions:\n1. All products come with manufacturer warranty\n2. Installation and training support available on request\n3. Goods once sold will not be taken back except for manufacturing defects\n4. Subject to Mumbai jurisdiction for any disputes\n5. This is a computer-generated invoice and requires no signature\n\nFor any queries, please contact our support team.',
      bankDetails: bankDetails,
    );
  }

  static InvoiceData getPartialPaymentScenario() {
    final seller = BusinessDetails(
      businessName: 'Building Materials Co',
      phone: '+91 99999 44444',
      email: 'sales@buildingmaterials.com',
      gstin: '09BUILD123M1C2',
      pan: 'BUILD123M',
      state: 'Uttar Pradesh',
      district: 'Lucknow',
      businessAddress: 'Industrial Area, Lucknow - 226003',
    );

    final buyer = BusinessDetails(
      businessName: 'Construction Ventures Pvt Ltd',
      phone: '+91 88888 55555',
      email: 'accounts@constructionventures.com',
      gstin: '09CONST567V2L3',
      pan: 'CONST567V',
      state: 'Uttar Pradesh',
      district: 'Lucknow',
      businessAddress: 'Gomti Nagar, Lucknow - 226010',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Cement - OPC 53 Grade',
          description: 'ACC Brand - 50kg bags',
          hsnCode: '2523',
          qtyUnit: 'Bag',
        ),
        partyNetPrice: 400.00,
        qtyOnBill: 500,
        subtotal: 200000.00,
        taxableValue: 200000.00,
        csgst: 18000.00,
        grossTaxCharged: 18.0,
        lineTotal: 236000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Steel TMT Bars - 12mm',
          description: 'Fe 500D Grade',
          hsnCode: '7214',
          qtyUnit: 'Ton',
        ),
        partyNetPrice: 55000.00,
        qtyOnBill: 10,
        subtotal: 550000.00,
        taxableValue: 550000.00,
        csgst: 49500.00,
        grossTaxCharged: 18.0,
        lineTotal: 649000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Sand - River Sand',
          description: 'M-Sand alternative',
          hsnCode: '2505',
          qtyUnit: 'Ton',
        ),
        partyNetPrice: 800.00,
        qtyOnBill: 100,
        subtotal: 80000.00,
        taxableValue: 80000.00,
        csgst: 400.00,
        grossTaxCharged: 1.0,
        lineTotal: 80800.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 830000.00,
      totalGst: 135800.00,
      totalLineItemsAfterTaxes: 965800.00,
      dueBalancePayable: 465800.00,
    );

    final bankDetails = BankingDetails(
      bankName: 'Punjab National Bank',
      accountNo: '1234567890123456',
      ifsc: 'PUNB0123400',
      accountHolderName: 'Building Materials Co',
      upi: 'buildmat@pnb',
      branchAddress: 'Hazratganj, Lucknow',
    );

    return InvoiceData(
      invoiceNumber: 'BMC/2024/556',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 20)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      paymentTerms: [
        'Total Amount: ₹965,800.00',
        'Paid: ₹500,000.00 (Advance)',
        'Balance Due: ₹465,800.00',
        'Balance payable within 20 days',
      ],
      notesFooter: 'Partial Payment Received.\nBalance payment required before delivery of remaining material.',
      bankDetails: bankDetails,
    );
  }

  static InvoiceData getMinimalDataInvoice() {
    final seller = BusinessDetails(
      businessName: 'QuickBiz',
      phone: '9876543210',
      email: '',
      gstin: '',
      pan: '',
      state: '',
      businessAddress: '',
    );

    final buyer = BusinessDetails(
      businessName: 'Customer',
      phone: '',
      email: '',
      gstin: '',
      pan: '',
      state: '',
      businessAddress: '',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Item A',
          description: '',
          hsnCode: '',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 100.00,
        qtyOnBill: 5,
        subtotal: 500.00,
        taxableValue: 500.00,
        grossTaxCharged: 0.0,
        lineTotal: 500.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Item B',
          description: '',
          hsnCode: '',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 200.00,
        qtyOnBill: 3,
        subtotal: 600.00,
        taxableValue: 600.00,
        grossTaxCharged: 0.0,
        lineTotal: 600.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 1100.00,
      totalGst: 0.00,
      totalLineItemsAfterTaxes: 1100.00,
      dueBalancePayable: 1100.00,
    );

    return InvoiceData(
      invoiceNumber: '001',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: '',
    );
  }

  // === NOTES & TERMS CONDITIONS TESTING ===

  static InvoiceData _getNotesTermsTestBase({
    required String schemaLabel,
    String? notes,
    List<String> paymentTerms = const [],
  }) {
    final seller = BusinessDetails(
      businessName: 'Test Company Pvt Ltd',
      phone: '+91 98765 43210',
      email: 'test@company.com',
      gstin: '27TEST1234C1D2',
      pan: 'TEST1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Test Address, Mumbai - 400001',
    );

    final buyer = BusinessDetails(
      businessName: 'Customer Company Ltd',
      phone: '+91 87654 32109',
      email: 'customer@company.com',
      gstin: '27CUST5678D2E3',
      pan: 'CUST5678D',
      state: 'Maharashtra',
      district: 'Pune',
      businessAddress: 'Customer Address, Pune - 411001',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Test Product A',
          description: 'Sample product for template testing',
          hsnCode: '84713010',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 10000.00,
        qtyOnBill: 5,
        subtotal: 50000.00,
        taxableValue: 50000.00,
        csgst: 4500.00,
        grossTaxCharged: 18.0,
        lineTotal: 59000.00,
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Test Product B',
          description: 'Another sample product',
          hsnCode: '85171200',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 5000.00,
        qtyOnBill: 10,
        subtotal: 50000.00,
        taxableValue: 50000.00,
        csgst: 4500.00,
        grossTaxCharged: 18.0,
        lineTotal: 59000.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 100000.00,
      totalGst: 18000.00,
      totalLineItemsAfterTaxes: 118000.00,
      dueBalancePayable: 118000.00,
    );

    return InvoiceData(
      invoiceNumber: 'TEST-$schemaLabel',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: notes ?? '',
      paymentTerms: paymentTerms,
    );
  }

  // === TALLY SCHEMA TESTS (MBBook Tally, Tally Professional) ===

  static InvoiceData getTallySchemaWithNotes() => _getNotesTermsTestBase(
        schemaLabel: 'TALLY-NOTES',
        notes: 'NOTES: Testing Tally schema with notes only.\n'
            'This should appear in the footer section.\n'
            'Verify proper layout and spacing.',
      );

  static InvoiceData getTallySchemaWithTerms() => _getNotesTermsTestBase(
        schemaLabel: 'TALLY-TERMS',
        paymentTerms: [
          'Payment due within 30 days',
          'Late payment charges: 2% per month',
          'Subject to Mumbai jurisdiction',
        ],
      );

  static InvoiceData getTallySchemaWithBoth() => _getNotesTermsTestBase(
        schemaLabel: 'TALLY-BOTH',
        notes: 'NOTES: Testing Tally schema with both notes and terms.\n'
            'Notes section should display alongside terms & conditions.\n'
            'Verify proper row/column layout.',
        paymentTerms: [
          'Payment Terms: Net 30 days',
          'Goods once sold will not be taken back',
          'Subject to Mumbai jurisdiction',
          'E&OE (Errors and Omissions Excepted)',
        ],
      );

  static InvoiceData getTallySchemaWithNone() => _getNotesTermsTestBase(
        schemaLabel: 'TALLY-NONE',
      );

  // === MODERN SCHEMA TESTS (MBBook Stylish, Modern Elite) ===

  static InvoiceData getModernSchemaWithNotes() => _getNotesTermsTestBase(
        schemaLabel: 'MODERN-NOTES',
        notes: 'NOTES: Testing Modern schema with notes only.\n'
            'Modern templates typically have cleaner layouts.\n'
            'Verify that notes appear prominently.',
      );

  static InvoiceData getModernSchemaWithTerms() => _getNotesTermsTestBase(
        schemaLabel: 'MODERN-TERMS',
        paymentTerms: [
          'Payment due within 30 days from invoice date',
          'Late payment will attract 2% monthly interest',
          'Delivery within 15 business days',
          'Warranty as per manufacturer terms',
        ],
      );

  static InvoiceData getModernSchemaWithBoth() => _getNotesTermsTestBase(
        schemaLabel: 'MODERN-BOTH',
        notes: 'NOTES: Testing Modern schema with both notes and T&C.\n'
            'Modern templates should display both sections elegantly.\n'
            'Verify alignment and visual hierarchy.',
        paymentTerms: [
          'Payment Terms: Net 30 days',
          'Bank charges borne by the buyer',
          'All disputes subject to Mumbai jurisdiction',
          'Goods remain our property until full payment',
        ],
      );

  static InvoiceData getModernSchemaWithNone() => _getNotesTermsTestBase(
        schemaLabel: 'MODERN-NONE',
      );

  // === A5/THERMAL SCHEMA TESTS (A5 Compact, Thermal) ===

  static InvoiceData getA5ThermalSchemaWithNotes() => _getNotesTermsTestBase(
        schemaLabel: 'A5-NOTES',
        notes: 'NOTES: Testing A5/Thermal with notes.\n'
            'These formats are typically space-constrained.\n'
            'Verify compact yet readable display.',
      );

  static InvoiceData getA5ThermalSchemaWithTerms() => _getNotesTermsTestBase(
        schemaLabel: 'A5-TERMS',
        paymentTerms: [
          'Payment due within 15 days',
          'No returns without prior approval',
          'Thank you for your business!',
        ],
      );

  static InvoiceData getA5ThermalSchemaWithBoth() => _getNotesTermsTestBase(
        schemaLabel: 'A5-BOTH',
        notes: 'NOTES: Testing A5/Thermal with both.\n'
            'Space is limited in these formats.\n'
            'Verify proper text wrapping.',
        paymentTerms: [
          'Payment: Cash/UPI/Card accepted',
          'Exchange within 7 days with receipt',
          'Visit again!',
        ],
      );

  static InvoiceData getA5ThermalSchemaWithNone() => _getNotesTermsTestBase(
        schemaLabel: 'A5-NONE',
      );

  static List<InvoiceData> getNotesAndTermsTestingInvoices() {
    return [
      // Tally Schema Tests
      getTallySchemaWithNotes(),
      getTallySchemaWithTerms(),
      getTallySchemaWithBoth(),
      getTallySchemaWithNone(),
      // Modern Schema Tests
      getModernSchemaWithNotes(),
      getModernSchemaWithTerms(),
      getModernSchemaWithBoth(),
      getModernSchemaWithNone(),
      // A5/Thermal Schema Tests
      getA5ThermalSchemaWithNotes(),
      getA5ThermalSchemaWithTerms(),
      getA5ThermalSchemaWithBoth(),
      getA5ThermalSchemaWithNone(),
    ];
  }

  // ========================================================================
  // CUSTOM FIELDS TESTING DEMOS (Phase 3)
  // ========================================================================

  // === ITEM CUSTOM FIELDS TESTS (4 demos) ===

  static InvoiceData getItemCustomFieldsBasic() {
    final seller = BusinessDetails(
      businessName: 'TechMart Electronics',
      phone: '+91 98765 43210',
      email: 'info@techmart.com',
      gstin: '27TECH1234C1D2',
      pan: 'TECH1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Shop 5, Tech Plaza, Mumbai - 400001',
    );

    final buyer = BusinessDetails(
      businessName: 'Customer ABC Ltd',
      phone: '+91 87654 32109',
      email: 'purchase@abc.com',
      gstin: '27CUST5678D2E3',
      pan: 'CUST5678D',
      state: 'Maharashtra',
      district: 'Pune',
      businessAddress: 'Plot 12, Industrial Area, Pune - 411001',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Laptop - Dell Inspiron',
          description: '15.6" FHD Display, 8GB RAM, 512GB SSD',
          hsnCode: '84713010',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 45000.00,
        qtyOnBill: 2,
        subtotal: 90000.00,
        taxableValue: 90000.00,
        csgst: 8100.00,
        grossTaxCharged: 18.0,
        lineTotal: 106200.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Warranty',
            fieldType: 'text',
            value: '3 Years',
            displayOrder: 1,
            isRequired: false,
          ),
          CustomFieldValue(
            fieldName: 'Serial No',
            fieldType: 'text',
            value: 'SN12345ABC',
            displayOrder: 2,
            isRequired: false,
          ),
        ],
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Wireless Mouse',
          description: 'Logitech M331',
          hsnCode: '84716060',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 600.00,
        qtyOnBill: 5,
        subtotal: 3000.00,
        taxableValue: 3000.00,
        csgst: 270.00,
        grossTaxCharged: 18.0,
        lineTotal: 3540.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Color',
            fieldType: 'select',
            value: 'Black',
            displayOrder: 1,
            isRequired: false,
          ),
        ],
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 93000.00,
      totalGst: 16740.00,
      totalLineItemsAfterTaxes: 109740.00,
      dueBalancePayable: 109740.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-ITEM-BASIC',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'TEST: Item custom fields - Basic (1-2 fields, text types)',
    );
  }

  static InvoiceData getItemCustomFieldsMultiple() {
    final seller = BusinessDetails(
      businessName: 'Gold Palace Jewellers',
      phone: '+91 22 2345 6789',
      email: 'sales@goldpalace.com',
      gstin: '27GOLD1234C1D2',
      pan: 'GOLD1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: '123 Zaveri Bazaar, Mumbai - 400002',
    );

    final buyer = BusinessDetails(
      businessName: 'Mrs. Priya Sharma',
      phone: '+91 98765 00000',
      email: '',
      gstin: '',
      pan: '',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Bandra West, Mumbai - 400050',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Gold Necklace',
          description: '22K Gold',
          hsnCode: '71131910',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 125000.00,
        qtyOnBill: 1,
        subtotal: 125000.00,
        taxableValue: 125000.00,
        csgst: 1500.00,
        grossTaxCharged: 3.0,
        lineTotal: 128750.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'HUID',
            fieldType: 'text',
            value: '22K916ABC123',
            displayOrder: 1,
            isRequired: true,
          ),
          CustomFieldValue(
            fieldName: 'Weight',
            fieldType: 'number',
            value: 45.5,
            displayOrder: 2,
            isRequired: true,
          ),
          CustomFieldValue(
            fieldName: 'Purity',
            fieldType: 'select',
            value: '22K - 916',
            displayOrder: 3,
            isRequired: true,
          ),
          CustomFieldValue(
            fieldName: 'Certified',
            fieldType: 'boolean',
            value: true,
            displayOrder: 4,
            isRequired: false,
          ),
          CustomFieldValue(
            fieldName: 'Certificate Date',
            fieldType: 'date',
            value: DateTime(2025, 10, 15),
            displayOrder: 5,
            isRequired: false,
          ),
        ],
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 125000.00,
      totalGst: 3750.00,
      totalLineItemsAfterTaxes: 128750.00,
      dueBalancePayable: 128750.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-ITEM-MULTI',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'TEST: Item custom fields - Multiple (5 fields, all types)',
    );
  }

  static InvoiceData getItemCustomFieldsMixed() {
    final seller = BusinessDetails(
      businessName: 'Pharma Plus Distributors',
      phone: '+91 22 2222 3333',
      email: 'orders@pharmaplus.com',
      gstin: '27PHAR1234C1D2',
      pan: 'PHAR1234C',
      state: 'Maharashtra',
      district: 'Thane',
      businessAddress: 'Medical Complex, Thane - 400601',
    );

    final buyer = BusinessDetails(
      businessName: 'City Hospital',
      phone: '+91 22 3333 4444',
      email: 'purchase@cityhospital.com',
      gstin: '27HOSP5678D2E3',
      pan: 'HOSP5678D',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Central Mumbai - 400012',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Paracetamol 500mg',
          description: 'Fever relief tablets',
          hsnCode: '30049099',
          qtyUnit: 'Strip',
        ),
        partyNetPrice: 15.00,
        qtyOnBill: 100,
        subtotal: 1500.00,
        taxableValue: 1500.00,
        csgst: 90.00,
        grossTaxCharged: 12.0,
        lineTotal: 1680.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Batch No',
            fieldType: 'text',
            value: 'BTH2025001',
            displayOrder: 1,
            isRequired: true,
          ),
          CustomFieldValue(
            fieldName: 'Expiry Date',
            fieldType: 'date',
            value: DateTime(2027, 12, 31),
            displayOrder: 2,
            isRequired: true,
          ),
          CustomFieldValue(
            fieldName: 'MRP',
            fieldType: 'number',
            value: 20.00,
            displayOrder: 3,
            isRequired: false,
          ),
        ],
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Surgical Gloves',
          description: 'Latex free, powder free',
          hsnCode: '40151900',
          qtyUnit: 'Box',
        ),
        partyNetPrice: 250.00,
        qtyOnBill: 10,
        subtotal: 2500.00,
        taxableValue: 2500.00,
        csgst: 225.00,
        grossTaxCharged: 18.0,
        lineTotal: 2950.00,
        // NO custom fields for this item
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Hand Sanitizer',
          description: '500ml bottle',
          hsnCode: '33074900',
          qtyUnit: 'Bottle',
        ),
        partyNetPrice: 80.00,
        qtyOnBill: 50,
        subtotal: 4000.00,
        taxableValue: 4000.00,
        csgst: 360.00,
        grossTaxCharged: 18.0,
        lineTotal: 4720.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Alcohol %',
            fieldType: 'number',
            value: 70.0,
            displayOrder: 1,
            isRequired: false,
          ),
        ],
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 8000.00,
      totalGst: 1350.00,
      totalLineItemsAfterTaxes: 9350.00,
      dueBalancePayable: 9350.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-ITEM-MIXED',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 15)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'TEST: Item custom fields - Mixed (some items with fields, some without)',
    );
  }

  static InvoiceData getItemCustomFieldsEdgeCase() {
    final seller = BusinessDetails(
      businessName: 'Industrial Components & Supplies Co.',
      phone: '+91 22 5555 6666',
      email: 'info@industrialcomponents.com',
      gstin: '27INDU1234C1D2',
      pan: 'INDU1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'MIDC Industrial Estate, Andheri East, Mumbai - 400093',
    );

    final buyer = BusinessDetails(
      businessName: 'Manufacturing Unit #7',
      phone: '+91 22 6666 7777',
      email: '',
      gstin: '27MANU5678D2E3',
      pan: 'MANU5678D',
      state: 'Maharashtra',
      district: 'Thane',
      businessAddress: 'Plot 15/A, MIDC Area, Thane - 400710',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Specialized Bearing Assembly',
          description: 'High-precision industrial grade bearing with extended specifications',
          hsnCode: '84821000',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 5000.00,
        qtyOnBill: 5,
        subtotal: 25000.00,
        taxableValue: 25000.00,
        csgst: 2250.00,
        grossTaxCharged: 18.0,
        lineTotal: 29500.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Very Long Field Name That Tests Layout Boundaries',
            fieldType: 'text',
            value: r'This is a very long value string that contains special characters like @#$%^&*() and tests how the PDF handles extended text content that might wrap or overflow in constrained layouts',
            displayOrder: 1,
            isRequired: false,
          ),
          CustomFieldValue(
            fieldName: 'Unicode Test',
            fieldType: 'text',
            value: 'Test: हिंदी, ગુજરાતી, தமிழ், 中文, العربية',
            displayOrder: 2,
            isRequired: false,
          ),
          CustomFieldValue(
            fieldName: 'Special Chars',
            fieldType: 'text',
            value: r'Symbols: °C, ±5%, µm, ≤10mm, €/$£¥',
            displayOrder: 3,
            isRequired: false,
          ),
        ],
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 25000.00,
      totalGst: 4500.00,
      totalLineItemsAfterTaxes: 29500.00,
      dueBalancePayable: 29500.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-ITEM-EDGE',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'TEST: Item custom fields - Edge Cases (long names/values, special characters, Unicode)',
    );
  }

  // === BUSINESS CUSTOM FIELDS TESTS (4 demos) ===

  static InvoiceData getBusinessCustomFieldsSeller() {
    final seller = BusinessDetails(
      businessName: 'Premium Exports International',
      phone: '+91 22 7777 8888',
      email: 'exports@premium.com',
      gstin: '27PREM1234C1D2',
      pan: 'PREM1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Export House, Nariman Point, Mumbai - 400021',
      customFields: [
        CustomFieldValue(
          fieldName: 'IEC Code',
          fieldType: 'text',
          value: 'IEC0515012345',
          displayOrder: 1,
          isRequired: true,
        ),
        CustomFieldValue(
          fieldName: 'Export License',
          fieldType: 'text',
          value: 'EXP/2025/12345',
          displayOrder: 2,
          isRequired: true,
        ),
        CustomFieldValue(
          fieldName: 'ISO Certified',
          fieldType: 'boolean',
          value: true,
          displayOrder: 3,
          isRequired: false,
        ),
      ],
    );

    final buyer = BusinessDetails(
      businessName: 'Regular Customer Ltd',
      phone: '+91 22 8888 9999',
      email: 'purchase@regular.com',
      gstin: '27REGU5678D2E3',
      pan: 'REGU5678D',
      state: 'Maharashtra',
      district: 'Pune',
      businessAddress: 'Pune - 411001',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Export Quality Fabric',
          description: 'Cotton blend, 100 meters roll',
          hsnCode: '52081100',
          qtyUnit: 'Roll',
        ),
        partyNetPrice: 15000.00,
        qtyOnBill: 10,
        subtotal: 150000.00,
        taxableValue: 150000.00,
        csgst: 7500.00,
        grossTaxCharged: 5.0,
        lineTotal: 157500.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 150000.00,
      totalGst: 15000.00,
      totalLineItemsAfterTaxes: 165000.00,
      dueBalancePayable: 165000.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-BIZ-SELLER',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 45)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'TEST: Business custom fields - Seller only',
    );
  }

  static InvoiceData getBusinessCustomFieldsBuyer() {
    final seller = BusinessDetails(
      businessName: 'Standard Suppliers Co',
      phone: '+91 22 1111 2222',
      email: 'sales@standard.com',
      gstin: '27STAN1234C1D2',
      pan: 'STAN1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Mumbai - 400001',
    );

    final buyer = BusinessDetails(
      businessName: 'Corporate Client Pvt Ltd',
      phone: '+91 22 3333 4444',
      email: 'accounts@corporate.com',
      gstin: '27CORP5678D2E3',
      pan: 'CORP5678D',
      state: 'Maharashtra',
      district: 'Pune',
      businessAddress: 'Corporate Tower, Pune - 411014',
      customFields: [
        CustomFieldValue(
          fieldName: 'Customer Code',
          fieldType: 'text',
          value: 'CUST-2025-1234',
          displayOrder: 1,
          isRequired: true,
        ),
        CustomFieldValue(
          fieldName: 'Credit Limit',
          fieldType: 'number',
          value: 500000.00,
          displayOrder: 2,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'Payment Terms',
          fieldType: 'select',
          value: 'Net 45 days',
          displayOrder: 3,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'Delivery Instructions',
          fieldType: 'text',
          value: 'Loading Bay 3, Weekdays 9AM-5PM only',
          displayOrder: 4,
          isRequired: false,
        ),
      ],
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Office Supplies Bundle',
          description: 'Stationery kit for corporate office',
          hsnCode: '48201090',
          qtyUnit: 'Set',
        ),
        partyNetPrice: 5000.00,
        qtyOnBill: 5,
        subtotal: 25000.00,
        taxableValue: 25000.00,
        csgst: 2250.00,
        grossTaxCharged: 18.0,
        lineTotal: 29500.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 25000.00,
      totalGst: 4500.00,
      totalLineItemsAfterTaxes: 29500.00,
      dueBalancePayable: 29500.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-BIZ-BUYER',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 45)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'TEST: Business custom fields - Buyer only',
    );
  }

  static InvoiceData getBusinessCustomFieldsBoth() {
    final seller = BusinessDetails(
      businessName: 'Certified Traders & Co',
      phone: '+91 22 4444 5555',
      email: 'info@certified.com',
      gstin: '27CERT1234C1D2',
      pan: 'CERT1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Trade Center, Mumbai - 400013',
      customFields: [
        CustomFieldValue(
          fieldName: 'MSME Registration',
          fieldType: 'text',
          value: 'UDYAM-MH-12-3456789',
          displayOrder: 1,
          isRequired: true,
        ),
        CustomFieldValue(
          fieldName: 'TAN',
          fieldType: 'text',
          value: 'CERT1234D',
          displayOrder: 2,
          isRequired: false,
        ),
      ],
    );

    final buyer = BusinessDetails(
      businessName: 'Partner Enterprises Ltd',
      phone: '+91 22 5555 6666',
      email: 'purchase@partner.com',
      gstin: '27PART5678D2E3',
      pan: 'PART5678D',
      state: 'Maharashtra',
      district: 'Thane',
      businessAddress: 'Business Park, Thane - 400607',
      customFields: [
        CustomFieldValue(
          fieldName: 'Account Manager',
          fieldType: 'text',
          value: 'Mr. Rajesh Kumar',
          displayOrder: 1,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'Territory',
          fieldType: 'select',
          value: 'West Zone',
          displayOrder: 2,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'VIP Customer',
          fieldType: 'boolean',
          value: true,
          displayOrder: 3,
          isRequired: false,
        ),
      ],
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Enterprise Software License',
          description: 'Annual subscription',
          hsnCode: '98314',
          qtyUnit: 'License',
        ),
        partyNetPrice: 50000.00,
        qtyOnBill: 1,
        subtotal: 50000.00,
        taxableValue: 50000.00,
        csgst: 4500.00,
        grossTaxCharged: 18.0,
        lineTotal: 59000.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 50000.00,
      totalGst: 9000.00,
      totalLineItemsAfterTaxes: 59000.00,
      dueBalancePayable: 59000.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-BIZ-BOTH',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'TEST: Business custom fields - Both seller and buyer',
    );
  }

  static InvoiceData getBusinessCustomFieldsAllTypes() {
    final seller = BusinessDetails(
      businessName: 'All Fields Demo Company',
      phone: '+91 22 6666 7777',
      email: 'demo@allfields.com',
      gstin: '27DEMO1234C1D2',
      pan: 'DEMO1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Demo Plaza, Mumbai - 400001',
      customFields: [
        CustomFieldValue(
          fieldName: 'Text Field',
          fieldType: 'text',
          value: 'Sample text value',
          displayOrder: 1,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'Number Field',
          fieldType: 'number',
          value: 12345.67,
          displayOrder: 2,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'Date Field',
          fieldType: 'date',
          value: DateTime(2025, 10, 31),
          displayOrder: 3,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'Boolean Field',
          fieldType: 'boolean',
          value: true,
          displayOrder: 4,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'Select Field',
          fieldType: 'select',
          value: 'Option A',
          displayOrder: 5,
          isRequired: false,
        ),
        CustomFieldValue(
          fieldName: 'Multiselect Field',
          fieldType: 'multiselect',
          value: ['Choice 1', 'Choice 2', 'Choice 3'],
          displayOrder: 6,
          isRequired: false,
        ),
      ],
    );

    final buyer = BusinessDetails(
      businessName: 'All Types Customer',
      phone: '+91 22 7777 8888',
      email: '',
      gstin: '',
      pan: '',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Mumbai - 400050',
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Demo Product',
          description: 'For testing all field types',
          hsnCode: '00000000',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 10000.00,
        qtyOnBill: 1,
        subtotal: 10000.00,
        taxableValue: 10000.00,
        csgst: 900.00,
        grossTaxCharged: 18.0,
        lineTotal: 11800.00,
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 10000.00,
      totalGst: 1800.00,
      totalLineItemsAfterTaxes: 11800.00,
      dueBalancePayable: 11800.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-BIZ-ALLTYPES',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'TEST: Business custom fields - All 6 field types',
    );
  }

  // === COMBINED TESTS (4 demos) ===

  static InvoiceData getCustomFieldsFull() {
    final seller = BusinessDetails(
      businessName: 'Complete Solutions Pvt Ltd',
      phone: '+91 22 8888 9999',
      email: 'sales@complete.com',
      gstin: '27COMP1234C1D2',
      pan: 'COMP1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Complete Tower, BKC, Mumbai - 400051',
      customFields: [
        CustomFieldValue(
          fieldName: 'Company Registration',
          fieldType: 'text',
          value: 'CIN: U12345MH2020PTC123456',
          displayOrder: 1,
          isRequired: true,
        ),
        CustomFieldValue(
          fieldName: 'Authorized Dealer',
          fieldType: 'boolean',
          value: true,
          displayOrder: 2,
          isRequired: false,
        ),
      ],
    );

    final buyer = BusinessDetails(
      businessName: 'Full Test Customer Co',
      phone: '+91 22 9999 0000',
      email: 'buyer@fulltest.com',
      gstin: '27FULL5678D2E3',
      pan: 'FULL5678D',
      state: 'Maharashtra',
      district: 'Pune',
      businessAddress: 'Pune - 411045',
      customFields: [
        CustomFieldValue(
          fieldName: 'PO Number',
          fieldType: 'text',
          value: 'PO/2025/10/12345',
          displayOrder: 1,
          isRequired: true,
        ),
        CustomFieldValue(
          fieldName: 'Credit Days',
          fieldType: 'number',
          value: 60.0,
          displayOrder: 2,
          isRequired: false,
        ),
      ],
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Industrial Machinery',
          description: 'CNC machine with controller',
          hsnCode: '84561000',
          qtyUnit: 'Unit',
        ),
        partyNetPrice: 500000.00,
        qtyOnBill: 1,
        subtotal: 500000.00,
        taxableValue: 500000.00,
        csgst: 45000.00,
        grossTaxCharged: 18.0,
        lineTotal: 590000.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Model No',
            fieldType: 'text',
            value: 'CNC-2025-PRO',
            displayOrder: 1,
            isRequired: true,
          ),
          CustomFieldValue(
            fieldName: 'Warranty Years',
            fieldType: 'number',
            value: 5.0,
            displayOrder: 2,
            isRequired: false,
          ),
          CustomFieldValue(
            fieldName: 'Installation Req',
            fieldType: 'boolean',
            value: true,
            displayOrder: 3,
            isRequired: false,
          ),
        ],
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Spare Parts Kit',
          description: 'Essential spares for 1 year',
          hsnCode: '84569000',
          qtyUnit: 'Kit',
        ),
        partyNetPrice: 25000.00,
        qtyOnBill: 1,
        subtotal: 25000.00,
        taxableValue: 25000.00,
        csgst: 2250.00,
        grossTaxCharged: 18.0,
        lineTotal: 29500.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Kit Code',
            fieldType: 'text',
            value: 'SPARE-KIT-001',
            displayOrder: 1,
            isRequired: false,
          ),
        ],
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 525000.00,
      totalGst: 94500.00,
      totalLineItemsAfterTaxes: 619500.00,
      dueBalancePayable: 619500.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-FULL',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 60)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'TEST: Full custom fields - Item AND business fields combined',
    );
  }

  static InvoiceData getCustomFieldsWithNotesTerms() {
    final seller = BusinessDetails(
      businessName: 'Full Featured Invoicing Co',
      phone: '+91 22 1234 5678',
      email: 'invoices@fullfeatured.com',
      gstin: '27FEAT1234C1D2',
      pan: 'FEAT1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Feature Complex, Mumbai - 400020',
      customFields: [
        CustomFieldValue(
          fieldName: 'Vendor Code',
          fieldType: 'text',
          value: 'VEND-2025-789',
          displayOrder: 1,
          isRequired: false,
        ),
      ],
    );

    final buyer = BusinessDetails(
      businessName: 'Comprehensive Testing Ltd',
      phone: '+91 22 8765 4321',
      email: '',
      gstin: '27TEST5678D2E3',
      pan: '',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Mumbai - 400070',
      customFields: [
        CustomFieldValue(
          fieldName: 'Customer ID',
          fieldType: 'text',
          value: 'CUST-ID-9876',
          displayOrder: 1,
          isRequired: false,
        ),
      ],
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Premium Service Package',
          description: 'Annual maintenance contract',
          hsnCode: '998314',
          qtyUnit: 'Year',
        ),
        partyNetPrice: 75000.00,
        qtyOnBill: 1,
        subtotal: 75000.00,
        taxableValue: 75000.00,
        csgst: 6750.00,
        grossTaxCharged: 18.0,
        lineTotal: 88500.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Contract ID',
            fieldType: 'text',
            value: 'AMC/2025/12345',
            displayOrder: 1,
            isRequired: true,
          ),
          CustomFieldValue(
            fieldName: 'Start Date',
            fieldType: 'date',
            value: DateTime(2025, 11, 1),
            displayOrder: 2,
            isRequired: true,
          ),
        ],
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 75000.00,
      totalGst: 13500.00,
      totalLineItemsAfterTaxes: 88500.00,
      dueBalancePayable: 88500.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-NOTES-TERMS',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.bankTransfer,
      notesFooter: 'NOTES: This invoice tests custom fields along with notes and terms.\n'
          'All three elements should render correctly without layout conflicts.\n'
          'Verify proper spacing and alignment.',
      paymentTerms: [
        'Payment due within 30 days from invoice date',
        'Late payment will attract 2% monthly interest',
        'Service contract valid for 365 days from start date',
        'All disputes subject to Mumbai jurisdiction only',
      ],
    );
  }

  static InvoiceData getCustomFieldsCompactLayout() {
    final seller = BusinessDetails(
      businessName: 'Compact Store',
      phone: '+91 98765 43210',
      email: '',
      gstin: '27COMP1234C1D2',
      pan: '',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Shop 3, Mumbai',
      customFields: [
        CustomFieldValue(
          fieldName: 'License',
          fieldType: 'text',
          value: 'LIC-2025-12345',
          displayOrder: 1,
          isRequired: false,
        ),
      ],
    );

    final buyer = BusinessDetails(
      businessName: 'Walk-in Customer',
      phone: '+91 98765 00000',
      email: '',
      gstin: '',
      pan: '',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: '',
      customFields: [
        CustomFieldValue(
          fieldName: 'Membership',
          fieldType: 'text',
          value: 'GOLD-123',
          displayOrder: 1,
          isRequired: false,
        ),
      ],
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Product A',
          description: '',
          hsnCode: '',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 100.00,
        qtyOnBill: 5,
        subtotal: 500.00,
        taxableValue: 500.00,
        csgst: 45.00,
        grossTaxCharged: 18.0,
        lineTotal: 590.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Warranty',
            fieldType: 'text',
            value: '1Y',
            displayOrder: 1,
            isRequired: false,
          ),
        ],
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Product B',
          description: '',
          hsnCode: '',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 200.00,
        qtyOnBill: 3,
        subtotal: 600.00,
        taxableValue: 600.00,
        csgst: 54.00,
        grossTaxCharged: 18.0,
        lineTotal: 708.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Color',
            fieldType: 'select',
            value: 'Blue',
            displayOrder: 1,
            isRequired: false,
          ),
          CustomFieldValue(
            fieldName: 'Size',
            fieldType: 'select',
            value: 'M',
            displayOrder: 2,
            isRequired: false,
          ),
        ],
      ),
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Product C',
          description: '',
          hsnCode: '',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 150.00,
        qtyOnBill: 2,
        subtotal: 300.00,
        taxableValue: 300.00,
        csgst: 27.00,
        grossTaxCharged: 18.0,
        lineTotal: 354.00,
        customFields: [
          CustomFieldValue(
            fieldName: 'Batch',
            fieldType: 'text',
            value: 'B123',
            displayOrder: 1,
            isRequired: false,
          ),
        ],
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 1400.00,
      totalGst: 252.00,
      totalLineItemsAfterTaxes: 1652.00,
      dueBalancePayable: 1652.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-COMPACT',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'TEST: Custom fields in A5/Thermal compact layouts',
    );
  }

  static InvoiceData getCustomFieldsEmpty() {
    final seller = BusinessDetails(
      businessName: 'Backward Compatible Co',
      phone: '+91 22 1111 2222',
      email: 'info@backcompat.com',
      gstin: '27BACK1234C1D2',
      pan: 'BACK1234C',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Mumbai - 400001',
      // NO custom fields
    );

    final buyer = BusinessDetails(
      businessName: 'Regular Customer',
      phone: '+91 22 3333 4444',
      email: '',
      gstin: '',
      pan: '',
      state: 'Maharashtra',
      district: 'Mumbai',
      businessAddress: 'Mumbai - 400050',
      // NO custom fields
    );

    final items = [
      ItemSaleInfo(
        item: ItemBasicInfo(
          name: 'Standard Product',
          description: 'No custom fields',
          hsnCode: '12345678',
          qtyUnit: 'Pcs',
        ),
        partyNetPrice: 1000.00,
        qtyOnBill: 10,
        subtotal: 10000.00,
        taxableValue: 10000.00,
        csgst: 900.00,
        grossTaxCharged: 18.0,
        lineTotal: 11800.00,
        // NO custom fields
      ),
    ];

    final billSummary = BillSummary(
      totalTaxableValue: 10000.00,
      totalGst: 1800.00,
      totalLineItemsAfterTaxes: 11800.00,
      dueBalancePayable: 11800.00,
    );

    return InvoiceData(
      invoiceNumber: 'CF-EMPTY',
      invoiceMode: InvoiceMode.salesInv,
      issueDate: DateTime.now(),
      dueDate: DateTime.now().add(const Duration(days: 30)),
      sellerDetails: seller,
      buyerDetails: buyer,
      lineItems: items,
      billSummary: billSummary,
      paymentMode: PaymentMode.cash,
      notesFooter: 'TEST: Zero custom fields - Backward compatibility check',
    );
  }

  static List<InvoiceData> getCustomFieldsTestingInvoices() {
    return [
      // Item Custom Fields Tests
      getItemCustomFieldsBasic(),
      getItemCustomFieldsMultiple(),
      getItemCustomFieldsMixed(),
      getItemCustomFieldsEdgeCase(),
      // Business Custom Fields Tests
      getBusinessCustomFieldsSeller(),
      getBusinessCustomFieldsBuyer(),
      getBusinessCustomFieldsBoth(),
      getBusinessCustomFieldsAllTypes(),
      // Combined Tests
      getCustomFieldsFull(),
      getCustomFieldsWithNotesTerms(),
      getCustomFieldsCompactLayout(),
      getCustomFieldsEmpty(),
    ];
  }

  static List<InvoiceData> getAllSamples() {
    return [
      getSampleInvoice1(),
      getSampleInvoice2(),
      getSampleInvoice3(),
      getSampleInvoice4(),
      getA5RetailBill(),
      getSimpleServiceInvoice(),
      getMultiGstRatesInvoice(),
      getCessHeavyGoods(),
      getZeroRatedExport(),
      getIntraStateDetailed(),
      getInterStateIgst(),
      getCompositeUnregistered(),
      getEstimateQuote(),
      getPurchaseOrder(),
      getCreditNote(),
      getDebitNote(),
      getDeliveryChallan(),
      getRestaurantBill(),
      getRetailGroceryReceipt(),
      getStressTestManyItems(),
      getPartialPaymentScenario(),
      getMinimalDataInvoice(),
      ...getNotesAndTermsTestingInvoices(),
      ...getCustomFieldsTestingInvoices(),
    ];
  }
}
